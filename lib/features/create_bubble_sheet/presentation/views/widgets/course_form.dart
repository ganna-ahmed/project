import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/create_bubble_sheet/data/cubits/bubble_sheet_cubit/bubble_sheet_cubit.dart';
import 'package:project/features/create_bubble_sheet/data/cubits/bubble_sheet_cubit/bubble_sheet_state.dart';
import 'package:project/features/create_bubble_sheet/data/models/course_model.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CourseForm extends StatefulWidget {
  final List<CourseModel> courses;
  final CourseModel? selectedCourse;

  const CourseForm({
    Key? key,
    required this.courses,
    this.selectedCourse,
  }) : super(key: key);

  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
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
  void didUpdateWidget(CourseForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCourse != oldWidget.selectedCourse) {
      _updateControllers();
    }
    // context.read<BubbleSheetCubit>().loadCourses();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   //context.read<BubbleSheetCubit>().resetState();
  // }

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
    return SingleChildScrollView(
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
                    borderSide: BorderSide(color: AppColors.stoneBlue))),
            items: widget.courses.map((course) {
              return DropdownMenuItem(
                value: course.id,
                child: Text('${course.courseName} (${course.courseCode})'),
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
          _buildEditableTextField('Course Name', courseNameController),
          _buildEditableTextField('Course Code', courseCodeController),
          _buildEditableTextField('Course Level', courseLevelController),
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
              backgroundColor:
                  (_areAllFieldsFilled() || widget.selectedCourse != null)
                      ? Colors.blue
                      : Colors.grey,
              minimumSize: Size(
                  double.infinity, MediaQuery.of(context).size.height * 0.06),
            ),
            onPressed: (_areAllFieldsFilled() || widget.selectedCourse != null)
                ? () => context
                    .read<BubbleSheetCubit>()
                    .creaetPdf(course: _getUpdatedCourse())
                : null,
            child: Text(
              'Done',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white,
              ),
            ),
          ),
          // BlocListener<BubbleSheetCubit, BubbleSheetState>(
          //   listener: (context, state) {
          //     if (state is PDFCreatedSuccess) {
          //       QuickAlert.show(
          //         context: context,
          //         type: QuickAlertType.success,
          //         text: 'Download Completed Successfully!',
          //       );
          // showDialog(
          //   context: context,
          //   builder: (context) => AlertDialog(
          //     title: Text('Success'),
          //     content: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text('Bubble sheet created successfully!'),
          //         SizedBox(height: 10.h),
          //       ],
          //     ),
          //     actions: [
          //       TextButton(
          //         onPressed: () => Navigator.pop(context),
          //         child: Text('OK'),
          //       ),
          //     ],
          //   ),
          // );
          //     } else if (state is BubbleSheetError) {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text(state.message),
          //           backgroundColor: Colors.red,
          //         ),
          //       );
          //     }
          //   },
          //   child: SizedBox(),
          // ),
        ],
      ),
    );
  }

  Widget _buildEditableTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.stoneBlue)),
          prefixIconColor: AppColors.babyBlue,
          labelStyle: TextStyle(color: AppColors.darkBlue),
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
//() async {
                      //     var status = await Permission.storage.status;
                      //     if (!status.isGranted) {
                      //       status = await Permission.storage.request();
                      //       if (!status.isGranted) {
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //           SnackBar(
                      //             content: Text('Storage permission denied'),
                      //             backgroundColor: Colors.red,
                      //           ),
                      //         );
                      //         return;
                      //       }
                      //     }
                      //     context
                      //         .read<BubbleSheetCubit>()
                      //         .creaetPdf(_getUpdatedCourse());
                      //   