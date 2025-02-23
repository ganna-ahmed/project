import 'package:go_router/go_router.dart';
import 'package:project/features/Main/presentation/view/main_screen.dart';
import 'package:project/features/auth/presentation/view/login_page.dart';
import 'package:project/features/create_bubble_sheet/presentation/views/bubble_sheet_page.dart';
import 'package:project/features/home/presentation/views/home_view.dart';
import 'package:project/features/intro/presentation/views/intro.dart';
import 'package:project/features/question/presentation/views/add_last_question.dart';
import 'package:project/features/question/presentation/views/add_question.dart';
import 'package:project/features/question/presentation/views/bubble_sheet.dart';
import 'package:project/features/splash/presentation/views/splash_view.dart';
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
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: kLoginView,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '$kProfileView/:doctorId/:password',
        builder: (context, state) {
          final doctorId = state.pathParameters['doctorId'] ?? '';
          final password = state.pathParameters['password'] ?? '';
          return ProfileView(doctorId: doctorId, password: password);
        },
      ),

      GoRoute(
        path: kEditProfileView,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: kHomeView,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: kUploadView,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: kAddQuestion,
        builder: (context, state) => AddQuestionPage(),
      ),
      //GoRoute(
      //  path: kLastQuestion,
      //builder: (context, state) => const AddLastQuestion(),
      // ),
      GoRoute(
        path: kBubbleShett,
        builder: (context, state) => const BubbleSheetPage(),
      ),
      GoRoute(
        path: kOnBoarding,
        builder: (context, state) => OnBoarding(),
      ),
      GoRoute(
        path: kMainScreen,
        builder: (context, state) => const MainScreen(),
      ),
    ],
  );
}
