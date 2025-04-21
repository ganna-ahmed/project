import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/features/auth/data/models/sign_in_model.dart';
import 'package:project/features/create_bubble_sheet/data/cubits/bubble_sheet_cubit/bubble_sheet_state.dart';
import 'package:project/features/create_bubble_sheet/data/models/course_model.dart';
import 'package:project/features/create_bubble_sheet/data/repos/bubble_sheet_repo.dart';

// class BubbleSheetCubit extends Cubit<BubbleSheetState> {
//   final BubbleSheetRepository repository;

//   BubbleSheetCubit(this.repository) : super(BubbleSheetInitial());

//   Future<void> loadCourses() async {
//     try {
//       emit(BubbleSheetLoading());
//       final courses = await repository.fetchCourses();
//       emit(CoursesLoaded(courses));
//     } catch (e) {
//       emit(BubbleSheetError(e.toString()));
//     }
//   }

//   void resetState() {
//     emit(BubbleSheetInitial());
//   }

//   void selectCourse(String courseId, List<CourseModel> courses) {
//     final currentState = state;
//     if (currentState is CoursesLoaded) {
//       final selectedCourse = courses.firstWhere(
//         (course) => course.id == courseId,
//         orElse: () => courses.first,
//       );
//       emit(CoursesLoaded(courses, selectedCourse: selectedCourse));
//     }
//   }

//   Future<void> creaetPdf({required CourseModel course}) async {
//     try {
//       emit(BubbleSheetLoading());
//       // var status = await Permission.storage.status;
//       // if (!status.isGranted) {
//       //   status = await Permission.storage.request();
//       //   if (!status.isGranted) {
//       //     throw Exception('Storage permission is denied');
//       //   }
//       // }
//       final result = await repository.createPDF(course);
//       emit(PDFCreatedSuccess());
//     } catch (e) {
//       emit(BubbleSheetError(e.toString()));
//     }
//   }
// }

class BubbleSheetCubit extends Cubit<BubbleSheetState> {
  final BubbleSheetRepository repository;

  // Add these variables to store the data
  List<CourseModel> _courses = [];
  CourseModel? _selectedCourse;
  SignInModel? doctor;

  // Add getters to access the data
  List<CourseModel> get courses => _courses;
  CourseModel? get selectedCourse => _selectedCourse;

  BubbleSheetCubit(this.repository) : super(BubbleSheetInitial());

  Future<void> loadCourses() async {
    try {
      emit(BubbleSheetLoading());
      final courses = await repository.fetchCourses();
      _courses = courses; // Store courses
      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(BubbleSheetError(e.toString()));
    }
  }

  void resetState() {
    _courses = [];
    _selectedCourse = null;
    emit(BubbleSheetInitial());
  }

  void selectCourse(String courseId, List<CourseModel> courses) {
    final currentState = state;
    if (currentState is CoursesLoaded) {
      _selectedCourse = courses.firstWhere(
        (course) => course.id == courseId,
        orElse: () => courses.first,
      );
      emit(CoursesLoaded(courses, selectedCourse: _selectedCourse));
    }
  }

  Future<void> creaetPdf({required CourseModel course}) async {
    try {
      emit(BubbleSheetLoading());
      final result = await repository.createPDF(course);
      emit(PDFCreatedSuccess());
    } catch (e) {
      emit(BubbleSheetError(e.toString()));
      print('❌❌❌$e');
    }
  }
}
