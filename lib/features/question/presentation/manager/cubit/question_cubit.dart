import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/features/question/data/models/question_model.dart';
import 'package:project/features/question/data/repository/question_repository.dart';

part 'question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  final QuestionRepository repository;

  QuestionCubit(this.repository) : super(QuestionInitial());

  Future<void> addQuestion(QuestionModel question) async {
    emit(QuestionLoading());

    try {
      bool success = await repository.addQuestion(question);
      if (success) {
        emit(QuestionSuccess());
      } else {
        emit(QuestionFailure("Failed to submit the question!"));
      }
    } catch (e) {
      emit(QuestionFailure("An error occurred: $e"));
    }
  }
}
