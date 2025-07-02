import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/constants.dart';
import 'package:project/features/question/presentation/views/widgets/common_widgets.dart';

class MultiChoiceQuestionsScreen extends StatefulWidget {
  final String doctorId;
  final String courseName;
  final String fileName;

  const MultiChoiceQuestionsScreen({
    Key? key,
    required this.doctorId,
    required this.courseName,
    required this.fileName,
  }) : super(key: key);

  @override
  _MultiChoiceQuestionsScreenState createState() =>
      _MultiChoiceQuestionsScreenState();
}

class _MultiChoiceQuestionsScreenState extends State<MultiChoiceQuestionsScreen> {
  final TextEditingController _multiQuestionController =
  TextEditingController();
  List<Map<String, dynamic>> _multiQuestions = [];

  // Keep track of controllers for multi-questions
  final List<Map<String, TextEditingController>> _multiQuestionControllers = [];

  String _aiResponse = '';
  bool _isLoading = false;

  // Currently focused text controller for symbol insertion
  TextEditingController? _focusedController;

  final String apiUrl = '$kBaseUrl/Doctor/manualQuestion';

  @override
  void initState() {
    super.initState();
    // Initialize _focusedController with question controller by default
    _focusedController = _multiQuestionController;
  }

  // Function to insert symbol at current cursor position
  void _insertSymbolAtCursor(String symbol) {
    if (_focusedController == null) return;

    final TextEditingController controller = _focusedController!;
    final TextSelection selection = controller.selection;
    final String currentText = controller.text;

    if (selection.isValid) {
      // Insert symbol at current cursor position
      final String newText = currentText.substring(0, selection.start) +
          symbol +
          currentText.substring(selection.end);

      controller.text = newText;

      // Update cursor position to be right after the inserted symbol
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: selection.start + symbol.length),
      );
    } else {
      // If cursor position is not valid, append symbol at the end
      controller.text += symbol;
    }
  }

  void _addMultiQuestion() {
    final questionController = TextEditingController();
    final option1Controller = TextEditingController();
    final option2Controller = TextEditingController();
    final option3Controller = TextEditingController();
    final option4Controller = TextEditingController();
    final correctAnswerController = TextEditingController();

    setState(() {
      _multiQuestions.add({
        'question': '',
        'options': ['', '', '', ''],
        'correctAnswer': '',
      });

      _multiQuestionControllers.add({
        'question': questionController,
        'option1': option1Controller,
        'option2': option2Controller,
        'option3': option3Controller,
        'option4': option4Controller,
        'correctAnswer': correctAnswerController,
      });
    });
  }

  Future<void> _addQuestion() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final Map<String, dynamic> questionData = {
        'type': 'Multi-Choice',
        'question': '', // Not used for Multi-Choice
        'choices': [], // Not used for Multi-Choice
        'correctAnswer': '', // Not used for Multi-Choice
        'courseName': widget.courseName,
        'idDoctor': widget.doctorId,
        'file': widget.fileName,
        'paragraph': _multiQuestionController.text,
        'questions': _multiQuestions
            .map((q) => {
          'question': q['question'],
          'choices': q['options'],
          'correctAnswer': q['correctAnswer'],
        })
            .toList(),
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(questionData),
      );

      if (response.statusCode == 200) {
        print('🔴🔴🚀🚀🚀${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question Added Successfully!')),
        );
        _clearMultiChoiceFields();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error🚀🚀🚀: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _askAI() async {
    if (_multiQuestionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a paragraph first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _aiResponse = '';
    });

    try {
      final Map<String, dynamic> questionData = {
        'type': 'Multi-Choice',
        'question': '', // Not used for Multi-Choice
        'choices': [], // Not used for Multi-Choice
        'paragraph': _multiQuestionController.text,
        'questions': _multiQuestions
            .map((q) => {
          'question': q['question'],
          'choices': q['options'],
        })
            .toList(),
      };

      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(questionData),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print('🚀🚀🚀🚀🚀${response.body}');
        setState(() {
          _aiResponse = result['message'] ?? 'AI response received';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearMultiChoiceFields() {
    _multiQuestionController.clear();
    setState(() {
      _multiQuestions = [];
      _multiQuestionControllers.clear();
      _aiResponse = '';
    });
  }

  Widget _buildMultiQuestionItem(Map<String, dynamic> question, int index,
      {Map<String, TextEditingController>? controllers}) {
    final colorScheme = Theme.of(context).colorScheme;
    // Use provided controllers or create new ones
    final questionController = controllers != null
        ? controllers['question']!
        : TextEditingController(text: question['question']);
    final option1Controller = controllers != null
        ? controllers['option1']!
        : TextEditingController(text: question['options'][0]);
    final option2Controller = controllers != null
        ? controllers['option2']!
        : TextEditingController(text: question['options'][1]);
    final option3Controller = controllers != null
        ? controllers['option3']!
        : TextEditingController(text: question['options'][2]);
    final option4Controller = controllers != null
        ? controllers['option4']!
        : TextEditingController(text: question['options'][3]);
    final correctAnswerController = controllers != null
        ? controllers['correctAnswer']!
        : TextEditingController(text: question['correctAnswer']);

    // Set up listeners to update the data when text changes
    questionController.addListener(() {
      question['question'] = questionController.text;
    });
    option1Controller.addListener(() {
      question['options'][0] = option1Controller.text;
    });
    option2Controller.addListener(() {
      question['options'][1] = option2Controller.text;
    });
    option3Controller.addListener(() {
      question['options'][2] = option3Controller.text;
    });
    option4Controller.addListener(() {
      question['options'][3] = option4Controller.text;
    });
    correctAnswerController.addListener(() {
      question['correctAnswer'] = correctAnswerController.text;
    });

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sub-Question ${index + 1}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _multiQuestions.removeAt(index);
                      if (_multiQuestionControllers.length > index) {
                        _multiQuestionControllers.removeAt(index);
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            buildTextField(questionController, "Enter sub-question", onTap: () {
              setState(() {
                _focusedController = questionController;
              });
            }),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: buildTextField(option1Controller, "Answer 1", onTap: () {
                    setState(() {
                      _focusedController = option1Controller;
                    });
                  }),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildTextField(option2Controller, "Answer 2", onTap: () {
                    setState(() {
                      _focusedController = option2Controller;
                    });
                  }),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: buildTextField(option3Controller, "Answer 3", onTap: () {
                    setState(() {
                      _focusedController = option3Controller;
                    });
                  }),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildTextField(option4Controller, "Answer 4", onTap: () {
                    setState(() {
                      _focusedController = option4Controller;
                    });
                  }),
                ),
              ],
            ),
            const SizedBox(height: 10),
            buildTextField(correctAnswerController, "Correct Answer", onTap: () {
              setState(() {
                _focusedController = correctAnswerController;
              });
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004aad),
        title: const Text("Add Multi-Choice Questions",
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Multi Choice Question",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

              // Math Symbols Section
              MathSymbolsDropdown(
                onSymbolSelected: _insertSymbolAtCursor,
              ),
              const SizedBox(height: 12),

              buildTextField(_multiQuestionController, "Enter paragraph",
                  maxLines: 5, minLines: 3, onTap: () {
                    setState(() {
                      _focusedController = _multiQuestionController;
                    });
                  }),
              const SizedBox(height: 16),
              if (_multiQuestions.isEmpty) ...[
                Center(
                  child: Text(
                    "Add sub-questions by clicking the button below",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],

              // Map through multi-questions with access to controllers
              ..._multiQuestions.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                return _buildMultiQuestionItem(question, index,
                    controllers: _multiQuestionControllers.length > index
                        ? _multiQuestionControllers[index]
                        : null);
              }).toList(),

              const SizedBox(height: 12),
              outlinedButton("Add Sub-Question", _addMultiQuestion,
                  isLoading: _isLoading),
              const SizedBox(height: 8),
              outlinedButton("Add Question", _addQuestion,
                  isLoading: _isLoading),
              outlinedButton("AI Asking about Question", _askAI,
                  isLoading: _isLoading),
              filledButton("Done", () {
                Navigator.pop(context);
              }, isLoading: _isLoading),
              if (_aiResponse.isNotEmpty) ...[
                const SizedBox(height: 20),
                aiResponseSection(_aiResponse),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:project/constants.dart';

// class MultiChoiceQuestionsScreen extends StatefulWidget {
//   final String courseName;
//   final String fileName;
//   final String doctorId;

//   const MultiChoiceQuestionsScreen({
//     super.key,
//     required this.courseName,
//     required this.fileName,
//     required this.doctorId,
//   });

//   @override
//   _MultiChoiceQuestionsScreenState createState() =>
//       _MultiChoiceQuestionsScreenState();
// }

// class _MultiChoiceQuestionsScreenState
//     extends State<MultiChoiceQuestionsScreen> {
//   final TextEditingController _paragraphController = TextEditingController();
//   List<Map<String, dynamic>> _subQuestions = [];
//   String _aiResponse = '';

//   void _addSubQuestion() {
//     setState(() {
//       _subQuestions.add({
//         'question': '',
//         'options': ['', '', '', ''],
//         'correctAnswer': '',
//       });
//     });
//   }

//   Future<void> _submitQuestion() async {
//     final url = Uri.parse('$kBaseUrl/Doctor/manualQuestion');

//     print('🔴🔴🔴🔴🔴🔴🔴🔴🔴${widget.doctorId}');
//     final body = {
//       'type': 'Multi-Choice',
//       'paragraph': _paragraphController.text,
//       'idDoctor': widget.doctorId,
//       'courseName': widget.courseName,
//       'file': widget.fileName,
//       'questions': _subQuestions.map((q) {
//         return {
//           'question': q['question'],
//           'choices': q['options'],
//           'correctAnswer': q['correctAnswer'],
//         };
//       }).toList()
//     };

//     final res = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(body),
//     );

//     if (res.statusCode == 200) {
//       print('🔴🚀🚀🚀${res.body}');
//       print('🔴🔴🔴🔴🔴🔴🔴🔴🔴${widget.courseName}');

//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('${res.body} ✅')));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Failed to add ❌: ${res.statusCode} ${res.body}')));
//     }
//   }

//   Future<void> _askAI() async {
//     final url = Uri.parse('$kBaseUrl/Doctor/manualQuestion');

//     final body = {
//       'type': 'Multi-Choice',
//       'paragraph': _paragraphController.text,
//       'idDoctor': widget.doctorId,
//       'course': widget.courseName,
//       'questions': _subQuestions.map((q) {
//         return {
//           'question': q['question'],
//           'choices': q['options'],
//         };
//       }).toList()
//     };

//     final res = await http.patch(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(body),
//     );

//     if (res.statusCode == 200) {
//       final result = json.decode(res.body);
//       setState(() {
//         _aiResponse = result['message'] ?? 'AI response done.';
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('AI request failed ❌: ${res.statusCode} ${res.body}')));
//     }
//   }

//   InputDecoration _inputDecoration(String hint) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: TextStyle(color: Colors.grey.shade400),
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(color: Colors.grey.shade300),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(color: Colors.grey.shade300),
//       ),
//     );
//   }

//   Widget _outlinedButton(String label, VoidCallback onPressed) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: OutlinedButton(
//         onPressed: onPressed,
//         style: OutlinedButton.styleFrom(
//           foregroundColor: Color(0xFF004aad),
//           side: BorderSide(color: Color(0xFF004aad), width: 1.5),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//           minimumSize: Size(double.infinity, 48),
//         ),
//         child: Text(label, style: TextStyle(fontSize: 16)),
//       ),
//     );
//   }

//   Widget _filledButton(String label, VoidCallback onPressed) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xFF004aad),
//           foregroundColor: Colors.white,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//           minimumSize: Size(double.infinity, 48),
//         ),
//         child: Text(label, style: TextStyle(fontSize: 16)),
//       ),
//     );
//   }

//   Widget _buildSubQuestion(Map<String, dynamic> question, int index) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           TextField(
//             decoration: _inputDecoration('Enter sub-question'),
//             onChanged: (val) => question['question'] = val,
//           ),
//           SizedBox(height: 8),
//           for (int i = 0; i < 4; i++) ...[
//             TextField(
//               decoration: _inputDecoration('Choice ${i + 1}'),
//               onChanged: (val) => question['options'][i] = val,
//             ),
//             SizedBox(height: 8),
//           ],
//           TextField(
//             decoration: _inputDecoration('Correct answer'),
//             onChanged: (val) => question['correctAnswer'] = val,
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Color(0xFF004aad),
//         title: Text("Multi-Choice Questions",
//             style: TextStyle(color: Colors.white)),
//         iconTheme: IconThemeData(color: Colors.white),
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _paragraphController,
//                 decoration: _inputDecoration("Enter main paragraph"),
//                 maxLines: null,
//               ),
//               SizedBox(height: 20),
//               ..._subQuestions
//                   .asMap()
//                   .entries
//                   .map((e) => _buildSubQuestion(e.value, e.key)),
//               SizedBox(height: 16),
//               _outlinedButton('Add Sub-Question', _addSubQuestion),
//               _outlinedButton('Add Questions', _submitQuestion),
//               _outlinedButton('Ask AI about questions', _askAI),
//               _filledButton('Done', () {
//                 Navigator.pop(context);
//               }),
//               if (_aiResponse.isNotEmpty) ...[
//                 SizedBox(height: 20),
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     _aiResponse,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.green[700],
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
