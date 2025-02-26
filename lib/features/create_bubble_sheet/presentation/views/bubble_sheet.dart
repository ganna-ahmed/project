// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project/core/constants/colors.dart';
// import 'package:project/features/create_bubble_sheet/data/cubits/bubble_sheet_cubit/bubble_sheet_cubit.dart';
// import 'package:project/features/create_bubble_sheet/data/models/course_model.dart';
// import 'package:project/features/create_bubble_sheet/presentation/views/widgets/course_form.dart';
// import '../../../question/presentation/views/widgets/custom_button.dart';
// import 'widgets/section.dart';

// class BubbleSheetForm extends StatefulWidget {
//   BubbleSheetForm({super.key, required this.courses, this.selectedCourse});
//   final List<CourseModel> courses;
//   final CourseModel? selectedCourse;
//   @override
//   State<BubbleSheetForm> createState() => _BubbleSheetFormState();
// }

// class _BubbleSheetFormState extends State<BubbleSheetForm> {
//   double containerWidth = 320.w;

//   double cornerRadius = 30.r;
//   String? selectedCourse;
//   late TextEditingController departmentController;
//   late TextEditingController courseNameController;
//   late TextEditingController courseCodeController;
//   late TextEditingController courseLevelController;
//   late TextEditingController semesterController;
//   late TextEditingController instructorController;
//   late TextEditingController dateController;
//   late TextEditingController timeController;
//   late TextEditingController fullMarkController;
//   late TextEditingController formController;
//   late TextEditingController numberOfQuestionsController;

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//   }

//   // @override
//   // void didUpdateWidget(CourseForm oldWidget) {
//   //   super.didUpdateWidget(oldWidget);
//   //   if (widget.selectedCourse != oldWidget.selectedCourse) {
//   //     _updateControllers();
//   //   }
//   // }

//   void _initializeControllers() {
//     departmentController =
//         TextEditingController(text: widget.selectedCourse?.department ?? '');
//     courseNameController =
//         TextEditingController(text: widget.selectedCourse?.courseName ?? '');
//     courseCodeController =
//         TextEditingController(text: widget.selectedCourse?.courseCode ?? '');
//     courseLevelController =
//         TextEditingController(text: widget.selectedCourse?.courseLevel ?? '');
//     semesterController =
//         TextEditingController(text: widget.selectedCourse?.semester ?? '');
//     instructorController =
//         TextEditingController(text: widget.selectedCourse?.instructor ?? '');
//     dateController =
//         TextEditingController(text: widget.selectedCourse?.date ?? '');
//     timeController =
//         TextEditingController(text: widget.selectedCourse?.time ?? '');
//     fullMarkController =
//         TextEditingController(text: widget.selectedCourse?.fullMark ?? '');
//     formController =
//         TextEditingController(text: widget.selectedCourse?.form ?? '');
//     numberOfQuestionsController = TextEditingController(
//       text: widget.selectedCourse?.numberOfQuestions ?? '',
//     );
//   }

//   void _updateControllers() {
//     departmentController.text = widget.selectedCourse?.department ?? '';
//     courseNameController.text = widget.selectedCourse?.courseName ?? '';
//     courseCodeController.text = widget.selectedCourse?.courseCode ?? '';
//     courseLevelController.text = widget.selectedCourse?.courseLevel ?? '';
//     semesterController.text = widget.selectedCourse?.semester ?? '';
//     instructorController.text = widget.selectedCourse?.instructor ?? '';
//     dateController.text = widget.selectedCourse?.date ?? '';
//     timeController.text = widget.selectedCourse?.time ?? '';
//     fullMarkController.text = widget.selectedCourse?.fullMark ?? '';
//     formController.text = widget.selectedCourse?.form ?? '';
//     numberOfQuestionsController.text =
//         widget.selectedCourse?.numberOfQuestions.toString() ?? '';
//   }

//   CourseModel _getUpdatedCourse() {
//     return CourseModel(
//       id: widget.selectedCourse?.id ?? '',
//       department: departmentController.text,
//       courseName: courseNameController.text,
//       courseCode: courseCodeController.text,
//       courseLevel: courseLevelController.text,
//       semester: semesterController.text,
//       instructor: instructorController.text,
//       date: dateController.text,
//       time: timeController.text,
//       fullMark: fullMarkController.text,
//       form: formController.text,
//       numberOfQuestions: numberOfQuestionsController.text,
//     );
//   }

//   @override
//   void dispose() {
//     departmentController.dispose();
//     courseNameController.dispose();
//     courseCodeController.dispose();
//     courseLevelController.dispose();
//     semesterController.dispose();
//     instructorController.dispose();
//     dateController.dispose();
//     timeController.dispose();
//     fullMarkController.dispose();
//     formController.dispose();
//     numberOfQuestionsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.ceruleanBlue,
//         foregroundColor: AppColors.white,
//         title: const Text(
//           'Create Bubble Sheet',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               DropdownButtonFormField<String>(
//                 value: widget.selectedCourse?.id,
//                 decoration: const InputDecoration(
//                   labelText: 'Select Course',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: widget.courses.map((course) {
//                   return DropdownMenuItem(
//                     value: course.id,
//                     child: Text('${course.courseName} (${course.courseCode})'),
//                   );
//                 }).toList(),
//                 onChanged: (courseId) {
//                   if (courseId != null) {
//                     context
//                         .read<BubbleSheetCubit>()
//                         .selectCourse(courseId, widget.courses);
//                   }
//                 },
//               ),
//               SizedBox(height: 20.h),
//               FormSection(),
//               SizedBox(height: 20.h),
//               DoneButton(
//                 width: 250.w,
//                 height: 55.h,
//                 fontSize: 20.sp,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// //  Widget _buildTextField(String hint) {
// //     TextEditingController controller = TextEditingController();
// //     return Padding(
// //       padding: EdgeInsets.symmetric(vertical: 10.h),
// //       child: TextField(
// //         controller: controller,
// //         style: TextStyle(fontSize: textFieldFontSize),
// //         decoration: InputDecoration(
// //           hintText: hint,
// //           hintStyle: TextStyle(fontSize: textFieldFontSize),
// //           filled: true,
// //           fillColor: Colors.blue[50],
// //           border: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(10.r),
// //             borderSide: BorderSide.none,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
