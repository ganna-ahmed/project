import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // تأكد من استيراد الحزمة
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
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: Colors.black,
          // تغيير النص ليكون بحجم أكبر باستخدام Theme أو TextStyle
        ),
        background: [
          // تأكد من أن الصورة متاحة في المسار الصحيح
          Image.asset(
            'assets/svg/welcom.svg',
            width: 300.w, // استخدم ScreenUtil للعرض
            height: 200.h, // استخدم ScreenUtil للارتفاع
            fit: BoxFit.cover,
          ),
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