import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/features/question/presentation/views/show_all_maual_questions.dart';
import 'essay_screen.dart';
import 'mcq_screen.dart';
import 'multiChoice_screen.dart';

class ManualQuestionScreen extends StatefulWidget {
  final String courseName;
  final String fileName;
  final String doctorId;

  const ManualQuestionScreen({
    Key? key,
    required this.courseName,
    required this.fileName,
    required this.doctorId,
  }) : super(key: key);

  @override
  State<ManualQuestionScreen> createState() => _ManualQuestionScreenState();
}

class _ManualQuestionScreenState extends State<ManualQuestionScreen>
    with TickerProviderStateMixin {
  bool showOptions = false;

  late final AnimationController _controller;
  late final AnimationController _pulseController;
  late final Animation<Offset> _mcqOffset;
  late final Animation<Offset> _easyOffset;
  late final Animation<Offset> _multiOffset;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _mcqOffset = Tween<Offset>(
      begin: Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 0.4, curve: Curves.easeOut)));

    _easyOffset = Tween<Offset>(
      begin: Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.2, 0.6, curve: Curves.easeOut)));

    _multiOffset = Tween<Offset>(
      begin: Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.4, 0.8, curve: Curves.easeOut)));

    // Start pulse animation
    _pulseController.repeat(reverse: true);
  }

  void toggleMenu() {
    setState(() {
      showOptions = !showOptions;
      if (showOptions) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Widget buildOption(
      String text, Animation<Offset> animation, VoidCallback onTap) {
    return SlideTransition(
      position: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40,
              color: Colors.indigo[900],
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInitialContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Main icon with pulse animation
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFb2e8fa), Color(0xFF004aad)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF004aad).withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.quiz_outlined,
                  size: 60.sp,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),

        SizedBox(height: 40.h),

        // Title
        Text(
          "Question Management",
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: Color(0xFF004aad),
            letterSpacing: 1.2,
          ),
        ),

        SizedBox(height: 16.h),

        // Subtitle
        Text(
          "Create and manage your course questions",
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 60.h),

        // Course info card
        Container(
          margin: EdgeInsets.symmetric(horizontal: 32.w),
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.book_outlined,
                    color: Color(0xFF004aad),
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Course Information",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004aad),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildInfoRow("Course", widget.courseName),
              SizedBox(height: 8.h),
              _buildInfoRow("File", widget.fileName),
            ],
          ),
        ),

        SizedBox(height: 40.h),

        // Get started button
        // Container(
        //   width: 280.w,
        //   height: 56.h,
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [Color(0xFFb2e8fa), Color(0xFF004aad)],
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //     ),
        //     borderRadius: BorderRadius.circular(28),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Color(0xFF004aad).withOpacity(0.3),
        //         blurRadius: 15,
        //         offset: Offset(0, 8),
        //       ),
        //     ],
        //   ),
        //   child: TextButton(
        //     onPressed: toggleMenu,
        //     style: TextButton.styleFrom(
        //       backgroundColor: Colors.transparent,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(28),
        //       ),
        //     ),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Icon(
        //           Icons.add_circle_outline,
        //           color: Colors.white,
        //           size: 24.sp,
        //         ),
        //         SizedBox(width: 12.w),
        //         Text(
        //           "Get Started",
        //           style: TextStyle(
        //             fontSize: 20.sp,
        //             color: Colors.white,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.w,
          child: Text(
            "$label:",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Color(0xFF004aad),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Add Questions",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (showOptions)
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: toggleMenu,
            ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[50]!,
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            Center(
              child: showOptions
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildOption("MCQ", _mcqOffset, () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MCQScreen(
                                        doctorId: widget.doctorId,
                                        courseName: widget.courseName,
                                        fileName: widget.fileName,
                                      )));
                        }),
                        buildOption("Essay", _easyOffset, () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EssayQuestionScreen(
                                        doctorId: widget.doctorId,
                                        courseName: widget.courseName,
                                        fileName: widget.fileName,
                                      )));
                        }),
                        buildOption("Multi Choice", _multiOffset, () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MultiChoiceQuestionsScreen(
                                        courseName: widget.courseName,
                                        fileName: widget.fileName,
                                        doctorId: widget.doctorId,
                                      )));
                        }),
                        SizedBox(height: 50.h),
                        Container(
                          width: 260.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFb2e8fa), Color(0xFF004aad)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          ShowAllMaualQuestionsScreen(
                                            doctorId: widget.doctorId,
                                            courseName: widget.courseName,
                                            fileName: widget.fileName,
                                          )));
                            },
                            child: Text(
                              "show all Questions",
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: buildInitialContent(),
                    ),
            ),

            // Floating action button for options
            if (!showOptions)
              Positioned(
                top: 20.h,
                right: 20.w,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFb2e8fa), Color(0xFF004aad)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF004aad).withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      size: 28.sp,
                      color: Colors.white,
                    ),
                    onPressed: toggleMenu,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project/features/question/presentation/views/show_all_maual_questions.dart';
// import 'essay_screen.dart';
// import 'mcq_screen.dart';
// import 'multiChoice_screen.dart';

// class ManualQuestionScreen extends StatefulWidget {
//   // final String url;
//   // final String title;
//   final String courseName;
//   final String fileName;
//   final String doctorId;

//   const ManualQuestionScreen({
//     Key? key,
//     // required this.url,
//     // required this.title,
//     required this.courseName,
//     required this.fileName,
//     required this.doctorId,
//   }) : super(key: key);

//   @override
//   State<ManualQuestionScreen> createState() => _ManualQuestionScreenState();
// }

// class _ManualQuestionScreenState extends State<ManualQuestionScreen>
//     with TickerProviderStateMixin {
//   bool showOptions = false;

//   late final AnimationController _controller;
//   late final Animation<Offset> _mcqOffset;
//   late final Animation<Offset> _easyOffset;
//   late final Animation<Offset> _multiOffset;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1200),
//     );

//     _mcqOffset = Tween<Offset>(
//       begin: Offset(0, -0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//         parent: _controller, curve: Interval(0.0, 0.4, curve: Curves.easeOut)));

//     _easyOffset = Tween<Offset>(
//       begin: Offset(0, -0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//         parent: _controller, curve: Interval(0.2, 0.6, curve: Curves.easeOut)));

//     _multiOffset = Tween<Offset>(
//       begin: Offset(0, -0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//         parent: _controller, curve: Interval(0.4, 0.8, curve: Curves.easeOut)));
//   }

//   void toggleMenu() {
//     setState(() {
//       showOptions = !showOptions;
//       if (showOptions) {
//         _controller.forward();
//       } else {
//         _controller.reverse();
//       }
//     });
//   }

//   Widget buildOption(
//       String text, Animation<Offset> animation, VoidCallback onTap) {
//     return SlideTransition(
//       position: animation,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20.0),
//         child: GestureDetector(
//           onTap: onTap,
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 40,
//               color: Colors.indigo[900],
//               fontWeight: FontWeight.bold,
//               letterSpacing: 1.2,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         backgroundColor: Color(0xFF004aad),
//         iconTheme: IconThemeData(color: Colors.white),
//         title: Text(
//           "Add Questions",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (showOptions)
//                     buildOption("MCQ", _mcqOffset, () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (_) => MCQScreen(
//                                 doctorId: widget.doctorId,
//                                 courseName: widget.courseName,
//                                 fileName: widget.fileName,
//                               )));
//                     }),
//                   if (showOptions)
//                     buildOption("Essay", _easyOffset, () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (_) => EssayQuestionScreen(
//                                 doctorId: widget.doctorId,
//                                 courseName: widget.courseName,
//                                 fileName: widget.fileName,
//                               )));
//                     }),
//                   if (showOptions)
//                     buildOption("Multi Choice", _multiOffset, () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (_) => MultiChoiceQuestionsScreen(
//                                 courseName: widget.courseName,
//                                 fileName: widget.fileName,
//                                 doctorId: widget.doctorId,
//                               )));
//                     }),
//                   SizedBox(height: 50.h),
//                   if (showOptions)
//                     Container(
//                       width: 260.w,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [Color(0xFFb2e8fa), Color(0xFF004aad)],
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => ShowAllMaualQuestionsScreen(
//                                     doctorId: widget.doctorId,
//                                     courseName: widget.courseName,
//                                     fileName: widget.fileName,
//                                   )));
//                         },
//                         child: Text(
//                           "show all Questions",
//                           style: TextStyle(
//                             fontSize: 24.sp,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: 20,
//               right: 20,
//               child: IconButton(
//                 icon: Icon(
//                   Icons.more_horiz,
//                   size: 38,
//                   color: Color(0xFF004aad),
//                 ),
//                 onPressed: toggleMenu,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
