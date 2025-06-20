import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01.h),
        child: SizedBox(
          height: screenHeight * 0.08.h,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ceruleanBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.015.h,
                horizontal: screenWidth * 0.05.w,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        buildButton('Question Bank', () {
          GoRouter.of(context).push(AppRouter.kQuestionBank);
        }),
        buildButton('Correction Of Bubble Sheet', () {
          GoRouter.of(context).push(AppRouter.kUploadModelAnswer);
        }),
        buildButton('Create Bubble Sheet', () {
          final doctorId = context.read<LoginCubit>().doctorDatabaseId;

          if (doctorId == null || doctorId.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("⚠ Doctor ID not found")),
            );
            return;
          }

          GoRouter.of(context).push(
            AppRouter.kCreateBubbleSheet,
            extra: doctorId,
          );
        }),
        buildButton('Create Models Of Questions', () {
          GoRouter.of(context).push(AppRouter.kStartExamPage);
        }),
      ],
    );
  }
}