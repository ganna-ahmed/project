import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/question/presentation/views/widgets/input_field.dart';

class AnswerField extends StatelessWidget {
  const AnswerField({
    super.key,
    required this.answerIndex,
  });

  final int answerIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<int>(
          value: answerIndex,
          groupValue: null,
          onChanged: (value) {},
        ),
        Expanded(
          child: InputField(
            hintText: 'Answer $answerIndex',
            borderColor: AppColors.black, // Custom color for answers
            borderRadius: 12.0,
          ),
        ),
      ],
    );
  }
}
