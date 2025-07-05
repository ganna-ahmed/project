//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project/core/constants/colors.dart';
//
// class EmptyStateDashboard extends StatelessWidget {
//   const EmptyStateDashboard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         padding: EdgeInsets.all(40.w),
//         child: Column(
//           children: [
//             Icon(
//               Icons.home_outlined,
//               size: 80.sp,
//               color: AppColors.darkBlue.withOpacity(0.3),
//             ),
//             SizedBox(height: 20.h),
//             Text(
//               "Welcome to your Dashboard",
//               style: TextStyle(
//                 fontSize: 20.sp,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.darkBlue,
//               ),
//             ),
//             SizedBox(height: 10.h),
//             Text(
//               "Start by adding notes and reminders to organize your work",
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }