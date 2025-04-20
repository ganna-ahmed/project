import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:project/constants.dart';
import 'dart:convert';
import '../models/course_model.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class BubbleSheetRepository {
  // final String baseUrl = kBaseUrl;
  final String id;

  BubbleSheetRepository({required this.id});
  Future<List<CourseModel>> fetchCourses() async {
    try {
      final response = await http.patch(
        Uri.parse('$kBaseUrl/Doctor/CreateBubbleSheet'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idDoctor': id}),
      );
      print('❌❌✅❌❌$id');
      print('${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['documents'] != null &&
            responseData['documents'].isNotEmpty) {
          final List<dynamic> documents = responseData['documents'];
          return documents.map((json) => CourseModel.fromJson(json)).toList();
        } else {
          return []; // Return empty list if no documents
        }
      } else {
        throw Exception('❌ Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('⚠️ Network error: $e');
    }
  }

  // Future<List<CourseModel>> fetchCourses() async {
  //   try {
  //     final response = await http.patch(
  //       Uri.parse('$kBaseUrl/Doctor/CreateBubbleSheet'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'idDoctor': id}),
  //     );
  //     print('❌❌✅❌❌$id');
  //     print('${response.body}');
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);

  //       return data.map((json) => CourseModel.fromJson(json)).toList();
  //     } else {
  //       throw Exception('❌ Failed to load courses: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('⚠️ Network error: $e');
  //   }
  // }

  /// 🔹 **إنشاء ملف PDF بناءً على بيانات الكورس**
  Future<void> createPDF(CourseModel course) async {
    try {
      var status = await Permission.storage.request();
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
          'FullMark': course.fullMark,
          'Form': course.form,
          'NumberOfQuestions': course.numberOfQuestions,
        }),
      );

      if (response.statusCode == 200) {
        final fileName = 'Bubble_Sheet_${course.courseName}.pdf';
        final file = await downloadFile(fileName, response);

        if (file == null) {
          throw Exception('❌ Failed to save PDF file');
        }

        print('✅ PDF saved successfully at: ${file.path}');
        OpenFile.open(file.path);
      } else {
        throw Exception('❌ Failed to submit form: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('⚠️ Network error: $e');
    }
  }

//   / 🔹 **تحميل وحفظ ملف PDF في مجلد التنزيلات**
  Future<File?> downloadFile(String fileName, http.Response response) async {
    try {
      const downloadPath = '/storage/emulated/0/Download';
      await Directory(downloadPath).create(recursive: true);

      final file = File('$downloadPath/$fileName');
      await file.writeAsBytes(response.bodyBytes);

      print('✅ File saved to: ${file.path}');
      return file;
    } catch (e) {
      print('❌ Error saving file: $e');
      return null;
    }
  }
}


// import 'package:http/http.dart' as http;
// import 'package:project/constants.dart';
// import 'package:project/features/auth/data/cubits/login_cubit/login_cubit.dart';
// import 'package:project/features/auth/data/models/sign_in_model.dart';
// import 'dart:convert';
// import '../models/course_model.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:open_file/open_file.dart';

// class BubbleSheetRepository {
//   final String baseUrl = kBaseUrl;
//   // 'https://843c-2c0f-fc88-5-597-49a2-fc16-b990-4a8b.ngrok-free.app';
//   //final String id ="${context.watch<LoginCubit>().doctorDatabaseId} ";

//   Future<List<CourseModel>> fetchCourses() async {
//     try {
//       //final loginCubit = context.read<LoginCubit>();
//       //inal SignInModel? doctor = loginCubit.state.user;
//       final response = await http.patch(
//         Uri.parse('$baseUrl/Doctor/CreateBubbleSheet'),
//         headers: {'Content-Type': 'application/json'},
//         //  body: jsonEncode({'idDoctor': doctor.id}
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         return data.map((json) => CourseModel.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load courses');
//       }
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }

//   Future<void> createPDF(CourseModel course) async {
//     try {
//       var status = await Permission.storage.request();
//       if (!status.isGranted) {
//         throw Exception('Storage permission denied');
//       }

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
//         final fileName = 'Bubble_Sheet_${course.courseName}.pdf';
//         final file = await downloadFile(fileName, response);

//         if (file == null) {
//           throw Exception('Failed to save PDF file');
//         }

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

//   Future<File?> downloadFile(String fileName, http.Response response) async {
//     try {
//       final directory = await getExternalStorageDirectory();
//       const downloadPath = '/storage/emulated/0/Download';
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