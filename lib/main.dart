import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/features/auth/data/cubits/login_cubit/login_cubit.dart';
import 'package:project/features/correction_bubble_sheet/data/cubits/cubit/answer_sheet_cubit.dart';
import 'package:project/features/correction_bubble_sheet/data/repos/answer_sheet_repo.dart';
import 'package:project/features/create_bubble_sheet/data/cubits/bubble_sheet_cubit/bubble_sheet_cubit.dart';
import 'package:project/features/create_bubble_sheet/data/repos/bubble_sheet_repo.dart';

void main() {
  debugPaintSizeEnabled = true;
  // const MainScreen();
  // WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize(
  //   debug: kDebugMode,
  //   ignoreSsl: true,
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final BubbleSheetRepository repository = BubbleSheetRepository();
  //  final AnswerSheetRepository repos = AnswerSheetRepository();
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(create: (context) => BubbleSheetCubit(repository)),
          //BlocProvider(create: (context) => AnswerSheetCubit(repos)),
        ],
        child: MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          theme: ThemeData().copyWith(
            scaffoldBackgroundColor: AppColors.white,
          ),
        ),
      ),
    );
  }
}
