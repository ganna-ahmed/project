import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';

class MoreButton extends StatelessWidget {
  final double width;
  final double height;
  final double fontSize;

  const MoreButton({
    super.key,
    required this.width,
    required this.height,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width.w,
        height: height.h,
        child: ElevatedButton(
          onPressed: () {
            GoRouter.of(context).push(AppRouter.kLastQuestion);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            backgroundColor: AppColors.ceruleanBlue,
          ),
          child: Text(
            'More',
            style: TextStyle(fontSize: fontSize.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class DoneButton extends StatelessWidget {
  final double width;
  final double height;
  final double fontSize;

  const DoneButton({
    super.key,
    required this.width,
    required this.height,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width.w,
        height: height.h,
        child: ElevatedButton(
          onPressed: () {
            GoRouter.of(context).push(AppRouter.kLastQuestion);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            backgroundColor: AppColors.ceruleanBlue,
          ),
          child: Text(
            'Done',
            style: TextStyle(fontSize: fontSize.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class NavigationButtons extends StatelessWidget {
  final double buttonWidth;
  final double buttonHeight;
  final double fontSize;

  const NavigationButtons({
    super.key,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 10.h,
          left: 10.w,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: MoreButton(
                  width: buttonWidth,
                  height: buttonHeight,
                  fontSize: fontSize,
                ),
              ),
               SizedBox(width: 20.w),
              Expanded(
                child: DoneButton(
                  width: buttonWidth,
                  height: buttonHeight,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}