import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/helper/show_snack_bar.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const CustomTextField(
      {Key? key,
      required this.label,
      required this.hintText,
      this.onChanged,
      this.obscureText = false,
      required this.controller})
      : super(key: key);
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 30.sp,
            color: AppColors.white,
          ),
        ),
        SizedBox(height: 22.h),
        TextFormField(
          obscureText: obscureText,
          validator: (data) {
            if (data!.isEmpty) {
              showSnackBar(context, 'inter your$hintText');
            }
          },
          onChanged: onChanged,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.spanishGray,
              fontSize: 18.sp,
            ),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class LoginTexts {
  static const String backButtonText = 'Back';
  static const String loginTitle = 'Log In';
  static const String emailLabel = 'Doctor ID';
  static const String passwordLabel = 'Password';
  static const String emailHintText = 'type here...';
  static const String passwordHintText = 'type here...';
  static const String loginButtonText = 'Log in';
}
