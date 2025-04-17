import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';

class AiQuestionsGeneratorScreen extends StatefulWidget {
  final String courseName;
  final String doctorId;
  final String fileName;

  const AiQuestionsGeneratorScreen({
    required this.courseName,
    required this.doctorId,
    required this.fileName,
  });

  @override
  _AiQuestionsGeneratorScreenState createState() =>
      _AiQuestionsGeneratorScreenState();
}

class _AiQuestionsGeneratorScreenState
    extends State<AiQuestionsGeneratorScreen> {
  List<dynamic> mcqQuestions = [];
  List<dynamic> multiChoiceQuestions = [];
  List<dynamic> essayQuestions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final url = Uri.parse('$kBaseUrl/Doctor/showAiQuestion');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idDoctor': widget.doctorId,
          'courseName': widget.courseName,
          'file': widget.fileName,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          mcqQuestions = data['mcq'] ?? [];
          multiChoiceQuestions = data['multi'] ?? [];
          essayQuestions = data['essay'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load questions: Server error ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Questions'),
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage,
                      style: const TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildSection(
                          'MCQ Questions', mcqQuestions, _buildMCQQuestion),
                      SizedBox(height: 20.h),
                      _buildSection('Multi-Choice with Passages',
                          multiChoiceQuestions, _buildMultiChoiceQuestion),
                      SizedBox(height: 20.h),
                      _buildSection('Essay Questions', essayQuestions,
                          _buildEssayQuestion),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSection(
      String title, List<dynamic> questions, Widget Function(dynamic) builder) {
    if (questions.isEmpty) {
      return SizedBox.shrink(); // Don't show empty sections
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E90FF),
              ),
            ),
            SizedBox(height: 10.h),
            ...questions.map((question) => builder(question)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMCQQuestion(dynamic question) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'],
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            ...(question['options'] as List<dynamic>).map((option) {
              final isCorrect = option == question['answer'];
              return Container(
                margin: EdgeInsets.only(bottom: 5.h),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isCorrect ? Color(0xFFC3F0C3) : Color(0xFFF0F8FF),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isCorrect ? Colors.green : Color(0xFF1E90FF),
                    width: 2.w,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
                    color: isCorrect ? Colors.green : Colors.black,
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiChoiceQuestion(dynamic item) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['passage'],
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            ...(item['questions'] as List<dynamic>).map((question) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question['question'],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  ...(question['options'] as List<dynamic>).map((option) {
                    final isCorrect = option == question['answer'];
                    return Container(
                      margin: EdgeInsets.only(bottom: 5.h),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            isCorrect ? Color(0xFFC3F0C3) : Color(0xFFF0F8FF),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isCorrect ? Colors.green : Color(0xFF1E90FF),
                          width: 2.w,
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight:
                              isCorrect ? FontWeight.bold : FontWeight.normal,
                          color: isCorrect ? Colors.green : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 10.h),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEssayQuestion(dynamic question) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'],
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (question['model_answer'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Model Answer:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E90FF),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      question['model_answer'],
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
