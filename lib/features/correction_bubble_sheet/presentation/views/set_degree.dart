import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';

class ResultStudentPage extends StatefulWidget {
  const ResultStudentPage({super.key});

  @override
  State<ResultStudentPage> createState() => _ResultStudentPageState();
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
  String? downloadedFilePath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() {
    // Retrieve data from extra
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    if (extra == null) {
      _showErrorMessage('No data received!');
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
      }

      bubbleSheetStudent =
          extra['BubbleSheetStudent']?.replaceAll('.pdf', '.json');
      degree = extra['degree'] as String?;
      namePdf = extra['namePdf'] as String?;
    });

    if (fileName == null || bubbleSheetStudent == null || degree == null) {
      _showErrorMessage('Missing required data!');
      setState(() {
        isLoading = false;
      });
      return;
    }

    fetchResults();
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.ceruleanBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Future<void> _openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        _showErrorMessage('Could not open file: ${result.message}');
      }
    } catch (e) {
      _showErrorMessage('Error opening file: $e');
    }
  }

  Future<void> fetchResults() async {
    try {
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
          'namepdf': namePdf ?? "default",
        }),
      );

      print('Raw API Response: ${response.body}');

      if (response.statusCode == 200) {
        // Download Excel file
        final responseFile = await http.patch(
          Uri.parse('$kBaseUrl/Doctor/ResultStudent'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'AnswerBubbleSheet': fileName,
            'BubbleSheetStudent': bubbleSheetStudent,
            'actuallyDegree': int.tryParse(degree!),
            'namepdf': namePdf ?? "default",
          }),
        );

        if (responseFile.statusCode == 200) {
          await _saveExcelFile(responseFile.bodyBytes);
        }

        // Parse JSON response
        final dynamic jsonData = jsonDecode(response.body);
        _parseJsonResponse(jsonData);
      } else {
        throw Exception(
            'Failed to load results: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorMessage('Error: $e');
      print('Error: $e');
    }
  }

  Future<void> _saveExcelFile(List<int> bytes) async {
    try {
      // Request storage permission
      if (await Permission.storage.request().isGranted ||
          await Permission.manageExternalStorage.request().isGranted) {
        // Get downloads directory
        Directory? downloadsDirectory;
        if (Platform.isAndroid) {
          downloadsDirectory = Directory('/storage/emulated/0/Download');
          if (!downloadsDirectory.existsSync()) {
            downloadsDirectory = await getExternalStorageDirectory();
          }
        } else {
          downloadsDirectory = await getApplicationDocumentsDirectory();
        }

        if (downloadsDirectory != null) {
          final String filePath =
              '${downloadsDirectory.path}/ResultStudent_${DateTime.now().millisecondsSinceEpoch}.xlsx';

          final File excelFile = File(filePath);
          await excelFile.writeAsBytes(bytes);

          setState(() {
            downloadedFilePath = filePath;
          });

          _showSuccessMessage('File saved successfully!');
          print("File saved at: $filePath");
        } else {
          _showErrorMessage('Could not access storage directory');
        }
      } else {
        _showErrorMessage('Storage permission denied');
      }
    } catch (e) {
      _showErrorMessage('Error saving file: $e');
      print("Error saving file: $e");
    }
  }

  void _parseJsonResponse(dynamic jsonData) {
    if (jsonData is List) {
      setState(() {
        tableData = jsonData;
        isLoading = false;
      });
    } else if (jsonData is Map &&
        jsonData.containsKey('data') &&
        jsonData['data'] is List) {
      setState(() {
        tableData = jsonData['data'] as List;
        isLoading = false;
      });
    } else if (jsonData is Map &&
        jsonData.containsKey('results') &&
        jsonData['results'] is List) {
      setState(() {
        tableData = jsonData['results'] as List;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception(
          'Invalid response format: Expected a list or map with "data" or "results" key');
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
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24.sp,
          ),
        ),
        backgroundColor: const Color(0xff2262c6),
        title: Text(
          "Show Results",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.ceruleanBlue,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Loading results...',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Results header
                    if (tableData.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade600,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 28.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Results Processed Successfully',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Found ${tableData.length} student(s)',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Results list or empty state
                    Expanded(
                      child: tableData.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64.sp,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'No results available',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Please check your data and try again',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: tableData.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = tableData[index];
                                if (item is Map<String, dynamic>) {
                                  return _buildResultCard(item, index);
                                } else {
                                  return _buildErrorCard(index);
                                }
                              },
                            ),
                    ),

                    // Bottom actions
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        // Open file button
                        if (downloadedFilePath != null) ...[
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _openFile(downloadedFilePath!),
                              icon: Icon(
                                Icons.file_open,
                                size: 20.sp,
                              ),
                              label: Text(
                                'Open Excel File',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                elevation: 3,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                        ],

                        // Back to home button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.go(AppRouter.kHomeView);
                            },
                            icon: Icon(
                              Icons.home,
                              size: 20.sp,
                            ),
                            label: Text(
                              'Back to Home',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff2262c6),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              elevation: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade700,
                    Colors.blue.shade900,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      "Sitting Number: ${item['sittingNumber'] ?? 'N/A'}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildInfoRow(
                    "Model",
                    item['model'] ?? 'N/A',
                    Icons.account_tree,
                  ),
                  _buildInfoRow(
                    "Correct Answers",
                    item['correctAnswersCount']?.toString() ?? 'N/A',
                    Icons.check_circle,
                  ),
                  _buildInfoRow(
                    "Total Degree",
                    item['TotalDegree']?.toString() ?? 'N/A',
                    Icons.grade,
                  ),
                  _buildInfoRow(
                    "Page Number",
                    item['Page']?.toString() ?? 'N/A',
                    Icons.pages,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon,
      {bool isLast = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: Colors.grey[600],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: Colors.grey[700],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Invalid data format at index $index',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:go_router/go_router.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:project/constants.dart';
// import 'package:project/core/constants/colors.dart';
// import 'package:project/core/utils/app_router.dart';

// class ResultStudentPage extends StatefulWidget {
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
//       if (fileName != null) {
//         fileName = '${fileName!}.json';
//       } else {
//         fileName = null; // قيمة افتراضية إذا كان null
//       }

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

//   void _showSuccess(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: AppColors.ceruleanBlue,
//       ),
//     );
//   }

//   Future<void> fetchResults() async {
//     try {
//       // طباعة البيانات المُمررة للتحقق
//       print('Sending request with:');
//       print('fileName: $fileName');
//       print('bubbleSheetStudent: $bubbleSheetStudent');
//       print('degree: $degree');
//       print('namePdf: $namePdf');

//       final response = await http.post(
//         Uri.parse('$kBaseUrl/Doctor/ResultStudent'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'AnswerBubbleSheet': fileName,
//           'BubbleSheetStudent': bubbleSheetStudent,
//           'actuallyDegree': int.tryParse(degree!),
//           'namepdf': "qqqqqqqq",
//         }),
//       );

//       // طباعة الاستجابة الكاملة للتحقق
//       print('📌📌📌📌📌📌📌Raw API Response: ${response.body}');

//       if (response.statusCode == 200) {
//         final responseFile = await http.patch(
//           Uri.parse('$kBaseUrl/Doctor/ResultStudent'),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode({
//             'AnswerBubbleSheet': fileName,
//             'BubbleSheetStudent': bubbleSheetStudent,
//             'actuallyDegree': int.tryParse(degree!),
//             'namepdf': "qqqqqqqq",
//           }),
//         );
//         if (responseFile.statusCode == 200) {
//           try {
//             // 🔹 طلب الإذن للوصول إلى التخزين
//             if (await Permission.storage.request().isGranted) {
//               // 🔹 الحصول على مسار مجلد التنزيلات
//               Directory? downloadsDirectory =
//                   Directory('/storage/emulated/0/Download');

//               if (!downloadsDirectory.existsSync()) {
//                 downloadsDirectory = await getExternalStorageDirectory();
//               }

//               // 🔹 تحديد مسار الحفظ داخل مجلد التنزيلات
//               final String filePath =
//                   '${downloadsDirectory!.path}/ResultStudent.xlsx';

//               // 🔹 إنشاء الملف وحفظ البيانات فيه
//               final File excelFile = File(filePath);
//               await excelFile.writeAsBytes(responseFile.bodyBytes);
//               _showSuccess(
//                   '✅ The file has been successfully saved in: $filePath');
//               // Fluttertoast.showToast(
//               //     msg: 'The file has been successfully saved in: $filePath');
//               print("✅ The file has been successfully saved in: $filePath");
//             } else {
//               print("❌ Permission denied to access storage.");
//             }
//           } catch (e) {
//             print("❌ Error while saving the file: $e");
//           }
//         } else {
//           print(
//               "❌ Failed to retrieve the file. Status code: ${responseFile.statusCode}");
//         }

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
//           print('Unexpected response structure: $jsonData');
//           throw Exception(
//               'Invalid response format: Expected a list or map with "data" or "results" key');
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
//           style: TextStyle(
//             color: Colors.white,
//           ),
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
//                     // Container(
//                     //   width: double.infinity,
//                     //   padding: const EdgeInsets.all(16),
//                     //   decoration: BoxDecoration(
//                     //     color: Colors.lightBlue.shade50,
//                     //     borderRadius: BorderRadius.circular(12),
//                     //   ),
//                     //   child: const Column(
//                     //     crossAxisAlignment: CrossAxisAlignment.start,
//                     //     mainAxisSize: MainAxisSize.min,
//                     //     children: [
//                     //       Text(
//                     //         'Student Results Processed',
//                     //         style: TextStyle(
//                     //           fontSize: 18,
//                     //           color: Colors.blue,
//                     //         ),
//                     //       ),
//                     //       Text(
//                     //         'Successfully',
//                     //         style: TextStyle(
//                     //           fontSize: 18,
//                     //           color: Colors.blue,
//                     //         ),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
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
//                     OutlinedButton.icon(
//                       onPressed: () {
//                         context.go(
//                             AppRouter.kHomeView); // Navigate using go_router
//                       },
//                       icon: const Icon(Icons.home, size: 20),
//                       label: const Text('Back to Home'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         side: BorderSide(color: Colors.white, width: 2.w),
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 24.w, vertical: 16.h),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30.r),
//                         ),
//                       ),
//                     ),
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
