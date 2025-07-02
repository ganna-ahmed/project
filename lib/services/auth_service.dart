//
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthService {
//   static const String _isLoggedInKey = 'isLoggedIn';
//   static const String _doctorIdKey = 'doctorId';
//   static const String _doctorDatabaseIdKey = 'doctorDatabaseId';
//
//   // حفظ حالة تسجيل الدخول
//   static Future<void> saveLoginState({
//     required bool isLoggedIn,
//     String? doctorId,
//     String? doctorDatabaseId,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_isLoggedInKey, isLoggedIn);
//     if (doctorId != null) await prefs.setString(_doctorIdKey, doctorId);
//     if (doctorDatabaseId != null) await prefs.setString(_doctorDatabaseIdKey, doctorDatabaseId);
//   }
//
//   // قراءة حالة تسجيل الدخول
//   static Future<bool> isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_isLoggedInKey) ?? false;
//   }
//
//   // قراءة بيانات الدكتور
//   static Future<Map<String, String?>> getDoctorData() async {
//     final prefs = await SharedPreferences.getInstance();
//     return {
//       'doctorId': prefs.getString(_doctorIdKey),
//       'doctorDatabaseId': prefs.getString(_doctorDatabaseIdKey),
//     };
//   }
//
//   // تسجيل الخروج
//   static Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_isLoggedInKey);
//     await prefs.remove(_doctorIdKey);
//     await prefs.remove(_doctorDatabaseIdKey);
//   }
// }