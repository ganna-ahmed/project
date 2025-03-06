// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:go_router/go_router.dart';
// import 'package:project/core/constants/colors.dart';
// import 'package:project/core/utils/app_router.dart';

// class CorrectBubbleSheetForStudent extends StatefulWidget {
//   @override
//   _CorrectBubbleSheetForStudentState createState() =>
//       _CorrectBubbleSheetForStudentState();
// }

// class _CorrectBubbleSheetForStudentState
//     extends State<CorrectBubbleSheetForStudent> {
//   String? fileName;
//   bool isLoading = false; // لإضافة مؤشر تحميل
//   double progress = 0.0; // لشريط التقدم
//   bool showProgressBar = false; // للتحكم في ظهور شريط التقدم

//   /// *اختيار ملف PDF ورفعه إلى الـ API*
//   Future<void> pickAndUploadFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//       // maxFiles: 1,
//       // fileSizeLimit: 10 * 1024 * 1024, // حد الحجم 10MB
//     );

//     if (result != null && result.files.single.size <= 10 * 1024 * 1024) {
//       String? path = result.files.single.path;
//       if (path != null) {
//         setState(() => isLoading = true);
//         await uploadFile(path);
//         setState(() => isLoading = false);
//       }
//     } else {
//       Fluttertoast.showToast(
//           msg: 'File size exceeds 10MB or invalid file type');
//     }
//   }

//   /// *رفع الملف إلى API ومعالجة التقدم*
//   Future<void> uploadFile(String filePath) async {
//     final url = Uri.parse(
//       'https://7959-197-192-206-85.ngrok-free.app/Doctor/uploadBubbelSheets',
//     );

//     var request = http.MultipartRequest('POST', url);
//     request.headers.addAll({
//       "Content-Type": "multipart/form-data",
//       "Accept": "application/json",
//     });

//     request.files.add(await http.MultipartFile.fromPath('file', filePath));

//     setState(() {
//       showProgressBar = true;
//     });

//     // تحديث شريط التقدم
//     const updateInterval = Duration(milliseconds: 200);
//     final progressTimer = Stream.periodic(updateInterval, (count) => count)
//         .takeWhile((count) => progress < 0.9)
//         .listen((_) {
//       setState(() {
//         progress += 0.1;
//       });
//     });

//     try {
//       final response = await request.send();
//       final respStr = await response.stream.bytesToString();

//       if (response.statusCode == 200) {
//         final data = jsonDecode(respStr) as Map<String, dynamic>?;
//         if (data != null &&
//             data.containsKey('fileName') &&
//             data['fileName'] != null) {
//           String uploadedFileName = data['fileName'] as String;
//           progressTimer.cancel();
//           setState(() {
//             fileName = uploadedFileName;
//             progress = 1.0;
//             showProgressBar = false;
//           });
//           Fluttertoast.showToast(msg: 'Upload successful!');
//           // *الانتقال إلى صفحة check for upload بعد نجاح الرفع*
//           GoRouter.of(context).push(AppRouter.kCheckForUpload, extra: {
//             'BubbleSheetStudent': uploadedFileName,
//           });
//         } else {
//           Fluttertoast.showToast(
//               msg: 'Upload successful, but fileName is missing!');
//         }
//       } else {
//         throw Exception(
//             'Upload failed: ${response.statusCode} - ${response.reasonPhrase}');
//       }
//     } catch (error) {
//       progressTimer.cancel();
//       setState(() {
//         showProgressBar = false;
//       });
//       Fluttertoast.showToast(msg: 'Error: ${error.toString()}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Correct bubble sheet for Student",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold)),
//             Text("Accurate correction, secure results.",
//                 style: TextStyle(color: Colors.white, fontSize: 14)),
//           ],
//         ),
//         backgroundColor: AppColors.ceruleanBlue,
//         elevation: 0,
//         toolbarHeight: 80,
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: screenHeight * 0.05),
//                 GestureDetector(
//                   onTap: pickAndUploadFile,
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: AppColors.ceruleanBlue,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Image.asset('assets/images/upload.png',
//                             width: screenWidth * 0.3, color: Colors.white),
//                         SizedBox(height: 10),
//                         // Text(
//                         //   'upload model answer',
//                         //   style: TextStyle(
//                         //       fontSize: 16,
//                         //       color: Colors.white,
//                         //       fontWeight: FontWeight.bold),
//                         // ),
//                         Text(
//                           'Upload the student answer PDF',
//                           style: TextStyle(fontSize: 12, color: Colors.white70),
//                         ),
//                         Text(
//                           'Ensure images are 870x600 for accurate results.',
//                           style: TextStyle(fontSize: 12, color: Colors.white70),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.03),
//                 if (showProgressBar)
//                   LinearProgressIndicator(
//                     value: progress,
//                     minHeight: 10,
//                     backgroundColor: Colors.grey[300],
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                   ),
//                 SizedBox(height: 10),
//                 Text(fileName ?? "No file uploaded",
//                     style: const TextStyle(fontSize: 16, color: Colors.black)),
//                 SizedBox(height: screenHeight * 0.02),
//                 if (fileName != null && !showProgressBar)
//                   ElevatedButton(
//                     onPressed: () {
//                       GoRouter.of(context).push(AppRouter.kCheckForUpload,
//                           extra: {'BubbleSheetStudent': fileName});
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.ceruleanBlue,
//                       padding: EdgeInsets.symmetric(
//                         vertical: screenHeight * 0.02,
//                         horizontal: screenWidth * 0.2,
//                       ),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     child: const Text("Correction",
//                         style: TextStyle(color: Colors.white, fontSize: 18)),
//                   ),
//               ],
//             ),
//           ),
//           if (isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: Center(
//                 child: CircularProgressIndicator(color: AppColors.ceruleanBlue),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';

class CorrectBubbleSheetForStudent extends StatefulWidget {
  final String fileName; // الاسم المُمرر من ProcessingPage

  const CorrectBubbleSheetForStudent({super.key, required this.fileName});

  @override
  _CorrectBubbleSheetForStudentState createState() =>
      _CorrectBubbleSheetForStudentState();
}

class _CorrectBubbleSheetForStudentState
    extends State<CorrectBubbleSheetForStudent> {
  String? bubbleSheetStudent; // الاسم المُرجع من السيرفر
  bool isLoading = false; // لإضافة مؤشر تحميل
  double progress = 0.0; // لشريط التقدم
  bool showProgressBar = false; // للتحكم في ظهور شريط التقدم

  /// *اختيار ملف PDF ورفعه إلى الـ API*
  Future<void> pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.size <= 10 * 1024 * 1024) {
      String? path = result.files.single.path;
      if (path != null) {
        setState(() => isLoading = true);
        await uploadFile(path);
        setState(() => isLoading = false);
      }
    } else {
      Fluttertoast.showToast(
          msg: 'File size exceeds 10MB or invalid file type');
    }
  }

  /// *رفع الملف إلى API ومعالجة التقدم*
  Future<void> uploadFile(String filePath) async {
    final url = Uri.parse(
      'https://bf40-2c0f-fc88-5-10ae-f4f8-1ba7-f2db-11b6.ngrok-free.app/Doctor/uploadBubbelSheets',
    );

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Accept": "application/json",
    });

    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    setState(() {
      showProgressBar = true;
      progress = 0.0; // إعادة تعيين التقدم
    });

    // تحديث شريط التقدم
    const updateInterval = Duration(milliseconds: 200);
    final progressTimer = Stream.periodic(updateInterval, (count) => count)
        .takeWhile((count) => progress < 0.9)
        .listen((_) {
      if (mounted) {
        setState(() {
          progress += 0.1;
        });
      }
    });

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(respStr) as Map<String, dynamic>?;
        if (data != null &&
            data.containsKey('fileName') &&
            data['fileName'] != null) {
          String uploadedFileName =
              data['fileName'] as String; // الاسم من السيرفر
          progressTimer.cancel();
          if (mounted) {
            setState(() {
              bubbleSheetStudent = uploadedFileName; // تخزين الاسم من السيرفر
              progress = 1.0;
              showProgressBar = false;
            });
          }
          Fluttertoast.showToast(msg: 'Upload successful!');
          // *الانتقال إلى صفحة check for upload بعد نجاح الرفع*
          if (mounted) {
            GoRouter.of(context).push(AppRouter.kCheckForUpload, extra: {
              'fileName': widget.fileName, // الاسم من ProcessingPage
              'BubbleSheetStudent': bubbleSheetStudent, // الاسم من السيرفر
            });
          }
        } else {
          Fluttertoast.showToast(
              msg: 'Upload successful, but fileName is missing!');
        }
      } else {
        throw Exception(
            'Upload failed: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (error) {
      progressTimer.cancel();
      if (mounted) {
        setState(() {
          showProgressBar = false;
        });
      }
      Fluttertoast.showToast(msg: 'Error: ${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Correct bubble sheet for Student",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text("Accurate correction, secure results.",
                style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
        backgroundColor: AppColors.ceruleanBlue,
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                GestureDetector(
                  onTap: pickAndUploadFile,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.ceruleanBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/upload.png',
                            width: screenWidth * 0.3, color: Colors.white),
                        SizedBox(height: 10),
                        Text(
                          'Upload the student answer PDF',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        Text(
                          'Ensure images are 870x600 for accurate results.',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                if (showProgressBar)
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                SizedBox(height: 10),
                Text(
                    bubbleSheetStudent ?? widget.fileName ?? "No file uploaded",
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
                SizedBox(height: screenHeight * 0.02),
                if (bubbleSheetStudent != null && !showProgressBar)
                  ElevatedButton(
                    onPressed: () {
                      if (mounted) {
                        GoRouter.of(context)
                            .push(AppRouter.kCheckForUpload, extra: {
                          'fileName':
                              widget.fileName, // الاسم من ProcessingPage
                          'BubbleSheetStudent':
                              bubbleSheetStudent, // الاسم من السيرفر
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ceruleanBlue,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.2,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Correction",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.ceruleanBlue),
              ),
            ),
        ],
      ),
    );
  }
}
