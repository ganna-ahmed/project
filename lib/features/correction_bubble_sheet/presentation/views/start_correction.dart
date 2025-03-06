// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:go_router/go_router.dart';
// import 'package:project/core/constants/colors.dart';
// import 'package:project/core/utils/app_router.dart';

// class StartCorrectScreen extends StatefulWidget {
//   @override
//   _StartCorrectScreenState createState() => _StartCorrectScreenState();
// }

// class _StartCorrectScreenState extends State<StartCorrectScreen> {
//   String? fileName; // لاستقبال اسم الملف من الصفحة السابقة
//   double progress = 0.0;
//   bool isLoading = true;
//   bool showProgressBar = false;
//   bool showCorrectionButton = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // استرجاع fileName من extra عند تحميل الصفحة
//     final extra = GoRouterState.of(context).extra;
//     if (extra is Map<String, dynamic> &&
//         extra.containsKey('BubbleSheetStudent')) {
//       setState(() {
//         fileName = extra['BubbleSheetStudent'] as String?;
//       });
//     } else if (extra is String) {
//       setState(() {
//         fileName = extra;
//       });
//     } else {
//       Fluttertoast.showToast(msg: 'No file data received!');
//     }
//     if (fileName != null) {
//       startCorrection();
//     }
//   }

//   Future<void> startCorrection() async {
//     if (fileName == null) return;

//     final fileNameWithoutExtension = fileName!.replaceAll('.pdf', '');

//     setState(() {
//       isLoading = true;
//       showProgressBar = true;
//     });

//     // تحديث شريط التقدم
//     const updateInterval = Duration(milliseconds: 200);
//     final progressTimer = Stream.periodic(updateInterval, (count) => count)
//         .takeWhile((count) => progress < 0.9)
//         .listen((_) {
//       setState(() {
//         progress += 0.1;
//       });
//     });

//     try {
//       final response = await http.post(
//         Uri.parse(
//             'https://bf40-2c0f-fc88-5-10ae-f4f8-1ba7-f2db-11b6.ngrok-free.app/Doctor/waitedUpload'),
//         headers: {'Content-Type': 'application/json'},
//         body:
//             jsonEncode({'fileNameWithoutExtension': fileNameWithoutExtension}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body) as String?;
//         if (data == "Completed processing all pages successfully.") {
//           progressTimer.cancel();
//           setState(() {
//             progress = 1.0;
//             isLoading = false;
//             showProgressBar = false;
//             showCorrectionButton = true;
//           });
//         } else {
//           throw Exception('Processing failed: $data');
//         }
//       } else {
//         throw Exception(
//             'Failed to complete processing: ${response.statusCode}');
//       }
//     } catch (e) {
//       progressTimer.cancel();
//       setState(() {
//         isLoading = false;
//         showProgressBar = false;
//       });
//       Fluttertoast.showToast(msg: 'Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Correct Bubble Sheet",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold)),
//             Text("Processing your file...",
//                 style: TextStyle(color: Colors.white, fontSize: 14)),
//           ],
//         ),
//         backgroundColor: AppColors.ceruleanBlue,
//         elevation: 0,
//         toolbarHeight: 80,
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: screenHeight * 0.1),
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: AppColors.ceruleanBlue,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset('assets/images/upload.png',
//                           width: screenWidth * 0.3, color: Colors.white),
//                       SizedBox(height: 10),
//                       Text(
//                         'upload model answer',
//                         style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         fileName ?? "No file uploaded",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                         textAlign: TextAlign.center,
//                       ),
//                       if (showProgressBar)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: LinearProgressIndicator(
//                             value: progress,
//                             minHeight: 10,
//                             backgroundColor: Colors.white30,
//                             valueColor:
//                                 AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.05),
//                 if (showCorrectionButton)
//                   ElevatedButton(
//                     onPressed: () {
//                       if (fileName != null) {
//                         Navigator.pushNamed(
//                           context,
//                           '/successCorrectModelAnswer',
//                           arguments: {
//                             'id':
//                                 'someIdDoctor', // استبدل بمعرف ديناميكي إذا كان موجودًا
//                             'AnswerBubbleSheet': fileName,
//                           },
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.ceruleanBlue,
//                       padding: EdgeInsets.symmetric(
//                         vertical: screenHeight * 0.02,
//                         horizontal: screenWidth * 0.2,
//                       ),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     child: const Text("Correction",
//                         style: TextStyle(color: Colors.white, fontSize: 18)),
//                   ),
//               ],
//             ),
//           ),
//           if (isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: Center(
//                 child: CircularProgressIndicator(color: AppColors.ceruleanBlue),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
