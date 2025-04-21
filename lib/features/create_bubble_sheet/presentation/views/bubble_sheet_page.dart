import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/features/create_bubble_sheet/data/cubits/bubble_sheet_cubit/bubble_sheet_cubit.dart';
import 'package:project/features/create_bubble_sheet/data/cubits/bubble_sheet_cubit/bubble_sheet_state.dart';
import 'package:project/features/create_bubble_sheet/presentation/views/widgets/course.dart';

class BubbleSheetPage extends StatefulWidget {
  const BubbleSheetPage({super.key});

  @override
  State<BubbleSheetPage> createState() => _BubbleSheetPageState();
}

class _BubbleSheetPageState extends State<BubbleSheetPage> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      context.read<BubbleSheetCubit>().resetState();
      context.read<BubbleSheetCubit>().loadCourses();
      _isInitialized = true;
    }
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

// class _BubbleSheetPageState extends State<BubbleSheetPage> {
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     context.read<BubbleSheetCubit>().loadCourses();
//   }

//   @override
//   void initState() {
//     super.initState();

//     context.read<BubbleSheetCubit>().resetState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: context.read<BubbleSheetCubit>(),
//       child: BlocBuilder<BubbleSheetCubit, BubbleSheetState>(
//         builder: (context, state) {
//           final courses = context.read<BubbleSheetCubit>().courses;
//           final selectedCourse =
//               context.read<BubbleSheetCubit>().selectedCourse;

//           return Course(
//             courses: courses,
//             selectedCourse: selectedCourse,
//           );
//         },
//       ),
//     );
//   }