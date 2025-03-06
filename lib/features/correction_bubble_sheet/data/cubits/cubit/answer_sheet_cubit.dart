// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:project/features/correction_bubble_sheet/data/cubits/cubit/answer_sheet_state.dart';
// import 'dart:io';

// import 'package:project/features/correction_bubble_sheet/data/repos/answer_sheet_repo.dart';

// class AnswerSheetCubit extends Cubit<AnswerSheetState> {
//   final AnswerSheetRepository repository;

//   AnswerSheetCubit(this.repository) : super(AnswerSheetInitial());

//   File? selectedPdfFile;
//   String? uploadedFileName;
//   bool isUploaded = false;
//   void selectPdfFile(File file) {
//     selectedPdfFile = file;
//     emit(PdfSelectedState(file));
//   }

//   Future<void> uploadAnswerSheet() async {
//     if (selectedPdfFile == null) {
//       emit(AnswerSheetFailure('No PDF file selected'));
//       return;
//     }

//     try {
//       emit(AnswerSheetLoading());
//       final result = await repository.uploadAnswerSheet(selectedPdfFile!);

//       if (result['message'] == 'Process completed successfully') {
//         uploadedFileName = result['fileName'];
//         isUploaded = true;
//         emit(AnswerSheetSuccess(uploadedFileName!));
//       } else {
//         emit(AnswerSheetFailure('An error occurred: ${result['message']}'));
//       }
//     } catch (e) {
//       emit(AnswerSheetFailure(e.toString()));
//     }
//   }

//   bool isUploadComplete() {
//     return state is AnswerSheetSuccess || isUploaded;
//   }

//   String? getUploadedFileName() {
//     return uploadedFileName;
//   }
// }

// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:equatable/equatable.dart';
// // import 'package:flutter/material.dart';
// // import 'package:project/features/correction_bubble_sheet/data/cubits/cubit/answer_sheet_state.dart';
// // import 'dart:io';
// // import 'package:project/features/correction_bubble_sheet/data/repos/answer_sheet_repo.dart';

// // class AnswerSheetCubit extends Cubit {
// //   final AnswerSheetRepository repository;
  
// //   AnswerSheetCubit(this.repository) : super(AnswerSheetInitial());
  
// //   File? selectedPdfFile;
// //   String? uploadedFileName;
// //   bool isUploaded = false; // متغير جديد لتتبع حالة التحميل
  
// //   void selectPdfFile(File file) {
// //     selectedPdfFile = file;
// //     emit(PdfSelectedState(file));
// //   }
  
// //   Future<void> uploadAnswerSheet() async {
// //     if (selectedPdfFile == null) {
// //       emit(AnswerSheetFailure('No PDF file selected'));
// //       return;
// //     }
    
// //     try {
// //       emit(AnswerSheetLoading());
// //       final result = await repository.uploadAnswerSheet(selectedPdfFile!);
      
// //       if (result['message'] == 'Process completed successfully') {
// //         uploadedFileName = result['fileName'];
// //         isUploaded = true; // تحديث حالة التحميل عند النجاح
// //         emit(AnswerSheetSuccess(uploadedFileName!));
// //       } else {
// //         emit(AnswerSheetFailure('An error occurred: ${result['message']}'));
// //       }
// //     } catch (e) {
// //       emit(AnswerSheetFailure(e.toString()));
// //     }
// //   }
  
// //   bool isUploadComplete() {
// //     return state is AnswerSheetSuccess || isUploaded;
// //   }
  
// //   String? getUploadedFileName() {
// //     return uploadedFileName;
// //   }
// // }