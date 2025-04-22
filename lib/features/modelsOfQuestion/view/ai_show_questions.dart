import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/modelsOfQuestion/view/infopage.dart';
import 'package:project/features/modelsOfQuestion/view/information.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class QuestionsForChapterAiPage extends StatefulWidget {
  const QuestionsForChapterAiPage({
    super.key,
    required this.courseName,
    // required this.year,
    required this.modelName,
    required this.idDoctor,
    required this.chapterName,
    required this.mode,
  });
  final String courseName;
//final String year;
  final String modelName;
  final String idDoctor;
  final String chapterName;
  final String mode;

  @override
  State<QuestionsForChapterAiPage> createState() =>
      _QuestionsForChapterAiPageState();
}

class _QuestionsForChapterAiPageState extends State<QuestionsForChapterAiPage> {
  final Map<String, List<dynamic>> selectedQuestions = {
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
        Uri.parse('$kBaseUrl/Doctor/SelectChapter'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idDoctor': widget.idDoctor,
          'courseName': widget.courseName,
          'modelName': widget.modelName,
          'chapterName': widget.chapterName,
          'mode': widget.mode,
        }),
      );
      print('🟢🟢${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // التحقق من نجاح الاستجابة ونوعها
        if (data['success'] == true && data['type'] == "ai") {
          // التحقق من وجود البيانات
          if (data['data'] != null) {
            setState(() {
              // تحديث هيكل البيانات بالتحقق من null
              mcqQuestions = data['data']['mcq'] ?? [];
              essayQuestions = data['data']['essay'] ?? [];
              multiChoiceQuestions = data['data']['multi'] ?? [];

              questionsLoaded = true;
              isLoading = false;
            });
          } else {
            // إظهار رسالة خطأ عند عدم وجود بيانات
            _showErrorAlert('No questions found for this chapter',
                'Please try selecting another chapter or contact support.');
          }
        } else {
          _showErrorAlert(
              'Error Loading Questions', 'API response format not as expected');
        }
      } else {
        _showErrorAlert(
            'Server Error', 'Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading questions: $e');
      _showErrorAlert('Error', 'Failed to load questions: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // دالة لعرض تنبيه الخطأ
  void _showErrorAlert(String title, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: title,
      text: message,
      confirmBtnText: 'OK',
      cancelBtnText: 'Go Back',
      showCancelBtn: true,
      onCancelBtnTap: () {
        Navigator.pop(context); // إغلاق التنبيه
        Navigator.pop(context); // العودة للصفحة السابقة
      },
      onConfirmBtnTap: () {
        Navigator.pop(context); // إغلاق التنبيه فقط
      },
    );
  }

  void _toggleSelection(dynamic question, String type) {
    setState(() {
      final selectedList = selectedQuestions[type]!;

      // التحقق من وجود العنصر المحدد في القائمة
      final isSelected = selectedList.contains(question);

      if (isSelected) {
        selectedList.remove(question);
      } else {
        selectedList.add(question);
      }
    });
  }

  bool _isSelected(dynamic question, String type) {
    return selectedQuestions[type]!.contains(question);
  }

  Future<void> _addToExam() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.patch(
        Uri.parse('$kBaseUrl/Doctor/SelectChapter'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'SelectedMCQs': selectedQuestions['mcq'],
          'SelectedEssayQuestions': selectedQuestions['essay'],
          'SelectedMultiQuestions': selectedQuestions['multi'],
          'modelName': widget.modelName,
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
    } finally {
      setState(() {
        isLoading = false;
      });
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
        title: const Text('Questions form Chapter Ai'),
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
              ...multiChoiceQuestions.map((passage) {
                return Container(
                  margin: EdgeInsets.only(top: 15.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFe9f5ff),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border(
                      left:
                          BorderSide(color: AppColors.ceruleanBlue, width: 4.w),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15.w),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _isSelected(passage, 'multi'),
                              onChanged: (_) =>
                                  _toggleSelection(passage, 'multi'),
                              activeColor: AppColors.ceruleanBlue,
                            ),
                            Text(
                              'Passage:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                passage['passage'] ?? '',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...List.generate(
                        (passage['questions'] as List<dynamic>?)
                                ?.take(3)
                                .length ??
                            0,
                        (qIndex) {
                          final question = passage['questions'][qIndex];
                          return Container(
                            margin: EdgeInsets.only(
                                left: 15.w, right: 15.w, bottom: 15.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(15.w),
                                  child: Text(
                                    question['question'] ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.w, right: 15.w, bottom: 15.h),
                                  child: Column(
                                    children: (question['options']
                                                as List<dynamic>?)
                                            ?.take(4)
                                            .map((option) => Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w,
                                                    vertical: 6.h,
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      bottom: 5.h),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFf8faff),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.r),
                                                  ),
                                                  child: Text(
                                                    option.toString(),
                                                    style: TextStyle(
                                                        fontSize: 14.sp),
                                                  ),
                                                ))
                                            .toList() ??
                                        [],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
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
          if (question['options'] != null && question['options'] is List) ...[
            SizedBox(height: 8.h),
            ...List.generate(
              (question['options'] as List).length,
              (index) {
                final option = question['options'][index];
                return Padding(
                  padding: EdgeInsets.only(left: 30.w, top: 4.h),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    margin: EdgeInsets.only(bottom: 5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFf8faff),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      option.toString(),
                      style: TextStyle(fontSize: 14.sp),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEssayQuestion(dynamic question) {
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
          const Icon(Icons.edit, size: 20),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              question['question'] ?? 'No question text',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
