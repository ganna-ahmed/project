import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/constants.dart';

class ShowAllMaualQuestionsScreen extends StatefulWidget {
  final String doctorId;
  final String courseName;
  final String fileName;

  const ShowAllMaualQuestionsScreen({
    Key? key,
    required this.doctorId,
    required this.courseName,
    required this.fileName,
  }) : super(key: key);

  @override
  _ShowAllMaualQuestionsScreenState createState() =>
      _ShowAllMaualQuestionsScreenState();
}

class _ShowAllMaualQuestionsScreenState
    extends State<ShowAllMaualQuestionsScreen> {
  List<dynamic> questions = [];
  bool isLoading = true;
  String errorMessage = '';

  // Map to track selected answers for each question
  Map<String, String> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      final url = Uri.parse('$kBaseUrl/Doctor/showAllManualQuestion');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idDoctor': widget.doctorId,
          'courseName': widget.courseName,
          'file': widget.fileName,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✳️✳️✳️✳️✳️Response data: $data");
        print(
            "📦 Received question types: ${data.map((q) => q['type']).toList()}");
        setState(() {
          questions = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load questions: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Color(0xFF18305B),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF18305B)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child:
                      Text(errorMessage, style: TextStyle(color: Colors.red)))
              : _buildQuestionsList(),
    );
  }

  Widget _buildQuestionsList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Questions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF18305B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildQuestionSection('Easy Questions',
                      questions.where((q) => q['type'] == 'Essay').toList()),
                  const SizedBox(height: 16),
                  _buildQuestionSection('MCQ Questions',
                      questions.where((q) => q['type'] == 'MCQ').toList()),
                  const SizedBox(height: 16),
                  _buildQuestionSection(
                      'Multi Choice Questions',
                      questions
                          .where((q) => q['type'] == 'Multi-Choice')
                          .toList()),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Generate AI-Based Questions',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildQuestionSection(String title, List<dynamic> sectionQuestions) {
    if (sectionQuestions.isEmpty) {
      return Container(); // Don't show empty sections
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        ...sectionQuestions
            .map((question) => _buildQuestionCard(question, title))
            .toList(),
      ],
    );
  }

  Widget _buildQuestionCard(dynamic question, String sectionTitle) {
    final String questionId = question['id'] ??
        question['_id'] ??
        question['question'].hashCode.toString();
    final bool isMultiChoice = question['type'] == 'Multi-Choice' ||
        sectionTitle == 'Multi Choice Questions';
    final bool isExpanded = true; // Show all as expanded

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            color: const Color(0xFF18305B),
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: const Color(0xFFEDF2F9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Type: ${question['type'] ?? 'MCQ'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF18305B),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFF18305B),
                ),
              ],
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question: ${question['question'] ?? ''}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  if (question['choices'] != null) ...[
                    const SizedBox(height: 12),
                    ..._buildChoiceOptions(question, questionId),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildChoiceOptions(dynamic question, String questionId) {
    final List<dynamic> choices = question['choices'] ?? [];
    final String correctAnswer = question['correctAnswer'] ?? '';

    return choices.map<Widget>((choice) {
      // Check if this choice is selected for this question
      final bool isSelected = selectedAnswers[questionId] == choice;
      // Check if this choice is the correct answer
      final bool isCorrect = correctAnswer == choice;

      // Determine the colors based on selection state
      Color backgroundColor;
      Color borderColor;

      if (isSelected) {
        if (isCorrect) {
          // Selected and correct
          backgroundColor = Colors.green.shade100;
          borderColor = Colors.green;
        } else {
          // Selected but wrong
          backgroundColor = Colors.red.shade100;
          borderColor = Colors.red;
        }
      } else {
        // Not selected
        backgroundColor = const Color(0xFFEDF2F9);
        borderColor = Colors.transparent;
      }

      return GestureDetector(
        onTap: () {
          setState(() {
            // Store selected answer for this question
            selectedAnswers[questionId] = choice;
          });
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Text(
            choice,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      );
    }).toList();
  }
}
