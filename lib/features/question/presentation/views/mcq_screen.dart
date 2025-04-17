import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MCQScreen extends StatefulWidget {
  @override
  _MCQScreenState createState() => _MCQScreenState();
}

class _MCQScreenState extends State<MCQScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();
  final TextEditingController _correctAnswerController = TextEditingController();

  String _aiResponse = '';

  final String apiUrl = 'https://ed3f-197-54-213-151.ngrok-free.app/Doctor/manualQuestion';

  Future<void> _submitQuestion() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'type': 'MCQ',
        'question': _questionController.text,
        'choices': [
          _option1Controller.text,
          _option2Controller.text,
          _option3Controller.text,
          _option4Controller.text,
        ],
        'correctAnswer': _correctAnswerController.text,
        'idDoctor': 'your_doctor_id_here',
        'course': 'your_course_name_here',
      }),
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
    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'type': 'MCQ',
        'question': _questionController.text,
        'choices': [
          _option1Controller.text,
          _option2Controller.text,
          _option3Controller.text,
          _option4Controller.text,
        ],
        'idDoctor': 'your_doctor_id_here',
        'course': 'your_course_name_here',
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        _aiResponse = result['message'];
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
        title: Text("MCQ Questions", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              TextField(
                controller: _questionController,
                decoration: _inputDecoration("Enter Question"),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _option1Controller,
                      decoration: _inputDecoration("Answer1"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _option2Controller,
                      decoration: _inputDecoration("Answer2"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _option3Controller,
                      decoration: _inputDecoration("Answer3"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _option4Controller,
                      decoration: _inputDecoration("Answer4"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              TextField(
                controller: _correctAnswerController,
                decoration: _inputDecoration("Correct Answer"),
              ),
              SizedBox(height: 20),
              _outlinedButton("Add Questions", _submitQuestion),
              _outlinedButton("AI Asking about Question", _askAI),
              _filledButton("Done", () {
                // Done action here
              }),
              if (_aiResponse.isNotEmpty) ...[
                SizedBox(height: 20),
                Text(
                  _aiResponse,
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}