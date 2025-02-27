import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/features/user/data/repository/doctor_repository.dart';
import 'package:project/features/user/presentation/manager/cubit/doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  final DoctorRepository repository;

  DoctorCubit(this.repository) : super(DoctorInitial());

  Future<void> getDoctors() async {
    emit(DoctorLoading());
    try {
      final doctors = await repository.fetchDoctors();
      emit(DoctorLoaded(doctors));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }
}
