import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 30, color: AppColors.white),
        ),
        const SizedBox(height: 22),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.spanishGray),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
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
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String emailHintText = 'type here...';
  static const String passwordHintText = 'type here...';
  static const String loginButtonText = 'Log in';
}
