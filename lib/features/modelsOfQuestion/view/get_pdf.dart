import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/features/modelsOfQuestion/view/exam.dart';
import '../../../constants.dart';
import '../../../core/constants/colors.dart';
import 'dart:async';

class PdfDownloadPage extends StatefulWidget {
  final String idDoctor;
  final String modelName;
  final String pdfName;

  const PdfDownloadPage({
    Key? key,
    required this.idDoctor,
    required this.modelName,
    required this.pdfName,
  }) : super(key: key);

  @override
  State<PdfDownloadPage> createState() => _PdfDownloadPageState();
}

class _PdfDownloadPageState extends State<PdfDownloadPage>
    with SingleTickerProviderStateMixin {
  double _progress = 0;
  bool _showSuccess = false;
  bool _downloadComplete = false;
  String _downloadPath = '';
  String _errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  final http.Client _httpClient = http.Client();

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startDownload();
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

  Future<void> _startDownload() async {
    try {
      setState(() {
        _progress = 0;
        _errorMessage = '';
      });

      final downloadUrl = '$kBaseUrl/Doctor/getPdf';

      // Get storage directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${widget.pdfName}.zip';

      setState(() {
        _downloadPath = filePath;
      });

      // Prepare the request (POST with JSON body, similar to web version)
      final response = await _httpClient.post(
        Uri.parse(downloadUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'pdfName': widget.pdfName,
          'modelName': widget.modelName,
          'idDoctor':
              widget.idDoctor, // Include idDoctor to match backend expectations
        }),
      );

      print('Request body: ${json.encode({
            'pdfName': widget.pdfName,
            'modelName': widget.modelName,
            'idDoctor': widget.idDoctor
          })}');
      print('Response: ${response.body}, Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Save the file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Verify the download completed successfully
        if (await file.exists()) {
          setState(() {
            _progress = 1.0; // Set to 100% for UI consistency
            _downloadComplete = true;
            _showSuccess = true;
          });
          _animationController.forward();
        } else {
          throw Exception('File was not created successfully');
        }
      } else {
        throw Exception(
            'Failed to download file: ${response.body}, Status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Download failed: ${e.toString()}';
      });
      print('Download error: $e');
    }
  }

  Future<void> _openDownloadedFile() async {
    try {
      if (_downloadPath.isEmpty) {
        _showSnackBar('File path is empty');
        return;
      }

      final file = File(_downloadPath);
      if (!await file.exists()) {
        _showSnackBar('File does not exist at path: $_downloadPath');
        return;
      }

      final result = await OpenFile.open(_downloadPath);
      if (result.type != ResultType.done) {
        _showSnackBar('Cannot open file: ${result.message ?? 'Unknown error'}');
      }
    } catch (e) {
      _showSnackBar('Error opening file: $e');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _retryDownload() async {
    setState(() {
      _errorMessage = '';
      _progress = 0;
      _showSuccess = false;
      _downloadComplete = false;
    });
    await _startDownload();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _httpClient.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Exam'),
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
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
        child: SafeArea(
          child: Center(
            child: _errorMessage.isNotEmpty
                ? _buildErrorView()
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: _showSuccess
                        ? _buildSuccessView()
                        : _buildLoadingView(),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 120.h,
            height: 120.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _progress,
                  strokeWidth: 8.w,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  color: Colors.white,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(_progress * 100).toInt()}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    const Text(
                      'Downloading...',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          const Text(
            'Please wait while downloading exam models...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _bounceAnimation,
            child: Container(
              width: 120.w,
              height: 120.h,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
            ),
          ),
          SizedBox(height: 32.h),
          Text(
            'Success!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'The five models have been successfully downloaded, along with the PDF of the model answers for the bubble sheet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _openDownloadedFile,
                icon: const Icon(Icons.folder_open, size: 20),
                label: const Text('Open File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF7709e4),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  elevation: 4,
                ),
              ),
              SizedBox(width: 16.w),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StartExamPage()));
                },
                icon: const Icon(Icons.home, size: 20),
                label: const Text('Back to Home'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white, width: 2.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Download Failed',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _retryDownload,
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF7709e4),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, size: 20),
                label: const Text('Go Back'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white, width: 2.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
