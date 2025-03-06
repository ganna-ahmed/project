import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/assets.dart';
import 'package:project/features/auth/data/cubits/login_cubit/login_cubit.dart';
import 'package:project/features/user/presentation/views/widgets/custom_app_bar_button.dart';
import 'package:project/features/user/presentation/views/widgets/custom_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        if (state is LoginSuccess) {
          final doctor = state.doctor;

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: AppColors.darkBlue),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Profile',
                style: TextStyle(color: AppColors.darkBlue, fontSize: 20.sp),
              ),
              actions: [
                CustomAppBarButton(
                  onTap: () {
                    GoRouter.of(context).push('/edit-profile');
                  },
                  text: 'edit',
                ),
              ],
            ),
            body: Center(
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  CircleAvatar(
                    radius: 90.r,
                    backgroundImage: doctor.image.path != null
                        ? NetworkImage(doctor.image.path!)
                        : const AssetImage(AssetsData.profile) as ImageProvider,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'DR. ${doctor.nameDoctor}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                      fontSize: 38.sp,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    doctor.emailDoctor,
                    style:
                        TextStyle(fontSize: 20.sp, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    doctor.specializationDoctor,
                    style:
                        TextStyle(fontSize: 20.sp, color: AppColors.darkBlue),
                  ),
                  SizedBox(height: 40.h),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CustomCard(
                        title: 'Email',
                        subTitle: doctor.emailDoctor,
                        color: AppColors.darkBlue,
                      ),
                      Positioned(
                        right: 0,
                        left: 0,
                        bottom: -95.h,
                        child: CustomCard(
                          title: 'Name',
                          subTitle: doctor.nameDoctor,
                          color: AppColors.ceruleanBlue,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        left: 0,
                        bottom: -185.h,
                        child: CustomCard(
                          title: 'Department',
                          subTitle: doctor.specializationDoctor,
                          color: AppColors.wildBlueYonder,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('No doctor logged in')),
          );
        }
      },
    );
  }
}
