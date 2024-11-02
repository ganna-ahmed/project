import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';

class QuestionSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // عنوان السؤال
        Container(
          width: 250,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.ceruleanBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              'Question 1:',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 36),

        // حقل إدخال نص السؤال
        TextField(
          decoration: InputDecoration(
            hintText: 'Input the question',
            hintStyle: TextStyle(fontSize: 18, color: AppColors.black),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.black, width: 2),
            ),
          ),
        ),
        SizedBox(height: 18),

        // مربعات إدخال الإجابات
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: 9,
          crossAxisSpacing: 9,
          childAspectRatio: 3,
          children: List.generate(4, (index) {
            return TextField(
              decoration: InputDecoration(
                hintText: 'Answer ${index + 1}',
                hintStyle: TextStyle(fontSize: 18, color: AppColors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.black, width: 2),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 20),

        // قائمة الخيارات مع الأزرار الدائرية (Radio Buttons)
        Column(
          children: List.generate(4, (index) {
            return Row(
              children: [
                Radio<int>(
                  value: index + 1,
                  groupValue: null,
                  onChanged: (value) {},
                ),
                Text(
                  '${index + 1}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}