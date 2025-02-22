part of 'question_cubit.dart';

abstract class QuestionState {
  @override
  List<Object> get props => [];
}

class QuestionInitial extends QuestionState {}

class QuestionLoading extends QuestionState {}

class QuestionSuccess extends QuestionState {}

class QuestionFailure extends QuestionState {
  final String message;

  QuestionFailure(this.message);

  @override
  List<Object> get props => [message];
}
