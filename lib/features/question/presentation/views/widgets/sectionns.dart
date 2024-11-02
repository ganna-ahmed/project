import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';

class HeaderSection extends StatelessWidget {
  final double cornerRadius = 30;
  final double titleFontSize = 18;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.ceruleanBlue,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(cornerRadius),
        ),
      ),
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          "Create Bubble Sheet",
          style: TextStyle(
            color: Colors.white,
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class FormSection extends StatelessWidget {
  final double textFieldFontSize = 16;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTextField("Enter the department"),
        buildTextField("Enter the Course Name"),
        buildTextField("Enter the Course Code"),
        buildTextField("Enter the Course Level"),
        buildTextField("Enter the Semester"),
        buildTextField("Enter the Instructor Name"),
        buildTextField("mm/dd/yyyy"),
        buildTextField("Enter the time"),
        buildTextField("Enter the Full Mark"),
        buildTextField("Final or Midterm"),
      ],
    );
  }

  Widget buildTextField(String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        style: TextStyle(fontSize: textFieldFontSize),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: textFieldFontSize),
          filled: true,
          fillColor: Colors.blue[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
