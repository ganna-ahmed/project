import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EssayQuestionScreen extends StatefulWidget {
  @override
  _EssayQuestionScreenState createState() => _EssayQuestionScreenState();
}

class _EssayQuestionScreenState extends State<EssayQuestionScreen> {
  final TextEditingController _essayController = TextEditingController();
  String _aiResponse = '';

  Future<void> _addEssayQuestion() async {
    final url = Uri.parse('https://ed3f-197-54-213-151.ngrok-free.app/Doctor/manualQuestion');

    final Map<String, dynamic> questionData = {
      'type': 'Essay',
      'question': _essayController.text,
      'choices': [],
      'correctAnswer': '',
      'paragraph': '',
      'questions': [],
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(questionData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Essay Question Added Successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  }

  Future<void> _askAI() async {
    final url = Uri.parse('https://ed3f-197-54-213-151.ngrok-free.app/Doctor/manualQuestion');

    final Map<String, dynamic> questionData = {
      'type': 'Essay',
      'question': _essayController.text,
      'choices': [],
      'paragraph': '',
      'questions': [],
    };

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(questionData),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Essay Questions',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: TextField(
                  controller: _essayController,
                  decoration: InputDecoration(
                    hintText: 'Enter Question',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              SizedBox(height: 30),
              _customButton('Add Questions', _addEssayQuestion),
              SizedBox(height: 16),
              _customButton('AI Asking about questions', _askAI),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Done action
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                ),
                child: Text('Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              if (_aiResponse.isNotEmpty) ...[
                SizedBox(height: 20),
                Text(_aiResponse, style: TextStyle(color: Colors.green)),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _customButton(String text, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        side: BorderSide(color: Colors.blue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
      ),
    );
  }
}