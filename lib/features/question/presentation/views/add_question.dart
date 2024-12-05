import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/question/presentation/views/widgets/input_field.dart';
import 'widgets/aswe_field.dart';
import 'widgets/custom_button.dart';

class AddQuestion extends StatelessWidget {
  const AddQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: AppColors.ceruleanBlue,
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.white, size: 32),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Center(
                        child: const Text(
                          'Question 1',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            const InputField(hintText: 'Input the question'),
            const SizedBox(height: 80),
            Column(
              children: List.generate(4, (index) {
                return Column(
                  children: [
                    AnswerField(answerIndex: index + 1),
                    const SizedBox(height: 30),
                  ],
                );
              }),
            ),
            const SizedBox(height: 40),
            const MoreButton(
              width: 270,
              height: 55,
              fontSize: 22,
            ),
            // Done Button
          ],
        ),
      ),
    );
  }
}