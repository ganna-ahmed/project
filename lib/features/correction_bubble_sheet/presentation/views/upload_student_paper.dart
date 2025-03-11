import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/features/correction_bubble_sheet/presentation/views/widget/custom_button.dart';

class CorrectBubbleSheetForStudent extends StatefulWidget {
  final String fileName;

  const CorrectBubbleSheetForStudent({super.key, required this.fileName});

  @override
  _CorrectBubbleSheetForStudentState createState() =>
      _CorrectBubbleSheetForStudentState();
}

class _CorrectBubbleSheetForStudentState extends State<CorrectBubbleSheetForStudent> {
  String? bubbleSheetStudent;
  bool isLoading = false;
  double progress = 0.0;
  bool showProgressBar = false;

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

  Future<void> uploadFile(String filePath) async {
    final url = Uri.parse(
      'https://843c-2c0f-fc88-5-597-49a2-fc16-b990-4a8b.ngrok-free.app/Doctor/uploadBubbelSheets',
    );

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Accept": "application/json",
    });

    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    setState(() {
      showProgressBar = true;
      progress = 0.0;
    });

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(respStr) as Map<String, dynamic>?;
        if (data != null && data.containsKey('fileName') && data['fileName'] != null) {
          String uploadedFileName = data['fileName'] as String;
          if (mounted) {
            setState(() {
              bubbleSheetStudent = uploadedFileName;
              progress = 1.0;
              showProgressBar = false;
            });
          }
          Fluttertoast.showToast(msg: 'Upload successful!');
        }
      } else {
        throw Exception('Upload failed: ${response.statusCode}');
      }
    } catch (error) {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Correction Bubble Sheet",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Accurate correction, secure results.",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        backgroundColor: AppColors.ceruleanBlue,
        elevation: 0,
        toolbarHeight: 90,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isLargeScreen ? screenWidth * 0.2 : 25,
          vertical: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/upload.png',
              width: isLargeScreen ? 350 : 250,
            ),
            const SizedBox(height: 30),

            CustomButtonn(
              onPressed: pickAndUploadFile,
              backgroundColor: const Color(0xffC9DEFF),
              icon: Icons.upload_file_rounded,
              title: "Upload Student Paper",
              subtitle: "Upload the student paper PDF.\nEnsure images are 870x600 for accurate results.",
            ),

            if (showProgressBar)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: bubbleSheetStudent == null
                  ? null // 🔴 تعطيل الزر إذا لم يتم رفع الملف
                  : () {
                      GoRouter.of(context).push(AppRouter.kCheckForUpload, extra: {
                        'fileName': widget.fileName,
                        'BubbleSheetStudent': bubbleSheetStudent,
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: bubbleSheetStudent == null
                    ? Colors.grey[400] // 🔴 تغيير اللون إلى الرمادي عند تعطيل الزر
                    : const Color(0xff2262C6),
                minimumSize: Size(screenWidth * 0.5, 50), // Responsive width
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Correction",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
