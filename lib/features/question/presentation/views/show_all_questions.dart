import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';

class ShowAllQuestionsScreen extends StatefulWidget {
  final String year;
  final String courseName;

  ShowAllQuestionsScreen({required this.year, required this.courseName});

  @override
  _ShowAllQuestionsScreenState createState() => _ShowAllQuestionsScreenState();
}

class _ShowAllQuestionsScreenState extends State<ShowAllQuestionsScreen> {
  List<Map<String, dynamic>> multipleChoiceQuestions = [];
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
          // FIXED: Properly handle multiple choice questions - ensure proper type casting
          if (data['multiple_choice_questions'] is Map) {
            final mcqMap =
            data['multiple_choice_questions'] as Map<String, dynamic>;
            multipleChoiceQuestions =
                mcqMap.entries.map<Map<String, dynamic>>((entry) {
                  final questionData =
                  Map<String, dynamic>.from(entry.value as Map);
                  questionData['id'] = entry.key;
                  return questionData;
                }).toList();
          } else {
            multipleChoiceQuestions = [];
          }

          // FIXED: Properly handle essay questions with explicit type checking
          if (data['essay_questions'] != null) {
            if (data['essay_questions'] is List) {
              writtenQuestions =
              List<dynamic>.from(data['essay_questions'] as List);
            } else if (data['essay_questions'] is Map) {
              // If it's coming as a Map instead of a List, convert Map values to a List
              final essayMap = data['essay_questions'] as Map<String, dynamic>;
              writtenQuestions = essayMap.values.toList();
            } else {
              writtenQuestions = [];
            }
          } else {
            writtenQuestions = [];
          }

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
          'Failed to load questions. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: $e';
        isLoading = false;
      });
      print('Exception details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.white,
        title: Text('${widget.courseName} - ${widget.year}'),
        backgroundColor: AppColors.ceruleanBlue,
      ),
      backgroundColor: colorScheme.background,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
        child: Text(
          errorMessage,
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      )
          : _buildResponsiveBody(),
    );
  }

  Widget _buildResponsiveBody() {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isWideScreen ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Multiple Choice Questions'),
              multipleChoiceQuestions.isEmpty
                  ? _buildEmptyMessage('No multiple choice questions available')
                  : _buildMCQList(isWideScreen),
              SizedBox(height: 30),
              _buildSectionTitle('Essay Questions'),
              writtenQuestions.isEmpty
                  ? _buildEmptyMessage('No essay questions available')
                  : _buildEssayList(isWideScreen),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyMessage(String message) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: colorScheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildMCQList(bool isWideScreen) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: multipleChoiceQuestions.map((question) {
        // Safely extract options - FIXED by adding more robust type checking
        Map<String, dynamic> optionsMap = {};
        if (question['options'] is Map) {
          optionsMap = Map<String, dynamic>.from(question['options'] as Map);
        }

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(isWideScreen ? 16 : 12),
          decoration: BoxDecoration(
            color: colorScheme.cardColor,
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
                    ? question['question'].toString()
                    : 'No Question',
                style: TextStyle(
                  fontSize: isWideScreen ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              SizedBox(height: 12),
              optionsMap.isNotEmpty
                  ? _buildDropdown(optionsMap)
                  : Text(
                'No options available',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Separated dropdown widget for better error handling
  Widget _buildDropdown(Map<String, dynamic> optionsMap) {
    final colorScheme = Theme.of(context).colorScheme;
    try {
      return DropdownButtonFormField<String>(
        isExpanded: true,
        hint: Text('Select an answer'),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          filled: true,
          fillColor: colorScheme.secondaryContainer,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        items: optionsMap.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text('${entry.key}: ${entry.value}'),
          );
        }).toList(),
        onChanged: (value) {},
      );
    } catch (e) {
      print('Error building dropdown: $e');
      // Fallback widget in case dropdown creation fails
      return Text(
        'Error displaying options: $e',
        style: TextStyle(color: Colors.red),
      );
    }
  }

  Widget _buildEssayList(bool isWideScreen) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: writtenQuestions.map((question) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(isWideScreen ? 18 : 15),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            question.toString(),
            style: TextStyle(
              fontSize: isWideScreen ? 18 : 16,
              color: colorScheme.onSurface,
            ),
          ),
        );
      }).toList(),
    );
  }
}

extension CustomColorScheme on ColorScheme {
  Color get cardColor => brightness == Brightness.light ? Colors.white : Colors.grey[800]!;
  Color get onPrimaryContainer => brightness == Brightness.light ? Colors.blue[900]! : Colors.white;
}