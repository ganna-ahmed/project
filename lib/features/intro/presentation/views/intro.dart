import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/splash/presentation/views/welcom_view.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingSlider(
        headerBackgroundColor: Colors.white,
        finishButtonText: 'Login',
        finishButtonStyle: const FinishButtonStyle(
          backgroundColor: Colors.black,
        ),
        //skipTextButton: const Text('Skip'),
        //trailing: const Text('Login'),
        background: [
          Image.asset('assets/svg/welcom.svg'),
        ],
        totalPage: 1,
        speed: 1.8,
        pageBodies: const [
          WelcomeScreen(),
        ],
      ),
    );
  }
}
