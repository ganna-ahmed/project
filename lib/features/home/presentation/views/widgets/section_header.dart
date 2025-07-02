//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class SectionHeader extends StatelessWidget {
//   final Color color;
//   final IconData icon;
//   final String title;
//
//   const SectionHeader({
//     Key? key,
//     required this.color,
//     required this.icon,
//     required this.title,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(20.r),
//             border: Border.all(color: color.withOpacity(0.3)),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, color: color, size: 16.sp),
//               SizedBox(width: 6.w),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                   color: color,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }