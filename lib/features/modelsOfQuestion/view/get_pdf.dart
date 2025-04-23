import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path_lib;
import '../../../constants.dart';

class PdfDownloadPage extends StatefulWidget {
  final String pdfName;
  final String idDoctor;
  final String modelName;
  final String randomId;

  const PdfDownloadPage({
    super.key,
    required this.pdfName,
    required this.idDoctor,
    required this.modelName,
    required this.randomId,
  });

  @override
  State<PdfDownloadPage> createState() => _PdfDownloadPageState();
}

class _PdfDownloadPageState extends State<PdfDownloadPage>
    with SingleTickerProviderStateMixin {
  double _progress = 0;
  bool _showSuccess = false;
  bool _showError = false;
  bool _isRetrying = false;
  String _errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  Timer? _progressTimer;
  int _retryCount = 0;
  final int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startDownload();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _bounceAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 0.3, end: 1.1), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 1.1, end: 0.9), weight: 20),
        TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
      ],
    ).animate(_animationController);
  }

  void _startProgressSimulation() {
    const duration = Duration(milliseconds: 8000);
    const interval = Duration(milliseconds: 50);
    final totalSteps = duration.inMilliseconds ~/ interval.inMilliseconds;

    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(interval, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_showError || _showSuccess) {
          timer.cancel();
          return;
        }

        _progress += 1 / totalSteps;
        if (_progress >= 1) {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _startDownload() async {
    if (!mounted) return;

    setState(() {
      _progress = 0;
      _showError = false;
      _showSuccess = false;
      _isRetrying = false;
      _retryCount = 0;
    });

    _startProgressSimulation();
    await _attemptDownload();
  }

  Future<void> _attemptDownload() async {
    if (!mounted) return;

    try {
      // Validate input parameters
      if (widget.idDoctor.isEmpty || widget.modelName.isEmpty || widget.pdfName.isEmpty) {
        throw Exception('معلمات الاستعلام غير صالحة');
      }

      final url = '${kBaseUrl}/Doctor/getPdf?'
          'id=${widget.idDoctor}&'
          'modelName=${widget.modelName}&'
          'pdfName=${widget.pdfName}&'
          'randomId=${widget.randomId}';

      debugPrint('📥 Download URL: $url');

      if (kIsWeb) {
        await _handleWebDownload(url);
      } else {
        await _handleMobileDownload(url);
      }

      if (mounted) {
        setState(() {
          _showSuccess = true;
          _isRetrying = false;
          _animationController.forward();
        });
      }
    } catch (e) {
      debugPrint('❌ Download error: $e');

      if (_retryCount < _maxRetries) {
        _retryCount++;
        if (mounted) {
          setState(() {
            _isRetrying = true;
            _errorMessage = 'محاولة جديدة (${_retryCount}/${_maxRetries})...';
          });
        }
        // Wait before retrying
        await Future.delayed(const Duration(seconds: 2));
        await _attemptDownload();
      } else {
        if (mounted) {
          setState(() {
            _showError = true;
            _isRetrying = false;
            _errorMessage = _getUserFriendlyError(e);
          });
        }
      }
    } finally {
      _progressTimer?.cancel();
    }
  }

  String _getUserFriendlyError(dynamic error) {
    if (error is SocketException) {
      return 'تعذر الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت';
    } else if (error is TimeoutException) {
      return 'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى';
    } else if (error.toString().contains('الرد ليس ملف PDF صالح')) {
      return 'الملف المطلوب غير موجود أو توجد مشكلة في الخادم';
    } else {
      return 'حدث خطأ أثناء التنزيل: ${error.toString().replaceAll('Exception: ', '')}';
    }
  }

  Future<void> _handleWebDownload(String url) async {
    // Implementation for web platform
    // You can use dart:html or js interop here
    throw UnsupportedError('Web download not implemented yet');
  }

  Future<File?> _downloadFile(String fileName, http.Response response) async {
    try {
      Directory? downloadDir;

      if (Platform.isAndroid) {
        downloadDir = Directory('/storage/emulated/0/Download');
        if (!await downloadDir.exists()) {
          downloadDir = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        downloadDir = await getApplicationDocumentsDirectory();
      }

      if (downloadDir == null || !await downloadDir.exists()) {
        throw Exception('تعذر العثور على مجلد التنزيلات');
      }

      final filePath = path_lib.join(downloadDir.path, fileName);
      final file = File(filePath);

      await file.writeAsBytes(response.bodyBytes, flush: true);

      debugPrint('✅ File saved to: ${file.path}');
      return file;
    } catch (e, stacktrace) {
      debugPrint('❌ Error saving file: $e');
      debugPrint('🛠 Stacktrace: $stacktrace');
      rethrow;
    }
  }

  Future<void> _handleMobileDownload(String url) async {
    try {
      // Prevent connection timeouts
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 60), // Increase timeout
        onTimeout: () => throw TimeoutException('انتهت مهلة الطلب'),
      );

      debugPrint('📊 Response status code: ${response.statusCode}');

      if (response.statusCode != 200) {
        final errorResponse = _parseErrorResponse(response);
        debugPrint('❌ Server response error: ${response.statusCode}, Body: ${response.body}');
        throw Exception(errorResponse);
      }

      // Log response size
      debugPrint('📦 Response size: ${response.bodyBytes.length} bytes');

      // Check content type with more flexibility
      final contentType = response.headers['content-type']?.toLowerCase() ?? '';
      debugPrint('📄 Content-Type: $contentType');

      final isValidContentType = contentType.contains('application/pdf') ||
          contentType.contains('octet-stream') ||
          contentType.contains('binary/') ||
          contentType.contains('application/');

      // More permissive content type checking
      if (!isValidContentType && response.bodyBytes.length > 1000) {
        debugPrint('⚠️ Content type not valid but file size is reasonable. Continuing anyway.');
      } else if (!isValidContentType) {
        throw Exception('الرد ليس ملف PDF صالح (نوع المحتوى: $contentType)');
      }

      // Check minimum file size (100 bytes)
      if (response.bodyBytes.length < 100) {
        throw Exception('حجم الملف صغير جدًا (${response.bodyBytes.length} بايت)');
      }

      // Add a PDF header if missing (experimental - may not work for all cases)
      List<int> fileBytes = response.bodyBytes;
      if (fileBytes.length > 5 &&
          String.fromCharCodes(fileBytes.sublist(0, 5)) != '%PDF-') {
        debugPrint('⚠️ PDF header not detected, this might not be a valid PDF file');
      }

      // Download file
      final fileName = '${widget.pdfName}.pdf';
      final file = await _downloadFile(fileName, response);

      if (file == null || !await file.exists()) {
        throw Exception('فشل إنشاء الملف');
      }

      // Verify file size
      final fileSize = await file.length();
      if (fileSize <= 0) {
        throw Exception('الملف المنشأ فارغ');
      }

      // Add a small delay before opening the file
      await Future.delayed(const Duration(milliseconds: 500));

      // Try to open the file
      final result = await OpenFile.open(file.path);
      if (result.type != ResultType.done) {
        debugPrint('❌ Failed to open file: ${result.message}');
        throw Exception('فشل فتح الملف: ${result.message}');
      }
    } catch (e) {
      debugPrint('❌ Download handling error: $e');
      rethrow;
    }
  }

  String _parseErrorResponse(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      return errorData['message'] ?? 'خطأ غير معروف من الخادم';
    } catch (e) {
      return 'خطأ في الخادم (رمز الحالة: ${response.statusCode})';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7709e4),
              Color(0xFF5b0296),
              Color(0xFF1787e4),
              Color(0xFFd5a8fc),
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _showError
                ? _buildErrorView()
                : (_showSuccess ? _buildSuccessView() : _buildLoadingView()),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: _progress,
                strokeWidth: 10,
                backgroundColor: Colors.white.withOpacity(0.3),
                color: Colors.white,
              ),
              Text(
                '${(_progress * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _isRetrying
              ? 'جاري إعادة المحاولة... (${_retryCount}/${_maxRetries})'
              : 'يرجى الانتظار بينما يتم تحضير ملف PDF...',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _bounceAnimation,
          child: Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Color(0xFF7709e4),
              size: 100,
            ),
          ),
        ),
        const SizedBox(height: 20),
        AnimatedOpacity(
          opacity: _showSuccess ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Transform.translate(
            offset: Offset(0, _showSuccess ? 0 : 20),
            child: Column(
              children: [
                const Text(
                  'تم التنزيل بنجاح!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'تم تنزيل النماذج الخمسة بنجاح، مع ملف PDF الخاص بإجابات النموذج لورقة الفقاعات.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF7709e4),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'العودة إلى الرئيسية',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 70,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'فشل التنزيل',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.white),
                ),
              ),
              child: const Text(
                'إلغاء',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: _startDownload,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'حاول مرة أخرى',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}