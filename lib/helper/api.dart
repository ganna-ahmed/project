import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  // Future<dynamic> get({required String url, @required String? token}) async {
  //   Map<String, String> header = {};
  //   if (token != null) {
  //     header.addAll({
  //       'Authorization': 'Bearer $token',
  //     });
  //   }
  //   http.Response response = await http.get(Uri.parse(url), headers: header);

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception(
  //         'there is a problem with status code ${response.statusCode}');
  //   }
  // }
  Future<dynamic> get({required String url, String? token}) async {
    try {
      Map<String, String> headers = {};
      if (token != null) {
        headers.addAll({'Authorization': 'Bearer $token'});
      }

      final response = await http.get(Uri.parse(url), headers: headers).timeout(
            const Duration(seconds: 15), // Add timeout
            onTimeout: () => throw Exception('Connection timeout'),
          );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<dynamic> post(
      {required String url,
      @required dynamic body,
      @required String? token}) async {
    Map<String, String> header = {};
    if (token != null) {
      header.addAll({'Authorization': 'Bearer $token'});
    }
    http.Response response = await http.post(
      Uri.parse(url),
      body: body,
      headers: header,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          'there is a problem with status code ${response.statusCode}with body${response.body}');
      //throw Exception(jsonDecode(response.body));
    }
  }

  Future<dynamic> put(
      {required String url,
      @required dynamic body,
      @required String? token}) async {
    Map<String, String> header = {};
    header.addAll({
      'Content-Type': 'application/x-www-form-urlencoded',
    });
    if (token != null) {
      header.addAll({'Authorization': 'Bearer $token'});
    }
    http.Response response = await http.post(
      Uri.parse(url),
      body: body,
      headers: header,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          'there is a problem with status code ${response.statusCode}with body${response.body}');
      //throw Exception(jsonDecode(response.body));
    }
  }
}
