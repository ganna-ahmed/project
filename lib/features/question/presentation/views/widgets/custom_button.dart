import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';

class MoreButtonWidget extends StatelessWidget {
  const MoreButtonWidget({super.key, required this.onPressed});
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ceruleanBlue,
          fixedSize: Size(250, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'More',
          style: TextStyle(
            fontSize: 24,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class DoneButton extends StatelessWidget {
  final double buttonFontSize = 16;
  final double buttonPaddingVertical = 10;
  final double buttonPaddingHorizontal = 20;

  const DoneButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.ceruleanBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: buttonPaddingVertical,
          horizontal: buttonPaddingHorizontal,
        ),
        child: Text(
          "Done",
          style: TextStyle(
            color: Colors.white,
            fontSize: buttonFontSize,
          ),
        ),
      ),
    );
  }
}
