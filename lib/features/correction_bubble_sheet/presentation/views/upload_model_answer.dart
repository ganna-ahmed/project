import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';
import 'package:project/features/correction_bubble_sheet/presentation/views/widget/custom_button.dart';

class UploadModelAnswer extends StatefulWidget {
  const UploadModelAnswer({super.key});

  @override
  _UploadModelAnswerState createState() => _UploadModelAnswerState();
}

class _UploadModelAnswerState extends State<UploadModelAnswer> {
  String? fileName;
  bool isLoading = false;

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
      '$kBaseUrl/Doctor/AnswerSheet',
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
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Accurate correction, secure results.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
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
              backgroundColor: const Color(0xff2D4263),
              icon: Icons.upload_file_rounded,
              title: "Upload Model Answer",
              subtitle:
                  "Upload the model answer PDF.\nEnsure images are 870x600 for accurate results.",
            ),
            const SizedBox(height: 10),
            if (isLoading)
              Column(
                children: [
                  LinearProgressIndicator(
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: fileName != null
                  ? () {
                      String processedFileName =
                          fileName!.replaceAll('.pdf', '');
                      GoRouter.of(context).push(AppRouter.kProcessingPage,
                          extra: processedFileName);
                    }
                  : null, // زر معطل إذا لم يتم اختيار الملف
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    fileName != null ? const Color(0xff2262C6) : Colors.grey,
                minimumSize: Size(screenWidth * 0.5, 50),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Next",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
