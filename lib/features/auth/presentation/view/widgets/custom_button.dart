import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.withOpacity(0.6),
          foregroundColor: Colors.white,
          minimumSize: Size(200.w, 40.h), // Width and height of the button
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h), // Padding around text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r), // Rounded corners
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 20.sp), // Adjust text size if needed
        ),
      ),
    );
  }
}

class DoneButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const DoneButton({
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 18.w),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Text(
          "Done",
          style: TextStyle(
            color: textColor,
            fontSize: 20.sp,
          ),
        ),
      ),
    );
  }
}

class BottomDoneButton extends StatelessWidget {
  final VoidCallback onPressed;

  BottomDoneButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80.h, // Height of the button
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r),
          topRight: Radius.circular(40.r),
        ),
      ),
      child: Center(
        child: DoneButton(
          onPressed: onPressed,
        ),
      ),
    );
  }
}