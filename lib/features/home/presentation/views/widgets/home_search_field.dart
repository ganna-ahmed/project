// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class HomeSearchField extends StatelessWidget {
//   final TextEditingController controller;
//   final bool isDarkMode;
//   final Function(String) onChanged;
//   final VoidCallback onClearSearch;
//   final String searchText;
//
//   const HomeSearchField({
//     Key? key,
//     required this.controller,
//     required this.isDarkMode,
//     required this.onChanged,
//     required this.onClearSearch,
//     required this.searchText,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: "Search...",
//         filled: true,
//         fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
//         prefixIcon: searchText.isNotEmpty
//             ? IconButton(
//           icon: Icon(Icons.arrow_back,
//               color: isDarkMode ? Colors.white70 : Colors.black45),
//           onPressed: onClearSearch,
//         )
//             : Icon(Icons.search,
//             color: isDarkMode ? Colors.white70 : Colors.black45),
//         suffixIcon: null, // 👈 نخلي الـ suffix فاضي أثناء البحث
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
//       onChanged: onChanged,
//     );
//   }
// }