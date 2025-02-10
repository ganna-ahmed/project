import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormSection extends StatelessWidget {
  final double textFieldFontSize = 16.sp;

  FormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: TextField(
        style: TextStyle(fontSize: textFieldFontSize),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: textFieldFontSize),
          filled: true,
          fillColor: Colors.blue[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}