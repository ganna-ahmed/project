import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_image.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            ImageWidget(
              height: screenHeight * 0.35,
              width: screenWidth,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: ButtonsWidget(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
