import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/features/create_bubble_sheet/data/cubits/bubble_sheet_cubit/bubble_sheet_cubit.dart';
import 'package:project/features/create_bubble_sheet/data/cubits/bubble_sheet_cubit/bubble_sheet_state.dart';
import 'package:project/features/create_bubble_sheet/data/models/course_model.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Course extends StatefulWidget {
  final List<CourseModel> courses;
  final CourseModel? selectedCourse;

  const Course({
    super.key,
    required this.courses,
    this.selectedCourse,
  });

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  bool isLoading = false;

  late TextEditingController departmentController;
  late TextEditingController courseNameController;
  late TextEditingController courseCodeController;
  late TextEditingController courseLevelController;
  late TextEditingController semesterController;
  late TextEditingController instructorController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController fullMarkController;
  late TextEditingController formController;
  late TextEditingController numberOfQuestionsController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(Course oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCourse != oldWidget.selectedCourse) {
      _updateControllers();
    }
    // context.read<BubbleSheetCubit>().loadCourses();
  }

  void _initializeControllers() {
    departmentController =
        TextEditingController(text: widget.selectedCourse?.department ?? '');
    courseNameController =
        TextEditingController(text: widget.selectedCourse?.courseName ?? '');
    courseCodeController =
        TextEditingController(text: widget.selectedCourse?.courseCode ?? '');
    courseLevelController =
        TextEditingController(text: widget.selectedCourse?.courseLevel ?? '');
    semesterController =
        TextEditingController(text: widget.selectedCourse?.semester ?? '');
    instructorController =
        TextEditingController(text: widget.selectedCourse?.instructor ?? '');
    dateController =
        TextEditingController(text: widget.selectedCourse?.date ?? '');
    timeController =
        TextEditingController(text: widget.selectedCourse?.time ?? '');
    fullMarkController =
        TextEditingController(text: widget.selectedCourse?.fullMark ?? '');
    formController =
        TextEditingController(text: widget.selectedCourse?.form ?? '');
    numberOfQuestionsController = TextEditingController(
      text: widget.selectedCourse?.numberOfQuestions ?? '',
    );
  }

  void _updateControllers() {
    departmentController.text = widget.selectedCourse?.department ?? '';
    courseNameController.text = widget.selectedCourse?.courseName ?? '';
    courseCodeController.text = widget.selectedCourse?.courseCode ?? '';
    courseLevelController.text = widget.selectedCourse?.courseLevel ?? '';
    semesterController.text = widget.selectedCourse?.semester ?? '';
    instructorController.text = widget.selectedCourse?.instructor ?? '';
    dateController.text = widget.selectedCourse?.date ?? '';
    timeController.text = widget.selectedCourse?.time ?? '';
    fullMarkController.text = widget.selectedCourse?.fullMark ?? '';
    formController.text = widget.selectedCourse?.form ?? '';
    numberOfQuestionsController.text =
        widget.selectedCourse?.numberOfQuestions.toString() ?? '';
  }

  CourseModel _getUpdatedCourse() {
    return CourseModel(
      id: widget.selectedCourse?.id ?? '',
      department: departmentController.text,
      courseName: courseNameController.text,
      courseCode: courseCodeController.text,
      courseLevel: courseLevelController.text,
      semester: semesterController.text,
      instructor: instructorController.text,
      date: dateController.text,
      time: timeController.text,
      fullMark: fullMarkController.text,
      form: formController.text,
      numberOfQuestions: numberOfQuestionsController.text,
    );
  }

  @override
  void dispose() {
    departmentController.dispose();
    courseNameController.dispose();
    courseCodeController.dispose();
    courseLevelController.dispose();
    semesterController.dispose();
    instructorController.dispose();
    dateController.dispose();
    timeController.dispose();
    fullMarkController.dispose();
    formController.dispose();
    numberOfQuestionsController.dispose();
    super.dispose();
  }

  bool _areAllFieldsFilled() {
    bool filled = departmentController.text.isNotEmpty &&
        courseNameController.text.isNotEmpty &&
        courseCodeController.text.isNotEmpty &&
        courseLevelController.text.isNotEmpty &&
        semesterController.text.isNotEmpty &&
        instructorController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        fullMarkController.text.isNotEmpty &&
        formController.text.isNotEmpty &&
        numberOfQuestionsController.text.isNotEmpty;
    return filled;
  }

  void _resetForm() {
    departmentController.clear();
    courseNameController.clear();
    courseCodeController.clear();
    courseLevelController.clear();
    semesterController.clear();
    instructorController.clear();
    dateController.clear();
    timeController.clear();
    fullMarkController.clear();
    formController.clear();
    numberOfQuestionsController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BubbleSheetCubit, BubbleSheetState>(
        listener: (context, state) {
          if (state is BubbleSheetInitial) {
            context.read<BubbleSheetCubit>().loadCourses();
            isLoading = true;

            //isLoading = true;
          }
          if (state is BubbleSheetLoading) {
            //context.read<BubbleSheetCubit>().loadCourses();
            isLoading = true;
          }
          if (state is BubbleSheetError) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Oops...',
              text: 'Sorry, something went wrong',
              onCancelBtnTap: () {
                Navigator.pop(context);
                GoRouter.of(context).pop(AppRouter.kHomeView);
                context.read<BubbleSheetCubit>().resetState();
              },
            );
            isLoading = false;
          }
          if (state is PDFCreatedSuccess) {
            QuickAlert.show(
                showCancelBtn: true,
                context: context,
                type: QuickAlertType.success,
                text: 'Download Completed Successfully!',
                onCancelBtnTap: () {
                  Navigator.pop(context);
                  GoRouter.of(context).pop(AppRouter.kHomeView);
                  context.read<BubbleSheetCubit>().resetState();
                },
                onConfirmBtnTap: () {
                  //context.read<BubbleSheetCubit>().resetState();
                  Navigator.pop(context);
                  GoRouter.of(context).pushReplacement(AppRouter.kAddQuestion);
                  context.read<BubbleSheetCubit>().resetState();
                });
          }
          if (state is CoursesLoaded) {}
        },
        builder: (context, state) => ModalProgressHUD(
            color: AppColors.babyBlue,
            inAsyncCall: isLoading,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.ceruleanBlue,
                foregroundColor: AppColors.white,
                title: const Text(
                  'Create Bubble Sheet',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    DropdownButtonFormField<String>(
                      value: widget.selectedCourse?.id,
                      decoration: const InputDecoration(
                          prefixIconColor: AppColors.babyBlue,
                          labelStyle: TextStyle(color: AppColors.darkBlue),
                          labelText: 'Select Course',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.stoneBlue))),
                      items: widget.courses.map((course) {
                        return DropdownMenuItem(
                          value: course.id,
                          child: Text(
                              '${course.courseName} (${course.courseCode})'),
                        );
                      }).toList(),
                      onChanged: (courseId) {
                        if (courseId != null) {
                          context
                              .read<BubbleSheetCubit>()
                              .selectCourse(courseId, widget.courses);
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                    _buildEditableTextField('Department', departmentController),
                    _buildEditableTextField(
                        'Course Name', courseNameController),
                    _buildEditableTextField(
                        'Course Code', courseCodeController),
                    _buildEditableTextField(
                        'Course Level', courseLevelController),
                    _buildEditableTextField('Semester', semesterController),
                    _buildEditableTextField('Instructor', instructorController),
                    _buildEditableTextField('Date', dateController),
                    _buildEditableTextField('Time', timeController),
                    _buildEditableTextField('Full Mark', fullMarkController),
                    _buildEditableTextField('Form', formController),
                    _buildEditableTextField(
                        'Number of Questions', numberOfQuestionsController,
                        keyboardType: TextInputType.number),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (_areAllFieldsFilled() ||
                                widget.selectedCourse != null)
                            ? Colors.blue
                            : Colors.grey,
                        minimumSize: Size(double.infinity,
                            MediaQuery.of(context).size.height * 0.06),
                      ),
                      onPressed: (_areAllFieldsFilled() ||
                              widget.selectedCourse != null)
                          ? () {
                              context
                                  .read<BubbleSheetCubit>()
                                  .creaetPdf(course: _getUpdatedCourse());
                            }
                          : null,
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  Widget _buildEditableTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.stoneBlue)),
          prefixIconColor: AppColors.babyBlue,
          labelStyle: const TextStyle(color: AppColors.darkBlue),
          filled: true,
          fillColor: Colors.blue[50],
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: keyboardType,
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }
}
