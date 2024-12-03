// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:project/core/constants/colors.dart';
// import 'package:project/features/home/presentation/views/home_view.dart';
// import 'package:project/features/user/presentation/views/profile_view.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class CustomNavBar extends StatefulWidget {
//   const CustomNavBar({super.key});

//   @override
//   State<CustomNavBar> createState() => _CustomNavBarState();
// }

// class _CustomNavBarState extends State<CustomNavBar> {
//   List<Widget> screens = [
//     const HomeView(),
//     const ProfileView(),
//     //const FileScreen(),
//   ];
//   int _page = 0;
//   final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     return CurvedNavigationBar(
//       height: 60,
//       color: AppColors.ceruleanBlue,
//       backgroundColor: AppColors.white,
//       buttonBackgroundColor: AppColors.darkBlue,
//       key: _bottomNavigationKey,
//       items: const <Widget>[
//         Icon(
//           FontAwesomeIcons.house,
//         ),
//         Icon(
//           FontAwesomeIcons.user,
//         ),
//         Icon(Icons.update),
//         // SizedBox(
//         //   width: 30.w,
//         //   height: 30.h,
//         //   child: Image.asset(
//         //     Assets.pngSearch,
//         //   ),
//         // ),
//       ],
//       onTap: (index) {
//         setState(() {
//           _page = index;
//         });
//       },
//     );
//   }
// }
