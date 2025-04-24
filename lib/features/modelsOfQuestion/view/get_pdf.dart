import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import '../../../constants.dart';
import '../../../core/constants/colors.dart';
import 'dart:async';

class PdfDownloadPage extends StatefulWidget {
  final String idDoctor;
  final String modelName;
  final String pdfName;

  const PdfDownloadPage({
    Key? key,
    required this.idDoctor,
    required this.modelName,
    required this.pdfName,
  }) : super(key: key);

  @override
  State<PdfDownloadPage> createState() => _PdfDownloadPageState();
}

class _PdfDownloadPageState extends State<PdfDownloadPage>
    with SingleTickerProviderStateMixin {
  double _progress = 0;
  bool _showSuccess = false;
  bool _downloadComplete = false;
  String _downloadPath = '';
  String _errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startDownload();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _bounceAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 0.3, end: 1.1), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 1.1, end: 0.9), weight: 20),
        TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
      ],
    ).animate(_animationController);
  }

  Future<void> _startDownload() async {
    try {
      final downloadUrl = '$kBaseUrl/Doctor/getPdf';
      final directory = await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${widget.pdfName}.zip';

      setState(() {
        _downloadPath = filePath;
      });

      await _dio.download(
        downloadUrl,
        filePath,
        queryParameters: {
          'id': widget.idDoctor,
          'modelName': widget.modelName,
          'pdfName': widget.pdfName,
        },
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _progress = received / total;
            });
          }
        },
      );

      setState(() {
        _downloadComplete = true;
        _showSuccess = true;
      });

      _animationController.forward();
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء التحميل: ${e.toString()}';
      });
      print('Download error: $e');
    }
  }

  Future<void> _openDownloadedFile() async {
    try {
      final result = await OpenFile.open(_downloadPath);
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لا يمكن فتح الملف: ${result.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ عند محاولة فتح الملف: $e')),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحميل الامتحان'),
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7709e4),
              Color(0xFF5b0296),
              Color(0xFF1787e4),
              Color(0xFFd5a8fc),
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: _errorMessage.isNotEmpty
              ? _buildErrorView()
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child:
                      _showSuccess ? _buildSuccessView() : _buildLoadingView(),
                ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: _progress,
                strokeWidth: 10,
                backgroundColor: Colors.white.withOpacity(0.3),
                color: Colors.white,
              ),
              Text(
                '${(_progress * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'برجاء الانتظار حتى يتم تحميل الامتحان...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScaleTransition(
          scale: _bounceAnimation,
          child: Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'تم تحميل خمسة نماذج من الامتحان والـ PDF الخاص بورقة الإجابة بنجاح!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _openDownloadedFile,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF7709e4),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'فتح الملف',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _errorMessage = '';
                _progress = 0;
              });
              _startDownload();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF7709e4),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'محاولة مرة أخرى',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:open_file/open_file.dart';
// import '../../../constants.dart';
// import '../../../core/constants/colors.dart';

// class PdfDownloadPage extends StatefulWidget {
//   final String idDoctor;
//   final String modelName;
//   final String pdfName;

//   const PdfDownloadPage({
//     Key? key,
//     required this.idDoctor,
//     required this.modelName,
//     required this.pdfName,
//   }) : super(key: key);

//   @override
//   State<PdfDownloadPage> createState() => _PdfDownloadPageState();
// }

// class _PdfDownloadPageState extends State<PdfDownloadPage>
//     with SingleTickerProviderStateMixin {
//   double _progress = 0;
//   bool _showSuccess = false;
//   bool _downloadComplete = false;
//   String _downloadPath = '';
//   String _errorMessage = '';
//   late AnimationController _animationController;
//   late Animation<double> _bounceAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initAnimations();
//     _startDownload();
//   }

//   void _initAnimations() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );

//     _bounceAnimation = TweenSequence<double>(
//       [
//         TweenSequenceItem(tween: Tween(begin: 0.3, end: 1.1), weight: 50),
//         TweenSequenceItem(tween: Tween(begin: 1.1, end: 0.9), weight: 20),
//         TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
//       ],
//     ).animate(_animationController);
//   }

//   Future<void> _startDownload() async {
//     print('🟢🟢🟢${widget.idDoctor}🟢🟢🟢${widget.modelName}');
//     try {
//       final downloadUrl = '$kBaseUrl/Doctor/getPdf';
//       final directory = await getExternalStorageDirectory() ??
//           await getApplicationDocumentsDirectory();
//       final filePath = '${directory.path}/${widget.pdfName}.zip';

//       setState(() {
//         _downloadPath = filePath;
//       });

//       final response =
//           await http.Client().send(http.Request('POST', Uri.parse(downloadUrl))
//             ..url.replace(queryParameters: {
//               'modelName': widget.modelName,
//               'pdfName': widget.pdfName,
//             }));

//       final totalLength = response.contentLength ?? -1;
//       var receivedLength = 0;
//       final file = File(filePath);
//       final bytes = <int>[];

//       await for (final chunk in response.stream) {
//         bytes.addAll(chunk);
//         receivedLength += chunk.length;

//         if (totalLength != -1) {
//           setState(() {
//             _progress = receivedLength / totalLength;
//           });
//         }
//       }

//       await file.writeAsBytes(bytes);

//       setState(() {
//         _downloadComplete = true;
//         _showSuccess = true;
//       });

//       _animationController.forward();
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'حدث خطأ أثناء التحميل: ${e.toString()}';
//       });
//       print('Download error: $e');
//     }
//   }

//   Future<void> _openDownloadedFile() async {
//     try {
//       final result = await OpenFile.open(_downloadPath);
//       if (result.type != ResultType.done) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('لا يمكن فتح الملف: ${result.message}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ عند محاولة فتح الملف: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('تحميل الامتحان'),
//         backgroundColor: AppColors.ceruleanBlue,
//         foregroundColor: Colors.white,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF7709e4),
//               Color(0xFF5b0296),
//               Color(0xFF1787e4),
//               Color(0xFFd5a8fc),
//             ],
//             stops: [0.0, 0.3, 0.6, 1.0],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: _errorMessage.isNotEmpty
//               ? _buildErrorView()
//               : AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 500),
//                   child:
//                       _showSuccess ? _buildSuccessView() : _buildLoadingView(),
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingView() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           width: 100,
//           height: 100,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               CircularProgressIndicator(
//                 value: _progress,
//                 strokeWidth: 10,
//                 backgroundColor: Colors.white.withOpacity(0.3),
//                 color: Colors.white,
//               ),
//               Text(
//                 '${(_progress * 100).toInt()}%',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 20),
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24),
//           child: Text(
//             'برجاء الانتظار حتى يتم تحميل الامتحان...',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSuccessView() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ScaleTransition(
//           scale: _bounceAnimation,
//           child: Container(
//             width: 120,
//             height: 120,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.check_circle,
//               color: Colors.green,
//               size: 80,
//             ),
//           ),
//         ),
//         const SizedBox(height: 24),
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 32),
//           child: Text(
//             'تم تحميل خمسة نماذج من الامتحان والـ PDF الخاص بورقة الإجابة بنجاح!',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         const SizedBox(height: 32),
//         ElevatedButton(
//           onPressed: _openDownloadedFile,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.white,
//             foregroundColor: Color(0xFF7709e4),
//             padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30),
//             ),
//           ),
//           child: const Text(
//             'فتح الملف',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildErrorView() {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(
//             Icons.error_outline,
//             color: Colors.white,
//             size: 64,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             _errorMessage,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//             ),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _errorMessage = '';
//                 _progress = 0;
//               });
//               _startDownload();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               foregroundColor: Color(0xFF7709e4),
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//             child: const Text(
//               'محاولة مرة أخرى',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
