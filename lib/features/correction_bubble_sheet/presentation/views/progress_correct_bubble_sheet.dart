import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:project/constants.dart';
import 'package:project/core/utils/app_router.dart';

class ProgressScreen extends StatefulWidget {
  final String? idDoctor;
  // final String? answerBubbleSheet;
  final String? bubbleSheetStudent;
  final String? fileName; // إضافة fileName كمعامل
  final String? pagesNumber;

  const ProgressScreen({
    Key? key,
    this.idDoctor,
    //this.answerBubbleSheet,
    this.bubbleSheetStudent,
    this.fileName,
    this.pagesNumber,
  }) : super(key: key);

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool isLoading = false;
  bool isComplete = false;
  String? bubbleSheetStudentBaseName;

  @override
  void initState() {
    super.initState();
    // استخراج اسم الملف بدون الامتداد .pdf
    bubbleSheetStudentBaseName =
        widget.bubbleSheetStudent?.replaceAll('.pdf', '');
    //startProcess();
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

          // انتظار ثانية ثم الانتقال إلى الشاشة التالية
          Future.delayed(
            const Duration(seconds: 1),
            () {
              if (!mounted) return;
              GoRouter.of(context).push('/resultStudent', extra: {
                'id': widget.idDoctor,
                //'AnswerBubbleSheet': widget.answerBubbleSheet,
                'BubbleSheetStudent': widget.bubbleSheetStudent,
                'fileName': widget.fileName, // تمرير fileName
                'degree': '20', // استبدل بقيمة ديناميكية إذا كانت متوفرة
                'namePdf': widget.bubbleSheetStudent, // يمكن تعديله حسب الحاجة
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
      appBar: AppBar(title: Text('Processing Bubble Sheet')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) CircularProgressIndicator(),
            if (isComplete)
              Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 50),
                  SizedBox(height: 10),
                  Text(
                    '🎉 Process Completed Successfully!',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              ),
            if (!isComplete && !isLoading)
              ElevatedButton(
                onPressed: startProcess,
                child: Text('Start Processing'),
              ),
          ],
        ),
      ),
    );
  }
}
