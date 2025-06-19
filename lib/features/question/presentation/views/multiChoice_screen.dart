import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/constants.dart';
// Import the new component

class MultiChoiceQuestionsScreen extends StatefulWidget {
  final String courseName;
  final String fileName;
  final String doctorId;

  const MultiChoiceQuestionsScreen({
    super.key,
    required this.courseName,
    required this.fileName,
    required this.doctorId,
  });

  @override
  _MultiChoiceQuestionsScreenState createState() =>
      _MultiChoiceQuestionsScreenState();
}

class _MultiChoiceQuestionsScreenState
    extends State<MultiChoiceQuestionsScreen> {
  final TextEditingController _paragraphController = TextEditingController();
  List<Map<String, dynamic>> _subQuestions = [];
  String _aiResponse = '';
  bool _isLoading = false;

  // Controller for active input
  TextEditingController? _activeController;

  @override
  void initState() {
    super.initState();
    _activeController = _paragraphController;
  }

  void _addSubQuestion() {
    setState(() {
      _subQuestions.add({
        'question': '',
        'options': ['', '', '', ''],
        'correctAnswer': '',
        'controller': TextEditingController(),
        'optionControllers': List.generate(4, (_) => TextEditingController()),
        'correctAnswerController': TextEditingController(),
      });
    });
  }

  Future<void> _submitQuestion() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('$kBaseUrl/Doctor/manualQuestion');

    final body = {
      'type': 'Multi-Choice',
      'paragraph': _paragraphController.text,
      'idDoctor': widget.doctorId,
      'courseName': widget.courseName,
      'file': widget.fileName,
      'questions': _subQuestions.map((q) {
        return {
          'question': q['controller']?.text ?? q['question'],
          'choices': List.generate(
              4, (i) => q['optionControllers']?[i]?.text ?? q['options'][i]),
          'correctAnswer':
              q['correctAnswerController']?.text ?? q['correctAnswer'],
        };
      }).toList()
    };

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Questions added successfully ✅'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add questions ❌: ${res.statusCode}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Network error: $e'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _askAI() async {
    if (_paragraphController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a paragraph first')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('$kBaseUrl/Doctor/manualQuestion');

    final body = {
      'type': 'Multi-Choice',
      'paragraph': _paragraphController.text,
      'idDoctor': widget.doctorId,
      'course': widget.courseName,
      'questions': _subQuestions.map((q) {
        return {
          'question': q['controller']?.text ?? q['question'],
          'choices': List.generate(
              4, (i) => q['optionControllers']?[i]?.text ?? q['options'][i]),
        };
      }).toList()
    };

    try {
      final res = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (res.statusCode == 200) {
        final result = json.decode(res.body);
        setState(() {
          _aiResponse =
              result['message'] ?? 'AI response received successfully.';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('AI request failed ❌: ${res.statusCode}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Network error: $e'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _insertSymbolAtCursor(String symbol) {
    if (_activeController == null) return;

    final currentText = _activeController!.text;
    final selection = _activeController!.selection;

    if (selection.isValid) {
      final newText = currentText.substring(0, selection.start) +
          symbol +
          currentText.substring(selection.end);

      _activeController!.text = newText;

      // Update cursor position
      _activeController!.selection = TextSelection.fromPosition(
        TextPosition(offset: selection.start + symbol.length),
      );
    } else {
      // If no valid selection, add at the end
      _activeController!.text += symbol;
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF004aad), width: 2),
      ),
    );
  }

  Widget _outlinedButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: OutlinedButton(
        onPressed: _isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF004aad),
          side: const BorderSide(color: Color(0xFF004aad), width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          minimumSize: const Size(double.infinity, 48),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF004aad),
                ),
              )
            : Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _filledButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF004aad),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          minimumSize: const Size(double.infinity, 48),
          disabledBackgroundColor: Colors.grey,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildSubQuestion(Map<String, dynamic> question, int index) {
    // Create controllers if they don't exist
    if (question['controller'] == null) {
      question['controller'] =
          TextEditingController(text: question['question']);
    }

    if (question['optionControllers'] == null) {
      question['optionControllers'] = List.generate(
          4, (i) => TextEditingController(text: question['options'][i]));
    }

    if (question['correctAnswerController'] == null) {
      question['correctAnswerController'] =
          TextEditingController(text: question['correctAnswer']);
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sub-Question ${index + 1}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004aad),
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _subQuestions.removeAt(index);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Question field
            TextField(
              controller: question['controller'],
              decoration: _inputDecoration('Enter sub-question'),
              maxLines: 2,
              minLines: 1,
              onTap: () {
                setState(() {
                  _activeController = question['controller'];
                });
              },
              onChanged: (val) => question['question'] = val,
            ),
            const SizedBox(height: 12),
            // Option fields
            for (int i = 0; i < 4; i++) ...[
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF004aad),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      String.fromCharCode(65 + i), // A, B, C, D
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: question['optionControllers'][i],
                      decoration: _inputDecoration('Option ${i + 1}'),
                      onTap: () {
                        setState(() {
                          _activeController = question['optionControllers'][i];
                        });
                      },
                      onChanged: (val) => question['options'][i] = val,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
            // Correct answer field
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: question['correctAnswerController'],
                    decoration: _inputDecoration('Correct answer'),
                    onTap: () {
                      setState(() {
                        _activeController = question['correctAnswerController'];
                      });
                    },
                    onChanged: (val) => question['correctAnswer'] = val,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIResponseSection() {
    if (_aiResponse.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.smart_toy_outlined,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              const Text(
                "AI Response:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _aiResponse,
            style: TextStyle(color: Colors.green.shade800),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF004aad),
        title: const Text("Multi-Choice Questions",
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Main Paragraph",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004aad),
                ),
              ),
              const SizedBox(height: 12),

              // Paragraph field
              TextField(
                controller: _paragraphController,
                decoration:
                    _inputDecoration("Enter the paragraph for your questions"),
                maxLines: 5,
                minLines: 3,
                onTap: () {
                  setState(() {
                    _activeController = _paragraphController;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Enhanced Math Symbols Dropdown
              EnhancedMathSymbolsDropdown(
                onSelected: (symbol) {
                  _insertSymbolAtCursor(symbol);
                },
                primaryColor: const Color(0xFF004aad),
                title: "Insert Math Symbols",
              ),

              const SizedBox(height: 16),
              // Divider with label
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Sub Questions",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),

              // Sub questions
              ..._subQuestions
                  .asMap()
                  .entries
                  .map((e) => _buildSubQuestion(e.value, e.key)),

              // Empty state for no sub questions
              if (_subQuestions.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.question_answer_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No sub-questions added yet",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Click 'Add Sub-Question' to get started",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),
              _outlinedButton('Add Sub-Question', _addSubQuestion),
              _outlinedButton('Submit Questions', _submitQuestion),
              _outlinedButton('Ask AI for Help', _askAI),
              _filledButton('Done', () {
                Navigator.pop(context);
              }),

              // AI Response section
              _buildAIResponseSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class EnhancedMathSymbolsDropdown extends StatefulWidget {
  final Function(String) onSelected;
  final Color primaryColor;
  final Color backgroundColor;
  final String title;

  const EnhancedMathSymbolsDropdown({
    required this.onSelected,
    this.primaryColor = const Color(0xFF004aad),
    this.backgroundColor = Colors.white,
    this.title = "Math Symbols",
    Key? key,
  }) : super(key: key);

  @override
  _EnhancedMathSymbolsDropdownState createState() =>
      _EnhancedMathSymbolsDropdownState();
}

class _EnhancedMathSymbolsDropdownState
    extends State<EnhancedMathSymbolsDropdown> {
  final List<Map<String, List<String>>> _symbolCategories = [
    {
      'Basic': ['+', '-', '×', '÷', '=', '±', '≠', '≈', '∞'],
    },
    {
      'Advanced': ['√', '∑', '∏', '^', '√x', 'π', 'e', '∫'],
    },
    {
      'Functions': ['log', 'ln', 'sin', 'cos', 'tan', 'csc', 'sec', 'cot'],
    },
    {
      'Inverse': ['asin', 'acos', 'atan', 'sinh', 'cosh', 'tanh'],
    },
  ];

  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.functions,
                  color: widget.primaryColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Category tabs
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _symbolCategories.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                final categoryName = _symbolCategories[index].keys.first;
                final isSelected = _selectedCategoryIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? widget.primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? widget.primaryColor
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      categoryName,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Symbols grid
          Container(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _symbolCategories[_selectedCategoryIndex]
                  .values
                  .first
                  .map((symbol) => _buildSymbolChip(symbol))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymbolChip(String symbol) {
    return InkWell(
      onTap: () {
        widget.onSelected(symbol);
      },
      child: Container(
        width: 50,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          symbol,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: widget.primaryColor,
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
