import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';

import 'widgets/custom_button.dart';
import 'widgets/sectionns.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BubbleSheetForm(),
    );
  }
}

class BubbleSheetForm extends StatelessWidget {
  final double containerWidth = 320;
  final double cornerRadius = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(cornerRadius),
            ),
            width: containerWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeaderSection(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        FormSection(),
                        SizedBox(height: 20),
                        DoneButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
