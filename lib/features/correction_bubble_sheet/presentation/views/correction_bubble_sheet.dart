import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';

class CorrectionBubbleSheet extends StatelessWidget {
  const CorrectionBubbleSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: AppColors.white,
        title: const Text(
          'Correction Bubble Sheet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
