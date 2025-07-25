import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/constants.dart';
import 'package:project/features/question/presentation/views/widgets/common_widgets.dart'; // استيراد الملف

class MCQScreen extends StatefulWidget {
  final String doctorId;
  final String courseName;
  final String fileName;

  MCQScreen({
    super.key,
    required this.doctorId,
    required this.courseName,
    required this.fileName,
  });

  @override
  _MCQScreenState createState() => _MCQScreenState();
}

class _MCQScreenState extends State<MCQScreen> {
  String _selectedSection = 'mcq';
  bool _isLoading = false;
  String _aiResponse = '';

  // Currently focused text controller for symbol insertion
  TextEditingController? _focusedController;

  // MCQ controllers
  final TextEditingController _mcqQuestionController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();
  final TextEditingController _correctAnswerController =
  TextEditingController();

  // Essay controllers
  final TextEditingController _essayQuestionController =
  TextEditingController();

  // Multi-Choice controllers
  final TextEditingController _multiQuestionController =
  TextEditingController();
  List<Map<String, dynamic>> _multiQuestions = [];

  // Keep track of controllers for multi-questions
  final List<Map<String, TextEditingController>> _multiQuestionControllers = [];

  final String apiUrl = '$kBaseUrl/Doctor/manualQuestion';

  @override
  void initState() {
    super.initState();
    // Initialize _focusedController with question controller by default
    _focusedController = _mcqQuestionController;
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

  void _showSection(String section) {
    setState(() {
      _selectedSection = section;
      _aiResponse = '';
    });
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

  Future<void> _addQuestion(String type) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final Map<String, dynamic> questionData = {
        'type': type,
        'question': type == 'MCQ'
            ? _mcqQuestionController.text
            : _essayQuestionController.text,
        'choices': type == 'MCQ'
            ? [
          _option1Controller.text,
          _option2Controller.text,
          _option3Controller.text,
          _option4Controller.text,
        ]
            : [],
        'correctAnswer': type == 'MCQ' ? _correctAnswerController.text : '',
        'courseName': widget.courseName,
        'idDoctor': widget.doctorId,
        'file': widget.fileName,
        'paragraph':
        type == 'Multi-Choice' ? _multiQuestionController.text : '',
        'questions': type == 'Multi-Choice'
            ? _multiQuestions
            .map((q) => {
          'question': q['question'],
          'choices': q['options'],
          'correctAnswer': q['correctAnswer'],
        })
            .toList()
            : [],
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
        if (type == 'MCQ') {
          _clearMCQFields();
        } else if (type == 'Essay') {
          _clearEssayFields();
        } else if (type == 'Multi-Choice') {
          _clearMultiChoiceFields();
        }
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

  Future<void> _askAI(String type) async {
    if ((type == 'MCQ' && _mcqQuestionController.text.isEmpty) ||
        (type == 'Essay' && _essayQuestionController.text.isEmpty) ||
        (type == 'Multi-Choice' && _multiQuestionController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a question first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _aiResponse = '';
    });

    try {
      final Map<String, dynamic> questionData = {
        'type': type,
        'question': type == 'MCQ'
            ? _mcqQuestionController.text
            : _essayQuestionController.text,
        'choices': type == 'MCQ'
            ? [
          _option1Controller.text,
          _option2Controller.text,
          _option3Controller.text,
          _option4Controller.text,
        ]
            : [],
        'paragraph':
        type == 'Multi-Choice' ? _multiQuestionController.text : '',
        'questions': type == 'Multi-Choice'
            ? _multiQuestions
            .map((q) => {
          'question': q['question'],
          'choices': q['options'],
        })
            .toList()
            : [],
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

  void _clearMCQFields() {
    _mcqQuestionController.clear();
    _option1Controller.clear();
    _option2Controller.clear();
    _option3Controller.clear();
    _option4Controller.clear();
    _correctAnswerController.clear();
    setState(() {
      _aiResponse = '';
    });
  }

  void _clearEssayFields() {
    _essayQuestionController.clear();
    setState(() {
      _aiResponse = '';
    });
  }

  void _clearMultiChoiceFields() {
    _multiQuestionController.clear();
    setState(() {
      _multiQuestions = [];
      _multiQuestionControllers.clear();
      _aiResponse = '';
    });
  }

  Widget _buildMCQSection() {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "MCQ Question",
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

        // Fields that will update _focusedController when tapped
        buildTextField(_mcqQuestionController, "Enter Question",
            maxLines: 3, minLines: 2, onTap: () {
              setState(() {
                _focusedController = _mcqQuestionController;
              });
            }),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: buildTextField(_option1Controller, "Answer 1"),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildTextField(_option2Controller, "Answer 2"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: buildTextField(_option3Controller, "Answer 3"),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildTextField(_option4Controller, "Answer 4"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        buildTextField(_correctAnswerController, "Correct Answer"),
        const SizedBox(height: 20),

        outlinedButton("Add Question", () => _addQuestion('MCQ'), isLoading: _isLoading),
        outlinedButton("AI Asking about Question", () => _askAI('MCQ'), isLoading: _isLoading),
        filledButton("Done", () {
          Navigator.pop(context);
        }, isLoading: _isLoading),
        if (_aiResponse.isNotEmpty) ...[
          const SizedBox(height: 20),
          aiResponseSection(_aiResponse),
        ],
      ],
    );
  }

  Widget _buildEssaySection() {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Essay Question",
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

        buildTextField(_essayQuestionController, "Enter essay question",
            maxLines: 4, minLines: 2, onTap: () {
              setState(() {
                _focusedController = _essayQuestionController;
              });
            }),
        const SizedBox(height: 20),
        outlinedButton("Add Question", () => _addQuestion('Essay'), isLoading: _isLoading),
        outlinedButton("AI Asking about Question", () => _askAI('Essay'), isLoading: _isLoading),
        filledButton("Done", () {
          Navigator.pop(context);
        }, isLoading: _isLoading),
        if (_aiResponse.isNotEmpty) ...[
          const SizedBox(height: 20),
          aiResponseSection(_aiResponse),
        ],
      ],
    );
  }

  Widget _buildMultiChoiceSection() {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
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
        outlinedButton("Add Sub-Question", _addMultiQuestion, isLoading: _isLoading),
        const SizedBox(height: 8),
        outlinedButton("Add Question", () => _addQuestion('Multi-Choice'), isLoading: _isLoading),
        outlinedButton(
            "AI Asking about Question", () => _askAI('Multi-Choice'), isLoading: _isLoading),
        filledButton("Done", () {
          Navigator.pop(context);
        }, isLoading: _isLoading),
        if (_aiResponse.isNotEmpty) ...[
          const SizedBox(height: 20),
          aiResponseSection(_aiResponse),
        ],
      ],
    );
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
        title:
        const Text("Add Questions", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: _selectedSection == 'mcq'
                    ? _buildMCQSection()
                    : _selectedSection == 'essay'
                    ? _buildEssaySection()
                    : _selectedSection == 'multichoice'
                    ? _buildMultiChoiceSection()
                    : const Center(
                    child: Text("Show All Questions View")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:project/constants.dart';

// class MCQScreen extends StatefulWidget {
//   final String doctorId;
//   final String courseName;
//   final String fileName;

//   MCQScreen({
//     super.key,
//     required this.doctorId,
//     required this.courseName,
//     required this.fileName,
//   });

//   @override
//   _MCQScreenState createState() => _MCQScreenState();
// }

// class _MCQScreenState extends State<MCQScreen> {
//   String _selectedSection = 'mcq';
//   bool _isLoading = false;
//   String _aiResponse = '';

//   // MCQ controllers
//   final TextEditingController _mcqQuestionController = TextEditingController();
//   final TextEditingController _option1Controller = TextEditingController();
//   final TextEditingController _option2Controller = TextEditingController();
//   final TextEditingController _option3Controller = TextEditingController();
//   final TextEditingController _option4Controller = TextEditingController();
//   final TextEditingController _correctAnswerController =
//       TextEditingController();

//   // Essay controllers
//   final TextEditingController _essayQuestionController =
//       TextEditingController();

//   // Multi-Choice controllers
//   final TextEditingController _multiQuestionController =
//       TextEditingController();
//   List<Map<String, dynamic>> _multiQuestions = [];

//   final String apiUrl = '$kBaseUrl/Doctor/manualQuestion';

//   void _showSection(String section) {
//     setState(() {
//       _selectedSection = section;
//       _aiResponse = '';
//     });
//   }

//   void _addMultiQuestion() {
//     setState(() {
//       _multiQuestions.add({
//         'question': '',
//         'options': ['', '', '', ''],
//         'correctAnswer': '',
//       });
//     });
//   }

//   Future<void> _addQuestion(String type) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final Map<String, dynamic> questionData = {
//         'type': type,
//         'question': type == 'MCQ'
//             ? _mcqQuestionController.text
//             : _essayQuestionController.text,
//         'choices': type == 'MCQ'
//             ? [
//                 _option1Controller.text,
//                 _option2Controller.text,
//                 _option3Controller.text,
//                 _option4Controller.text,
//               ]
//             : [],
//         'correctAnswer': type == 'MCQ' ? _correctAnswerController.text : '',
//         'courseName': widget.courseName,
//         'idDoctor': widget.doctorId,
//         'file': widget.fileName,
//         'paragraph':
//             type == 'Multi-Choice' ? _multiQuestionController.text : '',
//         'questions': type == 'Multi-Choice'
//             ? _multiQuestions
//                 .map((q) => {
//                       'question': q['question'],
//                       'choices': q['options'],
//                       'correctAnswer': q['correctAnswer'],
//                     })
//                 .toList()
//             : [],
//       };

//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(questionData),
//       );

//       if (response.statusCode == 200) {
//         print('🔴🔴🚀🚀🚀${response.body}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Question Added Successfully!')),
//         );
//         if (type == 'MCQ') {
//           _clearMCQFields();
//         } else if (type == 'Essay') {
//           _clearEssayFields();
//         } else if (type == 'Multi-Choice') {
//           _clearMultiChoiceFields();
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error🚀🚀🚀: ${response.body}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Network error: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _askAI(String type) async {
//     if ((type == 'MCQ' && _mcqQuestionController.text.isEmpty) ||
//         (type == 'Essay' && _essayQuestionController.text.isEmpty) ||
//         (type == 'Multi-Choice' && _multiQuestionController.text.isEmpty)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a question first')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _aiResponse = '';
//     });

//     try {
//       final Map<String, dynamic> questionData = {
//         'type': type,
//         'question': type == 'MCQ'
//             ? _mcqQuestionController.text
//             : _essayQuestionController.text,
//         'choices': type == 'MCQ'
//             ? [
//                 _option1Controller.text,
//                 _option2Controller.text,
//                 _option3Controller.text,
//                 _option4Controller.text,
//               ]
//             : [],
//         'paragraph':
//             type == 'Multi-Choice' ? _multiQuestionController.text : '',
//         'questions': type == 'Multi-Choice'
//             ? _multiQuestions
//                 .map((q) => {
//                       'question': q['question'],
//                       'choices': q['options'],
//                     })
//                 .toList()
//             : [],
//       };

//       final response = await http.patch(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(questionData),
//       );

//       if (response.statusCode == 200) {
//         final result = json.decode(response.body);
//         print('🚀🚀🚀🚀🚀${response.body}');
//         setState(() {
//           _aiResponse = result['message'] ?? 'AI response received';
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${response.body}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Network error: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _clearMCQFields() {
//     _mcqQuestionController.clear();
//     _option1Controller.clear();
//     _option2Controller.clear();
//     _option3Controller.clear();
//     _option4Controller.clear();
//     _correctAnswerController.clear();
//     setState(() {
//       _aiResponse = '';
//     });
//   }

//   void _clearEssayFields() {
//     _essayQuestionController.clear();
//     setState(() {
//       _aiResponse = '';
//     });
//   }

//   void _clearMultiChoiceFields() {
//     _multiQuestionController.clear();
//     setState(() {
//       _multiQuestions = [];
//       _aiResponse = '';
//     });
//   }

//   InputDecoration _inputDecoration(String hint) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: TextStyle(color: Colors.grey.shade400),
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
//         onPressed: _isLoading ? null : onPressed,
//         style: OutlinedButton.styleFrom(
//           foregroundColor: const Color(0xFF004aad),
//           side: const BorderSide(color: Color(0xFF004aad), width: 1.5),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//           minimumSize: const Size(double.infinity, 48),
//         ),
//         child: _isLoading
//             ? const SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Color(0xFF004aad),
//                 ),
//               )
//             : Text(label, style: const TextStyle(fontSize: 16)),
//       ),
//     );
//   }

//   Widget _filledButton(String label, VoidCallback onPressed) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: ElevatedButton(
//         onPressed: _isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF004aad),
//           foregroundColor: Colors.white,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//           minimumSize: const Size(double.infinity, 48),
//           disabledBackgroundColor: Colors.grey,
//         ),
//         child: _isLoading
//             ? const SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Colors.white,
//                 ),
//               )
//             : Text(label, style: const TextStyle(fontSize: 16)),
//       ),
//     );
//   }

//   Widget _buildSidebarButton(String text, String section) {
//     final bool isSelected = _selectedSection == section;
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: ElevatedButton(
//         onPressed: () => _showSection(section),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: isSelected ? Colors.white : const Color(0xFF004aad),
//           foregroundColor: isSelected ? const Color(0xFF004aad) : Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//             side: const BorderSide(color: Colors.white),
//           ),
//           minimumSize: const Size(double.infinity, 48),
//         ),
//         child: Text(text, style: const TextStyle(fontSize: 16)),
//       ),
//     );
//   }

//   Widget _buildAIResponseSection() {
//     if (_aiResponse.isEmpty) return const SizedBox.shrink();

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.green.shade50,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.green.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "AI Response:",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.green,
//               fontSize: 16,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _aiResponse,
//             style: TextStyle(color: Colors.green.shade800),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMCQSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "MCQ Question",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF004aad),
//           ),
//         ),
//         const SizedBox(height: 16),
//         TextField(
//           controller: _mcqQuestionController,
//           decoration: _inputDecoration("Enter Question"),
//           maxLines: 3,
//           minLines: 2,
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _option1Controller,
//                 decoration: _inputDecoration("Answer 1"),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: TextField(
//                 controller: _option2Controller,
//                 decoration: _inputDecoration("Answer 2"),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _option3Controller,
//                 decoration: _inputDecoration("Answer 3"),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: TextField(
//                 controller: _option4Controller,
//                 decoration: _inputDecoration("Answer 4"),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         TextField(
//           controller: _correctAnswerController,
//           decoration: _inputDecoration("Correct Answer"),
//         ),
//         const SizedBox(height: 20),
//         _outlinedButton("Add Question", () => _addQuestion('MCQ')),
//         _outlinedButton("AI Asking about Question", () => _askAI('MCQ')),
//         _filledButton("Done", () {
//           Navigator.pop(context);
//         }),
//         if (_aiResponse.isNotEmpty) ...[
//           const SizedBox(height: 20),
//           _buildAIResponseSection(),
//         ],
//       ],
//     );
//   }

//   Widget _buildEssaySection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Essay Question",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF004aad),
//           ),
//         ),
//         const SizedBox(height: 16),
//         TextField(
//           controller: _essayQuestionController,
//           decoration: _inputDecoration("Enter essay question"),
//           maxLines: 4,
//           minLines: 2,
//         ),
//         const SizedBox(height: 20),
//         _outlinedButton("Add Question", () => _addQuestion('Essay')),
//         _outlinedButton("AI Asking about Question", () => _askAI('Essay')),
//         _filledButton("Done", () {
//           Navigator.pop(context);
//         }),
//         if (_aiResponse.isNotEmpty) ...[
//           const SizedBox(height: 20),
//           _buildAIResponseSection(),
//         ],
//       ],
//     );
//   }

//   Widget _buildMultiChoiceSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Multi Choice Question",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF004aad),
//           ),
//         ),
//         const SizedBox(height: 16),
//         TextField(
//           controller: _multiQuestionController,
//           decoration: _inputDecoration("Enter paragraph"),
//           maxLines: 5,
//           minLines: 3,
//         ),
//         const SizedBox(height: 16),
//         if (_multiQuestions.isEmpty) ...[
//           Center(
//             child: Text(
//               "Add sub-questions by clicking the button below",
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//         ..._multiQuestions.asMap().entries.map((entry) {
//           final index = entry.key;
//           final question = entry.value;
//           return _buildMultiQuestionItem(question, index);
//         }).toList(),
//         const SizedBox(height: 12),
//         _outlinedButton("Add Sub-Question", _addMultiQuestion),
//         const SizedBox(height: 8),
//         _outlinedButton("Add Question", () => _addQuestion('Multi-Choice')),
//         _outlinedButton(
//             "AI Asking about Question", () => _askAI('Multi-Choice')),
//         _filledButton("Done", () {
//           Navigator.pop(context);
//         }),
//         if (_aiResponse.isNotEmpty) ...[
//           const SizedBox(height: 20),
//           _buildAIResponseSection(),
//         ],
//       ],
//     );
//   }

//   Widget _buildMultiQuestionItem(Map<String, dynamic> question, int index) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//         side: BorderSide(color: Colors.grey.shade300),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Sub-Question ${index + 1}",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF004aad),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () {
//                     setState(() {
//                       _multiQuestions.removeAt(index);
//                     });
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               decoration: _inputDecoration("Enter sub-question"),
//               onChanged: (value) => question['question'] = value,
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: _inputDecoration("Answer 1"),
//                     onChanged: (value) => question['options'][0] = value,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextField(
//                     decoration: _inputDecoration("Answer 2"),
//                     onChanged: (value) => question['options'][1] = value,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: _inputDecoration("Answer 3"),
//                     onChanged: (value) => question['options'][2] = value,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextField(
//                     decoration: _inputDecoration("Answer 4"),
//                     onChanged: (value) => question['options'][3] = value,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               decoration: _inputDecoration("Correct Answer"),
//               onChanged: (value) => question['correctAnswer'] = value,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF004aad),
//         title:
//             const Text("Add Questions", style: TextStyle(color: Colors.white)),
//         iconTheme: const IconThemeData(color: Colors.white),
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Sidebar
//             // Container(
//             //   width: MediaQuery.of(context).size.width * 0.25,
//             //   height: double.infinity,
//             //   color: const Color(0xFF004aad),
//             //   padding: const EdgeInsets.all(16),
//             //   child: Column(
//             //     crossAxisAlignment: CrossAxisAlignment.start,
//             //     children: [
//             //       Text(
//             //         "Course:\n${widget.courseName}",
//             //         style: const TextStyle(
//             //           fontSize: 16,
//             //           fontWeight: FontWeight.bold,
//             //           color: Colors.white,
//             //         ),
//             //       ),
//             //       const SizedBox(height: 30),
//             //       // _buildSidebarButton("MCQ", "mcq"),
//             //       // _buildSidebarButton("Essay", "essay"),
//             //       // _buildSidebarButton("Multi Choice", "multichoice"),
//             //       // const Spacer(),
//             //       // _buildSidebarButton("Show All Questions", "showall"),
//             //     ],
//             //   ),
//             // ),
//             // Main Content
//             Expanded(
//               child: SingleChildScrollView(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//                 child: _selectedSection == 'mcq'
//                     ? _buildMCQSection()
//                     : _selectedSection == 'essay'
//                         ? _buildEssaySection()
//                         : _selectedSection == 'multichoice'
//                             ? _buildMultiChoiceSection()
//                             : const Center(
//                                 child: Text("Show All Questions View")),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
