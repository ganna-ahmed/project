import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';

class UploadModelAnswer extends StatefulWidget {
  @override
  _UploadModelAnswerState createState() => _UploadModelAnswerState();
}

class _UploadModelAnswerState extends State<UploadModelAnswer> {
  String? fileName;
  bool isLoading = false; // لإضافة مؤشر تحميل

  Future<void> pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      // maxFiles: 1,
      // fileSizeLimit: 10 * 1024 * 1024, // حد الحجم 10MB
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

  Future<void> uploadFile(String filePath) async {
    final url = Uri.parse(
      'https://bf40-2c0f-fc88-5-10ae-f4f8-1ba7-f2db-11b6.ngrok-free.app/Doctor/AnswerSheet',
    );
    var request = http.MultipartRequest('PATCH', url);
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Accept": "application/json",
    });
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(respStr) as Map<String, dynamic>?;
        if (data != null &&
            data.containsKey('fileName') &&
            data['fileName'] != null) {
          setState(() {
            fileName = data['fileName'] as String;
          });
        } else {
          setState(() {
            fileName = "File uploaded";
          });
        }
        Fluttertoast.showToast(msg: 'Upload successful!');
      } else {
        Fluttertoast.showToast(
            msg:
                'Upload failed: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (error) {
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
            Text("Correction Bubble Sheet",
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
                        SizedBox(height: 10.h),
                        const Text(
                          'upload model answer',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '   Upload the model answer PDF  ',
                          style:
                              TextStyle(fontSize: 12.sp, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(fileName ?? "No file uploaded",
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
                SizedBox(height: screenHeight * 0.02),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (fileName != null) {
                      String processedFileName =
                          fileName!.replaceAll('.pdf', '');
                      GoRouter.of(context).push(AppRouter.kProcessingPage,
                          extra: processedFileName);
                    } else {
                      Fluttertoast.showToast(msg: "Please upload a file first");
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
                  child: const Text("NEXT",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.ceruleanBlue),
              ),
            ),
        ],
      ),
    );
  }
}
