import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:project/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../models/course_model.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class BubbleSheetRepository {
  final String id;

  BubbleSheetRepository({required this.id});

  Future<List<CourseModel>> fetchCourses() async {
    try {
      final response = await http.patch(
        Uri.parse('$kBaseUrl/Doctor/CreateBubbleSheet'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idDoctor': id}),
      );
      print('🔵 Doctor ID: $id');
      print('🟢 Response Body: ${response.body}');

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
      // ✅ طلب إذن التخزين مرة واحدة هنا
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
          'FuLLMark':
              course.fullMark, // Fixed case to match backend's expectation
          'fORm': course.form, // Fixed case to match backend's expectation
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
        await OpenFile.open(file.path); // ✅ فتح الملف هنا مرة واحدة بس
      } else {
        throw Exception('❌ Failed to submit form: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      print('⚠ Error in createPDF: $e');
      print('🛠 Stacktrace: $stacktrace');
      throw Exception('⚠ Network error: $e');
    }
  }

  Future<File?> downloadFile(String fileName, http.Response response) async {
    try {
      // ✅ مفيش طلب تصريح هنا
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

  Future<void> _submitForm(CourseModel course, {required modelName}) async {
    try {
      final response = await http.post(
        Uri.parse('$kBaseUrl/Doctor/informationModel'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'modelName': modelName,
          'Department': course.department,
          'CourseName': course.courseName,
          'CourseCode': course.courseCode,
          'CourseLevel': course.courseLevel,
          'Semester': course.semester,
          'Instructor': course.instructor,
          'Date': course.date,
          'Time': course.time,
          'FuLLMark':
              course.fullMark, // Fixed case to match backend's expectation
          'fORm': course.form, // Fixed case to match backend's expectation
          'NumberofQuestions': course.numberOfQuestions
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == 'Model saved successfully!') {
          // Navigate to mymatrials page after delay
          await Future.delayed(const Duration(seconds: 2));

          final uri = Uri.parse('$kBaseUrl/Doctor/mymatrials');
          final newUri = uri.replace(
            queryParameters: {
              'id': id,
              'modelName': modelName,
              'course': course.courseName,
            },
          );

          if (await canLaunchUrl(newUri)) {
            await launchUrl(newUri);
          }
        }
      } else {
        print(
          'Failed to save information',
        );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }
}
