import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';
import 'dart:convert';

import 'package:project/features/auth/data/cubits/login_cubit/login_cubit.dart';
import 'chapter_and_questions.dart' show ChapterAndQuestionsPage;

class QuestionBank extends StatefulWidget {
  @override
  _QuestionBankState createState() => _QuestionBankState();
}

class _QuestionBankState extends State<QuestionBank> {
  List<String> courses = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    final doctorId = BlocProvider.of<LoginCubit>(context).doctorDatabaseId;
    print('🚀 Doctor ID: $doctorId');

    if (doctorId == null) {
      setState(() {
        errorMessage = 'Doctor ID not found. Please log in again.';
        isLoading = false;
      });
      return;
    }

    final url = Uri.parse('$kBaseUrl/Doctor/questionBank');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'idDoctor': doctorId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['documents'] != null) {
        setState(() {
          courses = List<String>.from(
              data['documents'].map((course) => course['CourseName']));
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'No courses found';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = 'Failed to load courses';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: AppColors.white,
        title: const Text('Question Bank'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          const Text(
            'Your material according to your list',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004aad),
              decoration: TextDecoration.underline,
            ),
          ),
          SizedBox(height: 20.h),
          Image.asset(
            'assets/images/material.png',
            width: 200.w,
            height: 200.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20.h),
          if (isLoading)
            CircularProgressIndicator()
          else if (errorMessage.isNotEmpty)
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return CourseItem(course: courses[index]);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class CourseItem extends StatelessWidget {
  final String course;

  CourseItem({required this.course});

  @override
  Widget build(BuildContext context) {
    final doctorId = BlocProvider.of<LoginCubit>(context).doctorDatabaseId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChapterAndQuestionsPage(
                courseName: course,
                doctorId: doctorId ?? '',
              ),
            ),
          );
        },
        child: Column(
          children: [
            Text(
              course,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004aad),
              ),
            ),
            Divider(
              color: Color(0xFF004aad).withOpacity(0.5),
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
          ],
        ),
      ),
    );
  }
}
