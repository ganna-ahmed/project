import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';

class ProcessingPage extends StatefulWidget {
  final String fileName;

  const ProcessingPage({super.key, required this.fileName});

  @override
  _ProcessingPageState createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage> {
  bool isProcessingComplete = false;

  @override
  void initState() {
    super.initState();
    _startProcessing();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    final fileName = GoRouterState.of(context).extra as String?;
    // استخدام fileName هنا
  }

  void _startProcessing() {
    Timer(const Duration(seconds: 8), () {
      setState(() {
        isProcessingComplete = true;
      });

      _sendForCorrection();
    });
  }

  Future<void> _sendForCorrection() async {
    final url = Uri.parse(
      'https://bf40-2c0f-fc88-5-10ae-f4f8-1ba7-f2db-11b6.ngrok-free.app/Doctor/waitedUpload',
    );

    try {
      print("🚀 Sending correction request for file: ${widget.fileName}");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fileNameWithoutExtension': widget.fileName
        }), // ✅ Use dynamic file name
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        Fluttertoast.showToast(msg: 'Correction request sent successfully!');
        GoRouter.of(context)
            .push(AppRouter.kUploadStudentPaper, extra: widget.fileName);
      } else {
        Fluttertoast.showToast(
            msg: 'Correction failed: ${response.statusCode}');
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Error: ${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Processing...",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: AppColors.ceruleanBlue,
      ),
      body: Center(
        child: isProcessingComplete
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 80),
                  SizedBox(height: 20),
                  Text("Model Answer is ready for correction!",
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.ceruleanBlue),
                  SizedBox(height: 20),
                  Text("Processing, please wait...",
                      style: TextStyle(fontSize: 16)),
                ],
              ),
      ),
    );
  }
}
