import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {super.key,
      this.paddingBottom,
      required this.color,
      required this.title,
      required this.subTitle});
  final Color color;
  final String title;
  final String subTitle;
  final double? paddingBottom;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 55, top: 25, bottom: paddingBottom ?? 55),
      width: double.infinity,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(48),
            topLeft: Radius.circular(48),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: AppColors.white),
          ),
          Text(
            subTitle,
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
