import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';

import 'common_question_widgets.dart'; // استيراد الملف

class QuestionListBase extends StatelessWidget {
  const QuestionListBase({
    Key? key,
    required this.title,
    required this.isLoading,
    required this.questionsLoaded,
    required this.onLoadQuestions,
    required this.onAddToExam,
    required this.questionSections,
    required this.isAddToExamEnabled,
  }) : super(key: key);

  final String title;
  final bool isLoading;
  final bool questionsLoaded;
  final VoidCallback onLoadQuestions;
  final VoidCallback onAddToExam;
  final List<Widget> questionSections;
  final bool isAddToExamEnabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                      onPressed: onLoadQuestions,
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
                            ...questionSections
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
                      onPressed: isAddToExamEnabled ? onAddToExam : null,
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
}