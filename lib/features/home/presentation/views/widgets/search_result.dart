//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project/features/update/presentation/view/update_view.dart';
// import 'package:project/features/question/presentation/views/manual_questions.dart';
// import 'package:project/features/question/presentation/views/question_bank.dart';
// import 'package:project/features/correction_bubble_sheet/presentation/views/upload_student_paper.dart';
// import 'package:project/core/constants/colors.dart';
//
// class SearchResultList extends StatelessWidget {
//   final String searchText;
//   final bool isDarkMode;
//
//   const SearchResultList({Key? key, required this.searchText, required this.isDarkMode}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> allSections = [
//       {
//         'title': 'Update Page',
//         'subtitle': 'Update your profile and settings',
//         'icon': Icons.update,
//         'widget': UpdatePage(),
//       },
//       {
//         'title': 'Manual Exams',
//         'subtitle': 'Create and manage manual exams',
//         'icon': Icons.quiz,
//         'widget': ManualQuestionScreen(
//           courseName: '',
//           doctorId: '',
//           fileName: '',
//         ),
//       },
//       {
//         'title': 'Question bank',
//         'subtitle': 'Browse and manage question bank',
//         'icon': Icons.library_books,
//         'widget': QuestionBank(),
//       },
//       {
//         'title': 'correction bubble sheet',
//         'subtitle': 'Correct and grade bubble sheets',
//         'icon': Icons.assignment_turned_in,
//         'widget': CorrectBubbleSheetForStudent(
//           fileName: '',
//         ),
//       },
//     ];
//
//     List<Map<String, dynamic>> filteredSections = allSections
//         .where((section) => section['title']
//         .toLowerCase()
//         .contains(searchText.toLowerCase()))
//         .toList();
//
//     if (filteredSections.isEmpty) {
//       return Container(
//         padding: EdgeInsets.all(40.w),
//         child: Center(
//           child: Column(
//             children: [
//               Icon(
//                 Icons.search_off,
//                 size: 48.sp,
//                 color: Colors.grey[400],
//               ),
//               SizedBox(height: 16.h),
//               Text(
//                 "No results found",
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               Text(
//                 "Try searching with different keywords",
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: Colors.grey[500],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Column(
//       children: filteredSections
//           .map((section) => Container(
//         margin: EdgeInsets.only(bottom: 12.h),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               isDarkMode ? Colors.grey[800]! : Colors.grey[50]!,
//               isDarkMode ? Colors.grey[750]! : Colors.white,
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(16.r),
//           border: Border.all(
//             color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
//           ),
//         ),
//         child: ListTile(
//           contentPadding: EdgeInsets.all(16.w),
//           leading: Container(
//             padding: EdgeInsets.all(12.w),
//             decoration: BoxDecoration(
//               color: AppColors.darkBlue.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             child: Icon(
//               section['icon'],
//               color: AppColors.darkBlue,
//               size: 24.sp,
//             ),
//           ),
//           title: Text(
//             section['title'],
//             style: TextStyle(
//               fontSize: 16.sp,
//               fontWeight: FontWeight.bold,
//               color: isDarkMode ? Colors.white : AppColors.darkBlue,
//             ),
//           ),
//           subtitle: Text(
//             section['subtitle'],
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: isDarkMode ? Colors.white70 : Colors.grey[600],
//             ),
//           ),
//           trailing: Icon(
//             Icons.arrow_forward_ios,
//             color: AppColors.darkBlue,
//             size: 16.sp,
//           ),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => section['widget'],
//               ),
//             );
//           },
//         ),
//       ))
//           .toList(),
//     );
//   }
// }