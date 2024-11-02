// lib/features/upload/presentation/view/widgets/custom_buttons.dart

import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/upload/presentation/view/widgets/constant.dart';

class CustomButtons {
  static Widget chooseFileButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
      ),
      child: const Text(
        'Choose File',
        style:
            TextStyle(fontSize: AppSizes.buttonFontSize, color: AppColors.snow),
      ),
    );
  }

  static Widget doneButton(VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.darkBlue,
        side: const BorderSide(color: AppColors.darkBlue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
      ),
      child: const Text(
        'Done',
        style:
            TextStyle(fontSize: AppSizes.buttonFontSize, color: AppColors.snow),
      ),
    );
  }
}
