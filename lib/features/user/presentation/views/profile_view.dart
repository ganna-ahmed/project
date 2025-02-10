import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/core/utils/assets.dart';
import 'package:project/features/user/presentation/views/widgets/custom_app_bar_button.dart';
import 'package:project/features/user/presentation/views/widgets/custom_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.darkBlue,
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          CustomAppBarButton(
            onTap: () {
              GoRouter.of(context).push(AppRouter.kEditProfileView);
            },
            text: 'edit',
          ),
        ],
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(color: AppColors.darkBlue, fontSize: 20.sp),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 0.02.sh,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(120.r),
              child: Image.asset(
                AssetsData.profile,
                fit: BoxFit.cover,
                width: 285.w,
                height: 235.h,
              ),
            ),
            Text(
              'DR.Osama Elghonemey',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
                fontSize: 24.sp,
              ),
            ),
            SizedBox(
              height: 0.05.sh,
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                CustomCard(
                  title: 'Email',
                  subTitle: 'osamaelghonemy@gmail.com',
                  color: AppColors.darkBlue,
                ),
                Positioned(
                  right: 0,
                  left: 0,
                  bottom: -107.h,
                  child: CustomCard(
                    title: 'Name',
                    subTitle: 'osamaelghonemy',
                    color: AppColors.ceruleanBlue,
                  ),
                ),
                Positioned(
                  right: 0,
                  left: 0,
                  bottom: -214.h,
                  child: CustomCard(
                    title: 'Department',
                    subTitle: 'CSE',
                    color: AppColors.wildBlueYonder,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}