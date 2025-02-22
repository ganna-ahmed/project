import 'package:project/features/create_bubble_sheet/data/models/course_model.dart';

abstract class BubbleSheetState {}

class BubbleSheetInitial extends BubbleSheetState {}

class BubbleSheetLoading extends BubbleSheetState {}

class BubbleSheetError extends BubbleSheetState {
  final String message;
  BubbleSheetError(this.message);
}

class CoursesLoaded extends BubbleSheetState {
  final List<CourseModel> courses;
  final CourseModel? selectedCourse;
  CoursesLoaded(this.courses, {this.selectedCourse});
}

class PDFCreatedSuccess extends BubbleSheetState {}
