import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/features/auth/data/cubits/login_cubit/login_cubit.dart';
import 'package:project/features/create_bubble_sheet/presentation/views/bubble_sheet.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class StartExamPage extends StatefulWidget {
  const StartExamPage({Key? key}) : super(key: key);

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
      if (mounted) {
        setState(() => isLoading = false);
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
      if (!mounted) return;

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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Determine if the screen is wide enough to be considered a "large" screen
          bool isLargeScreen = constraints.maxWidth > 600;

          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isLargeScreen ? 48.w : 24.w),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/getsart.png',
                      height: isLargeScreen ? 320.h : 260.h,
                      width: isLargeScreen ? 320.w : 260.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: isLargeScreen ? 40.h : 30.h),
                    Text(
                      'Create Your Exam Model',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isLargeScreen ? 26.sp : 22.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainerTitle, // استخدام اللون المخصص
                      ),
                    ),
                    SizedBox(height: isLargeScreen ? 20.h : 12.h),
                    Text(
                      'Easily generate and customize your own exam models with our smart tools. Add questions, shuffle them, and print bubble sheets — all in one place.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isLargeScreen ? 16.sp : 14.sp,
                        color: colorScheme.onSurfaceDescription,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: isLargeScreen ? 50.h : 40.h),
                    SizedBox(
                      width: isLargeScreen ? 280.w : 220.w,
                      child: ElevatedButton(
                        onPressed: _handleGetStarted,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2B60EC),
                          padding: EdgeInsets.symmetric(
                              vertical: isLargeScreen ? 20.h : 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: isLargeScreen ? 18.sp : 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

extension CustomColorScheme on ColorScheme {
  // تعريف لون مخصص لعنوان الصفحة
  Color get onPrimaryContainerTitle => brightness == Brightness.light
      ? Colors.black87 // لون أسود تقريبًا في الـ Light Mode
      : Colors.white; // لون أبيض في الـ Dark Mode

  // تعريف لون مخصص لوصف التطبيق
  Color get onSurfaceDescription => brightness == Brightness.light
      ? Colors.black54 // لون رمادي داكن في الـ Light Mode
      : Colors.grey[400]!; // لون رمادي فاتح في الـ Dark Mode
}