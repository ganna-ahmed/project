part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final SignInModel doctor;
  final String doctorId;

  LoginSuccess({required this.doctor}) : doctorId = doctor.idDoctor;
}

final class LoginFailure extends LoginState {
  final String errMessage;
  LoginFailure({required this.errMessage});
}



// part of 'login_cubit.dart';

// @immutable
// sealed class LoginState {}

// final class LoginInitial extends LoginState {}

// final class LoginSuccess extends LoginState {
//   final SignInModel doctor;
//   LoginSuccess({required this.doctor});
// }

// final class LoginLoading extends LoginState {}

// final class LoginFailure extends LoginState {
//   final String errMessage;
//   LoginFailure({required this.errMessage});
// }







// part of 'login_cubit.dart';
// import 'package:meta/meta.dart';

// @immutable
// sealed class LoginState {}

// final class LoginInitial extends LoginState {}

// final class LoginSuccess extends LoginState {
//   final String? userId; 
//   LoginSuccess({this.userId});
// }

// final class LoginLoading extends LoginState {}

// final class LoginFailure extends LoginState {
//   String errMessage;
//   LoginFailure({required this.errMessage});
// }
