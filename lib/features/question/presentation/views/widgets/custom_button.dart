import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: () {
            GoRouter.of(context).push(AppRouter.kLastQuestion);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: AppColors.ceruleanBlue,
          ),
          child: Text(
            'More',
            style: TextStyle(fontSize: fontSize, color: Colors.white),
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
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: () {
            GoRouter.of(context).push(AppRouter.kLastQuestion);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: AppColors.ceruleanBlue,
          ),
          child: Text(
            'Done',
            style: TextStyle(fontSize: fontSize, color: Colors.white),
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
        // زر السهم للرجوع
        Positioned(
          top: 10,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // الرجوع للصفحة السابقة
            },
          ),
        ),
        // الأزرار الأخرى
        Padding(
          padding: const EdgeInsets.only(top: 50), // إزاحة المحتوى لأسفل بسبب زر السهم
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
              const SizedBox(width: 20),
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
