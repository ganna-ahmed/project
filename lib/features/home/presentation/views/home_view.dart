import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/assets.dart';

import '../../../../core/utils/app_router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        leading: Icon(
          Icons.arrow_back,
          color: AppColors.darkBlue,
        ),
        title: Text(
          "Home",
          style: TextStyle(color: AppColors.darkBlue),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              GoRouter.of(context).push(AppRouter.kProfileView);
            },
            child: Image.asset(
              AssetsData.profile,
              width: 73,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push(AppRouter.kBubbleShett);
              },
              child: Text(
                "New Project",
                style: TextStyle(color: AppColors.white, fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ceruleanBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: Size(130, 60)),
            ),
            SizedBox(height: 60),
            Expanded(
              child: ListView(
                children: [
                  ExamCard(
                    title: "Exam One",
                    questions: 20,
                    professors: ["DR. Osama", "DR. Amr"],
                    color: AppColors.stoneBlue,
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kAddQuestion);
                    },
                  ),
                  ExamCard(
                    title: "Exam Two",
                    questions: 50,
                    professors: ["DR. Osama"],
                    color: AppColors.paleSky,
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kAddQuestion);
                    },
                  ),
                  ExamCard(
                    title: "Exam Three",
                    questions: 100,
                    professors: ["DR. Osama", "DR. Sara"],
                    color: AppColors.babyBlue,
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kAddQuestion);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExamCard extends StatelessWidget {
  final String title;
  final int questions;
  final List<String> professors;
  final Color color;
  final VoidCallback onTap;

  const ExamCard({
    required this.title,
    required this.questions,
    required this.professors,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 2, bottom: 19, right: 30),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white),
            ),
            Text(
              "$questions questions",
              style: TextStyle(fontSize: 16, color: AppColors.white),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: professors
                  .map((professor) => Text(
                        professor,
                        style: TextStyle(fontSize: 16, color: AppColors.white),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
