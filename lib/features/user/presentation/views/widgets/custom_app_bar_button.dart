import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';

class CustomAppBarButton extends StatelessWidget {
  const CustomAppBarButton({
    super.key,
    required this.text,
    this.color,
    required this.onTap,
  });

  final String text;
  final Color? color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 32.w),
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            width: 2.w,
            color: AppColors.darkBlue,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}