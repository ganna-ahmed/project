import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/constants.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/features/auth/presentation/view/login_page.dart';
import 'package:project/features/splash/presentation/views/widgets/splash_view_body.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
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
    return const Scaffold(
      body: SplashViewBody(),
    );
  }
}
