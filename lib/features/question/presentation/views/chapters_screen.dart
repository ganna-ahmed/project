import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/question/presentation/views/ai_questions.dart';

import 'manual_questions.dart';

class ChaptersScreen extends StatefulWidget {
  final String doctorId;
  final String courseName;

  const ChaptersScreen({
    Key? key,
    required this.doctorId,
    required this.courseName,
  }) : super(key: key);

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  final TextEditingController chapterCountController = TextEditingController();
  List<Map<String, dynamic>> chapters = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchChapters() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('$kBaseUrl/Doctor/Chapters');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'idDoctor': widget.doctorId,
        'course': widget.courseName,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          chapters = List<Map<String, dynamic>>.from(
            data['pdfFiles'].map((fileName) => {
              'name': fileName,
              'manualUrl':
              '$kBaseUrl/Doctor/manualQuestion?course=${widget.courseName}&id=${widget.doctorId}&file=${Uri.encodeComponent(fileName)}',
              'aiUrl':
              '$kBaseUrl/Doctor/QuestionAi?course=${widget.courseName}&id=${widget.doctorId}&file=${Uri.encodeComponent(fileName)}',
              'hasPdf': true,
            }),
          );
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load chapters';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = 'Failed to load chapters';
        isLoading = false;
      });
    }
  }

  Future<void> uploadPdfForChapter(String chapterName) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final file = result.files.single;

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$kBaseUrl/Doctor/Chapter'),
      )
        ..fields['idDoctor'] = widget.doctorId
        ..fields['course'] = widget.courseName
        ..fields['chapter'] = chapterName
        ..files.add(await http.MultipartFile.fromPath('pdf', file.path!));

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF uploaded for $chapterName')),
        );

        setState(() {
          final index =
          chapters.indexWhere((chapter) => chapter['name'] == chapterName);
          if (index != -1) {
            final newFileName = file.name;
            chapters[index]['name'] = newFileName;
            chapters[index]['hasPdf'] = true;
            chapters[index]['manualUrl'] =
            '$kBaseUrl/Doctor/manualQuestion?course=${widget.courseName}&id=${widget.doctorId}&file=${Uri.encodeComponent(newFileName)}';
            chapters[index]['aiUrl'] =
            '$kBaseUrl/Doctor/QuestionAi?course=${widget.courseName}&id=${widget.doctorId}&file=${Uri.encodeComponent(newFileName)}';
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload PDF')),
        );
      }
    }
  }

  void generateChaptersLocally() {
    final input = chapterCountController.text.trim();
    final count = int.tryParse(input);

    if (count != null && count > 0) {
      setState(() {
        chapters = List.generate(
          count,
              (index) => {
            'name': 'Chapter ${index + 1}',
            'hasPdf': false,
          },
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid number of chapters')),
      );
    }
  }

  Widget buildGradientButton(String label, VoidCallback onPressed) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF004aad), Color(0xFF7ab6f9)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: AppColors.ceruleanBlue,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Chapter Manager', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: chapterCountController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                  color: Color(0xFF004aad), fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'Enter the Number of Chapters',
                hintStyle: TextStyle(
                    color: Color(0xFF004aad), fontWeight: FontWeight.bold),
                filled: true,
                fillColor: Colors.grey[300],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF004aad), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF004aad), width: 2),
                ),
              ),
            ),
            SizedBox(height: 16),
            buildGradientButton(
                'Generate Chapters Locally', generateChaptersLocally),
            SizedBox(height: 16),
            buildGradientButton('Show PDFs on Server', fetchChapters),
            SizedBox(height: 24),
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
              child: ListView.builder(
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  final chapter = chapters[index];
                  return Card(
                    color: Color(0xFFACE1F9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        if (chapter['hasPdf'] == false) {
                          uploadPdfForChapter(chapter['name']);
                        }
                      },
                      child: ListTile(
                        title: Text(
                          chapter['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: chapter['hasPdf'] == true
                            ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: Icon(Icons.smart_toy,
                                    color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AIQuestionsScreen(
                                            courseName:
                                            widget.courseName,
                                            doctorId: widget.doctorId,
                                            fileName: chapter['name'],
                                          ),
                                    ),
                                  );
                                }),
                            IconButton(
                              icon: Icon(Icons.edit_note,
                                  color: Colors.green),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ManualQuestionScreen(
                                        // url: chapter['manualUrl'],
                                        // title: chapter['name'],
                                        courseName: widget.courseName,
                                        fileName: chapter['name'],
                                        doctorId: widget.doctorId,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        )
                            : Icon(Icons.upload_file,
                            color: Colors.black54),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LinkScreen extends StatelessWidget {
  final String url;
  final String title;

  const LinkScreen({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('This should open: $url')),
    );
  }
}