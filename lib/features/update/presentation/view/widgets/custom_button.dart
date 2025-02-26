import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';

class ButtonsWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const ButtonsWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildButton(String text, VoidCallback onPressed) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ceruleanBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: screenHeight * 0.07.h,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.045.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        buildButton('Create Models Of Question', () {}),
        SizedBox(height: screenHeight * 0.02.h),
        buildButton('Correction Of Bubble Sheet', () {
          GoRouter.of(context).push(AppRouter.kCorrectionBubbleSheet);
        }),
        SizedBox(height: screenHeight * 0.02.h),
        buildButton('Create Bubble Sheet', () {
          GoRouter.of(context).push(AppRouter.kCreateBubbleSheet);
        }),
      ],
    );
  }
}
