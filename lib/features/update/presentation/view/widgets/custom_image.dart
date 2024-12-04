import 'package:flutter/material.dart';

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
    return Container(
      padding: EdgeInsets.all(width * 0.05),
      child: Image.asset(
        'assets/images/update.png',
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}
