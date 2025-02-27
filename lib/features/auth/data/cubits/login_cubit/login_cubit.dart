import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/features/user/data/models/profile_model.dart';
import 'package:project/helper/api.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Doctor? loggedInDoctor; // لتخزين بيانات الطبيب المسجل

  Future<void> loginUser({required String id, required String password}) async {
    emit(LoginLoading());

    try {
      var response = await Api().get(
        url:
            'https://ac65-2a09-bac5-d57b-1eb-00-31-111.ngrok-free.app/Admine/Doctor/apiAllDoctor',
      );

      List<dynamic> data = response;
      print(data);

      Doctor? foundDoctor;

      for (var docData in data) {
        if (docData['IdDoctor'] == id && docData['passDoctor'] == password) {
          foundDoctor = Doctor.fromJson(docData);
          break;
        }
      }

      if (foundDoctor != null) {
        loggedInDoctor = foundDoctor;
        emit(LoginSuccess(doctor: foundDoctor));
      } else {
        emit(LoginFailure(errMessage: 'Invalid ID or password'));
      }
    } catch (e) {
      emit(LoginFailure(errMessage: 'Error: $e'));
    }
  }
}
