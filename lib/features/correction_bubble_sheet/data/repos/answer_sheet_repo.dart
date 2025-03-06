// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'dart:convert';
// import 'package:http_parser/http_parser.dart';

// class AnswerSheetRepository {
//   final String baseUrl =
//       'https://2c29-2c0f-fc88-5-749a-2cdb-abfc-bb8f-8ed2.ngrok-free.app';

//   // Future<File?> pickPdfFile(BuildContext context) async {
//   //   try {
//   //     FilePickerResult? result = await FilePicker.platform.pickFiles(
//   //       type: FileType.custom,
//   //       allowedExtensions: ['pdf'],
//   //     );

//   //     if (result != null) {
//   //       File file = File(result.files.single.path!);
//   //       context.read().selectPdfFile(file);
//   //       Fluttertoast.showToast(
//   //           msg: 'PDF selected : ${file.path.split('/').last}');
//   //       return file; // Return the file
//   //     }
//   //     return null; // Return null if no file was selected
//   //   } catch (e) {
//   //     Fluttertoast.showToast(
//   //         msg: 'Error in selecting the file: ${e.toString()}');
//   //     return null; // Return null if there was an error
//   //   }
//   // }

//   Future<Map<String, dynamic>> uploadAnswerSheet(File pdfFile) async {
//     try {
//       // إنشاء طلب متعدد الأجزاء
//       var request = http.MultipartRequest(
//         'PATCH',
//         Uri.parse('$baseUrl/Doctor/AnswerSheet'),
//       );

//       // إضافة ملف PDF إلى الطلب
//       final fileName = pdfFile.path.split('/').last;
//       final bytes = await pdfFile.readAsBytes();
//       final file = http.MultipartFile.fromBytes(
//         'file',
//         bytes,
//         filename: fileName,
//         contentType: MediaType('application', 'pdf'),
//       );

//       request.files.add(file);

//       // إرسال الطلب
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data;
//       } else {
//         throw Exception(
//             'Something went wrong when uploading the file: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('something went wrong: ${e.toString()}');
//     }
//   }
// }




// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:io';
// // import 'dart:convert';
// // import 'package:http_parser/http_parser.dart';

// // class AnswerSheetRepository {
// //   final String baseUrl =
// //       'https://2c29-2c0f-fc88-5-749a-2cdb-abfc-bb8f-8ed2.ngrok-free.app';

// //   Future<File?> pickPdfFile() async {
// //     try {
// //       FilePickerResult? result = await FilePicker.platform.pickFiles(
// //         type: FileType.custom,
// //         allowedExtensions: ['pdf'],
// //       );

// //       if (result != null) {
// //         File file = File(result.files.first.path!);

// //         Fluttertoast.showToast(
// //             msg: 'PDF selected : ${file.path.split('/').last}');
// //         return file; // Return the file
// //       }
// //       return null; // Return null if no file was selected
// //     } catch (e) {
// //       Fluttertoast.showToast(
// //           msg: 'Error in selecting the file: ${e.toString()}');
// //       return null; // Return null if there was an error
// //     }
// //   }

// //   Future<Map<String, dynamic>> uploadAnswerSheet(File pdfFile) async {
// //     try {
// //       // إنشاء طلب متعدد الأجزاء
// //       var request = http.MultipartRequest(
// //         'PATCH',
// //         Uri.parse('$baseUrl/Doctor/AnswerSheet'),
// //       );

// //       // إضافة ملف PDF إلى الطلب
// //       final fileName = pdfFile.path.split('/').last;
// //       final bytes = await pdfFile.readAsBytes();
// //       final file = http.MultipartFile.fromBytes(
// //         'file',
// //         bytes,
// //         filename: fileName,
// //         contentType: MediaType('application', 'pdf'),
// //       );

// //       request.files.add(file);

// //       // إرسال الطلب
// //       final streamedResponse = await request.send();
// //       final response = await http.Response.fromStream(streamedResponse);

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         return data;
// //       } else {
// //         throw Exception(
// //             'Something went wrong when uploading the file: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       throw Exception('something went wrong: ${e.toString()}');
// //     }
// //   }
// // }


