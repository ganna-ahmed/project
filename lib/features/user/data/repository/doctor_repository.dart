import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/features/user/data/models/profile_model.dart';

class DoctorRepository {
  final String apiUrl =
      'https://ac65-2a09-bac5-d57b-1eb-00-31-111.ngrok-free.app/Admine/Doctor/apiAllDoctor';

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
