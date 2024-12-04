import 'package:flutter/material.dart';
import 'package:project/features/question/presentation/views/widgets/input_field.dart';

import 'widgets/aswe_field.dart';
import 'widgets/custom_button.dart';
import 'widgets/question_section.dart';

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

            const QuestionTitle(title: 'Question 1:'),

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
