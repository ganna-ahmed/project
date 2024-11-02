import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/constants.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/features/auth/presentation/view/login_page.dart';
import 'package:project/features/splash/presentation/views/widgets/splash_view_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashViewBody(),
    );
  }
}
