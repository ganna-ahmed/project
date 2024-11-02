import 'package:go_router/go_router.dart';
import 'package:project/features/auth/presentation/view/login_page.dart';
import 'package:project/features/splash/presentation/views/splash_view.dart';
import 'package:project/features/user/presentation/views/edit_profile.dart';
import 'package:project/features/user/presentation/views/profile_view.dart';

abstract class AppRouter {
  static const kLoginView = '/LoginScreen';
  static const kProfileView = '/ProfileView';
  static const kEditProfileView = '/EditProfileView';
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: kLoginView,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: kProfileView,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: kEditProfileView,
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
  );
}
