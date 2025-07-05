import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';

class ProgressScreen extends StatefulWidget {
  final String? idDoctor;
  final String? bubbleSheetStudent;
  final String? fileName;
  final String? pagesNumber;

  const ProgressScreen({
    super.key,
    this.idDoctor,
    this.bubbleSheetStudent,
    this.fileName,
    this.pagesNumber,
  });

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool isLoading = true; // يبدأ التحميل تلقائيًا
  bool isComplete = false;
  String? bubbleSheetStudentBaseName;

  @override
  void initState() {
    super.initState();
    bubbleSheetStudentBaseName =
        widget.bubbleSheetStudent?.replaceAll('.pdf', '');
    startProcess(); // يبدأ المعالجة مباشرة عند الدخول للشاشة
  }

  Future<void> startProcess() async {
    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$kBaseUrl/Doctor/progrssCorrcetBubbleSheed'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'BubbleSheetStudentBaseName': bubbleSheetStudentBaseName,
          'pagesNumber': widget.pagesNumber,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data == "Completed processing all pages successfully.") {
          setState(() {
            isLoading = false;
            isComplete = true;
          });

          // الانتقال للشاشة التالية بعد 1.5 ثانية
          Future.delayed(
            const Duration(seconds: 2),
            () {
              if (!mounted) return;
              GoRouter.of(context).push('/resultStudent', extra: {
                'id': widget.idDoctor,
                'BubbleSheetStudent': widget.bubbleSheetStudent,
                'fileName': widget.fileName,
                'degree': '100', // استبدل بقيمة ديناميكية إذا لزم الأمر
              });
            },
          );
        }
      } else {
        throw Exception('Failed to process data');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.ceruleanBlue,
        title: const Text(
          'Processing Bubble Sheet',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              Column(
                children: [
                  Lottie.asset(
                    'assets/lottie/loading.json',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Processing, please wait...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // يمكنك تغيير اللون هنا
                    ),
                  ),
                ],
              ),
            if (isComplete)
              Column(
                children: [
                  Lottie.asset(
                    'assets/lottie/mainscene.json',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '🎉 Process Completed Successfully!',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
