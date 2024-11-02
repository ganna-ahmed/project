import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';

class WelcomeScreen extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;
  final double titleFontSize;
  final double subtitleFontSize;

  const WelcomeScreen({
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
            'Welcome to ORM',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        // محتوى الشاشة
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 100),
              SizedBox(
                width: imageWidth,
                height: imageHeight,
                child: Image.asset(
                  'assets/images/welcom.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'where your grades are securely managed.',
                style: TextStyle(
                  fontSize: subtitleFontSize,
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
