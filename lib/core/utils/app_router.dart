import 'package:go_router/go_router.dart';
import 'package:project/features/Main/presentation/view/main_screen.dart';
import 'package:project/features/auth/presentation/view/login_page.dart';
import 'package:project/features/home/presentation/views/home_view.dart';
import 'package:project/features/intro/presentation/views/intro.dart';
import 'package:project/features/question/presentation/views/add_last_question.dart';
import 'package:project/features/question/presentation/views/add_question.dart';
import 'package:project/features/question/presentation/views/bubble_sheet.dart';
import 'package:project/features/splash/presentation/views/splash_view.dart';
import 'package:project/features/upload/presentation/view/upload_view.dart';
import 'package:project/features/user/presentation/views/edit_profile.dart';
import 'package:project/features/user/presentation/views/profile_view.dart';

abstract class AppRouter {
  static const kLoginView = '/LoginScreen';
  static const kProfileView = '/ProfileView';
  static const kEditProfileView = '/EditProfileView';
  static const kHomeView = '/HomeView';
  static const kUploadView = '/UploadFileScreen';
  static const kAddQuestion = '/AddQuestion';
  static const kLastQuestion = '/LastQuestion';
  static const kBubbleShett = '/BubbleSheet';
  static const kOnBoarding = '/OnBording';
  static const kMainScreen = '/MainScreen';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => SplashView(),
      ),
      GoRoute(
        path: kLoginView,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: kProfileView,
        builder: (context, state) => ProfileView(),
      ),
      GoRoute(
        path: kEditProfileView,
        builder: (context, state) => EditProfileScreen(),
      ),
      GoRoute(
        path: kHomeView,
        builder: (context, state) => HomeView(),
      ),
      GoRoute(
        path: kUploadView,
        builder: (context, state) => MainScreen(),
      ),
      GoRoute(
        path: kAddQuestion,
        builder: (context, state) => AddQuestion(),
      ),
      GoRoute(
        path: kLastQuestion,
        builder: (context, state) => AddLastQuestion(),
      ),
      GoRoute(
        path: kBubbleShett,
        builder: (context, state) => BubbleSheetForm(),
      ),
      GoRoute(
        path: kOnBoarding,
        builder: (context, state) => OnBoarding(),
      ),
      GoRoute(
        path: kMainScreen,
        builder: (context, state) => MainScreen(),
      ),
    ],
  );
}
