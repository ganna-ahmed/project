import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/modelsOfQuestion/view/infopage.dart';
import 'package:project/features/modelsOfQuestion/view/information.dart';

class ShowFromPreviosExam extends StatefulWidget {
  const ShowFromPreviosExam({
    super.key,
    required this.courseName,
    required this.year,
    required this.modelName,
    required this.idDoctor,
  });
  final String courseName;
  final String year;
  final String modelName;
  final String idDoctor;

  @override
  State<ShowFromPreviosExam> createState() => _ShowFromPreviosExamState();
}

class _ShowFromPreviosExamState extends State<ShowFromPreviosExam> {
  final Map<String, List<Map<String, dynamic>>> selectedQuestions = {
    'mcq': [],
    'essay': [],
    'multi': [],
  };

  List<dynamic> mcqQuestions = [];
  List<dynamic> essayQuestions = [];
  List<dynamic> multiChoiceQuestions = [];

  bool isLoading = false;
  bool questionsLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$kBaseUrl/Doctor/SelectPrivousExam'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'courseName': widget.courseName,
          'year': widget.year,
          //'chapterName': widget.chapterName,
        }),
      );
      //print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          // Handle MCQ questions
          if (data['multiple_choice_questions'] is List) {
            mcqQuestions = data['multiple_choice_questions'] ?? [];
          } else if (data['multiple_choice_questions'] is Map) {
            mcqQuestions = _convertMapToList(data['multiple_choice_questions']);
          } else {
            mcqQuestions = [];
          }

          // Handle essay questions
          if (data['essay_questions'] is List) {
            essayQuestions = data['essay_questions'] ?? [];
          } else if (data['essay_questions'] is Map) {
            essayQuestions = _processEssayQuestions(data['essay_questions']);
          } else {
            essayQuestions = [];
          }

          // Handle multi choice questions
          if (data['multi_choice_questions'] is List) {
            multiChoiceQuestions = data['multi_choice_questions'] ?? [];
          } else if (data['multi_choice_questions'] is Map) {
            multiChoiceQuestions =
                _convertMapToList(data['multi_choice_questions']);
          } else {
            multiChoiceQuestions = [];
          }

          questionsLoaded = true;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading questions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  // Convert a Map to a List format
  List<dynamic> _convertMapToList(Map<String, dynamic> dataMap) {
    List<dynamic> resultList = [];
    dataMap.forEach((key, value) {
      if (value is Map) {
        value['id'] = key; // Preserve the key as an ID if needed
        resultList.add(value);
      }
    });
    return resultList;
  }

  List<dynamic> _processEssayQuestions(Map<String, dynamic> essayData) {
    List<dynamic> processed = [];

    // If essayData is empty, return an empty list
    if (essayData.isEmpty) {
      return processed;
    }

    String currentQuestion = '';
    int questionNumber = 1;

    List<String> keys = essayData.keys.toList()..sort();

    for (var key in keys) {
      var text = essayData[key];
      if (text.toString().startsWith('${questionNumber}.')) {
        if (currentQuestion.isNotEmpty) {
          processed.add(currentQuestion.trim());
          questionNumber++;
        }
        currentQuestion = text.toString();
      } else {
        currentQuestion += ' $text';
      }
    }

    if (currentQuestion.isNotEmpty) {
      processed.add(currentQuestion.trim());
    }

    return processed;
  }

  void _toggleSelection(dynamic question, String type) {
    setState(() {
      final selectedList = selectedQuestions[type]!;
      final questionText =
      type == 'mcq' || type == 'multi' ? question['question'] : question;

      // Check if already selected
      final isSelected = selectedList.any((q) => q['text'] == questionText);

      if (isSelected) {
        selectedList.removeWhere((q) => q['text'] == questionText);
      } else {
        selectedList.add({
          'text': questionText,
          'options':
          type == 'mcq' || type == 'multi' ? question['options'] : null,
        });
      }
    });
  }

  bool _isSelected(dynamic question, String type) {
    final questionText =
    type == 'mcq' || type == 'multi' ? question['question'] : question;
    return selectedQuestions[type]!.any((q) => q['text'] == questionText);
  }

  Future<void> _addToExam() async {
    try {
      final response = await http.patch(
        Uri.parse('$kBaseUrl/Doctor/SelectPrivousExam'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'SelectedMCQs': selectedQuestions['mcq'],
          'SelectedEssayQuestions': selectedQuestions['essay'],
          'SelectedMultiChoiceQuestions': selectedQuestions['multi'],
          'modelName': widget.modelName,
          'courseName': widget.courseName,
          'idDoctor': widget.idDoctor,
        }),
      );
      print('🟢🟢${response.body}');
      if (response.statusCode == 200) {
        _showSuccessDialog();
      } else {
        throw Exception(
            'Failed to add questions to exam: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.ceruleanBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          content: const Text(
            'Questions added to the exam successfully!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop(); // إغلاق الرسالة أولًا
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InfoPage(
            idDoctor: widget.idDoctor,
            modelName: widget.modelName,
            courseName: widget.courseName,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions form Previous Exam'),
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Text(
                    'Questions for Exam',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ceruleanBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),

                  // Load Questions Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loadQuestions,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ceruleanBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Load Questions',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Content section - using Expanded with SingleChildScrollView to prevent overflow
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (isLoading)
                            const Center(child: CircularProgressIndicator())
                          else if (questionsLoaded) ...[
                            // Show questions when loaded
                            ...buildQuestionSections()
                          ] else ...[
                            // Show empty placeholders before loading
                            buildEmptySection('MCQ Questions'),
                            SizedBox(height: 16.h),

                            buildEmptySection('Essay Questions'),
                            SizedBox(height: 16.h),

                            buildEmptySection('Multi-choice Questions'),
                          ],
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Add to Exam Button (at the bottom, outside of scrollable area)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: questionsLoaded &&
                          (selectedQuestions['mcq']!.isNotEmpty ||
                              selectedQuestions['essay']!.isNotEmpty ||
                              selectedQuestions['multi']!.isNotEmpty)
                          ? _addToExam
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ceruleanBlue,
                        disabledBackgroundColor:
                        AppColors.ceruleanBlue.withOpacity(0.5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Add to Exam',
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
          ),
        ),
      ),
    );
  }

  // Build empty section placeholder
  Widget buildEmptySection(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10.r),
        border: Border(
          left: BorderSide(
            color: AppColors.ceruleanBlue,
            width: 5.w,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.ceruleanBlue,
        ),
      ),
    );
  }

  // Build loaded question sections
  List<Widget> buildQuestionSections() {
    List<Widget> sections = [];

    // MCQ Questions Section
    if (mcqQuestions.isNotEmpty) {
      sections.add(
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10.r),
            border: Border(
              left: BorderSide(color: Colors.blue.shade700, width: 5.w),
            ),
          ),
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.only(bottom: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MCQ Questions',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ceruleanBlue,
                ),
              ),
              SizedBox(height: 10.h),
              ...mcqQuestions
                  .map((question) => _buildQuestion(question, 'mcq')),
            ],
          ),
        ),
      );
    } else {
      sections.add(buildEmptySection('MCQ Questions'));
    }

    sections.add(SizedBox(height: 16.h));

    // Essay Questions Section
    if (essayQuestions.isNotEmpty) {
      sections.add(
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10.r),
            border: Border(
              left: BorderSide(color: Colors.blue.shade700, width: 5.w),
            ),
          ),
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.only(bottom: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Essay Questions',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ceruleanBlue,
                ),
              ),
              SizedBox(height: 10.h),
              ...essayQuestions
                  .map((question) => _buildEssayQuestion(question)),
            ],
          ),
        ),
      );
    } else {
      sections.add(buildEmptySection('Essay Questions'));
    }

    sections.add(SizedBox(height: 16.h));

    // Multi-choice Questions Section
    if (multiChoiceQuestions.isNotEmpty) {
      sections.add(
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10.r),
            border: Border(
              left: BorderSide(color: Colors.blue.shade700, width: 5.w),
            ),
          ),
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.only(bottom: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Multi-choice Questions',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ceruleanBlue,
                ),
              ),
              SizedBox(height: 10.h),
              ...multiChoiceQuestions
                  .map((question) => _buildQuestion(question, 'multi')),
            ],
          ),
        ),
      );
    } else {
      sections.add(buildEmptySection('Multi-choice Questions'));
    }

    return sections;
  }

  Widget _buildQuestion(dynamic question, String type) {
    // Safe check to ensure question is a Map with a 'question' field
    if (question is! Map || !question.containsKey('question')) {
      return SizedBox
          .shrink(); // Skip this question if it's not properly formatted
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _isSelected(question, type),
                onChanged: (_) => _toggleSelection(question, type),
                activeColor: AppColors.ceruleanBlue,
              ),
              Expanded(
                child: Text(
                  question['question'] ?? 'No question text',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (question['options'] != null && question['options'] is Map) ...[
            SizedBox(height: 8.h),
            ...(question['options'] as Map).entries.map((option) {
              return Padding(
                padding: EdgeInsets.only(left: 30.w, top: 4.h),
                child: Text(
                  '${option.key}: ${option.value}',
                  style: TextStyle(fontSize: 14.sp),
                  overflow: TextOverflow.ellipsis, // Prevent text overflow
                  maxLines: 2, // Limit to 2 lines with ellipsis
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildEssayQuestion(String question) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _isSelected(question, 'essay'),
            onChanged: (_) => _toggleSelection(question, 'essay'),
            activeColor: AppColors.ceruleanBlue,
          ),
          Expanded(
            child: Text(
              question,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis, // Prevent text overflow
              maxLines: 3, // Limit to 3 lines with ellipsis
            ),
          ),
        ],
      ),
    );
  }
}