import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/helper/api.dart';
import 'package:project/features/auth/data/models/sign_in_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

//   Future<void> loginUser({required id, required String password}) async {
//     emit(LoginLoading());
//     final url = Uri.parse(
//         "https://4b10-2c0f-fc88-5-a18b-21f2-4b14-a0cb-16e9.ngrok-free.app/Admine/Doctor/apiAllDoctor");

//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         List<dynamic> doctors = jsonDecode(response.body);

//         for (var doctor in doctors) {
//           if (doctor['IdDoctor'] == id && doctor['passDoctor'] == password) {
//             emit(LoginSuccess());
//             //print("Successfully logged in! Doctor ID: ${doctor["IdDoctor"]}");
//             return;
//           }
//         }
//         LoginFailure(errMessage: 'Invalid ID or password');
//       }
//       // else {
//       //   print("Failed to fetch doctors data");
//       // }
//     } catch (e) {
//       emit(LoginFailure(errMessage: e.toString()));
//     }
//   }
// }

  //
  Future<void> loginUser({required String id, required String password}) async {
    emit(LoginLoading());

    try {
      var response = await Api().get(
        url: 'https://api.jsonbin.io/v3/b/67b267b1e41b4d34e4909b7d',
      );

      List<dynamic> data = response['record'];
      print(data);
      bool isAuthenticated = false;
      for (var docData in data) {
        if (docData['IdDoctor'] == id && docData['passDoctor'] == password) {
          isAuthenticated = true;
          print(docData);
          break;
        }
      }

      if (isAuthenticated) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(errMessage: 'Invalid ID or password'));
      }
    } catch (e) {
      emit(LoginFailure(errMessage: 'Error: $e'));
    }
  }
}

//   Future<void> loginUser({required String id, required String password}) async {
//     emit(LoginLoading());

//     try {
//       // Fetch data from API
//       final data = await Api().get(
//           url:
//               'https://api.jsonbin.io/v3/b/67b267b1e41b4d34e4909b7d?meta=false');

//       // Convert data to models
//       final loginData =
//           (data as List).map((item) => SignInModel.fromJson(item)).toList();

//       // Check for matching credentials
//       final matchingUser = loginData.firstWhere(
//         (user) => user.idDoctor == id && user.passDoctor == password,
//         orElse: () => throw Exception('Invalid credentials'),
//       );

//       // If we get here, we found a matching user
//       emit(LoginSuccess());
//     } catch (e) {
//       if (e.toString().contains('Invalid credentials')) {
//         emit(LoginFailure(errMessage: 'Invalid ID or password'));
//       } else {
//         emit(LoginFailure(errMessage: e.toString()));
//       }
//     }
//   }
// }
