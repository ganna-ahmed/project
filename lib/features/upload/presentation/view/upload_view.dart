import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/upload/presentation/view/widgets/buttons.dart';
import 'package:project/features/upload/presentation/view/widgets/constant.dart';

class UploadFileScreen extends StatelessWidget {
  const UploadFileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.snow,
      body: Column(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: Column(
                children: [
                  Text(
                    'Upload Files',
                    style: TextStyle(
                      fontSize: AppSizes.titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Upload your exam for editing.',
                    style: TextStyle(
                      fontSize: AppSizes.subtitleFontSize,
                      color: AppColors.darkBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: AppSizes.containerWidth,
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/cloud-upload.png',
                      width: AppSizes.iconWidth,
                      height: AppSizes.iconHeight,
                    ),
                    const SizedBox(height: 22),
                    CustomButtons.chooseFileButton(() {
                      // Add file picking logic here
                    }),
                    const SizedBox(height: 70),
                    CustomButtons.doneButton(() {
                      // Add submit logic here
                    }),
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
