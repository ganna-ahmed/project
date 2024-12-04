import 'package:flutter/material.dart';

class FormSection extends StatelessWidget {
  final double textFieldFontSize = 16;

  const FormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
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
      ),
    );
  }

  Widget buildTextField(String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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