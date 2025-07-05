// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'note_and_reminder.dart';
//
// class WelcomeSection extends StatelessWidget {
//   final String doctorName;
//   final bool isDarkMode;
//
//   const WelcomeSection({Key? key, required this.doctorName, required this.isDarkMode}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Welcome back,",
//           style: TextStyle(
//             fontSize: 16.sp,
//             color: isDarkMode
//                 ? Colors.white70
//                 : Colors.black.withOpacity(0.7),
//           ),
//         ),
//         Text(
//           "Dr. $doctorName",
//           style: TextStyle(
//             fontSize: 24.sp,
//             fontWeight: FontWeight.bold,
//             color: isDarkMode ? Colors.white : Colors.black,
//           ),
//         ),
//         SizedBox(height: 20.h),
//
//         // Notes and Reminders Section
//         NotesAndRemindersSection(isDarkMode: isDarkMode),
//
//         SizedBox(height: 30.h),
//       ],
//     );
//   }
// }