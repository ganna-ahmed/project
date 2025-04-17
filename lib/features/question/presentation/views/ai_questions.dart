import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/question/presentation/views/ai_question_generator.dart';

class AIQuestionsScreen extends StatefulWidget {
  @override
  _AIQuestionsScreenState createState() => _AIQuestionsScreenState();
  final String courseName;
  final String doctorId;
  final String fileName;

  const AIQuestionsScreen(
      {super.key,
      required this.courseName,
      required this.doctorId,
      required this.fileName});
}

class _AIQuestionsScreenState extends State<AIQuestionsScreen> {
  final TextEditingController _mcqCountController = TextEditingController();
  final TextEditingController _essayCountController = TextEditingController();
  final TextEditingController _multiCountController = TextEditingController();
  String _mcqDifficulty = '';
  String _essayDifficulty = '';
  String _essayType = '';
  String _multiDifficulty = '';
  bool isLoading = false;

  bool get _isFormValid {
    return _mcqCountController.text.isNotEmpty &&
        _mcqDifficulty.isNotEmpty &&
        _essayCountController.text.isNotEmpty &&
        _essayDifficulty.isNotEmpty &&
        _essayType.isNotEmpty &&
        _multiCountController.text.isNotEmpty &&
        _multiDifficulty.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to all controllers and dropdowns to update state when values change
    _mcqCountController.addListener(_updateState);
    _essayCountController.addListener(_updateState);
    _multiCountController.addListener(_updateState);
  }

  @override
  void dispose() {
    _mcqCountController.removeListener(_updateState);
    _essayCountController.removeListener(_updateState);
    _multiCountController.removeListener(_updateState);
    _mcqCountController.dispose();
    _essayCountController.dispose();
    _multiCountController.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {});
  }

  Future<void> _generateExam() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('$kBaseUrl/Doctor/QuestionAi');

      // Create a map of the request body
      final Map<String, String> body = {
        'mcqCount': _mcqCountController.text.trim(),
        'mcqDifficulty': _mcqDifficulty,
        'essayCount': _essayCountController.text.trim(),
        'essayDifficulty': _essayDifficulty,
        'essayType': _essayType,
        'multiCount': _multiCountController.text.trim(),
        'multiDifficulty': _multiDifficulty,
        'courseName': widget.courseName,
        'idDoctor': widget.doctorId,
        'file': widget.fileName,
      };

      print('Request body: $body'); // For debugging

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == 'Exam generated successfully') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AiQuestionsGeneratorScreen(
                courseName: widget.courseName,
                doctorId: widget.doctorId,
                fileName: widget.fileName,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to generate the exam: ${data['message'] ?? "Unknown error"}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 4.h,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Questions Using AI'),
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: AppColors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        constraints.maxWidth < 600 ? constraints.maxWidth : 600,
                  ),
                  child: Column(
                    children: [
                      _buildCard(
                        title: 'Multiple Choice Questions (MCQ)',
                        children: [
                          TextField(
                            controller: _mcqCountController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.ceruleanBlue)),
                              hintText: 'Number of questions',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10.h),
                          DropdownButtonFormField(
                            value:
                                _mcqDifficulty.isEmpty ? null : _mcqDifficulty,
                            hint: Text('Difficulty'),
                            items: const [
                              DropdownMenuItem(
                                  value: 'easy', child: Text('Easy')),
                              DropdownMenuItem(
                                  value: 'medium', child: Text('Medium')),
                              DropdownMenuItem(
                                  value: 'hard', child: Text('Hard')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _mcqDifficulty = value.toString();
                              });
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.ceruleanBlue)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _buildCard(
                        title: 'Essay Questions',
                        children: [
                          TextField(
                            controller: _essayCountController,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.ceruleanBlue)),
                              hintText: 'Number of questions',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10.h),
                          DropdownButtonFormField<String>(
                            value: _essayDifficulty.isEmpty
                                ? null
                                : _essayDifficulty,
                            hint: Text('Difficulty'),
                            items: [
                              DropdownMenuItem(
                                  value: 'easy', child: const Text('Easy')),
                              DropdownMenuItem(
                                  value: 'medium', child: Text('Medium')),
                              DropdownMenuItem(
                                  value: 'hard', child: Text('Hard')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _essayDifficulty = value.toString();
                              });
                            },
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.ceruleanBlue)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          DropdownButtonFormField<String>(
                            value: _essayType.isEmpty ? null : _essayType,
                            hint: Text('Type'),
                            items: [
                              DropdownMenuItem(
                                  value: 'text', child: Text('Text-based')),
                              DropdownMenuItem(
                                  value: 'numeric',
                                  child: Text('Numeric-based')),
                              DropdownMenuItem(
                                  value: 'both', child: Text('Both')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _essayType = value.toString();
                              });
                            },
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.ceruleanBlue)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _buildCard(
                        title: 'Multiple Choice',
                        children: [
                          TextField(
                            controller: _multiCountController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.ceruleanBlue)),
                              hintText: 'Number of questions',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10.h),
                          DropdownButtonFormField<String>(
                            value: _multiDifficulty.isEmpty
                                ? null
                                : _multiDifficulty,
                            hint: const Text('Difficulty Level'),
                            items: const [
                              DropdownMenuItem(
                                  value: 'easy', child: Text('Easy')),
                              DropdownMenuItem(
                                  value: 'medium', child: Text('Medium')),
                              DropdownMenuItem(
                                  value: 'hard', child: Text('Hard')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _multiDifficulty = value.toString();
                              });
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.ceruleanBlue)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: _isFormValid ? _generateExam : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.ceruleanBlue,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            disabledForegroundColor: Colors.grey[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  'Generate Exam',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
