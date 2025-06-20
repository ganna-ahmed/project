import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/core/utils/assets.dart';
import 'package:project/features/auth/data/cubits/login_cubit/login_cubit.dart';

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
            onTap: () {}, // تعطيل الحدث عند الضغط على الصورة أو تفعيل للذهاب للبروفايل
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                if (state is LoginSuccess) {
                  return Container(
                    margin: EdgeInsets.only(right: 16.w),
                    child: CircleAvatar(
                      radius: 25.r,
                      backgroundColor: AppColors.darkBlue,
                      child: ClipOval(
                        child: Image.network(
                          state.doctor.image.path,
                          width: 50.w,
                          height: 50.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // في حالة فشل تحميل الصورة، اعرض الصورة الافتراضية
                            return Image.asset(
                              AssetsData.profile,
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  // إذا مكنش في دكتور مسجل دخول، اعرض الصورة الافتراضية
                  return Container(
                    margin: EdgeInsets.only(right: 16.w),
                    child: CircleAvatar(
                      radius: 25.r,
                      backgroundColor: AppColors.darkBlue,
                      child: ClipOval(
                        child: Image.asset(
                          AssetsData.profile,
                          width: 50.w,
                          height: 50.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
            // إضافة ترحيب بالدكتور
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                if (state is LoginSuccess) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back,",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.darkBlue.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        "Dr. ${state.doctor.nameDoctor}",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue,
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  );
                }
                return SizedBox(height: 10.h);
              },
            ),
            ElevatedButton(
              onPressed: () {
                final doctorId = context.read<LoginCubit>().doctorDatabaseId;

                if (doctorId == null || doctorId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("⚠️ Doctor ID not found")),
                  );
                  return;
                }

                GoRouter.of(context).push(
                  AppRouter.kCreateBubbleSheet,
                  extra: doctorId,
                );
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
            Expanded(
              child: ListView(
                shrinkWrap: true,
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