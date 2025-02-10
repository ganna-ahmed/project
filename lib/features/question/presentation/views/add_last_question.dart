import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // تأكد من استيراد الحزمة
import 'package:project/core/constants/colors.dart';
import 'package:project/features/question/presentation/views/widgets/custom_button.dart';
import 'widgets/aswe_field.dart';
import 'widgets/input_field.dart';
import 'widgets/question_section.dart';

class AddLastQuestion extends StatelessWidget {
  const AddLastQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: AppColors.ceruleanBlue,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.w,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Center(
                        child:  Text(
                          'Question 20',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50.h),
            const InputField(hintText: 'Input the question'),
            SizedBox(height: 80.h),
            Column(
              children: List.generate(4, (index) {
                return Column(
                  children: [
                    AnswerField(answerIndex: index + 1),
                    SizedBox(height: 30.h),
                  ],
                );
              }),
            ),
            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  [
                Expanded(
                  child: MoreButton(
                    width: double.infinity,
                    height: 55.h,
                    fontSize: 22.sp,
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: DoneButton(
                    width: double.infinity,
                    height: 55.h,
                    fontSize: 22.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}