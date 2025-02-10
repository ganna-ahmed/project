import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Edit profile",
          style: TextStyle(
            fontSize: 28.sp,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 0.1.sh,
                  backgroundColor: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/profile.png',
                        height: 0.9.sh,
                        width: 0.9.sh,
                      ),
                      Positioned(
                        bottom: 0.05.sh,
                        child: Image.asset(
                          'assets/images/camera.png',
                          height: 0.07.sh,
                          width: 0.07.sh,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 0.05.sh),
            _buildTextField(
              label: "Name",
              textColor: AppColors.black,
            ),
            SizedBox(height: 0.05.sh),
            _buildTextField(
              label: "Email",
              textColor: AppColors.black,
            ),
            SizedBox(height: 0.05.sh),
            _buildTextField(
              label: "Department",
              textColor: AppColors.black,
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.w),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.ceruleanBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 14.h),
            minimumSize: Size(double.infinity, 0.07.sh),
          ),
          child: Text(
            'Done',
            style: TextStyle(color: Colors.white, fontSize: 28.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Color textColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: "type here...",
            hintStyle: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}