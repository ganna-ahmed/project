import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:project/features/Main/presentation/view/main_screen.dart';
import 'package:project/features/auth/presentation/view/login_page.dart';
import 'package:project/features/auth/presentation/view/login_screen.dart';
import 'package:project/features/correction_bubble_sheet/presentation/views/check_page.dart';
import 'package:project/features/correction_bubble_sheet/presentation/views/loading_correction_page.dart';
import 'package:project/features/correction_bubble_sheet/presentation/views/progress_correct_bubble_sheet.dart';
import 'package:project/features/correction_bubble_sheet/presentation/views/set_degree.dart';
import 'package:project/features/correction_bubble_sheet/presentation/views/start_correction.dart';
import 'package:project/features/correction_bubble_sheet/presentation/views/upload_model_answer.dart';
import 'package:project/features/correction_bubble_sheet/presentation/views/upload_student_paper.dart';
import 'package:project/features/create_bubble_sheet/data/cubits/bubble_sheet_cubit/bubble_sheet_cubit.dart';
import 'package:project/features/create_bubble_sheet/data/repos/bubble_sheet_repo.dart';
import 'package:project/features/create_bubble_sheet/presentation/views/bubble_sheet_page.dart';
import 'package:project/features/home/presentation/views/home_view.dart';
import 'package:project/features/intro/presentation/views/intro.dart';
import 'package:project/features/list/presentation/views/list_view.dart';
import 'package:project/features/modelsOfQuestion/view/exam.dart';
import 'package:project/features/question/presentation/views/add_last_question.dart';
import 'package:project/features/question/presentation/views/add_question.dart';
import 'package:project/features/question/presentation/views/bubble_sheet.dart';
import 'package:project/features/question/presentation/views/question_bank.dart';
import 'package:project/features/splash/presentation/views/splash_view.dart';
import 'package:project/features/update/presentation/view/update_view.dart';
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
  static const kCreateBubbleSheet = '/BubbleSheet';
  static const kOnBoarding = '/OnBording';
  static const kMainScreen = '/MainScreen';
  static const kUpdateView = '/UpdateView';
  static const kUploadModelAnswer = '/UploadModelAnswer';
  static const kUploadStudentPaper = '/UploadStudentPaper';
  static const kStartExamPage = '/StartExamPage';
  static const kProcessingPage = '/kProcessingPage';
  static const kCheckForUpload = '/checkForUpload';
  static const kProgrssScreen = '/progressCorrect';
  static const kResultStudent = '/resultStudent';
  static const kStartCorrectScreen = '/StartCorrectScreen';
  static const kQuestionBank = '/QuestionBank';

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
      GoRoute(
        path: kHomeView,
        builder: (context, state) => const HomeView(),
      ),
      // GoRoute(
      //   path: kUploadView,
      //   builder: (context, state) => const MainScreen(),
      // ),
      GoRoute(
        path: kAddQuestion,
        builder: (context, state) => const AddQuestionPage(),
      ),
      //GoRoute(
      //  path: kLastQuestion,
      //builder: (context, state) => const AddLastQuestion(),
      // ),
      // AppRouter.dart
      GoRoute(
        path: kCreateBubbleSheet,
        builder: (context, state) {
          final doctorId = state.extra as String;
          return BlocProvider(
            create: (_) =>
                BubbleSheetCubit(BubbleSheetRepository(id: doctorId)),
            child: const BubbleSheetPage(),
          );
        },
      ),

      // GoRoute(
      //   path: kSetDegree,
      //   builder: (context, state) => SetDegree(),
      // ),
      GoRoute(
        path: kOnBoarding,
        builder: (context, state) => const OnBoarding(),
      ),
      GoRoute(
        path: kMainScreen,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: kUploadModelAnswer,
        builder: (context, state) => const UploadModelAnswer(),
      ),
      GoRoute(
        path: kUpdateView,
        builder: (context, state) => const UpdatePage(),
      ),
      GoRoute(
        path: AppRouter.kUploadStudentPaper,
        builder: (context, state) {
          final fileName = state.extra as String?;
          if (fileName == null) {
            Fluttertoast.showToast(msg: 'No file name received!');
            return const Scaffold(
                body: Center(child: Text('Error: No file provided')));
          }
          return CorrectBubbleSheetForStudent(fileName: fileName);
        },
      ),
      GoRoute(
        path: kProcessingPage,
        builder: (context, state) {
          final fileName = state.extra as String;
          return ProcessingPage(fileName: fileName);
        },
      ),
      // GoRoute(
      //   path: AppRouter.kCheckForUpload,
      //   builder: (context, state) {
      //     final args = state.extra as Map<String, String>;
      //     return ProgressCorrectBubbleSheet(
      //         bubbleSheetStudent: args['BubbleSheetStudent']!);
      //   },
      // ),
      // GoRoute(
      //     path: kProgrssCorrectBubbleSheet, // ✅ تأكد من إضافة هذا المسار هنا
      //     builder: (context, state) {
      //       final extra = state.extra as Map<String, dynamic>?;
      //       return ProgressCorrectBubbleSheet(
      //         bubbleSheetStudent: extra?['BubbleSheetStudent'] ?? "",
      //         pagesNumber: extra?['pagesNumber'] ?? "0", idDoctor: '',

      //       );
      //     }),

      GoRoute(
        path: kStartExamPage,
        builder: (context, state) => const StartExamPage(),
      ),
      // GoRoute(
      //   path: kStartCorrectScreen,
      //   builder: (context, state) => StartCorrectScreen(),
      // ),
      // GoRoute(
      //   path: AppRouter.kCheckForUpload,
      //   builder: (context, state) {
      //     final args = state.extra as Map<String, dynamic>;
      //     return CheckForUpload(bubbleSheetStudent: args['BubbleSheetStudent']);
      //   },
      // ),
      GoRoute(
        path: AppRouter.kCheckForUpload,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            Fluttertoast.showToast(msg: 'No data received!');
            return const Scaffold(
                body: Center(child: Text('Error: No data provided')));
          }
          return CheckForUpload(extra: extra);
        },
      ),
      GoRoute(
        path: AppRouter.kProgrssScreen,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            Fluttertoast.showToast(msg: 'No data received!');
            return const Scaffold(
                body: Center(child: Text('Error: No data provided')));
          }
          final fileName = extra['fileName'] as String?;
          final bubbleSheetStudent = extra['BubbleSheetStudent'] as String?;
          final pagesNumber = extra['pagesNumber'] as String?;
          if (fileName == null ||
              bubbleSheetStudent == null ||
              pagesNumber == null) {
            Fluttertoast.showToast(msg: 'Missing required data!');
            return const Scaffold(
                body: Center(child: Text('Error: Missing data')));
          }
          return ProgressScreen(
            idDoctor: extra['id'] as String?, // قد يكون null إذا لم يُمرر
            // answerBubbleSheet:
            //     extra['AnswerBubbleSheet'] as String?, // قد يكون null
            bubbleSheetStudent: bubbleSheetStudent,
            fileName: fileName, // تمرير fileName
            pagesNumber: pagesNumber,
          );
        },
      ),

      // GoRoute(
      //   path: '/setDegree',
      //   builder: (context, state) => SetDegreeScreen(),
      // ),
      GoRoute(
        path: '/resultStudent',
        builder: (context, state) => ResultStudentPage(),
      ),
      GoRoute(
        path: kQuestionBank,
        builder: (context, state) => QuestionBank(),
      ),
    ],
  );
}
