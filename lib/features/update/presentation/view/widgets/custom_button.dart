import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';
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
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: screenHeight * 0.07,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.045,
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
        SizedBox(height: screenHeight * 0.02),
        buildButton('Correction Of Bubble Sheet', () {}),
        SizedBox(height: screenHeight * 0.02),
        buildButton('Create Bubble Sheet', () {}),
      ],
    );
  }
}
