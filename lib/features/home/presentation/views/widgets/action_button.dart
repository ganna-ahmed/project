//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class ActionButton extends StatelessWidget {
//   final Color color;
//   final IconData icon;
//   final String label;
//   final VoidCallback onPressed;
//
//   const ActionButton({
//     Key? key,
//     required this.color,
//     required this.icon,
//     required this.label,
//     required this.onPressed,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [color, color.withOpacity(0.8)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(15.r),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ElevatedButton.icon(
//         onPressed: onPressed,
//         icon: Icon(icon, size: 22.sp, color: Colors.white),
//         label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           foregroundColor: Colors.white,
//           shadowColor: Colors.transparent,
//           padding: EdgeInsets.symmetric(vertical: 15.h),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15.r),
//           ),
//         ),
//       ),
//     );
//   }
// }