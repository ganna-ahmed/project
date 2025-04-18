import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/constants.dart';

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

  void _addSubQuestion() {
    setState(() {
      _subQuestions.add({
        'question': '',
        'options': ['', '', '', ''],
        'correctAnswer': '',
      });
    });
  }

  Future<void> _submitQuestion() async {
    final url = Uri.parse('$kBaseUrl/Doctor/manualQuestion');

    print('🔴🔴🔴🔴🔴🔴🔴🔴🔴${widget.doctorId}');
    final body = {
      'type': 'Multi-Choice',
      'paragraph': _paragraphController.text,
      'idDoctor': widget.doctorId,
      'courseName': widget.courseName,
      'file': widget.fileName,
      'questions': _subQuestions.map((q) {
        return {
          'question': q['question'],
          'choices': q['options'],
          'correctAnswer': q['correctAnswer'],
        };
      }).toList()
    };

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (res.statusCode == 200) {
      print('🔴🚀🚀🚀${res.body}');
      print('🔴🔴🔴🔴🔴🔴🔴🔴🔴${widget.courseName}');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${res.body} ✅')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add ❌: ${res.statusCode} ${res.body}')));
    }
  }

  Future<void> _askAI() async {
    final url = Uri.parse('$kBaseUrl/Doctor/manualQuestion');

    final body = {
      'type': 'Multi-Choice',
      'paragraph': _paragraphController.text,
      'idDoctor': widget.doctorId,
      'course': widget.courseName,
      'questions': _subQuestions.map((q) {
        return {
          'question': q['question'],
          'choices': q['options'],
        };
      }).toList()
    };

    final res = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (res.statusCode == 200) {
      final result = json.decode(res.body);
      setState(() {
        _aiResponse = result['message'] ?? 'AI response done.';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('AI request failed ❌: ${res.statusCode} ${res.body}')));
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

  Widget _buildSubQuestion(Map<String, dynamic> question, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextField(
            decoration: _inputDecoration('Enter sub-question'),
            onChanged: (val) => question['question'] = val,
          ),
          SizedBox(height: 8),
          for (int i = 0; i < 4; i++) ...[
            TextField(
              decoration: _inputDecoration('Choice ${i + 1}'),
              onChanged: (val) => question['options'][i] = val,
            ),
            SizedBox(height: 8),
          ],
          TextField(
            decoration: _inputDecoration('Correct answer'),
            onChanged: (val) => question['correctAnswer'] = val,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF004aad),
        title: Text("Multi-Choice Questions",
            style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              TextField(
                controller: _paragraphController,
                decoration: _inputDecoration("Enter main paragraph"),
                maxLines: null,
              ),
              SizedBox(height: 20),
              ..._subQuestions
                  .asMap()
                  .entries
                  .map((e) => _buildSubQuestion(e.value, e.key)),
              SizedBox(height: 16),
              _outlinedButton('Add Sub-Question', _addSubQuestion),
              _outlinedButton('Add Questions', _submitQuestion),
              _outlinedButton('Ask AI about questions', _askAI),
              _filledButton('Done', () {
                Navigator.pop(context);
              }),
              if (_aiResponse.isNotEmpty) ...[
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _aiResponse,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
