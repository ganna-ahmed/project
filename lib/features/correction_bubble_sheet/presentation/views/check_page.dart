// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:go_router/go_router.dart';
// import 'package:project/core/utils/app_router.dart';

// class CheckForUpload extends StatefulWidget {
//   final String bubbleSheetStudent;

//   const CheckForUpload({required this.bubbleSheetStudent, Key? key})
//       : super(key: key);

//   @override
//   _CheckForUploadState createState() => _CheckForUploadState();
// }

// class _CheckForUploadState extends State<CheckForUpload> {
//   bool isLoading = true;
//   String completeMessage = "";
//   int pageCount = 0;
//   List<int> missingPages = [];
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     checkForUpload();
//     _startAutoRefresh();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   void _startAutoRefresh() {
//     _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
//       checkForUpload();
//     });
//   }

//   Future<void> checkForUpload() async {
//     try {
//       final response = await http.post(
//         Uri.parse(
//             "https://7959-197-192-206-85.ngrok-free.app/Doctor/checkForUpload"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"BubbleSheetStudent": widget.bubbleSheetStudent}),
//       );

//       print("🚀 Response from API: ${response.body}");

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           completeMessage = data['message'] ?? "";
//           pageCount = data['totalPages'] ?? 0;
//           missingPages = _parseMissingPages(data['missingPages']);
//           isLoading = false;
//         });

//         print("📌 Message: $completeMessage");
//         print("📄 Total Pages: $pageCount");
//         print("❌ Missing Pages: $missingPages");

//         if (!completeMessage.contains("missing")) {
//           _timer?.cancel();
//           navigateToCorrectionPage();
//         }
//       } else {
//         throw Exception("Failed to fetch data. Status: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("❌ Error: $e");
//       setState(() {
//         isLoading = false;
//       });
//       Fluttertoast.showToast(msg: "Error: ${e.toString()}");
//     }
//   }

//   List<int> _parseMissingPages(dynamic missingPagesData) {
//     if (missingPagesData == null) return [];
//     if (missingPagesData is List) {
//       return List<int>.from(missingPagesData);
//     } else if (missingPagesData is String) {
//       return missingPagesData
//           .split(',')
//           .map((e) => int.tryParse(e.trim()) ?? 0)
//           .where((e) => e > 0)
//           .toList();
//     }
//     return [];
//   }

//   void navigateToCorrectionPage() {
//     GoRouter.of(context).push(AppRouter.kProgrssScreen, extra: {
//       'BubbleSheetStudent': widget.bubbleSheetStudent,
//       'pagesNumber': pageCount.toString(),
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Check for Upload")),
//       body: Center(
//         child: isLoading
//             ? const CircularProgressIndicator()
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     completeMessage.contains("missing")
//                         ? "⏳ Waiting for all pages to upload..."
//                         : "✅ All pages are complete! Redirecting to correction...",
//                     style: TextStyle(
//                         fontSize: 18,
//                         color: completeMessage.contains("missing")
//                             ? Colors.orange
//                             : Colors.green),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
//                   if (missingPages.isNotEmpty)
//                     Text(
//                       "Missing pages: ${missingPages.join(", ")}",
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   if (pageCount > 0)
//                     Text(
//                       "Total Pages: $pageCount",
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   const SizedBox(height: 20),
//                   if (completeMessage.contains("missing"))
//                     const CircularProgressIndicator(),
//                 ],
//               ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/utils/app_router.dart';

class CheckForUpload extends StatefulWidget {
  final Map<String, dynamic>? extra;

  const CheckForUpload({this.extra, Key? key}) : super(key: key);

  @override
  _CheckForUploadState createState() => _CheckForUploadState();
}

class _CheckForUploadState extends State<CheckForUpload> {
  bool isLoading = true;
  String completeMessage = "";
  int pageCount = 0;
  List<int> missingPages = [];
  Timer? _timer;
  String? fileName; // الاسم من الصفحة السابقة
  String? bubbleSheetStudent; // الاسم من السيرفر

  @override
  void initState() {
    super.initState();
    // استخراج البيانات من extra
    final extra = widget.extra ??
        GoRouterState.of(context).extra as Map<String, dynamic>?;
    if (extra != null) {
      fileName = extra['fileName'] as String?;
      bubbleSheetStudent = extra['BubbleSheetStudent'] as String?;
    }
    if (bubbleSheetStudent == null) {
      Fluttertoast.showToast(msg: 'No BubbleSheetStudent received!');
      setState(() => isLoading = false);
      return;
    }
    checkForUpload();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      checkForUpload();
    });
  }

  Future<void> checkForUpload() async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://bf40-2c0f-fc88-5-10ae-f4f8-1ba7-f2db-11b6.ngrok-free.app/Doctor/checkForUpload"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"BubbleSheetStudent": bubbleSheetStudent}),
      );

      print("🚀 Response from API: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          completeMessage = data['message'] ?? "";
          pageCount = data['totalPages'] ?? 0;
          missingPages = _parseMissingPages(data['missingPages']);
          isLoading = false;
        });

        print("📌 Message: $completeMessage");
        print("📄 Total Pages: $pageCount");
        print("❌ Missing Pages: $missingPages");

        if (!completeMessage.contains("missing")) {
          _timer?.cancel();
          navigateToCorrectionPage();
        }
      } else {
        throw Exception("Failed to fetch data. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error: $e");
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
  }

  List<int> _parseMissingPages(dynamic missingPagesData) {
    if (missingPagesData == null) return [];
    if (missingPagesData is List) {
      return List<int>.from(missingPagesData);
    } else if (missingPagesData is String) {
      return missingPagesData
          .split(',')
          .map((e) => int.tryParse(e.trim()) ?? 0)
          .where((e) => e > 0)
          .toList();
    }
    return [];
  }

  void navigateToCorrectionPage() {
    if (fileName != null && bubbleSheetStudent != null) {
      GoRouter.of(context).push(AppRouter.kProgrssScreen, extra: {
        'fileName': fileName,
        'BubbleSheetStudent': bubbleSheetStudent,
        'pagesNumber': pageCount.toString(),
        'id': 'someId', // استبدل بقيمة ديناميكية إذا كانت متوفرة
        //'AnswerBubbleSheet': bubbleSheetStudent, // افتراضي، يمكن تعديله
      });
    } else {
      Fluttertoast.showToast(msg: 'Missing fileName or BubbleSheetStudent!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Check for Upload")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    completeMessage.contains("missing")
                        ? "⏳ Waiting for all pages to upload..."
                        : "✅ All pages are complete! Redirecting to correction...",
                    style: TextStyle(
                        fontSize: 18,
                        color: completeMessage.contains("missing")
                            ? Colors.orange
                            : Colors.green),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (missingPages.isNotEmpty)
                    Text(
                      "Missing pages: ${missingPages.join(", ")}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (pageCount > 0)
                    Text(
                      "Total Pages: $pageCount",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (completeMessage.contains("missing"))
                    const CircularProgressIndicator(),
                ],
              ),
      ),
    );
  }
}
