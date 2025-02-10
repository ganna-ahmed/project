import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';

class QuestionTitle extends StatelessWidget {
  const QuestionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: AppColors.ceruleanBlue,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}