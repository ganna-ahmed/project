import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/constants.dart';

class EssayQuestionScreen extends StatefulWidget {
  final String doctorId;
  final String courseName;
  final String fileName;

  const EssayQuestionScreen(
      {super.key,
        required this.doctorId,
        required this.courseName,
        required this.fileName});

  @override
  _EssayQuestionScreenState createState() => _EssayQuestionScreenState();
}

class _EssayQuestionScreenState extends State<EssayQuestionScreen> {
  final TextEditingController _essayQuestionController =
  TextEditingController();
  String _aiResponse = '';

  final String apiUrl = '$kBaseUrl/Doctor/manualQuestion';

  Future<void> _addQuestion() async {
    final Uri url = Uri.parse(apiUrl);
    final Map<String, dynamic> questionData = {
      'type': 'Essay',
      'question': _essayQuestionController.text,
      'choices': [],
      'correctAnswer': '',
      'paragraph': '',
      'questions': [],
      'idDoctor': widget.doctorId,
      'courseName': widget.courseName,
      'file': widget.fileName,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(questionData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  }

  Future<void> _askAI() async {
    final Uri url = Uri.parse(apiUrl);
    final Map<String, dynamic> questionData = {
      'type': 'Essay',
      'question': _essayQuestionController.text,
      'choices': [],
      'correctAnswer': '',
      'paragraph': '',
      'questions': [],
      'courseName': widget.courseName,
      'idDoctor': widget.doctorId,
      'file': widget.fileName,
    };

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(questionData),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        _aiResponse = result['message'] ?? 'No message from AI';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  }

  // دالة لإدراج الرمز في موضع المؤشر الحالي
  void _insertSymbolAtCursor(String symbol) {
    final TextEditingController controller = _essayQuestionController;
    final TextSelection selection = controller.selection;
    final String currentText = controller.text;

    if (selection.isValid) {
      // إدراج الرمز في موضع المؤشر الحالي
      final String newText = currentText.substring(0, selection.start) +
          symbol +
          currentText.substring(selection.end);

      controller.text = newText;

      // تحديث موضع المؤشر ليكون بعد الرمز المدرج مباشرة
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: selection.start + symbol.length),
      );
    } else {
      // إذا لم يكن المؤشر في موضع صالح، أضف الرمز في النهاية
      controller.text += symbol;
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        borderSide: BorderSide(color: Color(0xFF004aad), width: 2),
      ),
    );
  }

  Widget _outlinedButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFF004aad),
          side: BorderSide(color: Color(0xFF004aad), width: 1.5),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          minimumSize: Size(double.infinity, 48),
        ),
        child: Text(label, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _filledButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF004aad),
          foregroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          minimumSize: Size(double.infinity, 48),
        ),
        child: Text(label, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildAIResponseSection() {
    if (_aiResponse.isEmpty) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(16),
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
              Icon(
                Icons.smart_toy_outlined,
                color: Colors.green,
              ),
              SizedBox(width: 8),
              Text(
                "AI Response:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            _aiResponse,
            style: TextStyle(color: Colors.green.shade800),
          ),
        ],
      ),
    );
  }

  // Math Symbols Widget
  Widget _buildMathSymbolsWidget() {
    return MathSymbolsDropdown(
      onSymbolSelected: _insertSymbolAtCursor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Color(0xFF004aad),
        title: Text("Essay Questions", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Essay Question",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004aad),
                ),
              ),
              SizedBox(height: 16),

              // Math Symbols Section
              _buildMathSymbolsWidget(),
              SizedBox(height: 12),

              TextField(
                controller: _essayQuestionController,
                decoration:
                _inputDecoration("Enter your essay question here..."),
                maxLines: 5,
                minLines: 3,
              ),
              SizedBox(height: 24),

              _outlinedButton("Add Question", _addQuestion),
              _outlinedButton("Ask AI for Help", _askAI),
              _filledButton("Done", () {
                Navigator.pop(context);
              }),

              // AI Response section
              _buildAIResponseSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// Improved Math Symbols Dropdown with clear English category names
class MathSymbolsDropdown extends StatefulWidget {
  final Function(String) onSymbolSelected;

  const MathSymbolsDropdown({
    Key? key,
    required this.onSymbolSelected,
  }) : super(key: key);

  @override
  _MathSymbolsDropdownState createState() => _MathSymbolsDropdownState();
}

class _MathSymbolsDropdownState extends State<MathSymbolsDropdown> {
  bool _isExpanded = false;
  int _selectedCategoryIndex = 0;

  final List<Map<String, List<String>>> _symbolCategories = [
    {
      'Basic Math': ['+', '-', '×', '÷', '=', '±', '≠', '≈', '∞', '%'],
    },
    {
      'Advanced Math': ['√', '∑', '∏', '^', '²', '³', 'π', 'e', '∫', '∂'],
    },
    {
      'Trigonometry': ['sin', 'cos', 'tan', 'csc', 'sec', 'cot', 'sin⁻¹', 'cos⁻¹', 'tan⁻¹'],
    },
    {
      'Hyperbolic': ['sinh', 'cosh', 'tanh', 'csch', 'sech', 'coth'],
    },
    {
      'Logarithms': ['log', 'ln', 'log₂', 'log₁₀', 'lg'],
    },
    {
      'Relations': ['<', '>', '≤', '≥', '∈', '∉', '⊂', '⊆', '∪', '∩'],
    },
    {
      'Greek Letters': ['α', 'β', 'γ', 'δ', 'θ', 'λ', 'μ', 'σ', 'φ', 'ω'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
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
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF004aad).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF004aad),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.functions,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Insert Math Symbols",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004aad),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF004aad).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: const Color(0xFF004aad),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          if (_isExpanded) ...[
            const Divider(height: 1, color: Colors.grey),

            // Category tabs
            Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _symbolCategories.asMap().entries.map((entry) {
                    final index = entry.key;
                    final categoryName = entry.value.keys.first;
                    final isSelected = _selectedCategoryIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF004aad) : Colors.grey[50],
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF004aad) : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: const Color(0xFF004aad).withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ] : null,
                        ),
                        child: Text(
                          categoryName,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF004aad),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Symbols grid
            Container(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _symbolCategories[_selectedCategoryIndex]
                    .values
                    .first
                    .map((symbol) => _buildSymbolButton(symbol))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSymbolButton(String symbol) {
    return InkWell(
      onTap: () {
        widget.onSymbolSelected(symbol);
      },
      child: Container(
        width: 45,
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          symbol,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF004aad),
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

// class EssayQuestionScreen extends StatefulWidget {
//   final String doctorId;
//   final String courseName;
//   final String fileName;

//   const EssayQuestionScreen(
//       {super.key,
//       required this.doctorId,
//       required this.courseName,
//       required this.fileName});
//   @override
//   _EssayQuestionScreenState createState() => _EssayQuestionScreenState();
// }

// class _EssayQuestionScreenState extends State<EssayQuestionScreen> {
//   final TextEditingController _essayQuestionController =
//       TextEditingController();
//   String _aiResponse = '';

//   final String apiUrl = '$kBaseUrl/Doctor/manualQuestion';

//   Future<void> _addQuestion() async {
//     final Uri url = Uri.parse(apiUrl);
//     final Map<String, dynamic> questionData = {
//       'type': 'Essay',
//       'question': _essayQuestionController.text,
//       'choices': [],
//       'correctAnswer': '',
//       'paragraph': '',
//       'questions': [],
//       'idDoctor': widget.doctorId,
//       'courseName': widget.courseName,
//       'file': widget.fileName,
//     };

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(questionData),
//     );

//     if (response.statusCode == 200) {
//       print('🔴🔴🔴🔴🔴🔴🔴🔴🔴${widget.courseName}');
//       print('🔴🔴🔴🔴🔴🔴🔴🔴🔴${widget.fileName}');
//       print('🔴🔴🔴🔴🔴🔴🔴🔴🔴${widget.doctorId}');
//       print('🔴🔴🔴${response.body}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Question added successfully!${response.body}')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${response.body}')),
//       );
//     }
//   }

//   Future<void> _askAI() async {
//     final Uri url = Uri.parse(apiUrl);
//     final Map<String, dynamic> questionData = {
//       'type': 'Essay',
//       'question': _essayQuestionController.text,
//       'choices': [],
//       'correctAnswer': '',
//       'paragraph': '',
//       'questions': [],
//       'courseName': widget.courseName,
//       'idDoctor': widget.doctorId,
//       'file': widget.fileName,
//     };

//     final response = await http.patch(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(questionData),
//     );

//     if (response.statusCode == 200) {
//       final result = json.decode(response.body);
//       setState(() {
//         _aiResponse = result['message'] ?? 'No message from AI';
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${response.body}')),
//       );
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Color(0xFF004aad),
//         title: Text("Essay Questions", style: TextStyle(color: Colors.white)),
//         iconTheme: IconThemeData(color: Colors.white),
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _essayQuestionController,
//                 decoration: _inputDecoration("Enter Essay Question"),
//                 maxLines: null,
//               ),
//               SizedBox(height: 20),
//               _outlinedButton("Add Question", _addQuestion),
//               _outlinedButton("AI Asking about Question", _askAI),
//               _filledButton("Done", () {
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
