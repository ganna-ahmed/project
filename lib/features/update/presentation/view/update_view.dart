import 'package:flutter/material.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height.h;
    final screenWidth = MediaQuery.of(context).size.width.w;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            ImageWidget(
              height: screenHeight * 0.4,
              width: screenWidth.w,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1.w),
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
