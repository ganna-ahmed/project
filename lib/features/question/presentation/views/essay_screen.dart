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
      'course': widget.courseName,
      'file': widget.fileName,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(questionData),
    );

    if (response.statusCode == 200) {
      print('🔴🔴🔴${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question added successfully!${response.body}')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            children: [
              TextField(
                controller: _essayQuestionController,
                decoration: _inputDecoration("Enter Essay Question"),
                maxLines: null,
              ),
              SizedBox(height: 20),
              _outlinedButton("Add Question", _addQuestion),
              _outlinedButton("AI Asking about Question", _askAI),
              _filledButton("Done", () {
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
