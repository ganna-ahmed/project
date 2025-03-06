// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:io';

// // States
// abstract class AnswerSheetState extends Equatable {
//   const AnswerSheetState();

//   @override
//   List<Object?> get props => [];
// }

// class AnswerSheetInitial extends AnswerSheetState {}

// class AnswerSheetLoading extends AnswerSheetState {}

// class AnswerSheetSuccess extends AnswerSheetState {
//   final String fileName;

//   const AnswerSheetSuccess(this.fileName);

//   @override
//   List<Object?> get props => [fileName];
// }

// class AnswerSheetFailure extends AnswerSheetState {
//   final String error;

//   const AnswerSheetFailure(this.error);

//   @override
//   List<Object?> get props => [error];
// }

// class PdfSelectedState extends AnswerSheetState {
//   final File pdfFile;

//   const PdfSelectedState(this.pdfFile);

//   @override
//   List<Object?> get props => [pdfFile];
// }
