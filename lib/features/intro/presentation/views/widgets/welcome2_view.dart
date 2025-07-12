import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/intro/presentation/views/widgets/custom_button.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.07),
            Image.asset(
              'assets/images/onbroading2.png',
              width: screenWidth * 0.8,
              height: screenHeight * 0.38,
              fit: BoxFit.contain,
            ),
            SizedBox(height: screenHeight * 0.04),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Why Choose",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: " "),
                  TextSpan(
                    text: "SCORA",
                    style: TextStyle(
                      color: AppColors.ceruleanBlue,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: "?"),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.025),
            Column(
              children: [
                buildButton('Upload bubble sheets with ease.',
                    AppColors.ceruleanBlue, screenWidth),
                buildButton('Automate corrections for accurate results.',
                    AppColors.darkBlue, screenWidth),
                buildButton('Securely access and manage your data anytime',
                    AppColors.LightTeal, screenWidth),
              ],
            ),
            SizedBox(height: screenHeight * 0.015),
            NextButton(
              width: screenWidth * 0.5,
              height: screenHeight * 0.06,
              borderRadius: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String text, Color color, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size(screenWidth * 0.85, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: FittedBox(
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.04,
            ),
          ),
        ),
      ),
    );
  }
}
