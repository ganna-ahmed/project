import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.hintText,
    this.borderColor = AppColors.black,
    this.borderRadius = 16.0,
  });

  final String hintText;
  final Color borderColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 18.sp,
          color: Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor,
            width: 2.w,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius.r)),
        ),
      ),
    );
  }
}