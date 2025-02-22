import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/features/user/data/models/profile_model.dart';

class DoctorRepository {
  final String apiUrl = 'https://98b3-2c0f-fc88-5-b4ad-595e-dcc0-953e-40f7.ngrok-free.app/Admine/Doctor/apiAllDoctor';

  Future<List<Doctor>> fetchDoctors() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Doctor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}