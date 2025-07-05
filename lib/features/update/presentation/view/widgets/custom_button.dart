import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/features/auth/data/cubits/login_cubit/login_cubit.dart';

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
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ceruleanBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildButton('Question Bank', () {
          GoRouter.of(context).push(AppRouter.kQuestionBank);
        }),
        buildButton('Correction Of Bubble Sheet', () {
          GoRouter.of(context).push(AppRouter.kUploadModelAnswer);
        }),
        buildButton('Create Models Of Questions', () {
          GoRouter.of(context).push(AppRouter.kStartExamPage);
        }),
      ],
    );
  }
}
