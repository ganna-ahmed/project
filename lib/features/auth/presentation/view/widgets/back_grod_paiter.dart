import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = AppColors.ceruleanBlue;
    canvas.drawCircle(
      Offset((-0.1).w, (-0.1).h),
      0.5.sw,
      paint,
    );


    paint.color = Colors.grey.shade300;
    final path1 = Path()
      ..moveTo(0, 0.35.sh)
      ..quadraticBezierTo(
        0.5.sw, 0.25.sh,
        1.sw, 0.35.sh,
      )
      ..lineTo(1.sw, 1.sh)
      ..lineTo(0, 1.sh)
      ..close();
    canvas.drawPath(path1, paint);


    paint.color = Colors.grey.shade400;
    final path2 = Path()
      ..moveTo(0, 0.45.sh)
      ..quadraticBezierTo(
        0.5.sw, 0.35.sh,
        1.sw, 0.45.sh,
      )
      ..lineTo(1.sw, 1.sh)
      ..lineTo(0, 1.sh)
      ..close();
    canvas.drawPath(path2, paint);

    paint.color = AppColors.ceruleanBlue;
    final path3 = Path()
      ..moveTo(0, 0.55.sh)
      ..quadraticBezierTo(
        0.5.sw, 0.45.sh,
        1.sw, 0.55.sh,
      )
      ..lineTo(1.sw, 1.sh)
      ..lineTo(0, 1.sh)
      ..close();
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
