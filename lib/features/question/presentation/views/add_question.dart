import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/question/presentation/views/widgets/question_section.dart';

import 'widgets/custom_button.dart';

void main() {
  runApp(MaterialApp(
    home: AddQuestion(),
  ));
}

class AddQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            QuestionSectionWidget(),
            SizedBox(height: 36),
            MoreButtonWidget(),
          ],
        ),
      ),
    );
  }
}


