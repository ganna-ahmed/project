import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/assets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(color: AppColors.darkBlue),
        ),
        actions: [
          Image.asset(
            AssetsData.profile,
            width: 73,
          )
        ],
      ),
    );
  }
}
