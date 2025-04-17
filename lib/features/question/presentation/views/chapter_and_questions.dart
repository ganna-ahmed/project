import 'package:flutter/material.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/question/presentation/views/add_previous_exam.dart';
import 'package:project/features/question/presentation/views/chapters_screen.dart';

class ChapterAndQuestionsPage extends StatelessWidget {
  final String courseName;
  final String doctorId;

  const ChapterAndQuestionsPage({
    required this.courseName,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapter and Questions'),
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // عنوان الكورس
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Course ',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: courseName,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004aad),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // الأزرار
                GradientButton(
                  text: 'ADD previous Exam',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPreviousExamsScreen(
                          courseName: courseName,
                        ),
                      ),
                    );
                  },
                ),
                GradientButton(
                  text: 'From Chapters',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChaptersScreen(
                          courseName: courseName,
                          doctorId: doctorId,
                        ),
                      ),
                    );
                  },
                ),
                GradientButton(
                  text: 'make model from previous exam',
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/makeModel?course=$courseName&id=$doctorId');
                  },
                ),
                GradientButton(
                  text: 'Show Details',
                  onPressed: () {
                    Navigator.pushNamed(context,
                        '/showDetails?course=$courseName&id=$doctorId');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF004aad), Color(0xFF7ab6f9)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
