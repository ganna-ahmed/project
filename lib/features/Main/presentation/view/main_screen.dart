import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  // دالة للانتقال لصفحة الـ Home مع الاحتفاظ بالـ bottom bar
  void navigateToHome() {
    setState(() {
      _currentIndex = 0;
    });
  }

  // دالة للانتقال لصفحة معينة مع الاحتفاظ بالـ bottom bar
  void navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
        index: _currentIndex, // تأكد من إضافة هذا السطر
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

// Widget مساعد للوصول للـ MainScreen من أي مكان
class MainScreenHelper {
  static void navigateToHome(BuildContext context) {
    context.go('/MainScreen');
  }

  static void navigateToHomeWithTab(BuildContext context, int tabIndex) {
    // يمكنك إضافة معاملات إضافية هنا لتحديد التاب
    context.go('/MainScreen');
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
//     return Scaffold(
//       extendBody: true,
//       body: SafeArea(
//         bottom: false,
//         child: _screens[_currentIndex],
//       ),
//       bottomNavigationBar: CurvedNavigationBar(
//         letIndexChange: (index) => true,
//         height: navBarHeight,
//         color: AppColors.ceruleanBlue,
//         backgroundColor: AppColors.white,
//         buttonBackgroundColor: AppColors.lightGraynishBlue,
//         animationDuration: const Duration(milliseconds: 300),
//         key: _bottomNavigationKey,
//         items: const <Widget>[
//           Icon(
//             FontAwesomeIcons.house,
//             color: AppColors.darkBlue,
//           ),
//           Icon(
//             FontAwesomeIcons.user,
//             color: AppColors.darkBlue,
//           ),
//           Icon(
//             Icons.update,
//             color: AppColors.darkBlue,
//           ),
//         ],
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }
