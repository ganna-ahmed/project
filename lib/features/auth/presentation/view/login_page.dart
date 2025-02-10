import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 65.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Text(
                    LoginTexts.loginTitle,
                    style: TextStyle(color: Colors.white, fontSize: 28.sp),
                  ),
                  SizedBox(height: 290.h),
                  CustomTextField(
                    label: LoginTexts.emailLabel,
                    hintText: LoginTexts.emailHintText,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    label: LoginTexts.passwordLabel,
                    hintText: LoginTexts.passwordHintText,
                    obscureText: true,
                  ),
                  SizedBox(height: 26.h),
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