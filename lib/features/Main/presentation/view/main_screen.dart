import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/home/presentation/views/home_view.dart';
import 'package:project/features/update/presentation/view/update_view.dart';
import 'package:project/features/user/presentation/views/profile_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Color buttonColor = AppColors.darkBlue;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeView(),
    const ProfileView(),
    const UpdatePage(),
  ];

  @override
  Widget build(BuildContext context) {
    double navBarHeight = 55.0;
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        letIndexChange: (index) => true,
        height: navBarHeight,
        color: AppColors.ceruleanBlue,
        backgroundColor: AppColors.white,
        buttonBackgroundColor: AppColors.lightGraynishBlue,
        animationDuration: const Duration(milliseconds: 300),
        key: _bottomNavigationKey,
        items: const <Widget>[
          Icon(
            FontAwesomeIcons.house,
            color: AppColors.darkBlue,
          ),
          Icon(
            FontAwesomeIcons.user,
            color: AppColors.darkBlue,
          ),
          Icon(
            Icons.update,
            color: AppColors.darkBlue,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:project/core/constants/colors.dart';
// import 'package:project/features/home/presentation/views/home_view.dart';
// import 'package:project/features/update/presentation/view/update_view.dart';
// import 'package:project/features/user/presentation/views/profile_view.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   Color buttonColor = AppColors.darkBlue;
//   final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
//   int _currentIndex = 0;
//   final List<Widget> _screens = [
//     const HomeView(),
//     const ProfileView(),
//     const UpdatePage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     double navBarHeight = 55.0;

//     // Use a Stack to overlay the navigation bar on top of the screens
//     return Stack(
//       children: [
//         // IndexedStack preserves the state of all screens
//         IndexedStack(
//           index: _currentIndex,
//           children: _screens,
//         ),
//         // Position the navigation bar at the bottom
//         Positioned(
//           left: 0,
//           right: 0,
//           bottom: 0,
//           child: CurvedNavigationBar(
//             letIndexChange: (index) => true,
//             height: navBarHeight,
//             color: AppColors.ceruleanBlue,
//             backgroundColor:
//                 Colors.transparent, // Use transparent to see content
//             buttonBackgroundColor: AppColors.lightGraynishBlue,
//             animationDuration: const Duration(milliseconds: 300),
//             key: _bottomNavigationKey,
//             items: const <Widget>[
//               Icon(
//                 FontAwesomeIcons.house,
//                 color: AppColors.darkBlue,
//               ),
//               Icon(
//                 FontAwesomeIcons.user,
//                 color: AppColors.darkBlue,
//               ),
//               Icon(
//                 Icons.update,
//                 color: AppColors.darkBlue,
//               ),
//             ],
//             onTap: (index) {
//               setState(() {
//                 _currentIndex = index;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
