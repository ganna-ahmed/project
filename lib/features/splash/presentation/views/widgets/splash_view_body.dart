import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/assets.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.ceruleanBlue,
            AppColors.splashBlue,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            AssetsData.splashLogo,
            width: 272,
            height: 59,
          ),
        ],
      ),
    );
  }
}
