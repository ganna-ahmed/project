import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project/constants.dart';
import 'package:project/features/auth/data/models/sign_in_model.dart';
import 'package:project/helper/api.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  SignInModel? _loggedInDoctor;

  // Getter لاسترجاع الطبيب المسجل
  SignInModel? get loggedInDoctor => _loggedInDoctor;

  // Getter لاسترجاع ID الطبيب مباشرة
  String? get doctorDatabaseId => _loggedInDoctor?.id;

  Future<void> loginUser({required String id, required String password}) async {
    emit(LoginLoading());

    try {
      final response = await Api().get(
        url: '$kBaseUrl/Admine/Doctor/apiAllDoctor',
      );

      if (response is! List) {
        emit(LoginFailure(errMessage: 'Invalid response format'));
        return;
      }

      // البحث عن الدكتور
      final foundDoctor = response
          .map((docData) => SignInModel.fromJson(docData))
          .where((doctor) =>
              doctor.idDoctor == id && doctor.passDoctor == password)
          .toList();

      if (foundDoctor.isNotEmpty) {
        _loggedInDoctor = foundDoctor.first;
        emit(LoginSuccess(doctor: _loggedInDoctor!));
      } else {
        emit(LoginFailure(errMessage: 'Invalid ID or password'));
      }
    } catch (e) {
      emit(LoginFailure(errMessage: 'Error: $e'));
    }
  }
}
