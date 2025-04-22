import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';

class QuestionsForChapterPage extends StatefulWidget {
  const QuestionsForChapterPage(
      {super.key,
      required this.courseName,
      required this.year,
      required this.modelName,
      required this.idDoctor,
      required this.chapterName});
  final String courseName;
  final String year;
  final String modelName;
  final String idDoctor;
  final String chapterName;

  @override
  State<QuestionsForChapterPage> createState() =>
      _QuestionsForChapterPageState();
}

class _QuestionsForChapterPageState extends State<QuestionsForChapterPage> {
  final Map<String, List<Map<String, dynamic>>> selectedQuestions = {
    'mcq': [],
    'essay': [],
    'multi': [],
  };

  List<dynamic> mcqQuestions = [];
  List<dynamic> essayQuestions = [];
  List<dynamic> multiChoiceQuestions = [];

  bool isLoading = false;
  bool questionsLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$kBaseUrl/Doctor/SelectPrivousExam'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'courseName': widget.courseName,
          'year': widget.year,
          'chapterName': widget.chapterName,
        }),
      );
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          // Handle MCQ questions
          if (data['multiple_choice_questions'] is List) {
            mcqQuestions = data['multiple_choice_questions'] ?? [];
          } else if (data['multiple_choice_questions'] is Map) {
            mcqQuestions = _convertMapToList(data['multiple_choice_questions']);
          } else {
            mcqQuestions = [];
          }

          // Handle essay questions
          if (data['essay_questions'] is List) {
            essayQuestions = data['essay_questions'] ?? [];
          } else if (data['essay_questions'] is Map) {
            essayQuestions = _processEssayQuestions(data['essay_questions']);
          } else {
            essayQuestions = [];
          }

          // Handle multi choice questions
          if (data['multi_choice_questions'] is List) {
            multiChoiceQuestions = data['multi_choice_questions'] ?? [];
          } else if (data['multi_choice_questions'] is Map) {
            multiChoiceQuestions =
                _convertMapToList(data['multi_choice_questions']);
          } else {
            multiChoiceQuestions = [];
          }

          questionsLoaded = true;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading questions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  // Convert a Map to a List format
  List<dynamic> _convertMapToList(Map<String, dynamic> dataMap) {
    List<dynamic> resultList = [];
    dataMap.forEach((key, value) {
      if (value is Map) {
        value['id'] = key; // Preserve the key as an ID if needed
        resultList.add(value);
      }
    });
    return resultList;
  }

  List<dynamic> _processEssayQuestions(Map<String, dynamic> essayData) {
    List<dynamic> processed = [];

    // If essayData is empty, return an empty list
    if (essayData.isEmpty) {
      return processed;
    }

    String currentQuestion = '';
    int questionNumber = 1;

    List<String> keys = essayData.keys.toList()..sort();

    for (var key in keys) {
      var text = essayData[key];
      if (text.toString().startsWith('${questionNumber}.')) {
        if (currentQuestion.isNotEmpty) {
          processed.add(currentQuestion.trim());
          questionNumber++;
        }
        currentQuestion = text.toString();
      } else {
        currentQuestion += ' $text';
      }
    }

    if (currentQuestion.isNotEmpty) {
      processed.add(currentQuestion.trim());
    }

    return processed;
  }

  void _toggleSelection(dynamic question, String type) {
    setState(() {
      final selectedList = selectedQuestions[type]!;
      final questionText =
          type == 'mcq' || type == 'multi' ? question['question'] : question;

      // Check if already selected
      final isSelected = selectedList.any((q) => q['text'] == questionText);

      if (isSelected) {
        selectedList.removeWhere((q) => q['text'] == questionText);
      } else {
        selectedList.add({
          'text': questionText,
          'options':
              type == 'mcq' || type == 'multi' ? question['options'] : null,
        });
      }
    });
  }

  bool _isSelected(dynamic question, String type) {
    final questionText =
        type == 'mcq' || type == 'multi' ? question['question'] : question;

    return selectedQuestions[type]!.any((q) => q['text'] == questionText);
  }

  Future<void> _addToExam() async {
    try {
      final response = await http.patch(
        Uri.parse('$kBaseUrl/Doctor/SelectPrivousExam'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'SelectedMCQs': selectedQuestions['mcq'],
          'SelectedEssayQuestions': selectedQuestions['essay'],
          'SelectedMultiChoiceQuestions': selectedQuestions['multi'],
          'modelName': widget.modelName,
          'courseName': widget.courseName,
          'idDoctor': widget.idDoctor,
        }),
      );

      if (response.statusCode == 200) {
        _showSuccessDialog();
      } else {
        throw Exception(
            'Failed to add questions to exam: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: const Text(
            'Questions added to the exam successfully!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions for Chapter'),
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Questions for Chapter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Load Questions Button
                    Center(
                      child: ElevatedButton(
                        onPressed: _loadQuestions,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.ceruleanBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: const Text(
                          'Load Questions',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (isLoading)
                      const Center(child: CircularProgressIndicator()),

                    if (questionsLoaded && !isLoading) ...[
                      // MCQ Questions Section
                      if (mcqQuestions.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border(
                              left: BorderSide(
                                  color: Colors.blue.shade700, width: 5),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'MCQ Questions',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...mcqQuestions.map((question) =>
                                  _buildQuestion(question, 'mcq')),
                            ],
                          ),
                        ),

                      // Essay Questions Section
                      if (essayQuestions.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border(
                              left: BorderSide(
                                  color: Colors.blue.shade700, width: 5),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Essay Questions',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...essayQuestions.map(
                                  (question) => _buildEssayQuestion(question)),
                            ],
                          ),
                        ),

                      // Multi-choice Questions Section
                      if (multiChoiceQuestions.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border(
                              left: BorderSide(
                                  color: Colors.blue.shade700, width: 5),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Multi-choice Questions',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...multiChoiceQuestions.map((question) =>
                                  _buildQuestion(question, 'multi')),
                            ],
                          ),
                        ),

                      // Add to Exam Button
                      Center(
                        child: ElevatedButton(
                          onPressed: selectedQuestions['mcq']!.isNotEmpty ||
                                  selectedQuestions['essay']!.isNotEmpty ||
                                  selectedQuestions['multi']!.isNotEmpty
                              ? _addToExam
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: const Text(
                            'Add to Exam',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(dynamic question, String type) {
    // Safe check to ensure question is a Map with a 'question' field
    if (question is! Map || !question.containsKey('question')) {
      return const SizedBox
          .shrink(); // Skip this question if it's not properly formatted
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _isSelected(question, type),
                onChanged: (_) => _toggleSelection(question, type),
                activeColor: Colors.blue,
              ),
              Expanded(
                child: Text(
                  question['question'] ?? 'No question text',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (question['options'] != null && question['options'] is Map) ...[
            const SizedBox(height: 8),
            ...(question['options'] as Map).entries.map((option) {
              return Padding(
                padding: const EdgeInsets.only(left: 30, top: 4),
                child: Text(
                  '${option.key}: ${option.value}',
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildEssayQuestion(String question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _isSelected(question, 'essay'),
            onChanged: (_) => _toggleSelection(question, 'essay'),
            activeColor: Colors.blue,
          ),
          Expanded(
            child: Text(
              question,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
