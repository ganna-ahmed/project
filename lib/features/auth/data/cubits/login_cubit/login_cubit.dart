import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/features/auth/data/models/sign_in_model.dart';
import 'package:project/features/user/data/models/profile_model.dart';
import 'package:project/helper/api.dart';

part 'login_state.dart';

// class LoginCubit extends Cubit<LoginState> {
//   LoginCubit() : super(LoginInitial());

//   Doctor? loggedInDoctor; // لتخزين بيانات الطبيب المسجل

//   Future<void> loginUser({required String id, required String password}) async {
//     emit(LoginLoading());

//     try {
//       var response = await Api().get(
//         url:
//             'https://4882-156-210-92-118.ngrok-free.app/Admine/Doctor/apiAllDoctor',
//       );

//       List<dynamic> data = response;
//       print(data);

//       Doctor? foundDoctor;

//       for (var docData in data) {
//         if (docData['IdDoctor'] == id && docData['passDoctor'] == password) {
//           foundDoctor = Doctor.fromJson(docData);
//           break;
//         }
//       }

//       if (foundDoctor != null) {
//         loggedInDoctor = foundDoctor;
//         emit(LoginSuccess(doctor: foundDoctor));
//       } else {
//         emit(LoginFailure(errMessage: 'Invalid ID or password'));
//       }
//     } catch (e) {
//       emit(LoginFailure(errMessage: 'Error: $e'));
//     }
//   }
// }

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  SignInModel? _loggedInDoctor;

  // Getter لاسترجاع الطبيب المسجل
  SignInModel? get loggedInDoctor => _loggedInDoctor;

  // Getter لاسترجاع _id مباشرة
  String? get doctorDatabaseId => _loggedInDoctor?.id;

  Future<void> loginUser({required String id, required String password}) async {
    emit(LoginLoading());

    try {
      final response = await Api().get(
        url:
            'https://bf40-2c0f-fc88-5-10ae-f4f8-1ba7-f2db-11b6.ngrok-free.app/Admine/Doctor/apiAllDoctor',
      );

      if (response is! List) {
        emit(LoginFailure(errMessage: 'Invalid response format'));
        return;
      }

      // البحث عن الطبيب باستخدام firstWhere مع شرط افتراضي
      SignInModel? foundDoctor;
      try {
        foundDoctor = (response as List)
            .map((docData) => SignInModel.fromJson(docData))
            .firstWhere(
                (doctor) =>
                    doctor.idDoctor == id &&
                    doctor.passDoctor ==
                        password, // تأكد أن لديك password في SignInModel
                orElse: () => throw Exception('Invalid ID or password'));
      } catch (_) {
        emit(LoginFailure(errMessage: 'Invalid ID or password'));
        return;
      }

      _loggedInDoctor = foundDoctor;
      emit(LoginSuccess(doctor: foundDoctor));
    } catch (e) {
      emit(LoginFailure(errMessage: 'Error: $e'));
    }
  }
}
