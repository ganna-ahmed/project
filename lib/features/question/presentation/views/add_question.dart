// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'widgets/custom_text_field.dart';

// class AddQuestionPage extends StatefulWidget {
//   const AddQuestionPage({super.key});

//   @override
//   _AddQuestionPageState createState() => _AddQuestionPageState();
// }

// class _AddQuestionPageState extends State<AddQuestionPage> {
//   final TextEditingController pdfController = TextEditingController();
//   final TextEditingController questionController = TextEditingController();
//   final List<TextEditingController> answerControllers =
//       List.generate(4, (index) => TextEditingController());
//   final TextEditingController correctAnswerController = TextEditingController();
//   int questionCount = 1;

//   void showAlert(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: color),
//     );
//   }

//   void sendData() async {
//     final questionText = questionController.text;
//     final pdfName = pdfController.text;
//     final answers =
//         answerControllers.map((controller) => controller.text).toList();
//     final correctAnswer = correctAnswerController.text;

//     if (pdfName.isNotEmpty &&
//         questionText.isNotEmpty &&
//         answers.every((answer) => answer.isNotEmpty) &&
//         correctAnswer.isNotEmpty) {
//       if (answers.toSet().length != answers.length) {
//         showAlert('Answers must be unique.', Colors.red);
//         return;
//       }
//       if (!answers.contains(correctAnswer)) {
//         showAlert('Correct answer must be one of the options.', Colors.red);
//         return;
//       }

//       try {
//         final response = await http.post(
//           Uri.parse('https://your-api-url.com/Doctor/AddQuestion'),
//           headers: {'Content-Type': 'application/json'},
//           body: json.encode({
//             'pdfName': pdfName,
//             'question': questionText,
//             'answer1': answers[0],
//             'answer2': answers[1],
//             'answer3': answers[2],
//             'answer4': answers[3],
//             'correctAnswer': correctAnswer,
//           }),
//         );

//         if (response.statusCode == 200) {
//           showAlert('Question added successfully', Colors.green);
//           setState(() {
//             questionCount++;
//             questionController.clear();
//             pdfController.clear();
//             for (var controller in answerControllers) {
//               controller.clear();
//             }
//             correctAnswerController.clear();
//           });
//         } else {
//           showAlert('Failed to add question', Colors.red);
//         }
//       } catch (error) {
//         showAlert('An error occurred while adding the question.', Colors.red);
//       }
//     } else {
//       showAlert('Please fill in all fields.', Colors.red);
//     }
//   }

//   void checkAnswer() {
//     final correctAnswer = correctAnswerController.text;
//     for (var controller in answerControllers) {
//       if (controller.text == correctAnswer) {
//         showAlert('Correct answer: ${controller.text}', Colors.green);
//         return;
//       }
//     }
//     showAlert('Correct answer is not among the options.', Colors.red);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: const [
//                 BoxShadow(color: Colors.black26, blurRadius: 10),
//               ],
//             ),
//             width: 400,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'Question $questionCount',
//                     style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.purple),
//                   ),
//                   const SizedBox(height: 10),
//                   CustomTextField(
//                       controller: pdfController, hintText: 'Enter PDF Name'),
//                   CustomTextField(
//                       controller: questionController,
//                       hintText: 'Enter The Question'),
//                   ...List.generate(
//                     4,
//                     (index) => CustomTextField(
//                         controller: answerControllers[index],
//                         hintText: 'Answer ${index + 1}'),
//                   ),
//                   CustomTextField(
//                     controller: correctAnswerController,
//                     hintText: 'Correct Answer',
//                     borderColor: Colors.green,
//                   ),
//                   const SizedBox(height: 15),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       buildButton('Finish', Colors.green, () {}),
//                       buildButton('Next', Colors.blue, sendData),
//                       buildButton('Check', Colors.red, checkAnswer),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildButton(String text, Color color, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//       child: Text(text, style: const TextStyle(color: Colors.white)),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:project/core/constants/colors.dart';
// // import 'package:project/features/question/presentation/views/widgets/input_field.dart';
// // import 'widgets/aswe_field.dart';
// // import 'widgets/custom_button.dart';

// // class AddQuestionPage extends StatelessWidget {
// //   const AddQuestionPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Padding(
// //         padding: EdgeInsets.all(16.w),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             SizedBox(height: 30.h),
// //             GestureDetector(
// //               onTap: () {
// //                 Navigator.of(context).pop();
// //               },
// //               child: Container(
// //                 padding: EdgeInsets.all(14.w),
// //                 decoration: BoxDecoration(
// //                   color: AppColors.ceruleanBlue,
// //                   borderRadius: BorderRadius.circular(24.r),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.black26,
// //                       blurRadius: 4.w,
// //                       offset: Offset(0, 2.h),
// //                     ),
// //                   ],
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     const Icon(Icons.arrow_back, color: Colors.white, size: 32),
// //                     SizedBox(width: 8.w),
// //                     Expanded(
// //                       child: Center(
// //                         child: Text(
// //                           'Question 1',
// //                           style: TextStyle(
// //                             fontSize: 28.sp,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.white,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 50.h),
// //             const InputField(hintText: 'Input the question'),
// //             SizedBox(height: 80.h),
// //             Column(
// //               children: List.generate(4, (index) {
// //                 return Column(
// //                   children: [
// //                     AnswerField(answerIndex: index + 1),
// //                     SizedBox(height: 30.h),
// //                   ],
// //                 );
// //               }),
// //             ),
// //             SizedBox(height: 40.h),
// //             MoreButton(
// //               width: 270.w,
// //               height: 55.h,
// //               fontSize: 22.sp,
// //             ),
// //             // Done Button
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
