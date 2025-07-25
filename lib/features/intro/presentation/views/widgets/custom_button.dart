import 'package:flutter/material.dart';
import 'package:project/features/auth/presentation/view/login_screen.dart';


class NextButton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final double fontSize;

  const NextButton({
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.fontSize = 32,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          'Next',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
