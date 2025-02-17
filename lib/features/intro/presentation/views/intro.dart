import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // تأكد من استيراد الحزمة
import 'package:project/core/constants/colors.dart';
import 'package:project/features/intro/presentation/views/widgets/welcom_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatelessWidget {
  OnBoarding({super.key});
  PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _controller,
          children: [
            const WelcomeScreen(),
            Container(
              color: AppColors.ceruleanBlue,
            ),
          ],
        ),
        Container(
            alignment: Alignment(0, 0.75),
            child: SmoothPageIndicator(controller: _controller, count: 2))
      ]),
    );
  }
}
