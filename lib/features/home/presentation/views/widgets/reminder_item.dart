// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// // Custom Colors
// class CustomColors {
//   static const Color lightTeal = Color(0xff72B7C9);
//   static const Color stoneBlue = Color(0xFF507687);
// }
//
// // Reminder Model
// class ReminderModel {
//   String id;
//   String title;
//   String description;
//   DateTime reminderDate;
//   bool isCompleted;
//
//   ReminderModel({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.reminderDate,
//     this.isCompleted = false,
//   });
// }
//
// class ReminderItem extends StatelessWidget {
//   final ReminderModel reminder;
//   final VoidCallback onDelete;
//
//   const ReminderItem({Key? key, required this.reminder, required this.onDelete}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 15.h),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: reminder.isCompleted
//               ? [Colors.grey[100]!, Colors.grey[50]!]
//               : [
//             CustomColors.stoneBlue.withOpacity(0.08),
//             CustomColors.stoneBlue.withOpacity(0.03)
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(
//           color: reminder.isCompleted
//               ? Colors.grey[300]!
//               : CustomColors.stoneBlue.withOpacity(0.2),
//           width: 1.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: reminder.isCompleted
//                 ? Colors.grey.withOpacity(0.1)
//                 : CustomColors.stoneBlue.withOpacity(0.1),
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: Row(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: reminder.isCompleted
//                     ? Colors.grey[400]
//                     : CustomColors.stoneBlue,
//                 shape: BoxShape.circle,
//               ),
//               child: Checkbox(
//                 value: reminder.isCompleted,
//                 onChanged: (val) {
//                   // setState(() { // Removed setState as it's a StatelessWidget
//                   //   reminder.isCompleted = val ?? false;
//                   // });
//                 },
//                 activeColor: Colors.transparent,
//                 checkColor: Colors.white,
//                 side: BorderSide.none,
//               ),
//             ),
//             SizedBox(width: 12.w),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     reminder.title,
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w700,
//                       decoration: reminder.isCompleted
//                           ? TextDecoration.lineThrough
//                           : null,
//                       color: reminder.isCompleted
//                           ? Colors.grey
//                           : CustomColors.stoneBlue,
//                     ),
//                   ),
//                   if (reminder.description.isNotEmpty) ...[
//                     SizedBox(height: 6.h),
//                     Text(
//                       reminder.description,
//                       style: TextStyle(
//                         fontSize: 13.sp,
//                         color: reminder.isCompleted
//                             ? Colors.grey
//                             : Colors.grey[700],
//                         decoration: reminder.isCompleted
//                             ? TextDecoration.lineThrough
//                             : null,
//                         height: 1.3,
//                       ),
//                     ),
//                   ],
//                   SizedBox(height: 8.h),
//                   Container(
//                     padding:
//                     EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
//                     decoration: BoxDecoration(
//                       color: reminder.isCompleted
//                           ? Colors.grey[300]
//                           : CustomColors.stoneBlue.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8.r),
//                       border: Border.all(
//                         color: reminder.isCompleted
//                             ? Colors.grey[400]!
//                             : CustomColors.stoneBlue.withOpacity(0.3),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.access_time,
//                           size: 14.sp,
//                           color: reminder.isCompleted
//                               ? Colors.grey
//                               : CustomColors.stoneBlue,
//                         ),
//                         SizedBox(width: 4.w),
//                         Text(
//                           "${reminder.reminderDate.day}/${reminder.reminderDate.month}/${reminder.reminderDate.year} at ${reminder.reminderDate.hour.toString().padLeft(2, '0')}:${reminder.reminderDate.minute.toString().padLeft(2, '0')}",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             color: reminder.isCompleted
//                                 ? Colors.grey
//                                 : CustomColors.stoneBlue,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.red.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: IconButton(
//                 onPressed: onDelete, // Call the onDelete callback
//                 icon:
//                 Icon(Icons.delete_outline, color: Colors.red, size: 22.sp),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }