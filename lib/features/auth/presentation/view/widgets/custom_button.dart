 import 'package:flutter/material.dart';

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
          minimumSize: const Size(200, 40), // Width and height of the button
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding around text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20), // Adjust text size if needed
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
         borderRadius: BorderRadius.circular(20),
       ),
       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
       child: TextButton(
         onPressed: onPressed,
         style: TextButton.styleFrom(
           padding: EdgeInsets.zero,
         ),
         child: Text(
           "Done",
           style: TextStyle(color: textColor,
             fontSize: 20,
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
       height: 80,
       decoration: BoxDecoration(
         color: Colors.blue,
         borderRadius: BorderRadius.only(
           topLeft: Radius.circular(40),
           topRight: Radius.circular(40),
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