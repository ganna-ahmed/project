import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';

void main() {
  runApp(MaterialApp(
    home: AddLastQuestion(),
  ));
}

class AddLastQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                width: 250,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.ceruleanBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Question 20:',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 36),
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
            SizedBox(height: 36),
            Row(  // استخدام Row لعرض الأزرار جنبًا إلى جنب
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
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
                    fixedSize: Size(125, 60), // حجم الزر
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                SizedBox(width: 20), // مساحة بين الزرين
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBlue,
                    fixedSize: Size(125, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
