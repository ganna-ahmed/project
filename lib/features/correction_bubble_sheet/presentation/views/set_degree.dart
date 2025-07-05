// import 'dart:convert';
// import 'dart:io'; // لاستخدام File
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:go_router/go_router.dart';
// import 'package:path/path.dart' as path;

// class ResultStudentPage extends StatefulWidget {
//   const ResultStudentPage({super.key});

//   @override
//   _ResultStudentPageState createState() => _ResultStudentPageState();
// }

// class _ResultStudentPageState extends State<ResultStudentPage> {
//   List<dynamic> tableData = [];
//   bool isLoading = true;
//   String? idDoctor;
//   String? answerBubbleSheet;
//   String? bubbleSheetStudent;
//   String? fileName;
//   String? degree;
//   String? namePdf;

//   @override
//   void initState() {
//     super.initState();
//     // لا نستخدم GoRouterState.of(context) هنا
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // استرجاع البيانات من extra
//     final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
//     if (extra == null) {
//       Fluttertoast.showToast(msg: 'No data received!');
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }

//     setState(() {
//       idDoctor = extra['id'] as String?;
//       fileName = extra['fileName'] as String?;
//       // if (fileName != null) {
//       //   fileName = '${fileName!}.json';
//       // } else {
//       //   fileName = null; // قيمة افتراضية إذا كان null
//       // }

//       bubbleSheetStudent =
//           extra['BubbleSheetStudent']?.replaceAll('.pdf', '.json');
//       degree = extra['degree'] as String?;
//       namePdf = extra['namePdf'] as String?;
//     });

//     if (fileName == null || bubbleSheetStudent == null || degree == null) {
//       Fluttertoast.showToast(msg: 'Missing required data!');
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }

//     fetchResults();
//   }

//   Future<void> fetchResults() async {
//     try {
//       // طباعة البيانات المُمررة للتحقق

//       final response = await http.patch(
//         Uri.parse(
//             'https://843c-2c0f-fc88-5-597-49a2-fc16-b990-4a8b.ngrok-free.app/Doctor/ResultStudent'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'AnswerBubbleSheet': fileName,
//           'BubbleSheetStudent': bubbleSheetStudent,
//           'actuallyDegree': int.tryParse(degree!),
//           'Namepdf': "noooooo",
//         }),
//       );
//       print('Sending request with:');
//       print('fileName: $fileName');
//       print('bubbleSheetStudent: $bubbleSheetStudent');
//       print('degree: $degree');
//       print('namePdf: $namePdf');
//       // طباعة الاستجابة الكاملة للتحقق
//       print('📌📌📌📌📌📌📌Raw API Response: ${response.body}');

//       if (response.statusCode == 200) {
//         final dynamic jsonData = jsonDecode(response.body);

//         if (jsonData is List) {
//           setState(() {
//             tableData = jsonData;
//             isLoading = false;
//           });
//           print(
//               'Table Data after update: $tableData'); // تحقق من محتوى tableData
//         } else if (jsonData is Map &&
//             jsonData.containsKey('data') &&
//             jsonData['data'] is List) {
//           setState(() {
//             tableData = jsonData['data'] as List;
//             isLoading = false;
//           });
//           print('Table Data after update: $tableData');
//         } else if (jsonData is Map &&
//             jsonData.containsKey('results') &&
//             jsonData['results'] is List) {
//           setState(() {
//             tableData = jsonData['results'] as List;
//             isLoading = false;
//           });
//           print('Table Data after update: $tableData');
//         } else {
//           // إذا كانت الاستجابة تحتوي على بيانات الملف (مثل Excel)
//           if (response.headers['content-type']?.contains(
//                   'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') ??
//               false) {
//             final bytes = response.bodyBytes;
//             final directory = await DownloadsPathProvider
//                 .downloadsDirectory; // استخدام downloads_path_provider
//             if (directory != null) {
//               final filePath = path.join(
//                   directory.path, 'Bubble_Sheet_${namePdf ?? 'default'}.xlsx');
//               final file = File(filePath);
//               await file.writeAsBytes(bytes);
//               print('File saved at: $filePath');
//               Fluttertoast.showToast(
//                   msg: 'Excel file downloaded successfully to Downloads!');
//             } else {
//               print('Failed to get Downloads directory');
//               Fluttertoast.showToast(
//                   msg: 'Failed to access Downloads directory!');
//             }
//           } else {
//             print('Unexpected response structure: $jsonData');
//             throw Exception(
//                 'Invalid response format: Expected a list, map with "data" or "results" key, or Excel file');
//           }
//         }
//       } else {
//         throw Exception(
//             'Failed to load results: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       Fluttertoast.showToast(msg: 'Error: $e');
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffE5EEF1),
//       appBar: AppBar(
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             GoRouter.of(context).pop();
//           },
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//         ),
//         backgroundColor: const Color(0xff2262c6),
//         title: const Text(
//           "Show Result",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header info container
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.lightBlue.shade50,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             'Student Results Processed',
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colors.blue,
//                             ),
//                           ),
//                           Text(
//                             'Successfully',
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Check if tableData is empty
//                     tableData.isEmpty
//                         ? const Expanded(
//                             child: Center(
//                               child: Text(
//                                 'No results available.',
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             ),
//                           )
//                         : Expanded(
//                             child: ListView.builder(
//                               itemCount: tableData.length,
//                               shrinkWrap: true,
//                               physics: const AlwaysScrollableScrollPhysics(),
//                               itemBuilder: (context, index) {
//                                 final item = tableData[index];
//                                 if (item is Map<String, dynamic>) {
//                                   return _buildResultCard(item);
//                                 } else {
//                                   return Card(
//                                     margin: const EdgeInsets.only(bottom: 16),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(16),
//                                       child: Text(
//                                           'Invalid data format at index $index'),
//                                     ),
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildResultCard(Map<String, dynamic> item) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade700,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 topRight: Radius.circular(12),
//               ),
//             ),
//             width: double.infinity,
//             child: Text(
//               "Sitting Number: ${item['sittingNumber'] ?? 'N/A'}",
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//           _buildInfoRow("Model", item['model'] ?? 'N/A'),
//           _buildInfoRow("Number of Correct Answers",
//               (item['correctAnswersCount']?.toString() ?? 'N/A')),
//           _buildInfoRow("Degree", (item['TotalDegree']?.toString() ?? 'N/A')),
//           _buildInfoRow("Page Number", (item['Page']?.toString() ?? 'N/A')),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           Flexible(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//               textAlign: TextAlign.end,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';

class ResultStudentPage extends StatefulWidget {
  @override
  _ResultStudentPageState createState() => _ResultStudentPageState();
}

class _ResultStudentPageState extends State<ResultStudentPage> {
  List<dynamic> tableData = [];
  bool isLoading = true;
  String? idDoctor;
  String? answerBubbleSheet;
  String? bubbleSheetStudent;
  String? fileName;
  String? degree;
  String? namePdf;

  @override
  void initState() {
    super.initState();
    // لا نستخدم GoRouterState.of(context) هنا
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // استرجاع البيانات من extra
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    if (extra == null) {
      Fluttertoast.showToast(msg: 'No data received!');
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      idDoctor = extra['id'] as String?;
      fileName = extra['fileName'] as String?;
      if (fileName != null) {
        fileName = '${fileName!}.json';
      } else {
        fileName = null; // قيمة افتراضية إذا كان null
      }

      bubbleSheetStudent =
          extra['BubbleSheetStudent']?.replaceAll('.pdf', '.json');
      degree = extra['degree'] as String?;
      namePdf = extra['namePdf'] as String?;
    });

    if (fileName == null || bubbleSheetStudent == null || degree == null) {
      Fluttertoast.showToast(msg: 'Missing required data!');
      setState(() {
        isLoading = false;
      });
      return;
    }

    fetchResults();
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.ceruleanBlue,
      ),
    );
  }

  Future<void> fetchResults() async {
    try {
      // طباعة البيانات المُمررة للتحقق
      print('Sending request with:');
      print('fileName: $fileName');
      print('bubbleSheetStudent: $bubbleSheetStudent');
      print('degree: $degree');
      print('namePdf: $namePdf');

      final response = await http.post(
        Uri.parse('$kBaseUrl/Doctor/ResultStudent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'AnswerBubbleSheet': fileName,
          'BubbleSheetStudent': bubbleSheetStudent,
          'actuallyDegree': int.tryParse(degree!),
          'namepdf': "qqqqqqqq",
        }),
      );

      // طباعة الاستجابة الكاملة للتحقق
      print('📌📌📌📌📌📌📌Raw API Response: ${response.body}');

      if (response.statusCode == 200) {
        final responseFile = await http.patch(
          Uri.parse('$kBaseUrl/Doctor/ResultStudent'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'AnswerBubbleSheet': fileName,
            'BubbleSheetStudent': bubbleSheetStudent,
            'actuallyDegree': int.tryParse(degree!),
            'namepdf': "qqqqqqqq",
          }),
        );
        if (responseFile.statusCode == 200) {
          try {
            // 🔹 طلب الإذن للوصول إلى التخزين
            if (await Permission.storage.request().isGranted) {
              // 🔹 الحصول على مسار مجلد التنزيلات
              Directory? downloadsDirectory =
                  Directory('/storage/emulated/0/Download');

              if (!downloadsDirectory.existsSync()) {
                downloadsDirectory = await getExternalStorageDirectory();
              }

              // 🔹 تحديد مسار الحفظ داخل مجلد التنزيلات
              final String filePath =
                  '${downloadsDirectory!.path}/ResultStudent.xlsx';

              // 🔹 إنشاء الملف وحفظ البيانات فيه
              final File excelFile = File(filePath);
              await excelFile.writeAsBytes(responseFile.bodyBytes);
              _showSuccess(
                  '✅ The file has been successfully saved in: $filePath');
              // Fluttertoast.showToast(
              //     msg: 'The file has been successfully saved in: $filePath');
              print("✅ The file has been successfully saved in: $filePath");
            } else {
              print("❌ Permission denied to access storage.");
            }
          } catch (e) {
            print("❌ Error while saving the file: $e");
          }
        } else {
          print(
              "❌ Failed to retrieve the file. Status code: ${responseFile.statusCode}");
        }

        final dynamic jsonData = jsonDecode(response.body);

        if (jsonData is List) {
          setState(() {
            tableData = jsonData;
            isLoading = false;
          });
          print(
              'Table Data after update: $tableData'); // تحقق من محتوى tableData
        } else if (jsonData is Map &&
            jsonData.containsKey('data') &&
            jsonData['data'] is List) {
          setState(() {
            tableData = jsonData['data'] as List;
            isLoading = false;
          });
          print('Table Data after update: $tableData');
        } else if (jsonData is Map &&
            jsonData.containsKey('results') &&
            jsonData['results'] is List) {
          setState(() {
            tableData = jsonData['results'] as List;
            isLoading = false;
          });
          print('Table Data after update: $tableData');
        } else {
          print('Unexpected response structure: $jsonData');
          throw Exception(
              'Invalid response format: Expected a list or map with "data" or "results" key');
        }
      } else {
        throw Exception(
            'Failed to load results: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Error: $e');
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5EEF1),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: const Color(0xff2262c6),
        title: const Text(
          "Show Result",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header info container
                    // Container(
                    //   width: double.infinity,
                    //   padding: const EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     color: Colors.lightBlue.shade50,
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: const Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Text(
                    //         'Student Results Processed',
                    //         style: TextStyle(
                    //           fontSize: 18,
                    //           color: Colors.blue,
                    //         ),
                    //       ),
                    //       Text(
                    //         'Successfully',
                    //         style: TextStyle(
                    //           fontSize: 18,
                    //           color: Colors.blue,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 16),

                    // Check if tableData is empty
                    tableData.isEmpty
                        ? const Expanded(
                            child: Center(
                              child: Text(
                                'No results available.',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: tableData.length,
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = tableData[index];
                                if (item is Map<String, dynamic>) {
                                  return _buildResultCard(item);
                                } else {
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                          'Invalid data format at index $index'),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            width: double.infinity,
            child: Text(
              "Sitting Number: ${item['sittingNumber'] ?? 'N/A'}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          _buildInfoRow("Model", item['model'] ?? 'N/A'),
          _buildInfoRow("Number of Correct Answers",
              (item['correctAnswersCount']?.toString() ?? 'N/A')),
          _buildInfoRow("Degree", (item['TotalDegree']?.toString() ?? 'N/A')),
          _buildInfoRow("Page Number", (item['Page']?.toString() ?? 'N/A')),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
