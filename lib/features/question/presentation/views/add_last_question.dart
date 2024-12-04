import 'package:flutter/material.dart';
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


            const QuestionTitle(title: 'Question 20:'),

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
                    fontSize: 22, ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
