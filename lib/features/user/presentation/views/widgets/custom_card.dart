import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    this.paddingBottom,
    required this.color,
    required this.title,
    required this.subTitle,
  });

  final Color color;
  final String title;
  final String subTitle;
  final double? paddingBottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 55.w, top: 25.h, bottom: paddingBottom?.h ?? 55.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(48.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
              color: AppColors.white,
            ),
          ),
          Text(
            subTitle,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20.sp,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}