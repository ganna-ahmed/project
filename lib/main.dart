import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/question/presentation/views/add_last_question.dart';
import 'package:project/features/question/presentation/views/add_question.dart';
import 'package:project/features/question/presentation/views/bubble_sheet.dart';
import 'package:project/features/splash/presentation/views/splash_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: AppColors.white,
      ),
      home: BubbleSheetForm(),
    );
  }
}
