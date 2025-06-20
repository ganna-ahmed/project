// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project/core/constants/colors.dart';
// import 'widgets/custom_button.dart';
// import 'widgets/section.dart';

// class BubbleSheetForm extends StatelessWidget {
//   double containerWidth = 320.w;
//   double cornerRadius = 30.r;

//   BubbleSheetForm({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.ceruleanBlue,
//         foregroundColor: AppColors.white,
//         title: const Text(
//           'Create Bubble Sheet',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               FormSection(),
//               SizedBox(height: 20.h),
//               DoneButton(
//                 width: 250.w,
//                 height: 55.h,
//                 fontSize: 20.sp,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
