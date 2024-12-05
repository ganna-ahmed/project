import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/question/presentation/views/widgets/custom_button.dart';
import 'widgets/aswe_field.dart';
import 'widgets/input_field.dart';
import 'widgets/question_section.dart';

class AddLastQuestion extends StatelessWidget {
  const AddLastQuestion({super.key});

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
                    const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Center(
                        child: const Text(
                          'Question 20',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Expanded(
                  child: MoreButton(
                    width: double.infinity,  // Make More Button take full width
                    height: 55,
                    fontSize: 22,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: DoneButton(
                    width: double.infinity,
                    height: 55,
                    fontSize: 22,
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