import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/question/presentation/views/show_all_questions.dart';

class AddPreviousExamsScreen extends StatefulWidget {
  final String courseName;

  AddPreviousExamsScreen({required this.courseName});

  @override
  _AddPreviousExamsScreenState createState() => _AddPreviousExamsScreenState();
}

class _AddPreviousExamsScreenState extends State<AddPreviousExamsScreen> {
  final TextEditingController _yearController = TextEditingController();
  String? _selectedYear;
  List<String> _years = [];
  bool isLoading = true;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _fetchYears();
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: AppColors.ceruleanBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          margin: EdgeInsets.all(16.w),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          margin: EdgeInsets.all(16.w),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _fetchYears() async {
    if (!mounted) return;

    final url = Uri.parse('$kBaseUrl/Doctor/previousExam');
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'courseName': widget.courseName}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() {
            _years = List<String>.from(data);
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        //_showErrorMessage('There are no exams uploaded yet');
      }
    } catch (e) {
      print('Fetch years error: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        _showErrorMessage('Network error occurred');
      }
    }
  }

  Future<void> _uploadPdf() async {
    if (_yearController.text.trim().isEmpty) {
      _showErrorMessage('Please enter a year');
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && mounted) {
        setState(() {
          isUploading = true;
        });

        final file = result.files.single;
        final url = Uri.parse('$kBaseUrl/Doctor/previousExam');

        final request = http.MultipartRequest('POST', url)
          ..fields['year'] = _yearController.text.trim()
          ..fields['course'] = widget.courseName
          ..files.add(await http.MultipartFile.fromPath('pdf', file.path!));

        try {
          final response = await request.send();
          final responseBody = await response.stream.bytesToString();
          print('Server Response: $responseBody');

          if (!mounted) return;

          if (response.statusCode == 200) {
            _showSuccessMessage('✅ PDF uploaded successfully');
            _yearController.clear();
            await _fetchYears(); // تحديث قائمة السنوات
          } else {
            _showErrorMessage('Error uploading file');
          }
        } catch (e) {
          print('Upload error: $e');
          if (mounted) {
            _showErrorMessage('Upload failed');
          }
        }

        if (mounted) {
          setState(() {
            isUploading = false;
          });
        }
      }
    } catch (e) {
      print('File picker error: $e');
      if (mounted) {
        _showErrorMessage('Failed to select file');
      }
    }
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade300),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
        color: colorScheme.surface,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 14.sp),
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 50.h,
      margin: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF004aad), Color(0xFF7ab6f9)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: MaterialButton(
        onPressed: isUploading ? null : onPressed,
        child: isUploading
            ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
      ),
    );
  }

  Widget _buildExamsList() {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(color: Colors.blue.shade300),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100.withOpacity(0.5),
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'Loading exams...',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (_years.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(color: Colors.blue.shade300),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100.withOpacity(0.5),
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 40.w,
              color: Colors.grey,
            ),
            SizedBox(height: 8.h),
            Text(
              'No previous exams available',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Upload the first exam to get started',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: Colors.blue.shade300),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.history_edu,
                  color: Colors.blue.shade600,
                  size: 20.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Previous Exams (${_years.length})',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
          ),
          // List of exams
          Container(
            constraints: BoxConstraints(
              maxHeight: 300.h, // تحديد ارتفاع أقصى للقائمة
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _years.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),
              itemBuilder: (context, index) {
                final year = _years[index];
                return _buildExamItem(year, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamItem(String year, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowAllQuestionsScreen(
              year: year,
              courseName: widget.courseName,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: index == _years.length - 1
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                )
              : BorderRadius.zero,
        ),
        child: Row(
          children: [
            // أيقونة الامتحان
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.quiz,
                color: Colors.blue.shade600,
                size: 20.w,
              ),
            ),
            SizedBox(width: 12.w),
            // تفاصيل الامتحان
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exam Year $year',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Course: ${widget.courseName}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // أيقونة السهم
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: AppColors.ceruleanBlue,
        title: Text(
          'Add Exams - ${widget.courseName}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Container(
              width: screenWidth > 600 ? 400.w : screenWidth * 0.9,
              constraints: BoxConstraints(
                maxWidth: 400.w,
                minHeight: screenHeight * 0.6,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // عنوان توضيحي
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.upload_file,
                          size: 40.w,
                          color: Colors.blue.shade600,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Upload Previous Exam',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Add a PDF file of the previous exam for students to access',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  _buildTextField(
                    hint: 'Enter the year of the Exam (e.g., 2024)',
                    controller: _yearController,
                  ),

                  _buildGradientButton(
                    text: 'Upload PDF File',
                    onPressed: _uploadPdf,
                  ),

                  // خط فاصل
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                  ),

                  // عنوان للـ list
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      'Available Previous Exams',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onBackground,
                      ),
                    ),
                  ),

                  _buildExamsList(),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////الشغال
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:file_picker/file_picker.dart';
// import 'package:project/constants.dart';
// import 'package:project/core/constants/colors.dart';
// import 'dart:convert';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:project/features/question/presentation/views/show_all_questions.dart';

// class AddPreviousExamsScreen extends StatefulWidget {
//   final String courseName;

//   AddPreviousExamsScreen({required this.courseName});

//   @override
//   _AddPreviousExamsScreenState createState() => _AddPreviousExamsScreenState();
// }

// class _AddPreviousExamsScreenState extends State<AddPreviousExamsScreen> {
//   final TextEditingController _yearController = TextEditingController();
//   String? _selectedYear;
//   List<String> _years = [];
//   bool isLoading = true;
//   bool isUploading = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchYears();
//   }

//   void _showSuccessMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: AppColors.ceruleanBlue,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.r),
//         ),
//       ),
//     );
//   }

//   Future<void> _fetchYears() async {
//     final url = Uri.parse('$kBaseUrl/Doctor/previousExam');
//     try {
//       final response = await http.patch(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'courseName': widget.courseName}),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data is List) {
//           setState(() {
//             _years = List<String>.from(data);
//             isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Fetch years error: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _uploadPdf() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       setState(() {
//         isUploading = true;
//       });

//       final file = result.files.single;
//       final url = Uri.parse('$kBaseUrl/Doctor/previousExam');

//       final request = http.MultipartRequest('POST', url)
//         ..fields['year'] = _yearController.text
//         ..fields['course'] = widget.courseName
//         ..files.add(await http.MultipartFile.fromPath('pdf', file.path!));

//       try {
//         final response = await request.send();
//         final responseBody = await response.stream.bytesToString();
//         print('Server Response: $responseBody');

//         if (response.statusCode == 200) {
//           _showSuccessMessage('✅PDF uploaded successfully');
//           // ScaffoldMessenger.of(context).showSnackBar(
//           //   SnackBar(content: Text('PDF uploaded successfully')),
//           // );
//           _fetchYears();
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error uploading file')),
//           );
//         }
//       } catch (e) {
//         print('Upload error: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Upload failed')),
//         );
//       }

//       setState(() {
//         isUploading = false;
//       });
//     }
//   }

//   Widget _buildTextField(
//       {required String hint, required TextEditingController controller}) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.blue.shade300),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.shade100.withOpacity(0.5),
//             offset: Offset(0, 3),
//             blurRadius: 6,
//           ),
//         ],
//         color:
//             colorScheme.surface, // Use surface color for text field background
//       ),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: TextStyle(color: Colors.grey),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         ),
//         keyboardType: TextInputType.number,
//       ),
//     );
//   }

//   Widget _buildGradientButton(
//       {required String text, required VoidCallback onPressed}) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Container(
//       width: double.infinity,
//       height: 50,
//       margin: EdgeInsets.symmetric(vertical: 20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF004aad), Color(0xFF7ab6f9)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: MaterialButton(
//         onPressed: onPressed,
//         child: isUploading
//             ? CircularProgressIndicator(color: Colors.white)
//             : Text(
//                 text,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildDropdown() {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: colorScheme.surface, // Use surface color for dropdown background
//         border: Border.all(color: Colors.blue.shade300),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.shade100.withOpacity(0.5),
//             offset: Offset(0, 3),
//             blurRadius: 6,
//           ),
//         ],
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: _selectedYear,
//           hint: Text("Enter the year of the Exam"),
//           isExpanded: true,
//           icon: Icon(Icons.arrow_drop_down),
//           onChanged: (String? newValue) {
//             setState(() {
//               _selectedYear = newValue;
//             });
//             if (newValue != null) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ShowAllQuestionsScreen(
//                     year: newValue,
//                     courseName: widget.courseName,
//                   ),
//                 ),
//               );
//             }
//           },
//           items: _years.map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Scaffold(
//       backgroundColor:
//           colorScheme.background, // Use background color for scaffold
//       appBar: AppBar(
//         backgroundColor: AppColors.ceruleanBlue,
//         title: Text(
//           'Add Exams - ${widget.courseName}',
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(20),
//           child: Container(
//             width: 350,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildTextField(
//                   hint: 'Enter the year of the Exam',
//                   controller: _yearController,
//                 ),
//                 _buildGradientButton(
//                   text: 'Add Exam',
//                   onPressed: isUploading ? () {} : _uploadPdf,
//                 ),
//                 _buildDropdown(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//////////////////////////////////////////////////////////////////////////////////////////////////////////

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:file_picker/file_picker.dart';
// import 'package:project/constants.dart';
// import 'package:project/core/constants/colors.dart';
// import 'package:project/features/question/presentation/views/show_all_questions.dart';

// class AddPreviousExamsScreen extends StatefulWidget {
//   final String courseName;

//   AddPreviousExamsScreen({required this.courseName});

//   @override
//   _AddPreviousExamsScreenState createState() => _AddPreviousExamsScreenState();
// }

// class _AddPreviousExamsScreenState extends State<AddPreviousExamsScreen> {
//   final TextEditingController _yearController = TextEditingController();
//   String? _selectedYear;
//   List<String> _years = [];
//   bool isLoading = true;
//   bool isUploading = false;
//   bool isYearsFetchFailed = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchYears();
//   }

//   Future<void> _fetchYears() async {
//     final url = Uri.parse('$kBaseUrl/Doctor/previousExam');
//     try {
//       final response = await http.patch(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'courseName': widget.courseName}),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data is List) {
//           setState(() {
//             _years = List<String>.from(data);
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isYearsFetchFailed = true;
//             isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           isYearsFetchFailed = true;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Fetch years error: $e');
//       setState(() {
//         isYearsFetchFailed = true;
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _uploadPdf() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       setState(() {
//         isUploading = true;
//       });

//       final file = result.files.single;
//       final url = Uri.parse('$kBaseUrl/Doctor/previousExam');

//       final request = http.MultipartRequest('POST', url)
//         ..fields['year'] = _yearController.text
//         ..fields['course'] = widget.courseName
//         ..files.add(await http.MultipartFile.fromPath('pdf', file.path!));

//       try {
//         final response = await request.send();
//         final responseBody = await response.stream.bytesToString();
//         print('Server Response: $responseBody');

//         if (response.statusCode == 200) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('PDF uploaded successfully')),
//           );
//           _fetchYears(); // refresh years list
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error uploading file')),
//           );
//         }
//       } catch (e) {
//         print('Upload error: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Upload failed')),
//         );
//       }

//       setState(() {
//         isUploading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: AppColors.white,
//         title: Text('Add Previous Exams'),
//         backgroundColor: Color(0xFF004AAD),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Add previous exams for "${widget.courseName}"',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF004AAD),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 controller: _yearController,
//                 decoration: InputDecoration(
//                   focusColor: AppColors.darkBlue,
//                   hintText: 'Enter the year of the exam',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: isUploading ? null : _uploadPdf,
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                   backgroundColor: Color(0xFF004AAD),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: isUploading
//                     ? SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : Text(
//                         'Upload Exam PDF',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//               ),
//               SizedBox(height: 30),
//               AbsorbPointer(
//                 absorbing: isLoading,
//                 child: DropdownButtonFormField<String>(
//                   value: _selectedYear,
//                   decoration: InputDecoration(
//                     focusColor: AppColors.darkBlue,
//                     labelText:
//                         isLoading ? 'Loading years...' : 'All Exam Years',
//                     border: OutlineInputBorder(),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: AppColors.darkBlue),
//                     ),
//                   ),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedYear = newValue;
//                     });
//                     if (newValue != null) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ShowAllQuestionsScreen(
//                             year: newValue,
//                             courseName: widget.courseName,
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                   items: _years.map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ShowAllQuestionsScreen extends StatelessWidget {
//   final String year;
//   final String courseName;

//   ShowAllQuestionsScreen({required this.year, required this.courseName});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Questions for $year'),
//       ),
//       body: Center(
//         child: Text('Details for $courseName in $year'),
//       ),
//     );
//   }
// }
