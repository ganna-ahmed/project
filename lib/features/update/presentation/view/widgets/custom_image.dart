import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageWidget extends StatelessWidget {
  final double height;
  final double width;

  const ImageWidget({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1.w),
      child: Image.asset(
        'assets/images/update.png',
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}