import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';

class AddLastQuestion extends StatelessWidget {
  const AddLastQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                width: 250,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.ceruleanBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
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
            const SizedBox(height: 36),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Input the question',
                hintStyle: TextStyle(fontSize: 18, color: AppColors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.black, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 18),
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
                    hintStyle:
                        const TextStyle(fontSize: 18, color: AppColors.black),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.black, width: 2),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
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
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ceruleanBlue,
                    fixedSize: const Size(125, 60), // حجم الزر
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'More',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBlue,
                    fixedSize: const Size(125, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.white,
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
