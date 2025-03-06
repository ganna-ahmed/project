import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/features/auth/data/cubits/login_cubit/login_cubit.dart';
import 'package:project/features/auth/data/models/sign_in_model.dart';
import 'dart:convert';
import '../models/course_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class BubbleSheetRepository {
  final String baseUrl =
      'https://bf40-2c0f-fc88-5-10ae-f4f8-1ba7-f2db-11b6.ngrok-free.app';
  //final String id ="${context.watch<LoginCubit>().doctorDatabaseId} ";

  Future<List<CourseModel>> fetchCourses() async {
    try {
      //final loginCubit = context.read<LoginCubit>();
      //inal SignInModel? doctor = loginCubit.state.user;
      final response = await http.patch(
        Uri.parse('$baseUrl/Doctor/CreateBubbleSheet'),
        headers: {'Content-Type': 'application/json'},
        //  body: jsonEncode({'idDoctor': doctor.id}
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CourseModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> createPDF(CourseModel course) async {
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Storage permission denied');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/Doctor/CreateBubbleSheet'),
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
          'NumberofQuestions': course.numberOfQuestions,
        }),
      );

      if (response.statusCode == 200) {
        final fileName = 'Bubble_Sheet_${course.courseName}.pdf';
        final file = await downloadFile(fileName, response);

        if (file == null) {
          throw Exception('Failed to save PDF file');
        }

        print('PDF saved successfully at: ${file.path}');

        OpenFile.open(file.path);
      } else {
        throw Exception(
            'Failed to submit form. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<File?> downloadFile(String fileName, http.Response response) async {
    try {
      final directory = await getExternalStorageDirectory();
      final downloadPath = '/storage/emulated/0/Download';
      await Directory(downloadPath).create(recursive: true);

      final file = File('$downloadPath/$fileName');
      await file.writeAsBytes(response.bodyBytes);

      print('File saved to: ${file.path}');
      return file;
    } catch (e) {
      print('Error saving file: $e');
      return null;
    }
  }
}

//   Future<void> createPDF(CourseModel course) async {
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.storage,
//       //add more permission to request here.
//     ].request();

//     // if (statuses[Permission.storage]!.isGranted) {
//     //   var dir = await DownloadsPathProvider.downloadsDirectory;
//     //   if (dir != null) {
//     //     String savename = "${course.courseName}.pdf";
//     //     String savePath = dir.path + "/$savename";
//     //     print(savePath);

//     try {
//       // var status = await Permission.storage.request();
//       // if (!status.isGranted) {
//       //   throw Exception('Storage permission denied');
//       // }

//       final response = await http.post(
//         Uri.parse('$baseUrl/Doctor/CreateBubbleSheet'),
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
//           'NumberofQuestions': course.numberOfQuestions,
//         }),
//       );

//       if (response.statusCode == 200) {
//         // final downloadDir = await getApplicationDocumentsDirectory();
//         final fileName = 'Bubble_Sheet_${course.courseName}.pdf';
//         // final filePath = '${downloadDir.path}/$fileName';

//         // File file = File(filePath);
//         // await file.writeAsBytes(response.bodyBytes);

//         // print('PDF saved successfully at: $filePath');
//         final file = await downloadFile(fileName, response);
//         if (file == null) return;
//         print('PDF saved successfully at: ${file.path}');
//         OpenFile.open(file.path);
//       } else {
//         throw Exception(
//             'Failed to submit form. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }

//   Future<File?> downloadFile(String fileName, response) async {
//     final appStorage = await getApplicationDocumentsDirectory();
//     final file = File('${appStorage.path}/$fileName');
//     // final response = await http.post(
//     //   Uri.parse('$baseUrl/Doctor/CreateBubbleSheet'),
//     //   headers: {'Content-Type': 'application/json'},
//     //   body: json.encode({
//     //     'Department': course.department,
//     //     'CourseName': course.courseName,
//     //     'CourseCode': course.courseCode,
//     //     'CourseLevel': course.courseLevel,
//     //     'Semester': course.semester,
//     //     'Instructor': course.instructor,
//     //     'Date': course.date,
//     //     'Time': course.time,
//     //     'FuLLMark': course.fullMark,
//     //     'fORm': course.form,
//     //     'NumberofQuestions': course.numberOfQuestions,
//     //   }),
//     // );
//     await file.writeAsBytes(response.bodyBytes);
//     final raf = file.openSync(mode: FileMode.write);
//     raf.writeStringSync(response.body);
//     await raf.close();

//     return file;
//   }
// }

// Future<File?> downloadFile(String fileName, http.Response response) async {
//   try {
//     // الحصول على مسار التخزين
//     final appStorage = await getApplicationDocumentsDirectory();
//     final file = File('${appStorage.path}/$fileName');

//     // كتابة البيانات إلى الملف
//     await file.writeAsBytes(response.bodyBytes);

//     return file;
//   } catch (e) {
//     print('Error saving file: $e');
//     return null;
//   }
// }
//  Future<File?> downloadFile(String fileName, http.Response response) async {
//     try {
//       // الحصول على مسار التخزين الخارجي (مجلد التنزيلات العام)
//       final directory = await getExternalStorageDirectory();
//       final downloadPath =
//           '/storage/emulated/0/Download'; // مسار مجلد التنزيلات على معظم الأجهزة

//       // إنشاء المجلد إذا لم يكن موجوداً
//       await Directory(downloadPath).create(recursive: true);

//       final file = File('$downloadPath/$fileName');
//       await file.writeAsBytes(response.bodyBytes);

//       print('File saved to: ${file.path}');
//       return file;
//     } catch (e) {
//       print('Error saving file: $e');
//       return null;
//     }
//   }
// }
