import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/custom_button.dart';
import '../../../user/presentation/views/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  static const Color customWhite = Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -80,
            child: SvgPicture.asset(
              'assets/svg/loginCircle.svg',
              width: 300,
              height: 300,
              colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(
              'assets/svg/circles.svg',
              width: 2000,
              height: 566,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.arrow_back, color: customWhite),
                      const SizedBox(width: 8),
                      Text(
                        LoginTexts.backButtonText,
                        style: TextStyle(color: customWhite, fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    LoginTexts.loginTitle,
                    style: TextStyle(color: customWhite, fontSize: 28),
                  ),
                  const SizedBox(height: 240),
                  const CustomTextField(
                    label: LoginTexts.emailLabel,
                    hintText: LoginTexts.emailHintText,
                  ),
                  const SizedBox(height: 20),
                  const CustomTextField(
                    label: LoginTexts.passwordLabel,
                    hintText: LoginTexts.passwordHintText,
                    obscureText: true,
                  ),
                  const SizedBox(height: 26),
                  CustomButton(
                    text: LoginTexts.loginButtonText,
                    onPressed: () {
                      // Define what happens when the button is pressed
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}