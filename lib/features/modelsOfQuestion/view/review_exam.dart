import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';

import 'make_exam.dart';

class ExamReviewApp extends StatelessWidget {
  final String idDoctor;
  final String courseName;
  final String modelName;
  final String chapterName;
  final String mode;

  const ExamReviewApp({
    super.key,
    required this.idDoctor,
    required this.courseName,
    required this.modelName,
    required this.chapterName,
    required this.mode
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Review',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFe3f2fd),
      ),
      home: ExamReviewPage(
        idDoctor: idDoctor,
        modelName: modelName,
        courseName: courseName,
        chapterName: chapterName,
        mode: mode,
      ),
    );
  }
}

class ExamReviewPage extends StatefulWidget {
  final String idDoctor;
  final String modelName;
  final String courseName;
  final String chapterName;
  final String mode;

  const ExamReviewPage({
    super.key,
    required this.idDoctor,
    required this.modelName,
    required this.courseName,
    required this.chapterName,
    required this.mode,
  });

  @override
  State<ExamReviewPage> createState() => _ExamReviewPageState();
}

class _ExamReviewPageState extends State<ExamReviewPage> {
  List<dynamic> questions = [];
  bool isLoading = true;
  final Map<int, File?> _questionImages = {};
  final Map<String, TextEditingController> _answerControllers = {};
  final Map<String, List<TextEditingController>> _optionControllers = {};
  final Map<int, String> _selectedAnswers = {};
  final Map<int, bool> _showCorrectAnswer = {};

  // Track which option is selected as correct
  final Map<String, int> _selectedOptionIndex = {};

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      final uri = Uri.parse('${kBaseUrl}/Doctor/reviewExam');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'modelName': widget.modelName}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          setState(() {
            questions = data;
            _initializeControllers();
            isLoading = false;
          });
        } else {
          _showError('You must choose at least one question');
        }
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error fetching questions: ${e.toString()}');
      setState(() => isLoading = false);
    }
  }

  void _initializeControllers() {
    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final questionKey = 'q$i';

      // Only create answer controllers for non-Multi type questions
      if (question['type'] != 'Multi') {
        _answerControllers[questionKey] = TextEditingController();
      }

      _optionControllers[questionKey] = [];

      if (question['answers'] != null) {
        for (int j = 0; j < question['answers'].length; j++) {
          _optionControllers[questionKey]!.add(
              TextEditingController(text: question['answers'][j]['value'])
          );
        }
      }

      if (question['type'] == 'Multi' && question['questions'] != null) {
        for (int j = 0; j < question['questions'].length; j++) {
          final subKey = 'q$i-s$j';
          _answerControllers[subKey] = TextEditingController();
          _optionControllers[subKey] = [];

          if (question['questions'][j]['answers'] != null) {
            for (int k = 0; k < question['questions'][j]['answers'].length; k++) {
              _optionControllers[subKey]!.add(
                  TextEditingController(text: question['questions'][j]['answers'][k]['value'])
              );
            }
          }
        }
      }
    }
  }

  Future<void> _pickImage(int questionIndex) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _questionImages[questionIndex] = File(image.path);
      });
    }
  }

  void _setCorrectAnswer(int questionIndex, String questionKey, String answer, int optionIndex) {
    _answerControllers[questionKey]?.text = answer;
    setState(() {
      _selectedAnswers[questionIndex] = answer;
      _showCorrectAnswer[questionIndex] = true;
      _selectedOptionIndex[questionKey] = optionIndex; // Store which option was selected

      // Hide notification after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showCorrectAnswer[questionIndex] = false;
          });
        }
      });
    });
  }

  void _getAIRecommendation(int questionIndex, String questionKey) {
    // Simulate AI recommendation
    final options = _optionControllers[questionKey]!;
    if (options.isNotEmpty) {
      // Just for demo, AI selects the first option
      final answer = options.first.text;
      final optionIndex = 0;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.smart_toy, color: AppColors.ceruleanBlue),
              const SizedBox(width: 10),
              const Text('AI Recommendation'),
            ],
          ),
          content: Text('I recommend the answer: "$answer"'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _setCorrectAnswer(questionIndex, questionKey, answer, optionIndex);
                Navigator.pop(context);
              },
              child: const Text('Accept'),
            ),
          ],
        ),
      );
    }
  }
  void _validateAnswers() {
    List<String> warnings = [];

    _answerControllers.forEach((key, controller) {
      if (controller.text.isEmpty) {
        final parts = key.split('-');
        if (parts.length == 1) {
          final questionIndex = int.parse(parts[0].substring(1));
          final questionType = questions[questionIndex]['type'];

          // Skip validation for Essay questions AND reading passages in Multi questions
          if (questionType != 'Essay' && questionType != 'Multi') {
            warnings.add('⚠ Question ${questionIndex + 1} needs correct answer');
          }
        } else {
          final questionIndex = int.parse(parts[0].substring(1));
          final subQuestionIndex = int.parse(parts[1].substring(1));

          // Only validate sub-questions, not the reading passage
          if (questions[questionIndex]['type'] == 'Multi' &&
              questions[questionIndex]['questions'][subQuestionIndex]['type'] != 'Essay') {
            warnings.add('⚠ Sub Question ${questionIndex + 1}.${subQuestionIndex + 1} needs correct answer');
          }
        }
      }
    });

    if (warnings.isNotEmpty) {
      _showWarning(warnings.join('\n'));
    } else {
      _showToast('✅ All answers validated successfully!');
    }
  }
  Future<void> _submitExam() async {
    try {
      final response = await http.patch(
        Uri.parse('${kBaseUrl}/Doctor/reviewExam'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'questions': _prepareExamData(),
          'modelName': widget.modelName,
          'idDoctor': widget.idDoctor,
        }),
      );

      if (response.statusCode == 200) {
        _showSuccess('Exam submitted successfully!');
        final url = '${kBaseUrl}/Doctor/DownloadArchive?id=${widget.idDoctor}&modelName=${widget.modelName}';
        launchUrl(Uri.parse(url));
      } else {
        _showError('Failed to submit exam: ${response?.reasonPhrase}');
      }
    } catch (e) {
      _showError('Error submitting exam: ${e.toString()}');
    }
  }

  Map<String, dynamic> _prepareExamData() {
    return {
      'questions': questions.asMap().map((i, q) {
        final questionKey = 'q$i';
        final questionData = {
          'type': q['type'],
          'text': q['text'] ?? q['passage'],
          'answers': _optionControllers[questionKey]?.asMap().map((index, controller) =>
              MapEntry(index.toString(), controller.text)).values.toList(),
          'correct_answer': _answerControllers[questionKey]?.text,
        };

        if (_questionImages.containsKey(i)) {
          // In real application, convert image to base64 or handle file upload
          questionData['image'] = 'image_path_${i}';
        }

        if (q['type'] == 'Multi') {
          questionData['questions'] = (q['questions'] as List).asMap().map((j, sq) {
            final subKey = 'q$i-s$j';
            return MapEntry(j, {
              'text': sq['text'],
              'answers': _optionControllers[subKey]?.asMap().map((index, controller) =>
                  MapEntry(index.toString(), controller.text)).values.toList(),
              'correct_answer': _answerControllers[subKey]?.text,
            });
          }).values.toList();
        }

        return MapEntry(i.toString(), questionData);
      }),
    };
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.ceruleanBlue,
      ),
    );
  }

  void _showWarning(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validation Warnings'),
        content: SingleChildScrollView(child: Text(message)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showToast(String message) {
    FToast().init(context).showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: AppColors.ceruleanBlue,
          ),
          child: Text(message, style: const TextStyle(color: Colors.white)),
        )
    );
  }

  void _navigateToMakeExam() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArchiveDownloadPage(
          idDoctor: widget.idDoctor,
          modelName: widget.modelName,
        ),
      ),
    );
  }
  @override
  void dispose() {
    for (var controller in _answerControllers.values) {
      controller.dispose();
    }
    for (var list in _optionControllers.values) {
      for (var controller in list) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Review'),
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),

      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ...List.generate(questions.length, (index) {
              final question = questions[index];
              final questionKey = 'q$index';

              if (question['type'] == 'MCQ') {
                return _buildMcqQuestion(question, index);
              } else if (question['type'] == 'Multi') {
                return _buildMultiQuestion(question, index);
              } else {
                return _buildEssayQuestion(question, index);
              }
            }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _validateAnswers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ceruleanBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Validate All Answers', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _navigateToMakeExam,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Make Exam', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMcqQuestion(dynamic question, int index) {
    final questionKey = 'q$index';

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          // Notification for correct answer (highlight when selected)
          if (_showCorrectAnswer[index] == true)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Text(
                'Selected correct answer: ${_selectedAnswers[index]}',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Question ${index + 1}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ceruleanBlue),
                    ),
                    const SizedBox(width: 10),
                    IconButton(

                      icon: const Icon(Icons.smart_toy, color: AppColors.ceruleanBlue),
                      onPressed: () => _getAIRecommendation(index, questionKey),
                      tooltip: 'Get AI recommendation',
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Question Text
                TextFormField(
                  controller: TextEditingController(text: question['text']),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 2,
                ),

                // Question Image (if any)
                if (_questionImages[index] != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Image.file(_questionImages[index]!, height: 150),
                  ),

                const SizedBox(height: 15),

                // Options
                ...List.generate(_optionControllers[questionKey]!.length, (i) {
                  final isSelected = _selectedOptionIndex[questionKey] == i;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4),
                              // Highlight the selected answer with green background
                              color: isSelected ? Colors.green.shade50 : Colors.white,
                            ),
                            child: TextFormField(
                              controller: _optionControllers[questionKey]![i],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                // Apply green text color to selected answer
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.green : Colors.black,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              style: TextStyle(
                                color: isSelected ? Colors.green.shade800 : Colors.black,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        // Only show the checkmark for the selected answer
                        if (isSelected)
                          const IconButton(
                            icon: Icon(Icons.check_circle, color: Colors.green),
                            onPressed: null, // No action needed when clicked on the checkmark
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.circle_outlined, color: Colors.grey),
                            onPressed: () => _setCorrectAnswer(
                                index,
                                questionKey,
                                _optionControllers[questionKey]![i].text,
                                i
                            ),
                          ),
                      ],
                    ),
                  );
                }),

                // Correct Answer Field - Now editable
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white, // Changed to white since it's now editable
                  ),
                  child: TextFormField(
                    controller: _answerControllers[questionKey],
                    decoration: const InputDecoration(
                      labelText: 'Correct Answer',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    readOnly: false, // Changed to allow editing
                  ),
                ),

                const SizedBox(height: 10),

                // Image Upload Button
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickImage(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                      ),
                      child: Text(
                        _questionImages[index] != null
                            ? 'Change Image'
                            : 'Choose File',
                        style: TextStyle(color: Colors.grey.shade800),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (_questionImages[index] == null)
                      Text('No file chosen', style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiQuestion(dynamic question, int index) {
    final questionKey = 'q$index';

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Question ${index + 1} (Multi-Part)',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ceruleanBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Reading Passage - Now just displays as text, not requiring an answer
                TextFormField(
                  controller: TextEditingController(text: question['passage']),
                  decoration: const InputDecoration(
                    labelText: 'Reading Passage (Essay)',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 4,
                  // Note: We're not tracking this with an answer controller
                ),

                // Question Image (if any)
                if (_questionImages[index] != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Image.file(_questionImages[index]!, height: 150),
                  ),

                const SizedBox(height: 15),

                // Sub-questions
                ...List.generate(question['questions'].length, (subIndex) {
                  final subQuestion = question['questions'][subIndex];
                  final subKey = 'q$index-s$subIndex';
                  final compositeIndex = index * 100 + subIndex;

                  // Skip UI for essay questions in multi-part
                  if (subQuestion['type'] == 'Essay') {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Part ${index + 1}.${subIndex + 1}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.smart_toy, color: Colors.blue),
                              onPressed: () => _getAIRecommendation(compositeIndex, subKey),
                              tooltip: 'Get AI recommendation',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Sub-question Text
                        TextFormField(
                          controller: TextEditingController(text: subQuestion['text']),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Sub-question Options
                        ...List.generate(_optionControllers[subKey]!.length, (i) {
                          final isSelected = _selectedOptionIndex[subKey] == i;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(4),
                                      // Highlight the selected answer with green background
                                      color: isSelected ? Colors.green.shade50 : Colors.white,
                                    ),
                                    child: TextFormField(
                                      controller: _optionControllers[subKey]![i],
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                        // Apply green text color to selected answer
                                        labelStyle: TextStyle(
                                          color: isSelected ? Colors.green : Colors.black,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: isSelected ? Colors.green.shade800 : Colors.black,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                                // Only show the checkmark for the selected answer
                                if (isSelected)
                                  const IconButton(
                                    icon: Icon(Icons.check_circle, color: Colors.green),
                                    onPressed: null, // No action needed when clicked on the checkmark
                                  )
                                else
                                  IconButton(
                                    icon: const Icon(Icons.circle_outlined, color: Colors.grey),
                                    onPressed: () => _setCorrectAnswer(
                                        compositeIndex,
                                        subKey,
                                        _optionControllers[subKey]![i].text,
                                        i
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),

                        // Correct Answer Field for subquestion - Now editable
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white, // Changed to white since it's now editable
                          ),
                          child: TextFormField(
                            controller: _answerControllers[subKey],
                            decoration: const InputDecoration(
                              labelText: 'Correct Answer',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            readOnly: false, // Changed to allow editing
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                }),

                // Image Upload Button
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickImage(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                      ),
                      child: Text(
                        _questionImages[index] != null
                            ? 'Change Image'
                            : 'Choose File',
                        style: TextStyle(color: Colors.grey.shade800),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (_questionImages[index] == null)
                      Text('No file chosen', style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEssayQuestion(dynamic question, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Question ${index + 1} (Essay)',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ceruleanBlue),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.smart_toy, color: Colors.lightBlue
                  ),
                  onPressed: () {},
                  tooltip: 'Get AI recommendation',
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Essay Prompt
            TextFormField(
              controller: TextEditingController(text: question['text']),
              decoration: const InputDecoration(
                labelText: 'Essay Prompt',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
            ),

            // Question Image (if any)
            if (_questionImages[index] != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Image.file(_questionImages[index]!, height: 150),
              ),

            const SizedBox(height: 10),

            // Image Upload Button
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                  ),
                  child: Text(
                    _questionImages[index] != null
                        ? 'Change Image'
                        : 'Choose File',
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ),
                const SizedBox(width: 10),
                if (_questionImages[index] == null)
                  Text('No file chosen', style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Simple placeholder for the Make Exam page
class MakeExamPage extends StatelessWidget {
  const MakeExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Exam'),
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),

          onPressed: () => Navigator.of(context).pop(),

        ),

      ),

      body: const Center(

        child: Text('Make Exam Page - To be implemented'),

      ),

    );

  }

}