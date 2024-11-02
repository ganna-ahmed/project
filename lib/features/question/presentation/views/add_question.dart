import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/features/question/presentation/views/widgets/question_section.dart';

import 'widgets/custom_button.dart';

class AddQuestion extends StatelessWidget {
  const AddQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            QuestionSectionWidget(),
            const SizedBox(height: 36),
            MoreButtonWidget(
              onPressed: () {
                GoRouter.of(context).push(AppRouter.kLastQuestion);
              },
            ),
          ],
        ),
      ),
    );
  }
}
