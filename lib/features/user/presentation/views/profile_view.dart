import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/features/user/data/repository/doctor_repository.dart';
import 'package:project/features/user/presentation/manager/cubit/doctor_cubit.dart';
import 'package:project/features/user/presentation/manager/cubit/doctor_state.dart';
import 'package:project/features/user/presentation/views/widgets/custom_app_bar_button.dart';
import 'package:project/features/user/presentation/views/widgets/custom_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView(
      {super.key, required String doctorId, required String password});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorCubit(DoctorRepository())..getDoctors(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(color: AppColors.darkBlue, fontSize: 20.sp),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.darkBlue,
            ),
          ),
          actions: [
            CustomAppBarButton(
              onTap: () {
                GoRouter.of(context).push(AppRouter.kEditProfileView);
              },
              text: 'edit',
            ),
          ],
        ),
        body: BlocBuilder<DoctorCubit, DoctorState>(
          builder: (context, state) {
            if (state is DoctorLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DoctorLoaded) {
              if (state.doctors.isEmpty) {
                return const Center(child: Text('No Doctors Available'));
              }
              final doctor =
                  state.doctors.first; // عرض أول دكتور فقط كـ Profile
              return Column(children: [
                SizedBox(
                  height: 0.02.sh,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(170.r),
                  child: Image.network(
                    doctor.imageUrl,
                    fit: BoxFit.fill,
                    width: 180.w,
                    height: 190.h,
                  ),
                ),
                SizedBox(
                  height: 0.02.sh,
                ),
                Text(
                  'DR. ${doctor.name}',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
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
                      subTitle: doctor.email,
                      color: AppColors.darkBlue,
                    ),
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: -107.h,
                      child: CustomCard(
                        title: 'Name',
                        subTitle: doctor.name,
                        color: AppColors.ceruleanBlue,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: -214.h,
                      child: CustomCard(
                        title: 'Department',
                        subTitle: doctor.department,
                        color: AppColors.wildBlueYonder, ),
                    ),
                  ],
                )
              ]);
            } else if (state is DoctorError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('No Data'));
            }
          },
        ),
      ),
    );
  }
}