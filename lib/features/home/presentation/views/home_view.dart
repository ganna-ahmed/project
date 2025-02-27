import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/core/utils/assets.dart';
import 'package:project/features/auth/data/cubits/login_cubit/login_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
            onTap: () {}, // تعطيل الحدث عند الضغط على الصورة
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                if (state is LoginSuccess) {
                  return CircleAvatar(
                    radius: 25.r,
                    backgroundImage: NetworkImage(state.doctor.imageUrl),
                  );
                } else {
                  return Image.asset(
                    AssetsData.profile,
                    width: 73.w,
                  );
                }
              },
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
            SizedBox(height: 20.h),
            SizedBox(
              height: 400.h,
              child: ListView(
                children: [
                  ExamCard(
                    title: "Exam One",
                    questions: 20,
                    professors: const ["DR. Osama", "DR. Amr"],
                    color: AppColors.stoneBlue,
                    onTap: () {},
                  ),
                  ExamCard(
                    title: "Exam Two",
                    questions: 50,
                    professors: const ["DR. Osama"],
                    color: AppColors.paleSky,
                    onTap: () {},
                  ),
                  ExamCard(
                    title: "Exam Three",
                    questions: 100,
                    professors: const ["DR. Osama", "DR. Sara"],
                    color: AppColors.babyBlue,
                    onTap: () {},
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
        margin: const EdgeInsets.only(left: 2, bottom: 19, right: 30),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "$questions questions",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: professors
                  .map((professor) => Text(
                        professor,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
