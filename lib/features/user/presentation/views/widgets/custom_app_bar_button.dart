import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';

class CustomAppBarButton extends StatelessWidget {
  CustomAppBarButton(
      {super.key, required this.text, this.color, required this.onTap});
  final String text;
  final Color? color;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 32),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            width: 2,
            color: AppColors.darkBlue,
          ),
        ),
        child: const Text(
          'edit',
          style: TextStyle(color: AppColors.darkBlue),
        ),
      ),
    );
  }
}
