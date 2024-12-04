import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';

import 'widgets/custom_button.dart';
import 'widgets/section.dart';

class BubbleSheetForm extends StatelessWidget {
  final double containerWidth = 320;
  final double cornerRadius = 30;

  const BubbleSheetForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: AppColors.white,
        title: const Text(
          'Create Bubble Sheet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormSection(),

              SizedBox(height: 20),

              DoneButton(
                width: 250,
                height: 55,
                fontSize: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
