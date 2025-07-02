
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';

class MultiChoiceQuestionsSection extends StatelessWidget {
  const MultiChoiceQuestionsSection({
    Key? key,
    required this.multiChoiceQuestions,
    required this.isSelected,
    required this.toggleSelection,
  }) : super(key: key);

  final List<dynamic> multiChoiceQuestions;
  final bool Function(dynamic, String) isSelected;
  final Function(dynamic, String) toggleSelection;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  left: BorderSide(color: AppColors.ceruleanBlue, width: 4.w),
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
                          value: isSelected(passage, 'multi'),
                          onChanged: (_) => toggleSelection(passage, 'multi'),
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
                            passage['paragraph'] ?? passage['passage'] ?? '',
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
                                children: ((question['options'] ??
                                    question['choices'])
                                as List<dynamic>?)
                                    ?.take(4)
                                    .map((option) => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 6.h,
                                  ),
                                  margin: EdgeInsets.only(bottom: 5.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFf8faff),
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  child: Text(
                                    option.toString(),
                                    style: TextStyle(fontSize: 14.sp),
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
    );
  }
}