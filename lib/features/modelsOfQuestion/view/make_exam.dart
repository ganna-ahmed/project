import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../constants.dart';
import '../../../core/constants/colors.dart';
import 'get_pdf.dart';
import 'dart:math';

class ArchiveDownloadPage extends StatefulWidget {
  final String idDoctor;
  final String modelName;

  const ArchiveDownloadPage({
    super.key,
    required this.idDoctor,
    required this.modelName,
  });

  @override
  State<ArchiveDownloadPage> createState() => _ArchiveDownloadPageState();
}

class _ArchiveDownloadPageState extends State<ArchiveDownloadPage> {
  final TextEditingController _fileNameController = TextEditingController();
  bool isLoading = false;
  late String randomId;

  @override
  void initState() {
    super.initState();
    _fileNameController.text = '${widget.modelName}_exam';
    randomId = _generateRandomId();
  }

  String _generateRandomId() {
    final random = Random();
    return List.generate(10, (index) => random.nextInt(10)).join();
  }

  Future<void> _downloadFile() async {
    if (_fileNameController.text.trim().isEmpty) {
      _showAlert('Please enter a file name!');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final fileName = _fileNameController.text.trim();

      if (kIsWeb) {
        final downloadPageUrl = '${kBaseUrl}/download-page?'
            'id=${widget.idDoctor}&'
            'modelName=${widget.modelName}&'
            'pdfName=$fileName&'
            'randomId=$randomId';

        if (await canLaunchUrl(Uri.parse(downloadPageUrl))) {
          await launchUrl(
            Uri.parse(downloadPageUrl),
            mode: LaunchMode.externalApplication,
          );
          _showSuccess('Download started in a new window!');
        } else {
          _showAlert('Could not launch the download page.');
        }
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PdfDownloadPage(
              idDoctor: widget.idDoctor,
              modelName: widget.modelName,
              pdfName: fileName,
              randomId: randomId,
            ),
          ),
        );
      }
    } catch (e) {
      _showAlert('Error: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Exam'),
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0044cc), Color(0xFF00aaff)],
          ),
        ),
        child: Center(
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1500),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, -20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.cloud_download,
                      size: 50,
                      color: Color(0xFF0044cc),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your Exam Archive is Ready!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    kIsWeb
                        ? 'Enter a file name and download your exam archive'
                        : 'Enter a file name to download directly to your device',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _fileNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter file name...',
                      prefixIcon: const Icon(Icons.insert_drive_file),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _downloadFile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0044cc),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.download),
                          const SizedBox(width: 10),
                          Text(kIsWeb ? 'Download Now' : 'Download to Device'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (widget.modelName.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Exam Model: ${widget.modelName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}