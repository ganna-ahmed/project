import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';

class WelcomeScreen extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;
  final double titleFontSize;
  final double subtitleFontSize;

  const WelcomeScreen({
    super.key,
    this.imageWidth = 300.0,
    this.imageHeight = 300.0,
    this.titleFontSize = 30.0,
    this.subtitleFontSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: BackgroundClipper(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            color: Colors.blue[700],
          ),
        ),
        Align(
          alignment: const Alignment(0, -0.7),
          child: Text(
            'Welcome to SCORA',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: titleFontSize.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 100.h),
              SizedBox(
                width: imageWidth.w,
                height: imageHeight.h,
                child: Image.asset(
                  'assets/images/welcom.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                'where your grades are securely managed.',
                style: TextStyle(
                  fontSize: subtitleFontSize.sp,
                  color: AppColors.ceruleanBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
