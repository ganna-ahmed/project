import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/assets.dart';
import 'package:project/features/user/presentation/manager/cubit/doctor_cubit.dart';
import '../../../../core/utils/app_router.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        leading: const Icon(
          Icons.arrow_back,
          color: AppColors.darkBlue,
        ),
        title: const Text(
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
              width: 73.w,
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(25.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push(AppRouter.kCreateBubbleSheet);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ceruleanBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                minimumSize: Size(130.w, 60.h),
              ),
              child: Text(
                "New Project",
                style: TextStyle(color: AppColors.white, fontSize: 20.sp),
              ),
            ),
            SizedBox(height: 60.h),
            Expanded(
              child: ListView(
                children: [
                  ExamCard(
                    title: "Exam One",
                    questions: 20,
                    professors: const ["DR. Osama", "DR. Amr"],
                    color: AppColors.stoneBlue,
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kAddQuestion);
                    },
                  ),
                  ExamCard(
                    title: "Exam Two",
                    questions: 50,
                    professors: const ["DR. Osama"],
                    color: AppColors.paleSky,
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kAddQuestion);
                    },
                  ),
                  ExamCard(
                    title: "Exam Three",
                    questions: 100,
                    professors: const ["DR. Osama", "DR. Sara"],
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
    super.key,
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
        margin: EdgeInsets.only(left: 2.w, bottom: 19.h, right: 30.w),
        padding: EdgeInsets.all(15.w), // Use ScreenUtil for padding
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            Text(
              "$questions questions",
              style: TextStyle(fontSize: 16.sp, color: AppColors.white),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: professors
                  .map((professor) => Text(
                        professor,
                        style:
                            TextStyle(fontSize: 16.sp, color: AppColors.white),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
