// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project/core/cubits/theme_cubit.dart';
// import 'package:go_router/go_router.dart';
// import 'package:project/core/utils/app_router.dart';
// import 'package:provider/provider.dart';
//
// class SettingsView extends StatefulWidget {
//   const SettingsView({super.key});
//
//   @override
//   State<SettingsView> createState() => _SettingsViewState();
// }
//
// class _SettingsViewState extends State<SettingsView> {
//   bool notificationsEnabled = true;
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         leading: Container(
//           margin: EdgeInsets.all(8.w),
//           decoration: BoxDecoration(
//             color: isDarkMode ? Colors.grey[800] : Colors.white,
//             borderRadius: BorderRadius.circular(12.r),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: IconButton(
//             icon: Icon(
//               Icons.arrow_back_ios_new,
//               color: isDarkMode ? Colors.white : Colors.black87,
//               size: 20.sp,
//             ),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         title: Text(
//           "Settings",
//           style: TextStyle(
//             fontSize: 24.sp,
//             fontWeight: FontWeight.bold,
//             color: isDarkMode ? Colors.white : Colors.black87,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Section
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(20.w),
//               margin: EdgeInsets.only(bottom: 20.h),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     const Color(0xFF2196F3),
//                     const Color(0xFF1976D2),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(20.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF2196F3).withOpacity(0.3),
//                     blurRadius: 15,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(12.w),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(15.r),
//                     ),
//                     child: Icon(
//                       Icons.settings,
//                       color: Colors.white,
//                       size: 28.sp,
//                     ),
//                   ),
//                   SizedBox(width: 15.w),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Preferences",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         "Customize your experience",
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.8),
//                           fontSize: 14.sp,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             // Settings Cards
//             _buildSettingsCard(
//               context: context,
//               isDarkMode: isDarkMode,
//               icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
//               title: isDarkMode ? "Light Mode" : "Dark Mode",
//               subtitle: "Toggle between light and dark theme",
//               trailing: _buildCustomSwitch(
//                 value: isDarkMode,
//                 onChanged: (val) {
//                   context.read<ThemeCubit>().toggleTheme(val);
//                 },
//               ),
//             ),
//
//             SizedBox(height: 15.h),
//
//             _buildSettingsCard(
//               context: context,
//               isDarkMode: isDarkMode,
//               icon: Icons.notifications_outlined,
//               title: "Notifications",
//               subtitle: "Enable or disable push notifications",
//               trailing: _buildCustomSwitch(
//                 value: notificationsEnabled,
//                 onChanged: (val) {
//                   setState(() {
//                     notificationsEnabled = val;
//                   });
//                 },
//               ),
//             ),
//
//             SizedBox(height: 15.h),
//
//             _buildSettingsCard(
//               context: context,
//               isDarkMode: isDarkMode,
//               icon: Icons.language_outlined,
//               title: "Language",
//               subtitle: "Change app language",
//               trailing: Container(
//                 padding: EdgeInsets.all(8.w),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF2196F3).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10.r),
//                 ),
//                 child: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 16.sp,
//                   color: const Color(0xFF2196F3),
//                 ),
//               ),
//               onTap: () {
//                 _showLanguageDialog(context, isDarkMode);
//               },
//             ),
//
//             SizedBox(height: 30.h),
//
//             // Logout Section
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: isDarkMode ? Colors.grey[850] : Colors.white,
//                 borderRadius: BorderRadius.circular(20.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   borderRadius: BorderRadius.circular(20.r),
//                   onTap: () => _showLogoutDialog(context, isDarkMode),
//                   child: Padding(
//                     padding: EdgeInsets.all(20.w),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(12.w),
//                           decoration: BoxDecoration(
//                             color: Colors.red.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12.r),
//                           ),
//                           child: Icon(
//                             Icons.logout_outlined,
//                             color: Colors.red,
//                             size: 24.sp,
//                           ),
//                         ),
//                         SizedBox(width: 15.w),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Logout",
//                                 style: TextStyle(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                               Text(
//                                 "Sign out of your account",
//                                 style: TextStyle(
//                                   fontSize: 12.sp,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Icon(
//                           Icons.arrow_forward_ios,
//                           size: 16.sp,
//                           color: Colors.red.withOpacity(0.7),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSettingsCard({
//     required BuildContext context,
//     required bool isDarkMode,
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Widget trailing,
//     VoidCallback? onTap,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isDarkMode ? Colors.grey[850] : Colors.white,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             spreadRadius: 0,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(20.r),
//           onTap: onTap,
//           child: Padding(
//             padding: EdgeInsets.all(20.w),
//             child: Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(12.w),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF2196F3).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: Icon(
//                     icon,
//                     color: const Color(0xFF2196F3),
//                     size: 24.sp,
//                   ),
//                 ),
//                 SizedBox(width: 15.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                           color: isDarkMode ? Colors.white : Colors.black87,
//                         ),
//                       ),
//                       SizedBox(height: 2.h),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 12.sp,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 trailing,
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCustomSwitch({
//     required bool value,
//     required ValueChanged<bool> onChanged,
//   }) {
//     return GestureDetector(
//       onTap: () => onChanged(!value),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         width: 60.w,
//         height: 32.h,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20.r),
//           color: value ? const Color(0xFF2196F3) : Colors.grey[300],
//           boxShadow: [
//             BoxShadow(
//               color: value
//                   ? const Color(0xFF2196F3).withOpacity(0.3)
//                   : Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: AnimatedAlign(
//           duration: const Duration(milliseconds: 200),
//           alignment: value ? Alignment.centerRight : Alignment.centerLeft,
//           child: Container(
//             width: 28.w,
//             height: 28.h,
//             margin: EdgeInsets.all(2.w),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.15),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showLanguageDialog(BuildContext context, bool isDarkMode) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.r),
//         ),
//         title: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(8.w),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF2196F3).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10.r),
//               ),
//               child: Icon(
//                 Icons.language,
//                 color: const Color(0xFF2196F3),
//                 size: 24.sp,
//               ),
//             ),
//             SizedBox(width: 10.w),
//             Text(
//               "Coming Soon",
//               style: TextStyle(
//                 color: isDarkMode ? Colors.white : Colors.black87,
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         content: Text(
//           "Language settings will be available in the next update.",
//           style: TextStyle(
//             color: Colors.grey[600],
//             fontSize: 14.sp,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             style: TextButton.styleFrom(
//               backgroundColor: const Color(0xFF2196F3).withOpacity(0.1),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.r),
//               ),
//             ),
//             child: Text(
//               "OK",
//               style: TextStyle(
//                 color: const Color(0xFF2196F3),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showLogoutDialog(BuildContext context, bool isDarkMode) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.r),
//         ),
//         title: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(8.w),
//               decoration: BoxDecoration(
//                 color: Colors.red.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10.r),
//               ),
//               child: Icon(
//                 Icons.logout,
//                 color: Colors.red,
//                 size: 24.sp,
//               ),
//             ),
//             SizedBox(width: 10.w),
//             Text(
//               "Logout",
//               style: TextStyle(
//                 color: isDarkMode ? Colors.white : Colors.black87,
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         content: Text(
//           "Are you sure you want to logout from your account?",
//           style: TextStyle(
//             color: Colors.grey[600],
//             fontSize: 14.sp,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             style: TextButton.styleFrom(
//               backgroundColor: Colors.grey.withOpacity(0.1),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.r),
//               ),
//             ),
//             child: Text(
//               "Cancel",
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           SizedBox(width: 8.w),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//
//               // مسح البيانات المحفوظة (لو موجودة)
//               // SharedPreferences.getInstance().then((prefs) => prefs.clear());
//
//               // لو عندك LoginCubit للـ logout
//               // context.read<LoginCubit>().logout();
//
//               // استخدام GoRouter للخروج والرجوع للـ Login
//               context.go(AppRouter.kLoginView);
//
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text("Logged out successfully"),
//                   backgroundColor: const Color(0xFF2196F3),
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                 ),
//               );
//             },
//             style: TextButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.r),
//               ),
//             ),
//             child: Text(
//               "Logout",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }