import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question_model.dart';

class QuestionRepository {
  final String apiUrl =
      "https://98b3-2c0f-fc88-5-b4ad-595e-dcc0-953e-40f7.ngrok-free.app/Doctor/AddQuestion";

  Future<bool> addQuestion(QuestionModel question) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(question.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("خطأ أثناء إرسال السؤال: $e");
    }
  }
}
