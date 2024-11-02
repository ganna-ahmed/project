import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/splash/presentation/views/welcom_view.dart';
import 'package:project/features/user/presentation/views/home_view.dart';

import 'features/question/presentation/views/bubble_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: AppColors.white,
      ),
      home: HomeScreen(),
    );
  }
}
