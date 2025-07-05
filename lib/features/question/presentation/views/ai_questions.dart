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

      print('Request body: $body');

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
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: _getResponsiveFontSize(18),
                fontWeight: FontWeight.bold,
                color: AppColors.ceruleanBlue,
              ),
            ),
            SizedBox(height: 16.h),
            ...children,
          ],
        ),
      ),
    );
  }

  double _getResponsiveFontSize(double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 768) {
      return baseSize + 2; // Tablet
    } else if (screenWidth > 480) {
      return baseSize; // Large mobile
    } else {
      return baseSize - 1; // Small mobile
    }
  }

  double _getResponsiveSpacing(double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 768) {
      return baseSpacing * 1.5; // Tablet
    } else if (screenWidth > 480) {
      return baseSpacing; // Large mobile
    } else {
      return baseSpacing * 0.8; // Small mobile
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.ceruleanBlue, width: 2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        hintStyle: TextStyle(fontSize: _getResponsiveFontSize(14)),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: _getResponsiveFontSize(16)),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      hint: Text(
        hint,
        style: TextStyle(fontSize: _getResponsiveFontSize(14)),
      ),
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.ceruleanBlue, width: 2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
      style: TextStyle(
        fontSize: _getResponsiveFontSize(16),
        color: Colors.black,
      ),
      dropdownColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final maxWidth = isTablet ? 800.0 : screenWidth * 0.95;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Generate Questions Using AI',
          style: TextStyle(fontSize: _getResponsiveFontSize(18)),
        ),
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: _getResponsiveSpacing(16),
            vertical: _getResponsiveSpacing(20),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                children: [
                  // MCQ Section
                  _buildCard(
                    title: 'Multiple Choice Questions (MCQ)',
                    children: [
                      _buildTextField(
                        controller: _mcqCountController,
                        hintText: 'Number of questions',
                      ),
                      SizedBox(height: _getResponsiveSpacing(12)),
                      _buildDropdown<String>(
                        value: _mcqDifficulty.isEmpty ? null : _mcqDifficulty,
                        hint: 'Select Difficulty',
                        items: const [
                          DropdownMenuItem(value: 'easy', child: Text('Easy')),
                          DropdownMenuItem(value: 'medium', child: Text('Medium')),
                          DropdownMenuItem(value: 'hard', child: Text('Hard')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _mcqDifficulty = value.toString();
                          });
                        },
                      ),
                    ],
                  ),

                  // Essay Section
                  _buildCard(
                    title: 'Essay Questions',
                    children: [
                      _buildTextField(
                        controller: _essayCountController,
                        hintText: 'Number of questions',
                      ),
                      SizedBox(height: _getResponsiveSpacing(12)),
                      _buildDropdown<String>(
                        value: _essayDifficulty.isEmpty ? null : _essayDifficulty,
                        hint: 'Select Difficulty',
                        items: const [
                          DropdownMenuItem(value: 'easy', child: Text('Easy')),
                          DropdownMenuItem(value: 'medium', child: Text('Medium')),
                          DropdownMenuItem(value: 'hard', child: Text('Hard')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _essayDifficulty = value.toString();
                          });
                        },
                      ),
                      SizedBox(height: _getResponsiveSpacing(12)),
                      _buildDropdown<String>(
                        value: _essayType.isEmpty ? null : _essayType,
                        hint: 'Select Type',
                        items: const [
                          DropdownMenuItem(value: 'text', child: Text('Text-based')),
                          DropdownMenuItem(value: 'numeric', child: Text('Numeric-based')),
                          DropdownMenuItem(value: 'both', child: Text('Both')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _essayType = value.toString();
                          });
                        },
                      ),
                    ],
                  ),

                  // Multiple Choice Section
                  _buildCard(
                    title: 'Multiple Choice',
                    children: [
                      _buildTextField(
                        controller: _multiCountController,
                        hintText: 'Number of questions',
                      ),
                      SizedBox(height: _getResponsiveSpacing(12)),
                      _buildDropdown<String>(
                        value: _multiDifficulty.isEmpty ? null : _multiDifficulty,
                        hint: 'Select Difficulty Level',
                        items: const [
                          DropdownMenuItem(value: 'easy', child: Text('Easy')),
                          DropdownMenuItem(value: 'medium', child: Text('Medium')),
                          DropdownMenuItem(value: 'hard', child: Text('Hard')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _multiDifficulty = value.toString();
                          });
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: _getResponsiveSpacing(30)),

                  // Generate Button
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 60.h : 50.h,
                    child: ElevatedButton(
                      onPressed: _isFormValid ? _generateExam : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ceruleanBlue,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        disabledForegroundColor: Colors.grey[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        elevation: 3,
                      ),
                      child: isLoading
                          ? SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'Generate Exam',
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: _getResponsiveSpacing(20)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}