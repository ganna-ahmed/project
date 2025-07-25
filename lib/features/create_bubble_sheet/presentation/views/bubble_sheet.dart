import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/features/create_bubble_sheet/data/models/course_model.dart';
import 'package:project/features/modelsOfQuestion/view/infopage.dart';
import 'package:project/features/modelsOfQuestion/view/information.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:io';

class BubbleSheet2Page extends StatefulWidget {
  final String id;
  final String modelName;

  const BubbleSheet2Page(
      {Key? key, required this.id, required this.modelName})
      : super(key: key);

  @override
  State<BubbleSheet2Page> createState() => _BubbleSheet2PageState();
}

class _BubbleSheet2PageState extends State<BubbleSheet2Page> {
  // State variables
  bool isLoading = false;
  List<CourseModel> _courses = [];
  CourseModel? _selectedCourse;
  final _formKey = GlobalKey<FormState>();

  // Text controllers
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
    _loadCourses();
  }

  void _initializeControllers() {
    departmentController =
        TextEditingController(text: _selectedCourse?.department ?? '');
    courseNameController =
        TextEditingController(text: _selectedCourse?.courseName ?? '');
    courseCodeController =
        TextEditingController(text: _selectedCourse?.courseCode ?? '');
    courseLevelController =
        TextEditingController(text: _selectedCourse?.courseLevel ?? '');
    semesterController =
        TextEditingController(text: _selectedCourse?.semester ?? '');
    instructorController =
        TextEditingController(text: _selectedCourse?.instructor ?? '');
    dateController = TextEditingController(text: _selectedCourse?.date ?? '');
    timeController = TextEditingController(text: _selectedCourse?.time ?? '');
    fullMarkController =
        TextEditingController(text: _selectedCourse?.fullMark ?? '');
    formController = TextEditingController(text: _selectedCourse?.form ?? '');
    numberOfQuestionsController = TextEditingController(
      text: _selectedCourse?.numberOfQuestions ?? '',
    );
  }

  void _updateControllers() {
    departmentController.text = _selectedCourse?.department ?? '';
    courseNameController.text = _selectedCourse?.courseName ?? '';
    courseCodeController.text = _selectedCourse?.courseCode ?? '';
    courseLevelController.text = _selectedCourse?.courseLevel ?? '';
    semesterController.text = _selectedCourse?.semester ?? '';
    instructorController.text = _selectedCourse?.instructor ?? '';
    dateController.text = _selectedCourse?.date ?? '';
    timeController.text = _selectedCourse?.time ?? '';
    fullMarkController.text = _selectedCourse?.fullMark ?? '';
    formController.text = _selectedCourse?.form ?? '';
    numberOfQuestionsController.text =
        _selectedCourse?.numberOfQuestions.toString() ?? '';
  }

  CourseModel _getUpdatedCourse() {
    return CourseModel(
      id: _selectedCourse?.id ?? '',
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

  bool _canEnableButtons() {
    return _areAllFieldsFilled() && dateController.text.isNotEmpty;
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

  // API Functions
  Future<void> _loadCourses() async {
    try {
      setState(() {
        isLoading = true;
      });

      final courses = await fetchCourses();

      setState(() {
        _courses = courses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Failed to load courses: ${e.toString()}',
        onCancelBtnTap: () {
          Navigator.pop(context);
          GoRouter.of(context).pop(AppRouter.kHomeView);
        },
      );
    }
  }

  Future<List<CourseModel>> fetchCourses() async {
    try {
      final response = await http.patch(
        Uri.parse('$kBaseUrl/Doctor/CreateBubbleSheet'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idDoctor': widget.id}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['documents'] != null &&
            responseData['documents'].isNotEmpty) {
          final List<dynamic> documents = responseData['documents'];
          return documents.map((json) => CourseModel.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('❌ Failed to load courses: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      print('⚠ Error in fetchCourses: $e');
      print('🛠 Stacktrace: $stacktrace');
      throw Exception('⚠ Network error: $e');
    }
  }

  Future<void> createPDF(CourseModel course) async {
    try {
      setState(() {
        isLoading = true;
      });

      // ✅ Request storage permission
      var status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      if (!status.isGranted) {
        throw Exception('❌ Storage permission denied');
      }

      final response = await http.post(
        Uri.parse('$kBaseUrl/Doctor/CreateBubbleSheet'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'Department': course.department,
          'CourseName': course.courseName,
          'CourseCode': course.courseCode,
          'CourseLevel': course.courseLevel,
          'Semester': course.semester,
          'Instructor': course.instructor,
          'Date': course.date,
          'Time': course.time,
          'FuLLMark': course.fullMark,
          'fORm': course.form,
          'NumberofQuestions': course.numberOfQuestions
        }),
      );

      print('📄 Response body length: ${response.bodyBytes.length}');
      print('📄 Content-Type: ${response.headers['content-type']}');

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/pdf')) {
        throw Exception(
            '❌ Response is not a PDF file! Content-Type: $contentType');
      }

      if (response.statusCode == 200) {
        final fileName = 'Bubble_Sheet_${course.courseName}.pdf';
        final file = await downloadFile(fileName, response);

        if (file == null) {
          throw Exception('❌ Failed to save PDF file');
        }

        print('✅ PDF saved successfully at: ${file.path}');
        await OpenFile.open(file.path);

        setState(() {
          isLoading = false;
        });

        // ✅ تم إصلاح المشكلة هنا - لن ينتقل لصفحة أخرى
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success!',
          text: 'PDF Downloaded and Opened Successfully!',
          confirmBtnText: 'OK',
          onConfirmBtnTap: () {
            Navigator.pop(context); // فقط إغلاق الـ dialog
          },
        );
      } else {
        throw Exception('❌ Failed to submit form: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      setState(() {
        isLoading = false;
      });

      print('⚠ Error in createPDF: $e');
      print('🛠 Stacktrace: $stacktrace');

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Failed to create PDF: ${e.toString()}',
        onCancelBtnTap: () {
          Navigator.pop(context);
          GoRouter.of(context).pop(AppRouter.kHomeView);
        },
      );
    }
  }

  Future<File?> downloadFile(String fileName, http.Response response) async {
    try {
      final downloadPath = '/storage/emulated/0/Download';
      final downloadDir = Directory(downloadPath);

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final filePath = path_lib.join(downloadDir.path, fileName);
      final file = File(filePath);

      await file.writeAsBytes(response.bodyBytes);

      print('✅ File saved to: ${file.path}');
      return file;
    } catch (e, stacktrace) {
      print('❌ Error saving file: $e');
      print('🛠 Stacktrace: $stacktrace');
      return null;
    }
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate() && !_areAllFieldsFilled()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Form Incomplete',
        text: 'Please complete all required fields',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: 'Processing',
        text: 'Please wait until information is saved',
        barrierDismissible: false,
      );

      final CourseModel course = _getUpdatedCourse();

      final response = await http.post(
        Uri.parse('$kBaseUrl/Doctor/informationModel'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'modelName': widget.modelName,
          'Department': course.department,
          'CourseName': course.courseName,
          'CourseCode': course.courseCode,
          'CourseLevel': course.courseLevel,
          'Semester': course.semester,
          'Instructor': course.instructor,
          'Date': course.date,
          'Time': course.time,
          'FuLLMark': course.fullMark,
          'fORm': course.form,
          'NumberofQuestions': course.numberOfQuestions
        }),
      );

      // Close the loading alert
      Navigator.pop(context);

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == 'Model saved successfully!') {
          QuickAlert.show(
            onConfirmBtnTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InfoPage(
                    idDoctor: widget.id,
                    modelName: widget.modelName,
                    courseName: course.courseName,
                  ),
                ),
              );
            },
            context: context,
            type: QuickAlertType.success,
            title: 'Success',
            text: 'Information saved successfully',
          );
        }
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to save information',
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print('Error: ${e.toString()}');
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Error: ${e.toString()}',
      );
    }
  }

  void selectCourse(String courseId) {
    setState(() {
      _selectedCourse = _courses.firstWhere(
            (course) => course.id == courseId,
        orElse: () => _courses.first,
      );
      _updateControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ تحسين الـ responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = colorScheme.brightness == Brightness.dark;

    return ModalProgressHUD(
      color: AppColors.babyBlue,
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode ? colorScheme.background : AppColors.ceruleanBlue,
          foregroundColor: Colors.white,
          title: Text(
            'Create Bubble Sheet',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 24.sp : 18.sp,
            ),
          ),
        ),
        backgroundColor: isDarkMode ? colorScheme.background : Colors.white,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isLargeScreen ? 32.w : (isTablet ? 24.w : 16.w),
              vertical: isTablet ? 16.h : 8.h,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isLargeScreen ? 800 : double.infinity,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Dropdown للكورسات
                    _buildResponsiveDropdown(isTablet, isDarkMode, colorScheme),

                    SizedBox(height: isTablet ? 30.h : 20.h),

                    // حقول النص في شبكة للشاشات الكبيرة
                    if (isLargeScreen) ...[
                      _buildGridLayout(isDarkMode, colorScheme),
                    ] else ...[
                      _buildSingleColumnLayout(isTablet, isDarkMode, colorScheme),
                    ],

                    SizedBox(height: isTablet ? 30.h : 20.h),

                    // الأزرار
                    _buildResponsiveButtons(isTablet, screenWidth, isDarkMode, colorScheme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveDropdown(bool isTablet, bool isDarkMode, ColorScheme colorScheme) {
    return DropdownButtonFormField<String>(
      value: _selectedCourse?.id,
      decoration: InputDecoration(
        prefixIconColor: AppColors.babyBlue,
        labelStyle: TextStyle(
          color: AppColors.darkBlue,
          fontSize: isTablet ? 18.sp : 14.sp,
        ),
        labelText: 'Select Course',
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.stoneBlue),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20.w : 12.w,
          vertical: isTablet ? 20.h : 16.h,
        ),
      ),
      style: TextStyle(
        fontSize: isTablet ? 16.sp : 14.sp,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
      items: _courses.map((course) {
        return DropdownMenuItem(
          value: course.id,
          child: Text('${course.courseName} (${course.courseCode})'),
        );
      }).toList(),
      onChanged: (courseId) {
        if (courseId != null) {
          selectCourse(courseId);
        }
      },
      validator: (value) =>
      value == null || value.isEmpty ? 'Please select a course' : null,
    );
  }

  Widget _buildGridLayout(bool isDarkMode, ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: _buildEditableTextField(
                    'Department', departmentController,
                    isTablet: true, isDarkMode: isDarkMode, colorScheme: colorScheme)),
            SizedBox(width: 16.w),
            Expanded(
                child: _buildEditableTextField(
                    'Course Name', courseNameController,
                    isTablet: true, isDarkMode: isDarkMode, colorScheme: colorScheme)),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: _buildEditableTextField(
                    'Course Code', courseCodeController,
                    isTablet: true, isDarkMode: isDarkMode, colorScheme: colorScheme)),
            SizedBox(width: 16.w),
            Expanded(
                child: _buildEditableTextField(
                    'Course Level', courseLevelController,
                    isTablet: true, isDarkMode: isDarkMode, colorScheme: colorScheme)),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: _buildEditableTextField('Semester', semesterController,
                    isTablet: true, isDarkMode: isDarkMode, colorScheme: colorScheme)),
            SizedBox(width: 16.w),
            Expanded(
                child: _buildEditableTextField(
                    'Instructor', instructorController,
                    isTablet: true, isDarkMode: isDarkMode, colorScheme: colorScheme)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildDatePicker(true, isDarkMode, colorScheme)),
            SizedBox(width: 16.w),
            Expanded(
                child: _buildEditableTextField('Time', timeController,
                    isTablet: true, isDarkMode: isDarkMode, colorScheme: colorScheme)),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: _buildEditableTextField('Full Mark', fullMarkController,
                    keyboardType: TextInputType.number, isTablet: true, isDarkMode: isDarkMode, colorScheme: colorScheme)),
            SizedBox(width: 16.w),
            Expanded(
                child: _buildEditableTextField(
                    'Form (Final or Midterm)', formController,
                    isTablet: true, isDarkMode: isDarkMode, colorScheme: colorScheme)),
          ],
        ),
        _buildEditableTextField(
            'Number of Questions', numberOfQuestionsController,
            keyboardType: TextInputType.number, isTablet: true, isDarkMode: isDarkMode, colorScheme: colorScheme),
        _buildNoteText(true, isDarkMode, colorScheme),
      ],
    );
  }

  Widget _buildSingleColumnLayout(bool isTablet, bool isDarkMode, ColorScheme colorScheme) {
    return Column(
      children: [
        _buildEditableTextField('Department', departmentController,
            isTablet: isTablet, isDarkMode: isDarkMode, colorScheme: colorScheme),
        _buildEditableTextField('Course Name', courseNameController,
            isTablet: isTablet, isDarkMode: isDarkMode, colorScheme: colorScheme),
        _buildEditableTextField('Course Code', courseCodeController,
            isTablet: isTablet, isDarkMode: isDarkMode, colorScheme: colorScheme),
        _buildEditableTextField('Course Level', courseLevelController,
            isTablet: isTablet, isDarkMode: isDarkMode, colorScheme: colorScheme),
        _buildEditableTextField('Semester', semesterController,
            isTablet: isTablet, isDarkMode: isDarkMode, colorScheme: colorScheme),
        _buildEditableTextField('Instructor', instructorController,
            isTablet: isTablet, isDarkMode: isDarkMode, colorScheme: colorScheme),
        _buildDatePicker(isTablet, isDarkMode, colorScheme),
        _buildEditableTextField('Time', timeController, isTablet: isTablet, isDarkMode: isDarkMode, colorScheme: colorScheme),
        _buildEditableTextField('Full Mark', fullMarkController,
            keyboardType: TextInputType.number, isTablet: isTablet, isDarkMode: isDarkMode, colorScheme: colorScheme),
        _buildEditableTextField('Form (Final or Midterm)', formController,
            isTablet: isTablet, isDarkMode: isDarkMode, colorScheme: colorScheme),
        _buildEditableTextField(
            'Number of Questions', numberOfQuestionsController,
            keyboardType: TextInputType.number, isTablet: isTablet, isDarkMode: isDarkMode, colorScheme: colorScheme),
        _buildNoteText(isTablet, isDarkMode, colorScheme),
      ],
    );
  }

  Widget _buildDatePicker(bool isTablet, bool isDarkMode, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 15.h : 10.h),
      child: TextFormField(
        controller: dateController,
        style: TextStyle(fontSize: isTablet ? 16.sp : 14.sp, color: isDarkMode ? Colors.white : Colors.black),
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.stoneBlue),
          ),
          prefixIconColor: AppColors.babyBlue,
          labelText: 'Date (mm/dd/yyyy)',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isTablet ? 12.r : 10.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: isTablet ? 20.w : 16.w,
            vertical: isTablet ? 20.h : 16.h,
          ),
          filled: true,
          fillColor: isDarkMode ? Colors.grey[700] : Colors.blue[50],
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
          suffixIcon: Icon(
            Icons.calendar_today,
            size: isTablet ? 24.w : 20.w,
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
        readOnly: true,
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.blue,
                  ),
                  dialogBackgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
                ),
                child: child!,
              );
            },
          );
          if (date != null) {
            setState(() {
              dateController.text = '${date.month}/${date.day}/${date.year}';
            });
          }
        },
        validator: (value) => value!.isEmpty ? 'Required field' : null,
      ),
    );
  }

  Widget _buildNoteText(bool isTablet, bool isDarkMode, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 15.h : 10.h),
      child: Text(
        'The Number of questions of one column is 30',
        style: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey,
          fontSize: isTablet ? 16.sp : 14.sp,
        ),
      ),
    );
  }

  Widget _buildResponsiveButtons(bool isTablet, double screenWidth, bool isDarkMode, ColorScheme colorScheme) {
    final buttonHeight = isTablet ? 60.h : 50.h;
    final fontSize = isTablet ? 18.sp : 16.sp;

    if (screenWidth > 600) {
      // للشاشات الكبيرة - الأزرار جنب بعض
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                _canEnableButtons() ? Colors.blue : Colors.grey,
                minimumSize: Size(double.infinity, buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 12.r : 8.r),
                ),
              ),
              onPressed: _canEnableButtons()
                  ? () {
                createPDF(_getUpdatedCourse());
              }
                  : null,
              child: Text(
                'Generate PDF',
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: isTablet ? 24.w : 16.w),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                _canEnableButtons() ? AppColors.darkBlue : Colors.grey,
                minimumSize: Size(double.infinity, buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 12.r : 8.r),
                ),
              ),
              onPressed: _canEnableButtons()
                  ? () {
                submitForm();
              }
                  : null,
              child: Text(
                'Save Information',
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // للشاشات الصغيرة - الأزرار تحت بعض
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                _canEnableButtons() ? Colors.blue : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: _canEnableButtons()
                  ? () {
                createPDF(_getUpdatedCourse());
              }
                  : null,
              child: Text(
                'Generate PDF',
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                _canEnableButtons() ? AppColors.darkBlue : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: _canEnableButtons()
                  ? () {
                submitForm();
              }
                  : null,
              child: Text(
                'Save Information',
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildEditableTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType, bool isTablet = false, required bool isDarkMode, required ColorScheme colorScheme}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 15.h : 10.h),
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontSize: isTablet ? 16.sp : 14.sp, color: isDarkMode ? Colors.white : Colors.black),
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.stoneBlue),
          ),
          prefixIconColor: AppColors.babyBlue,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isTablet ? 12.r : 10.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: isTablet ? 20.w : 16.w,
            vertical: isTablet ? 20.h : 16.h,
          ),
          filled: true,
          fillColor: isDarkMode ? Colors.grey[700] : Colors.blue[50],
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
        keyboardType: keyboardType,
        validator: (value) => value!.isEmpty ? 'Required field' : null,
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_file_downloader/flutter_file_downloader.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart' as http;
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path/path.dart' as path_lib;
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:project/constants.dart';
// import 'package:project/core/constants/colors.dart';
// import 'package:project/core/utils/app_router.dart';
// import 'package:project/features/create_bubble_sheet/data/models/course_model.dart';
// import 'package:project/features/modelsOfQuestion/view/infopage.dart';
// import 'package:project/features/modelsOfQuestion/view/information.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:convert';
// import 'dart:io';

// class BubbleSheet2Page extends StatefulWidget {
//   final String id;
//   final String modelName;

//   const BubbleSheet2Page(
//       {super.key, required this.id, required this.modelName});

//   @override
//   State<BubbleSheet2Page> createState() => _BubbleSheet2PageState();
// }

// class _BubbleSheet2PageState extends State<BubbleSheet2Page> {
//   // State variables
//   bool isLoading = false;
//   List<CourseModel> _courses = [];
//   CourseModel? _selectedCourse;
//   final _formKey = GlobalKey<FormState>();

//   // Text controllers
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
//     _loadCourses();
//   }

//   void _initializeControllers() {
//     departmentController =
//         TextEditingController(text: _selectedCourse?.department ?? '');
//     courseNameController =
//         TextEditingController(text: _selectedCourse?.courseName ?? '');
//     courseCodeController =
//         TextEditingController(text: _selectedCourse?.courseCode ?? '');
//     courseLevelController =
//         TextEditingController(text: _selectedCourse?.courseLevel ?? '');
//     semesterController =
//         TextEditingController(text: _selectedCourse?.semester ?? '');
//     instructorController =
//         TextEditingController(text: _selectedCourse?.instructor ?? '');
//     dateController = TextEditingController(text: _selectedCourse?.date ?? '');
//     timeController = TextEditingController(text: _selectedCourse?.time ?? '');
//     fullMarkController =
//         TextEditingController(text: _selectedCourse?.fullMark ?? '');
//     formController = TextEditingController(text: _selectedCourse?.form ?? '');
//     numberOfQuestionsController = TextEditingController(
//       text: _selectedCourse?.numberOfQuestions ?? '',
//     );
//   }

//   void _updateControllers() {
//     departmentController.text = _selectedCourse?.department ?? '';
//     courseNameController.text = _selectedCourse?.courseName ?? '';
//     courseCodeController.text = _selectedCourse?.courseCode ?? '';
//     courseLevelController.text = _selectedCourse?.courseLevel ?? '';
//     semesterController.text = _selectedCourse?.semester ?? '';
//     instructorController.text = _selectedCourse?.instructor ?? '';
//     dateController.text = _selectedCourse?.date ?? '';
//     timeController.text = _selectedCourse?.time ?? '';
//     fullMarkController.text = _selectedCourse?.fullMark ?? '';
//     formController.text = _selectedCourse?.form ?? '';
//     numberOfQuestionsController.text =
//         _selectedCourse?.numberOfQuestions.toString() ?? '';
//   }

//   CourseModel _getUpdatedCourse() {
//     return CourseModel(
//       id: _selectedCourse?.id ?? '',
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

//   bool _areAllFieldsFilled() {
//     bool filled = departmentController.text.isNotEmpty &&
//         courseNameController.text.isNotEmpty &&
//         courseCodeController.text.isNotEmpty &&
//         courseLevelController.text.isNotEmpty &&
//         semesterController.text.isNotEmpty &&
//         instructorController.text.isNotEmpty &&
//         dateController.text.isNotEmpty &&
//         timeController.text.isNotEmpty &&
//         fullMarkController.text.isNotEmpty &&
//         formController.text.isNotEmpty &&
//         numberOfQuestionsController.text.isNotEmpty;
//     return filled;
//   }

//   void _resetForm() {
//     departmentController.clear();
//     courseNameController.clear();
//     courseCodeController.clear();
//     courseLevelController.clear();
//     semesterController.clear();
//     instructorController.clear();
//     dateController.clear();
//     timeController.clear();
//     fullMarkController.clear();
//     formController.clear();
//     numberOfQuestionsController.clear();
//     setState(() {});
//   }

//   // API Functions
//   Future<void> _loadCourses() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       final courses = await fetchCourses();

//       setState(() {
//         _courses = courses;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });

//       QuickAlert.show(
//         context: context,
//         type: QuickAlertType.error,
//         title: 'Oops...',
//         text: 'Failed to load courses: ${e.toString()}',
//         onCancelBtnTap: () {
//           Navigator.pop(context);
//           GoRouter.of(context).pop(AppRouter.kHomeView);
//         },
//       );
//     }
//   }

//   Future<List<CourseModel>> fetchCourses() async {
//     try {
//       final response = await http.patch(
//         Uri.parse('$kBaseUrl/Doctor/CreateBubbleSheet'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'idDoctor': widget.id}),
//       );
//       // print('🔵 Doctor ID: ${widget.id}');
//       // print('🟢 Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);

//         if (responseData['documents'] != null &&
//             responseData['documents'].isNotEmpty) {
//           final List<dynamic> documents = responseData['documents'];
//           return documents.map((json) => CourseModel.fromJson(json)).toList();
//         } else {
//           return [];
//         }
//       } else {
//         throw Exception('❌ Failed to load courses: ${response.statusCode}');
//       }
//     } catch (e, stacktrace) {
//       print('⚠ Error in fetchCourses: $e');
//       print('🛠 Stacktrace: $stacktrace');
//       throw Exception('⚠ Network error: $e');
//     }
//   }

//   Future<void> createPDF(CourseModel course) async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       // ✅ Request storage permission
//       var status = await Permission.manageExternalStorage.request();
//       if (!status.isGranted) {
//         status = await Permission.storage.request();
//       }
//       if (!status.isGranted) {
//         throw Exception('❌ Storage permission denied');
//       }

//       final response = await http.post(
//         Uri.parse('$kBaseUrl/Doctor/CreateBubbleSheet'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'Department': course.department,
//           'CourseName': course.courseName,
//           'CourseCode': course.courseCode,
//           'CourseLevel': course.courseLevel,
//           'Semester': course.semester,
//           'Instructor': course.instructor,
//           'Date': course.date,
//           'Time': course.time,
//           'FuLLMark': course.fullMark,
//           'fORm': course.form,
//           'NumberofQuestions': course.numberOfQuestions
//         }),
//       );

//       print('📄 Response body length: ${response.bodyBytes.length}');
//       print('📄 Content-Type: ${response.headers['content-type']}');

//       final contentType = response.headers['content-type'];
//       if (contentType == null || !contentType.contains('application/pdf')) {
//         throw Exception(
//             '❌ Response is not a PDF file! Content-Type: $contentType');
//       }

//       if (response.statusCode == 200) {
//         final fileName = 'Bubble_Sheet_${course.courseName}.pdf';
//         final file = await downloadFile(fileName, response);

//         if (file == null) {
//           throw Exception('❌ Failed to save PDF file');
//         }

//         print('✅ PDF saved successfully at: ${file.path}');
//         await OpenFile.open(file.path);

//         setState(() {
//           isLoading = false;
//         });

//         QuickAlert.show(
//             // showCancelBtn: true,
//             // confirmBtnText: 'Continue',
//             context: context,
//             type: QuickAlertType.success,
//             text: 'Download Completed Successfully!',
//             onCancelBtnTap: () {
//               Navigator.pop(context);
//               GoRouter.of(context).pop(AppRouter.kHomeView);
//             },
//             onConfirmBtnTap: () {
//               Navigator.pop(context);
//             });
//       } else {
//         throw Exception('❌ Failed to submit form: ${response.statusCode}');
//       }
//     } catch (e, stacktrace) {
//       setState(() {
//         isLoading = false;
//       });

//       print('⚠ Error in createPDF: $e');
//       print('🛠 Stacktrace: $stacktrace');

//       QuickAlert.show(
//         context: context,
//         type: QuickAlertType.error,
//         title: 'Oops...',
//         text: 'Failed to create PDF: ${e.toString()}',
//         onCancelBtnTap: () {
//           Navigator.pop(context);
//           GoRouter.of(context).pop(AppRouter.kHomeView);
//         },
//       );
//     }
//   }

//   Future<File?> downloadFile(String fileName, http.Response response) async {
//     try {
//       final downloadPath = '/storage/emulated/0/Download';
//       final downloadDir = Directory(downloadPath);

//       if (!await downloadDir.exists()) {
//         await downloadDir.create(recursive: true);
//       }

//       final filePath = path_lib.join(downloadDir.path, fileName);
//       final file = File(filePath);

//       await file.writeAsBytes(response.bodyBytes);

//       print('✅ File saved to: ${file.path}');
//       return file;
//     } catch (e, stacktrace) {
//       print('❌ Error saving file: $e');
//       print('🛠 Stacktrace: $stacktrace');
//       return null;
//     }
//   }

//   Future<void> submitForm() async {
//     if (!_formKey.currentState!.validate() && !_areAllFieldsFilled()) {
//       QuickAlert.show(
//         context: context,
//         type: QuickAlertType.error,
//         title: 'Form Incomplete',
//         text: 'Please complete all required fields',
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       QuickAlert.show(
//         context: context,
//         type: QuickAlertType.info,
//         title: 'Processing',
//         text: 'Please wait until information is saved',
//         barrierDismissible: false,
//       );

//       final CourseModel course = _getUpdatedCourse();

//       final response = await http.post(
//         Uri.parse('$kBaseUrl/Doctor/informationModel'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'modelName': widget.modelName,
//           'Department': course.department,
//           'CourseName': course.courseName,
//           'CourseCode': course.courseCode,
//           'CourseLevel': course.courseLevel,
//           'Semester': course.semester,
//           'Instructor': course.instructor,
//           'Date': course.date,
//           'Time': course.time,
//           'FuLLMark': course.fullMark,
//           'fORm': course.form,
//           'NumberofQuestions': course.numberOfQuestions
//         }),
//       );

//       // Close the loading alert
//       Navigator.pop(context);

//       setState(() {
//         isLoading = false;
//       });

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['message'] == 'Model saved successfully!') {
//           QuickAlert.show(
//             onConfirmBtnTap: () {
//               Navigator.pop(context); // <<< أهو دي الإضافة
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => InfoPage(
//                     idDoctor: widget.id,
//                     modelName: widget.modelName,
//                     courseName: course.courseName,
//                   ),
//                 ),
//               );
//             },
//             context: context,
//             type: QuickAlertType.success,
//             title: 'Success',
//             text: 'Information saved successfully',
//           );

//           // (ممكن كمان تشيل الكود بتاع launchUrl لو مش عايزه بعدين)
//         }
//       } else {
//         QuickAlert.show(
//           context: context,
//           type: QuickAlertType.error,
//           title: 'Error',
//           text: 'Failed to save information',
//         );
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });

//       print('Error: ${e.toString()}');
//       QuickAlert.show(
//         context: context,
//         type: QuickAlertType.error,
//         title: 'Error',
//         text: 'Error: ${e.toString()}',
//       );
//     }
//   }

//   void selectCourse(String courseId) {
//     setState(() {
//       _selectedCourse = _courses.firstWhere(
//         (course) => course.id == courseId,
//         orElse: () => _courses.first,
//       );
//       _updateControllers();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ModalProgressHUD(
//         color: AppColors.babyBlue,
//         inAsyncCall: isLoading,
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: AppColors.ceruleanBlue,
//             foregroundColor: AppColors.white,
//             title: const Text(
//               'Create Bubble Sheet',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           body: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   DropdownButtonFormField<String>(
//                     value: _selectedCourse?.id,
//                     decoration: const InputDecoration(
//                         prefixIconColor: AppColors.babyBlue,
//                         labelStyle: TextStyle(color: AppColors.darkBlue),
//                         labelText: 'Select Course',
//                         border: OutlineInputBorder(),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(color: AppColors.stoneBlue))),
//                     items: _courses.map((course) {
//                       return DropdownMenuItem(
//                         value: course.id,
//                         child:
//                             Text('${course.courseName} (${course.courseCode})'),
//                       );
//                     }).toList(),
//                     onChanged: (courseId) {
//                       if (courseId != null) {
//                         selectCourse(courseId);
//                       }
//                     },
//                     validator: (value) => value == null || value.isEmpty
//                         ? 'Please select a course'
//                         : null,
//                   ),
//                   SizedBox(height: 20.h),
//                   _buildEditableTextField('Department', departmentController),
//                   _buildEditableTextField('Course Name', courseNameController),
//                   _buildEditableTextField('Course Code', courseCodeController),
//                   _buildEditableTextField(
//                       'Course Level', courseLevelController),
//                   _buildEditableTextField('Semester', semesterController),
//                   _buildEditableTextField('Instructor', instructorController),

//                   // Date picker field
//                   Padding(
//                     padding: EdgeInsets.symmetric(vertical: 10.h),
//                     child: TextFormField(
//                       controller: dateController,
//                       decoration: InputDecoration(
//                         focusedBorder: const OutlineInputBorder(
//                             borderSide: BorderSide(color: AppColors.stoneBlue)),
//                         prefixIconColor: AppColors.babyBlue,
//                         labelStyle: const TextStyle(color: AppColors.darkBlue),
//                         filled: true,
//                         fillColor: Colors.blue[50],
//                         labelText: 'Date (mm/dd/yyyy)',
//                         suffixIcon: const Icon(Icons.calendar_today),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.r),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       readOnly: true,
//                       onTap: () async {
//                         final date = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(2000),
//                           lastDate: DateTime(2100),
//                         );
//                         if (date != null) {
//                           setState(() {
//                             dateController.text =
//                                 '${date.month}/${date.day}/${date.year}';
//                           });
//                         }
//                       },
//                       validator: (value) =>
//                           value!.isEmpty ? 'Required field' : null,
//                     ),
//                   ),

//                   _buildEditableTextField('Time', timeController),
//                   _buildEditableTextField('Full Mark', fullMarkController,
//                       keyboardType: TextInputType.number),
//                   _buildEditableTextField(
//                       'Form (Final or Midterm)', formController),
//                   _buildEditableTextField(
//                       'Number of Questions', numberOfQuestionsController,
//                       keyboardType: TextInputType.number),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 10),
//                     child: Text(
//                       'The Number of questions of one column is 30',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: (_areAllFieldsFilled() ||
//                                     _selectedCourse != null)
//                                 ? Colors.blue
//                                 : Colors.grey,
//                             minimumSize: Size(double.infinity,
//                                 MediaQuery.of(context).size.height * 0.06),
//                           ),
//                           onPressed:
//                               (_areAllFieldsFilled() || _selectedCourse != null)
//                                   ? () {
//                                       createPDF(_getUpdatedCourse());
//                                     }
//                                   : null,
//                           child: Text(
//                             'Generate PDF',
//                             style: TextStyle(
//                               fontSize: 16.sp,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 16.w),
//                       Expanded(
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: (_areAllFieldsFilled() ||
//                                     _selectedCourse != null)
//                                 ? AppColors.darkBlue
//                                 : Colors.grey,
//                             minimumSize: Size(double.infinity,
//                                 MediaQuery.of(context).size.height * 0.06),
//                           ),
//                           onPressed:
//                               (_areAllFieldsFilled() || _selectedCourse != null)
//                                   ? () {
//                                       submitForm();

// // You might want to get this from URL parameters
//                                     }
//                                   : null,
//                           child: Text(
//                             'Save Information',
//                             style: TextStyle(
//                               fontSize: 16.sp,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }

//   Widget _buildEditableTextField(String label, TextEditingController controller,
//       {TextInputType? keyboardType}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10.h),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           focusedBorder: const OutlineInputBorder(
//               borderSide: BorderSide(color: AppColors.stoneBlue)),
//           prefixIconColor: AppColors.babyBlue,
//           labelStyle: const TextStyle(color: AppColors.darkBlue),
//           filled: true,
//           fillColor: Colors.blue[50],
//           labelText: label,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.r),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         keyboardType: keyboardType,
//         validator: (value) => value!.isEmpty ? 'Required field' : null,
//         onChanged: (value) {
//           setState(() {});
//         },
//       ),
//     );
//   }
// }
