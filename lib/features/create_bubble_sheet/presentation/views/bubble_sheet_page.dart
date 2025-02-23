import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/features/create_bubble_sheet/data/cubits/bubble_sheet_cubit/bubble_sheet_cubit.dart';
import 'package:project/features/create_bubble_sheet/data/cubits/bubble_sheet_cubit/bubble_sheet_state.dart';
import 'package:project/features/create_bubble_sheet/presentation/views/widgets/course.dart';
import 'package:project/features/create_bubble_sheet/presentation/views/widgets/course_form.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class BubbleSheetPage extends StatefulWidget {
  const BubbleSheetPage({super.key});

  @override
  State<BubbleSheetPage> createState() => _BubbleSheetPageState();
}

class _BubbleSheetPageState extends State<BubbleSheetPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<BubbleSheetCubit>().loadCourses();
  }

  @override
  void initState() {
    super.initState();

    context.read<BubbleSheetCubit>().resetState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<BubbleSheetCubit>(),
      child: BlocBuilder<BubbleSheetCubit, BubbleSheetState>(
        builder: (context, state) {
          final courses = context.read<BubbleSheetCubit>().courses;
          final selectedCourse =
              context.read<BubbleSheetCubit>().selectedCourse;

          return Course(
            courses: courses,
            selectedCourse: selectedCourse,
          );
        },
      ),
    );
  }
}
// return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: AppColors.ceruleanBlue,
    //     foregroundColor: AppColors.white,
    //     title: const Text(
    //       'Create Bubble Sheet',
    //       style: TextStyle(fontWeight: FontWeight.bold),
    //     ),
    //   ),
    //   body: BlocConsumer<BubbleSheetCubit, BubbleSheetState>(
    //     listener: (context, state) {
    //       if (state is PDFCreatedSuccess) {
    //         Future.microtask(() {
    //           QuickAlert.show(
    //               context: context,
    //               type: QuickAlertType.success,
    //               text: 'Download Completed Successfully!',
    //               onConfirmBtnTap: () {
    //                 //context.read<BubbleSheetCubit>().resetState();
    //                 Navigator.pop(context);
    //                 GoRouter.of(context)
    //                     .pushReplacement(AppRouter.kAddQuestion);
    //                 context.read<BubbleSheetCubit>().resetState();
    //               });
    //         });
    //       }
    //     },
    //     builder: (context, state) {
    //       if (state is BubbleSheetInitial) {
    //         context.read<BubbleSheetCubit>().loadCourses();
    //         return const Center(
    //             child: CircularProgressIndicator(
    //           color: AppColors.ceruleanBlue,
    //         ));
    //       }

    //       if (state is BubbleSheetLoading) {
    //         return const Center(
    //             child: CircularProgressIndicator(
    //           color: AppColors.ceruleanBlue,
    //         ));
    //       }

    //       if (state is BubbleSheetError) {
    //         //return Center(child: Text(state.message));
    //         QuickAlert.show(
    //           context: context,
    //           type: QuickAlertType.error,
    //           title: 'Oops...',
    //           text: 'Sorry, something went wrong',
    //           onCancelBtnTap: () {
    //             Navigator.pop(context);
    //             GoRouter.of(context).pop(AppRouter.kHomeView);
    //             context.read<BubbleSheetCubit>().resetState();
    //           },
    //         );
    //       }

    //       if (state is CoursesLoaded) {
    //         return CourseForm(
    //           courses: state.courses,
    //           selectedCourse: state.selectedCourse,
    //         );
    //       }

    //       return Container(); // حالة افتراضية
    //     },
    //   ),
    // );