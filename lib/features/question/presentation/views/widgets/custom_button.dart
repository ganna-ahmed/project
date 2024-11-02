import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';

class MoreButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          'More',
          style: TextStyle(
            fontSize: 24,
            color: AppColors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ceruleanBlue,
          fixedSize: Size(250, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}