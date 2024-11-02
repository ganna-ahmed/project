import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/core/utils/assets.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  void navigateToHome() {
    final dynamic currentcontext = context;
    Future.delayed(
      const Duration(seconds: 2),
      () {
        // Get.to(() => LoginScreen(),
        //     transition: Transition.fade, duration: kTransitionDuration);
        GoRouter.of(currentcontext).push(AppRouter.kLoginView);
      },
    );
  }

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
