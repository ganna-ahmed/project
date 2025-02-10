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
      body: _screens[_currentIndex],
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
