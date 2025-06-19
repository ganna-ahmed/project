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
              SizedBox(height: 12),
              TextField(
                controller: _essayQuestionController,
                decoration:
                    _inputDecoration("Enter your essay question here..."),
                maxLines: 5,
                minLines: 3,
              ),
              SizedBox(height: 16),

              // Enhanced Math Symbols Dropdown
              EnhancedMathSymbolsDropdown(
                onSelected: (symbol) {
                  _insertSymbolAtCursor(symbol);
                },
                primaryColor: Color(0xFF004aad),
                title: "Insert Math Symbols",
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
