// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'dart:io';
//
// // Custom Colors
// class CustomColors {
//   static const Color lightTeal = Color(0xff72B7C9);
//   static const Color stoneBlue = Color(0xFF507687);
// }
//
// // Note Model
// class NoteModel {
//   String id;
//   String title;
//   String content;
//   String? imagePath;
//   DateTime createdAt;
//   bool isCompleted;
//
//   NoteModel({
//     required this.id,
//     required this.title,
//     required this.content,
//     this.imagePath,
//     required this.createdAt,
//     this.isCompleted = false,
//   });
// }
//
// class NoteItem extends StatelessWidget {
//   final NoteModel note;
//   final VoidCallback onDelete;
//
//   const NoteItem({Key? key, required this.note, required this.onDelete}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 15.h),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: note.isCompleted
//               ? [Colors.grey[100]!, Colors.grey[50]!]
//               : [
//             CustomColors.lightTeal.withOpacity(0.08),
//             CustomColors.lightTeal.withOpacity(0.03)
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(
//           color: note.isCompleted
//               ? Colors.grey[300]!
//               : CustomColors.lightTeal.withOpacity(0.2),
//           width: 1.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: note.isCompleted
//                 ? Colors.grey.withOpacity(0.1)
//                 : CustomColors.lightTeal.withOpacity(0.1),
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: Row(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 // setState(() { // Removed setState as it's a StatelessWidget
//                 //   note.isCompleted = !note.isCompleted;
//                 // });
//               },
//               child: Container(
//                 width: 24.w,
//                 height: 24.h,
//                 decoration: BoxDecoration(
//                   color: note.isCompleted
//                       ? CustomColors.lightTeal
//                       : Colors.transparent,
//                   border: Border.all(
//                     color:
//                     note.isCompleted ? CustomColors.lightTeal : Colors.grey,
//                     width: 2,
//                   ),
//                   borderRadius: BorderRadius.circular(4.r),
//                 ),
//                 child: note.isCompleted
//                     ? Icon(Icons.check, color: Colors.white, size: 16.sp)
//                     : null,
//               ),
//             ),
//             SizedBox(width: 12.w),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     note.title,
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w700,
//                       decoration:
//                       note.isCompleted ? TextDecoration.lineThrough : null,
//                       color: note.isCompleted
//                           ? Colors.grey
//                           : CustomColors.lightTeal,
//                     ),
//                   ),
//                   if (note.content.isNotEmpty) ...[
//                     SizedBox(height: 6.h),
//                     Text(
//                       note.content,
//                       style: TextStyle(
//                         fontSize: 13.sp,
//                         color:
//                         note.isCompleted ? Colors.grey : Colors.grey[700],
//                         decoration: note.isCompleted
//                             ? TextDecoration.lineThrough
//                             : null,
//                         height: 1.3,
//                       ),
//                     ),
//                   ],
//                   if (note.imagePath != null) ...[
//                     SizedBox(height: 10.h),
//                     Container(
//                       height: 70.h,
//                       width: 70.w,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12.r),
//                         border: Border.all(
//                             color: CustomColors.lightTeal.withOpacity(0.3)),
//                         image: DecorationImage(
//                           image: FileImage(File(note.imagePath!)),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ],
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