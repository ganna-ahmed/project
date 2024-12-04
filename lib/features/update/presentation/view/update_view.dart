import 'package:flutter/material.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_image.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [

            ImageWidget(
              height: screenHeight * 0.5,
              width: screenWidth,
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
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
