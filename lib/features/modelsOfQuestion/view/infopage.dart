import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:project/constants.dart';
import 'package:project/features/modelsOfQuestion/view/ai_show_questions.dart';
import 'package:project/features/modelsOfQuestion/view/manual_show_questions.dart';
import 'package:project/features/modelsOfQuestion/view/review_exam.dart';
import 'package:project/features/modelsOfQuestion/view/show_previous_exam.dart';
import 'dart:convert';

class InfoPage extends StatefulWidget {
  const InfoPage({
    super.key,
    required this.idDoctor,
    required this.modelName,
    required this.courseName,
  });

  final String idDoctor;
  final String modelName;
  final String courseName;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String? selectedExam;
  String? selectedChapter;
  String? selectedMode;
  List<String> exams = [];
  List<String> chapters = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchExams();
    _fetchChapters();
  }

  Future<void> _fetchExams() async {
    setState(() => isLoading = true);
    try {
      final response = await http.patch(
        Uri.parse('$kBaseUrl/Doctor/mymatrials'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'courseName': widget.courseName}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() {
            exams = List<String>.from(data);
          });
        }
      }
    } catch (_) {
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchChapters() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$kBaseUrl/Doctor/mymatrials'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idDoctor': widget.idDoctor,
          'courseName': widget.courseName,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['pdfFiles'] is List) {
          setState(() {
            chapters = List<String>.from(data['pdfFiles']);
          });
        }
      }
    } catch (_) {
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _handleExamSelection(String? value) {
    if (value != null) {
      setState(() {
        selectedExam = value;
      });
    }
  }

  void _handleChapterSelection(String? value) {
    setState(() {
      selectedChapter = value;
      selectedMode = null;
    });
  }

  void _handleModeSelection(String? value) {
    setState(() {
      selectedMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 600.w;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose question for your exam',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF004AAD),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: isDesktop ? 500.w : double.infinity),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLabel('Previous Exams'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      hint: 'All Exam Added',
                      value: selectedExam,
                      items: exams,
                      onChanged: _handleExamSelection,
                    ),
                    if (selectedExam != null) ...[
                      SizedBox(height: 20.h),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF004AAD), Color(0xFF7AB6F9)],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowFromPreviosExam(
                                          idDoctor: widget.idDoctor,
                                          courseName: widget.courseName,
                                          modelName: widget.modelName,
                                          year: selectedExam!,
                                        )));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Open Selected Exam',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 20.h),
                    _buildLabel('From Chapter'),
                    SizedBox(height: 8.h),
                    _buildDropdown(
                      hint: 'Select Chapter',
                      value: selectedChapter,
                      items: chapters,
                      onChanged: _handleChapterSelection,
                    ),
                    if (selectedChapter != null) ...[
                      SizedBox(height: 20.h),
                      _buildLabel('Choose Mode'),
                      SizedBox(height: 8.h),
                      _buildDropdown(
                        hint: 'Select Mode (AI / Manual)',
                        value: selectedMode,
                        items: ['ai', 'manual'],
                        onChanged: _handleModeSelection,
                      ),
                    ],
                    if (selectedChapter != null && selectedMode != null) ...[
                      SizedBox(height: 20.h),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF004AAD), Color(0xFF7AB6F9)],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => selectedMode == 'manual'
                                    ? QuestionsForChapterManualPage(
                                        idDoctor: widget.idDoctor,
                                        courseName: widget.courseName,
                                        modelName: widget.modelName,
                                        // year: selectedExam!,
                                        chapterName: selectedChapter!,
                                        mode: selectedMode!,
                                      )
                                    : QuestionsForChapterAiPage(
                                        idDoctor: widget.idDoctor,
                                        courseName: widget.courseName,
                                        modelName: widget.modelName,
                                        // year: selectedExam!,
                                        chapterName: selectedChapter!,
                                        mode: selectedMode!,
                                      ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Open Questions From Chapter',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 20.h),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF004AAD), Color(0xFF7AB6F9)],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExamReviewApp(
                                        idDoctor: widget.idDoctor,
                                        modelName: widget.modelName,
                                      )));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Review Exam',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18.sp,
        color: Color(0xFF004AAD),
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade300),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        hint: Text(
          hint,
          style: const TextStyle(
            color: Color(0xFF004AAD),
            fontWeight: FontWeight.bold,
          ),
        ),
        value: value,
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF004AAD)),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(color: Color(0xFF004AAD)),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
