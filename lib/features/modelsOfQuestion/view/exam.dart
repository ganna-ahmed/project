import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/auth/data/cubits/login_cubit/login_cubit.dart';
import 'package:project/features/create_bubble_sheet/presentation/views/bubble_sheet.dart';

class StartExamPage extends StatefulWidget {
  const StartExamPage({super.key});

  @override
  State<StartExamPage> createState() => _StartExamPageState();
}

class _StartExamPageState extends State<StartExamPage> {
  late String modelName;
  String? doctorId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateRandomModelName();
    _initializeData();
  }

  void _generateRandomModelName() {
    final random = Random();
    String number = '';
    for (int i = 0; i < 10; i++) {
      number += random.nextInt(10).toString();
    }
    modelName = number;
  }

  void _initializeData() {
    // استخدم Future.microtask بدلاً من addPostFrameCallback
    Future.microtask(() {
      if (mounted) {
        _loadDoctorId();
      }
    });
  }

  void _loadDoctorId() {
    try {
      final loginCubit = context.read<LoginCubit>();
      setState(() {
        doctorId = loginCubit.doctorDatabaseId;
        isLoading = false;
      });
    } catch (e) {
      // في حالة حدوث خطأ أثناء قراءة البيانات
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠ Error loading doctor data: $e")),
        );
      }
    }
  }

  Future<void> _handleGetStarted() async {
    if (doctorId == null || doctorId!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠ Doctor ID not found")),
        );
      }
      return;
    }

    final uri = Uri.parse('$kBaseUrl/Doctor/informationModel');
    final newUri = uri.replace(
      queryParameters: {
        'id': doctorId!,
        'modelName': modelName,
      },
    );

    try {
      final response = await http.get(newUri);
      print('Response: ${response.body} - Status: ${response.statusCode}');

      if (!mounted) return; // تأكد من أن الـ widget لسه موجود

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BubbleSheet2Page(
              id: doctorId!,
              modelName: modelName,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("❌ Failed to create exam model: ${response.statusCode}"),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("🚫 Error occurred: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: AppColors.white,
        title: const Text('Create New Exam Model'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : doctorId == null || doctorId!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Doctor ID not found',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('Please login again'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // يمكنك إزالة هذا السطر إذا كنت مش عايز تظهر الـ IDs
                        // Text('Model: $modelName\nDoctor ID: $doctorId'),
                        Image.asset(
                          'assets/images/welcom.png',
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: _handleGetStarted,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'GET STARTED',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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




// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
// import 'package:project/constants.dart';
// import 'package:project/core/constants/colors.dart';
// import 'package:project/features/auth/data/cubits/login_cubit/login_cubit.dart';
// import 'package:project/features/create_bubble_sheet/presentation/views/bubble_sheet.dart';

// class StartExamPage extends StatefulWidget {
//   const StartExamPage({super.key});

//   @override
//   State<StartExamPage> createState() => _StartExamPageState();
// }

// class _StartExamPageState extends State<StartExamPage> {
//   late String modelName;
//   String? doctorId;

//   @override
//   void initState() {
//     super.initState();
//     _generateRandomModelName();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadDoctorId();
//     });
//   }

//   void _generateRandomModelName() {
//     final random = Random();
//     String number = '';
//     for (int i = 0; i < 10; i++) {
//       number += random.nextInt(10).toString();
//     }
//     modelName = number;
//   }

//   void _loadDoctorId() {
//     setState(() {
//       doctorId = context.read<LoginCubit>().doctorDatabaseId;
//     });
//   }

//   Future<void> _handleGetStarted() async {
//     if (doctorId == null || doctorId!.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("⚠ Doctor ID not found")),
//       );
//       return;
//     }

//     final uri = Uri.parse('$kBaseUrl/Doctor/informationModel');
//     final newUri = uri.replace(
//       queryParameters: {
//         'id': doctorId!,
//         'modelName': modelName,
//       },
//     );

//     try {
//       final response = await http.get(newUri);
//       print('🚫🚫🚫${response.body}${response.statusCode}');
//       if (response.statusCode == 200) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BubbleSheet2Page(
//               id: doctorId!,
//               modelName: modelName,
//             ),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   "❌ Failed to create exam model: ${response.statusCode}")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("🚫 Error occurred: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.ceruleanBlue,
//         foregroundColor: AppColors.white,
//         title: const Text('Create New Exam Model'),
//       ),
//       body: doctorId == null
//           ? const Center(child: CircularProgressIndicator())
//           : Center(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('$modelName \n🚫🚫🚫$doctorId'),
//                     Image.asset(
//                       'assets/images/welcom.png',
//                       height: 250,
//                       fit: BoxFit.contain,
//                     ),
//                     const SizedBox(height: 40),
//                     ElevatedButton(
//                       onPressed: _handleGetStarted,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 40,
//                           vertical: 15,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                       child: const Text(
//                         'GET STARTED',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
