import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 400.h,
          decoration: const BoxDecoration(
            color: AppColors.wildBlueYonder,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(150.0),
              bottomRight: Radius.circular(150.0),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 60.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ceruleanBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 40.h,
                        horizontal: 5.w,
                      ),
                      minimumSize: Size(160.w, 60.h),
                    ),
                    onPressed: () {
                      GoRouter.of(context).push(AppRouter.kUploadView);
                    },
                    child: Column( // Removed "const" here
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Update',
                          style: TextStyle(fontSize: 28.sp, color: Colors.white),
                        ),
                        Text(
                          'Project',
                          style: TextStyle(fontSize: 28.sp, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ceruleanBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 40.h,
                        horizontal: 5.w,
                      ),
                      minimumSize: Size(160.w, 60.h),
                    ),
                    onPressed: () {
                      GoRouter.of(context).push(AppRouter.kAddQuestion);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New',
                          style: TextStyle(fontSize: 28.sp, color: Colors.white),
                        ),
                        Text(
                          'Project',
                          style: TextStyle(fontSize: 28.sp, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 40.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ceruleanBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  minimumSize: Size(double.infinity, 48.h),
                ),
                onPressed: () {
                  GoRouter.of(context).push(AppRouter.kBubbleShett);
                },
                child: Text(
                  'Create Bubble Sheet',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: AppColors.snow,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ceruleanBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  minimumSize: Size(double.infinity, 48.h),
                ),
                onPressed: () {},
                child: Text(
                  'Create Models Of Question',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: AppColors.snow,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ceruleanBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  minimumSize: Size(double.infinity, 48.h),
                ),
                onPressed: () {},
                child: Text(
                  'Correction Of Bubble Sheet',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: AppColors.snow,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
