// import 'dart:html' as html;
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:go_router/go_router.dart';
// import 'package:project/core/constants/colors.dart';
// import 'package:project/core/utils/app_router.dart';

// class ResultStudentPage extends StatefulWidget {
//   @override
//   _ResultStudentPageState createState() => _ResultStudentPageState();
// }

// class _ResultStudentPageState extends State<ResultStudentPage> {
//   List<dynamic> tableData = [];
//   int currentPage = 1;
//   final int rowsPerPage = 10;
//   bool isLoading = true;
//   String? idDoctor;
//   String? answerBubbleSheet;
//   String? bubbleSheetStudent;
//   String? degree;
//   String? namePdf;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // استرجاع البيانات من extra
//     final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
//     if (extra != null) {
//       setState(() {
//         idDoctor = extra['id'] as String?;
//         answerBubbleSheet = extra['AnswerBubbleSheet'] as String?;
//         bubbleSheetStudent = extra['BubbleSheetStudent'] as String?;
//         degree = extra['degree'] as String?;
//         namePdf = extra['namePdf'] as String?;
//       });
//     } else {
//       Fluttertoast.showToast(msg: 'No data received!');
//       return;
//     }
//     if (answerBubbleSheet != null && bubbleSheetStudent != null && degree != null && namePdf != null) {
//       fetchResults();
//     }
//   }

//   Future<void> fetchResults() async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://7ede-2c0f-fc88-5-84ab-e067-c7fc-3e22-c978.ngrok-free.app/Doctor/ResultStudent'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'AnswerBubbleSheet': answerBubbleSheet,
//           'BubbleSheetStudent': bubbleSheetStudent,
//           'actuallyDegree': int.tryParse(degree!) ?? 0,
//           'Namepdf': namePdf,
//         }),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           tableData = jsonDecode(response.body) as List<dynamic>;
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       Fluttertoast.showToast(msg: 'Error: $e');
//     }
//   }

//   Future<void> downloadPDF() async {
//     try {
//       final response = await http.patch(
//         Uri.parse('https://7ede-2c0f-fc88-5-84ab-e067-c7fc-3e22-c978.ngrok-free.app/Doctor/ResultStudent'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'AnswerBubbleSheet': answerBubbleSheet,
//           'BubbleSheetStudent': bubbleSheetStudent,
//           'actuallyDegree': int.tryParse(degree!) ?? 0,
//           'Namepdf': namePdf,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final blob = html.Blob([response.bodyBytes]);
//         final url = html.Url.createObjectUrlFromBlob(blob);
//         final anchor = html.AnchorElement(href: url)
//           ..target = 'blank'
//           ..download = 'Bubble_Sheet_${namePdf}.pdf';
//         anchor.click();
//         html.Url.revokeObjectUrl(url);
//       } else {
//         throw Exception('Failed to generate PDF: ${response.statusCode}');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: $e');
//     }
//   }

//   List<DataRow> getCurrentPageRows() {
//     final start = (currentPage - 1) * rowsPerPage;
//     final end = start + rowsPerPage;
//     final pageData = tableData.sublist(start, end.clamp(0, tableData.length));

//     return pageData.map((row) {
//       final totalDegree = row['TotalDegree'] is int
//           ? row['TotalDegree']
//           : (row['TotalDegree'] is num ? row['TotalDegree'].toInt() : 0);
//       final avgGrade = tableData.isNotEmpty
//           ? (tableData.fold(0, (sum, row) {
//               final degreeValue = row['TotalDegree'] is int
//                   ? row['TotalDegree']
//                   : (row['TotalDegree'] is num ? row['TotalDegree'].toInt() : 0);
//               return (sum + degreeValue);
//             }) ~/ tableData.length)
//           : 0;

//       Color rowColor;
//       if (totalDegree > avgGrade) {
//         rowColor = Colors.green.shade100;
//       } else if (totalDegree >= avgGrade - 10) {
//         rowColor = Colors.yellow.shade100;
//       } else {
//         rowColor = Colors.red.shade100;
//       }

//       return DataRow(
//         color: MaterialStateProperty.resolveWith((_) => rowColor),
//         cells: [
//           DataCell(Text(row['sittingNumber'] ?? 'N/A')),
//           DataCell(Text(row['model'] ?? 'N/A')),
//           DataCell(Text(row['correctAnswersCount']?.toString() ?? 'N/A')),
//           DataCell(Text(row['TotalDegree']?.toString() ?? 'N/A')),
//           DataCell(Text(degree ?? 'N/A')),
//           DataCell(Text(row['Page']?.toString() ?? 'N/A')),
//         ],
//       );
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final totalPages = (tableData.length / rowsPerPage).ceil();

//     return Scaffold(
//       backgroundColor: const Color(0xffE5EEF1),
//       appBar: AppBar(
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             GoRouter.of(context).pop(); // العودة إلى الصفحة السابقة
//           },
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//         ),
//         backgroundColor: const Color(0xff2262c6),
//         title: const Text(
//           "Results",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Student Results Processed",
//                     style: TextStyle(fontSize: 18, color: Colors.black54),
//                   ),
//                   const Text(
//                     "Successfully",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Color(0xff2262c6),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: tableData.isNotEmpty
//                             ? [
//                                 ListView.builder(
//                                   shrinkWrap: true,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemCount: tableData.length,
//                                   itemBuilder: (context, index) {
//                                     final item = tableData[index];
//                                     return ResultCard(item: item);
//                                   },
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(vertical: 10),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text('Page $currentPage of $totalPages'),
//                                       Row(
//                                         children: [
//                                           ElevatedButton(
//                                             onPressed: currentPage > 1
//                                                 ? () => setState(() => currentPage--)
//                                                 : null,
//                                             child: const Text('Previous'),
//                                           ),
//                                           const SizedBox(width: 10),
//                                           ElevatedButton(
//                                             onPressed: currentPage < totalPages
//                                                 ? () => setState(() => currentPage++)
//                                                 : null,
//                                             child: const Text('Next'),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ]
//                             : [const Text("No results available.")],
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: downloadPDF,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xff2262c6),
//                       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                     ),
//                     child: const Text(
//                       "Download PDF",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//     );
//   }
// }

// class ResultCard extends StatelessWidget {
//   final Map<String, dynamic> item;

//   const ResultCard({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8.0),
//             color: Colors.grey[300],
//             width: double.infinity,
//             child: const Text(
//               "sitting Number :",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Table(
//             border: TableBorder(
//               horizontalInside: BorderSide(color: Colors.grey.shade400, width: 1),
//             ),
//             columnWidths: const {
//               0: FlexColumnWidth(2),
//               1: FlexColumnWidth(3),
//             },
//             children: [
//               _buildTableRow(0, "Model", item['model'] ?? 'N/A'),
//               _buildTableRow(1, "Number of Correct Answers", item['correctAnswersCount']?.toString() ?? 'N/A'),
//               _buildTableRow(2, "Degree", item['TotalDegree']?.toString() ?? 'N/A'),
//               _buildTableRow(3, "Expected Degree", 'N/A'), // استبدل بقيمة ديناميكية إذا كانت متوفرة
//               _buildTableRow(4, "Page Number", item['Page']?.toString() ?? 'N/A'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   TableRow _buildTableRow(int index, String title, String value) {
//     return TableRow(
//       decoration: BoxDecoration(
//         color: index.isEven ? Colors.white : Colors.grey[200],
//       ),
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(value),
//         ),
//       ],
//     );
//   }
// }