import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  Future<void> _fetchYears() async {
    final url = Uri.parse('$kBaseUrl/Doctor/previousExam');
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'courseName': widget.courseName}),
      );

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
      }
    } catch (e) {
      print('Fetch years error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _uploadPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        isUploading = true;
      });

      final file = result.files.single;
      final url = Uri.parse('$kBaseUrl/Doctor/previousExam');

      final request = http.MultipartRequest('POST', url)
        ..fields['year'] = _yearController.text
        ..fields['course'] = widget.courseName
        ..files.add(await http.MultipartFile.fromPath('pdf', file.path!));

      try {
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        print('Server Response: $responseBody');

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('PDF uploaded successfully')),
          );
          _fetchYears();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading file')),
          );
        }
      } catch (e) {
        print('Upload error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed')),
        );
      }

      setState(() {
        isUploading = false;
      });
    }
  }

  Widget _buildTextField(
      {required String hint, required TextEditingController controller}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildGradientButton(
      {required String text, required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF004aad), Color(0xFF7ab6f9)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: isUploading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedYear,
          hint: Text("Enter the year of the Exam"),
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            setState(() {
              _selectedYear = newValue;
            });
            if (newValue != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowAllQuestionsScreen(
                    year: newValue,
                    courseName: widget.courseName,
                  ),
                ),
              );
            }
          },
          items: _years.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF004aad),
        title: Text(
          'Add Exams - ${widget.courseName}',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Container(
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTextField(
                  hint: 'Enter the year of the Exam',
                  controller: _yearController,
                ),
                _buildGradientButton(
                  text: 'Add Exam',
                  onPressed: isUploading ? () {} : _uploadPdf,
                ),
                _buildDropdown(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



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
