import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/constants.dart';

class ShowAllQuestionsScreen extends StatefulWidget {
  final String year;
  final String courseName;

  ShowAllQuestionsScreen({required this.year, required this.courseName});

  @override
  _ShowAllQuestionsScreenState createState() => _ShowAllQuestionsScreenState();
}

class _ShowAllQuestionsScreenState extends State<ShowAllQuestionsScreen> {
  List<dynamic> multipleChoiceQuestions = [];
  List<dynamic> writtenQuestions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final url = Uri.parse('$kBaseUrl/Doctor/showAllQuestionPrevious');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'courseName': widget.courseName,
          'year': widget.year,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response Data: $data');

        setState(() {
          // Convert the map values into a list for multiple_choice_questions
          multipleChoiceQuestions =
              (data['multiple_choice_questions'] ?? {}).values.toList();
          // Directly use essay_questions as a list
          writtenQuestions = List.from(data['essay_questions'] ?? []);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load questions.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data. $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.courseName} - ${widget.year}'),
        backgroundColor: Color(0xFF0D47A1),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child:
                      Text(errorMessage, style: TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildSectionTitle('Multiple Choice Questions'),
                      _buildMCQList(),
                      SizedBox(height: 30),
                      _buildSectionTitle('Essay Questions'),
                      _buildEssayList(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
      ),
    );
  }

  Widget _buildMCQList() {
    return Column(
      children: multipleChoiceQuestions.map((question) {
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question['question'] != null
                    ? question['question']
                    : 'No Question',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField(
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  filled: true,
                  fillColor: Color(0xFFE3F2FD),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                items: (question['options'] as Map<String, dynamic>?)
                        ?.entries
                        .map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text('${entry.key}: ${entry.value}'),
                      );
                    }).toList() ??
                    [],
                onChanged: (value) {},
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEssayList() {
    return Column(
      children: writtenQuestions.map((question) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Color(0xFFE1F5FE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            question.toString(),
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF01579B),
            ),
          ),
        );
      }).toList(),
    );
  }
}
