import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/auth/presentation/view/widgets/back_grod_paiter.dart';
import 'package:project/features/auth/presentation/view/widgets/custom_button.dart';

import '../../../../core/utils/app_router.dart';
import '../../../user/presentation/views/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundPainter(),
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 65.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 24),
                  const Text(
                    LoginTexts.loginTitle,
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                  const SizedBox(height: 290),
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
                      GoRouter.of(context).push(AppRouter.kMainScreen);
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
