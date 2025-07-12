import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/constants.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/utils/app_router.dart';

class ShowAllMaualQuestionsScreen extends StatefulWidget {
  final String doctorId;
  final String courseName;
  final String fileName;

  const ShowAllMaualQuestionsScreen({
    Key? key,
    required this.doctorId,
    required this.courseName,
    required this.fileName,
  }) : super(key: key);

  @override
  _ShowAllMaualQuestionsScreenState createState() =>
      _ShowAllMaualQuestionsScreenState();
}

class _ShowAllMaualQuestionsScreenState
    extends State<ShowAllMaualQuestionsScreen> {
  List<dynamic> questions = [];
  bool isLoading = true;
  String errorMessage = '';
  Map<String, String> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      final url = Uri.parse('$kBaseUrl/Doctor/showAllManualQuestion');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idDoctor': widget.doctorId,
          'course': widget.courseName,
          'file': widget.fileName,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✳️ Response data: $data");
        setState(() {
          questions = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'No questions have been added yet. Please add questions first';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
        backgroundColor: AppColors.ceruleanBlue,
        foregroundColor: AppColors.white,
      ),
      body: Column(
        children: [
          // المحتوى الأساسي
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(
                        child: Text(errorMessage,
                            style: TextStyle(color: Colors.red)))
                    : _buildQuestionsList(),
          ),

          // الزرار في الأسفل
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.go(AppRouter.kHomeView);
                  },
                  icon: Icon(
                    Icons.home,
                    size: 22.sp,
                  ),
                  label: Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2262c6),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    elevation: 5,
                    shadowColor: const Color(0xff2262c6).withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsList() {
    List<dynamic> essayQuestions =
        questions.where((q) => q['type'] == 'Essay').toList();
    List<dynamic> mcqQuestions =
        questions.where((q) => q['type'] == 'MCQ').toList();
    List<dynamic> multiChoiceGroups =
        questions.where((q) => q['type'] == 'Multi-Choice').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionSection('Essay', essayQuestions),
          const SizedBox(height: 16),
          _buildQuestionSection('MCQ', mcqQuestions),
          const SizedBox(height: 16),
          _buildQuestionSection('Multi-Choice', multiChoiceGroups),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildQuestionSection(String title, List<dynamic> sectionQuestions) {
    if (sectionQuestions.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title Questions',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 12),
        if (title == 'Multi-Choice')
          ...sectionQuestions.map((q) => _buildMultiChoiceGroup(q)).toList()
        else
          ...sectionQuestions.map((q) => _buildQuestionCard(q)).toList(),
      ],
    );
  }

  Widget _buildMultiChoiceGroup(dynamic group) {
    final String paragraph = group['paragraph'] ?? '';
    final List<dynamic> subQuestions = group['questions'] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (paragraph.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '📝 $paragraph',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ...subQuestions
              .map((q) => _buildQuestionCard({
                    'type': 'Multi-Choice',
                    'question': q['question'],
                    'choices': q['choices'],
                    'correctAnswer': q['correctAnswer'],
                  }))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(dynamic question) {
    final String questionId = question['id'] ??
        question['_id'] ??
        question['question'].hashCode.toString();
    final bool isExpanded = true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            color: const Color(0xFF18305B),
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: const Color(0xFFEDF2F9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Type: ${question['type'] ?? 'MCQ'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF18305B),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFF18305B),
                ),
              ],
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question: ${question['question'] ?? ''}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  if (question['choices'] != null) ...[
                    const SizedBox(height: 12),
                    ..._buildChoiceOptions(question, questionId),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildChoiceOptions(dynamic question, String questionId) {
    final List<dynamic> choices = question['choices'] ?? [];
    final String correctAnswer = question['correctAnswer'] ?? '';

    return choices.map<Widget>((choice) {
      final bool isSelected = selectedAnswers[questionId] == choice;
      final bool isCorrect = correctAnswer == choice;

      Color backgroundColor;
      Color borderColor;

      if (isSelected) {
        if (isCorrect) {
          backgroundColor = Colors.green.shade100;
          borderColor = Colors.green;
        } else {
          backgroundColor = Colors.red.shade100;
          borderColor = Colors.red;
        }
      } else {
        backgroundColor = const Color(0xFFEDF2F9);
        borderColor = Colors.transparent;
      }

      return GestureDetector(
        onTap: () {
          setState(() {
            selectedAnswers[questionId] = choice;
          });
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Text(
            choice,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      );
    }).toList();
  }
}


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:project/constants.dart';
// import 'package:project/core/constants/colors.dart';

// class ShowAllMaualQuestionsScreen extends StatefulWidget {
//   final String doctorId;
//   final String courseName;
//   final String fileName;

//   const ShowAllMaualQuestionsScreen({
//     Key? key,
//     required this.doctorId,
//     required this.courseName,
//     required this.fileName,
//   }) : super(key: key);

//   @override
//   _ShowAllMaualQuestionsScreenState createState() =>
//       _ShowAllMaualQuestionsScreenState();
// }

// class _ShowAllMaualQuestionsScreenState
//     extends State<ShowAllMaualQuestionsScreen> {
//   List<dynamic> questions = [];
//   bool isLoading = true;
//   String errorMessage = '';

//   Map<String, String> selectedAnswers = {};

//   @override
//   void initState() {
//     super.initState();
//     _fetchQuestions();
//   }

//   Future<void> _fetchQuestions() async {
//     try {
//       final url = Uri.parse('$kBaseUrl/Doctor/showAllManualQuestion');
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'idDoctor': widget.doctorId,
//           'course': widget.courseName,
//           'file': widget.fileName,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print(
//             "📦 Received question types: ${data.map((q) => q['type']).toList()}");

//         List<dynamic> processedQuestions = [];

//         for (var item in data) {
//           if (item['type'] == 'Multi-Choice' && item['questions'] != null) {
//             for (var subQ in item['questions']) {
//               processedQuestions.add({
//                 'type': 'Multi-Choice',
//                 'question': subQ['question'],
//                 'choices': subQ['choices'],
//                 'correctAnswer': subQ['correctAnswer'],
//               });
//             }
//           } else {
//             processedQuestions.add(item);
//           }
//         }

//         setState(() {
//           questions = processedQuestions;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = 'Failed to load questions: ${response.statusCode}';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error: ${e.toString()}';
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Questions'),
//         backgroundColor: AppColors.ceruleanBlue,
//         foregroundColor: AppColors.white,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : errorMessage.isNotEmpty
//               ? Center(
//                   child:
//                       Text(errorMessage, style: TextStyle(color: Colors.red)))
//               : _buildQuestionsList(),
//     );
//   }

//   Widget _buildQuestionsList() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildQuestionSection(
//               'Essay', questions.where((q) => q['type'] == 'Essay').toList()),
//           const SizedBox(height: 16),
//           _buildQuestionSection(
//               'MCQ', questions.where((q) => q['type'] == 'MCQ').toList()),
//           const SizedBox(height: 16),
//           _buildQuestionSection('Multi-Choice',
//               questions.where((q) => q['type'] == 'Multi-Choice').toList()),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuestionSection(String title, List<dynamic> sectionQuestions) {
//     if (sectionQuestions.isEmpty) return const SizedBox();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '$title Questions',
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.blue,
//           ),
//         ),
//         const SizedBox(height: 12),
//         ...sectionQuestions.map((q) => _buildQuestionCard(q)).toList(),
//       ],
//     );
//   }

//   Widget _buildQuestionCard(dynamic question) {
//     final String questionId = question['question'].hashCode.toString();
//     final List<dynamic>? choices = question['choices'];

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           left: BorderSide(color: Colors.blue.shade900, width: 4),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Type: ${question['type']}',
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             question['question'] ?? '',
//             style: const TextStyle(fontSize: 16),
//           ),
//           if (choices != null) ...[
//             const SizedBox(height: 12),
//             ..._buildChoiceOptions(question, questionId),
//           ],
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildChoiceOptions(dynamic question, String questionId) {
//     final List<dynamic> choices = question['choices'] ?? [];
//     final String correctAnswer = question['correctAnswer'] ?? '';

//     return choices.map<Widget>((choice) {
//       final bool isSelected = selectedAnswers[questionId] == choice;
//       final bool isCorrect = correctAnswer == choice;

//       Color backgroundColor;
//       Color borderColor;

//       if (isSelected) {
//         if (isCorrect) {
//           backgroundColor = Colors.green.shade100;
//           borderColor = Colors.green;
//         } else {
//           backgroundColor = Colors.red.shade100;
//           borderColor = Colors.red;
//         }
//       } else {
//         backgroundColor = const Color(0xFFEDF2F9);
//         borderColor = Colors.transparent;
//       }

//       return GestureDetector(
//         onTap: () {
//           setState(() {
//             selectedAnswers[questionId] = choice;
//           });
//         },
//         child: Container(
//           width: double.infinity,
//           margin: const EdgeInsets.only(bottom: 8),
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//           decoration: BoxDecoration(
//             color: backgroundColor,
//             borderRadius: BorderRadius.circular(6),
//             border: Border.all(
//               color: borderColor,
//               width: 1.5,
//             ),
//           ),
//           child: Text(
//             choice.toString(),
//             style: const TextStyle(fontSize: 14),
//           ),
//         ),
//       );
//     }).toList();
//   }
// }
////////////////////////////




// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:project/constants.dart';
// import 'package:project/core/constants/colors.dart';

// class ShowAllMaualQuestionsScreen extends StatefulWidget {
//   final String doctorId;
//   final String courseName;
//   final String fileName;

//   const ShowAllMaualQuestionsScreen({
//     Key? key,
//     required this.doctorId,
//     required this.courseName,
//     required this.fileName,
//   }) : super(key: key);

//   @override
//   _ShowAllMaualQuestionsScreenState createState() =>
//       _ShowAllMaualQuestionsScreenState();
// }

// class _ShowAllMaualQuestionsScreenState
//     extends State<ShowAllMaualQuestionsScreen> {
//   List<dynamic> questions = [];
//   bool isLoading = true;
//   String errorMessage = '';

//   // Map to track selected answers for each question
//   Map<String, String> selectedAnswers = {};

//   @override
//   void initState() {
//     super.initState();
//     _fetchQuestions();
//   }

//   Future<void> _fetchQuestions() async {
//     try {
//       final url = Uri.parse('$kBaseUrl/Doctor/showAllManualQuestion');
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'idDoctor': widget.doctorId,
//           'course': 'magnatic',
//           'file': 'Database 4 year CSE 2025 (1).pdf',
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print("✳️✳️✳️✳️✳️Response data: $data");
//         print(
//             "📦 Received question types: ${data.map((q) => q['type']).toList()}");
//         setState(() {
//           questions = data;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = 'Failed to load questions: ${response.statusCode}';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error: ${e.toString()}';
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Questions'),
//         backgroundColor: AppColors.ceruleanBlue,
//         foregroundColor: AppColors.white,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : errorMessage.isNotEmpty
//               ? Center(
//                   child:
//                       Text(errorMessage, style: TextStyle(color: Colors.red)))
//               : _buildQuestionsList(),
//     );
//   }

//   Widget _buildQuestionsList() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(bottom: 16),
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Questions',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF18305B),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   _buildQuestionSection('Easy Questions',
//                       questions.where((q) => q['type'] == 'Essay').toList()),
//                   const SizedBox(height: 16),
//                   _buildQuestionSection('MCQ Questions',
//                       questions.where((q) => q['type'] == 'MCQ').toList()),
//                   const SizedBox(height: 16),
//                   _buildQuestionSection(
//                       'Multi Choice Questions',
//                       questions
//                           .where((q) => q['type'] == 'Multi-Choice')
//                           .toList()),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: const Center(
//               child: Text(
//                 'Generate AI-Based Questions',
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuestionSection(String title, List<dynamic> sectionQuestions) {
//     if (sectionQuestions.isEmpty) {
//       return Container(); // Don't show empty sections
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//             color: Colors.blue,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 12),
//         ...sectionQuestions
//             .map((question) => _buildQuestionCard(question, title))
//             .toList(),
//       ],
//     );
//   }

//   Widget _buildQuestionCard(dynamic question, String sectionTitle) {
//     final String questionId = question['id'] ??
//         question['_id'] ??
//         question['question'].hashCode.toString();
//     final bool isMultiChoice = question['type'] == 'Multi-Choice' ||
//         sectionTitle == 'Multi Choice Questions';
//     final bool isExpanded = true; // Show all as expanded

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           left: BorderSide(
//             color: const Color(0xFF18305B),
//             width: 4,
//           ),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             color: const Color(0xFFEDF2F9),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Type: ${question['type'] ?? 'MCQ'}',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF18305B),
//                   ),
//                 ),
//                 Icon(
//                   isExpanded
//                       ? Icons.keyboard_arrow_up
//                       : Icons.keyboard_arrow_down,
//                   color: const Color(0xFF18305B),
//                 ),
//               ],
//             ),
//           ),
//           if (isExpanded)
//             Container(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Question: ${question['question'] ?? ''}',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   if (question['choices'] != null) ...[
//                     const SizedBox(height: 12),
//                     ..._buildChoiceOptions(question, questionId),
//                   ],
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildChoiceOptions(dynamic question, String questionId) {
//     final List<dynamic> choices = question['choices'] ?? [];
//     final String correctAnswer = question['correctAnswer'] ?? '';

//     return choices.map<Widget>((choice) {
//       // Check if this choice is selected for this question
//       final bool isSelected = selectedAnswers[questionId] == choice;
//       // Check if this choice is the correct answer
//       final bool isCorrect = correctAnswer == choice;

//       // Determine the colors based on selection state
//       Color backgroundColor;
//       Color borderColor;

//       if (isSelected) {
//         if (isCorrect) {
//           // Selected and correct
//           backgroundColor = Colors.green.shade100;
//           borderColor = Colors.green;
//         } else {
//           // Selected but wrong
//           backgroundColor = Colors.red.shade100;
//           borderColor = Colors.red;
//         }
//       } else {
//         // Not selected
//         backgroundColor = const Color(0xFFEDF2F9);
//         borderColor = Colors.transparent;
//       }

//       return GestureDetector(
//         onTap: () {
//           setState(() {
//             // Store selected answer for this question
//             selectedAnswers[questionId] = choice;
//           });
//         },
//         child: Container(
//           width: double.infinity,
//           margin: const EdgeInsets.only(bottom: 8),
//           decoration: BoxDecoration(
//             color: backgroundColor,
//             borderRadius: BorderRadius.circular(4),
//             border: Border.all(
//               color: borderColor,
//               width: isSelected ? 1.5 : 1,
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//           child: Text(
//             choice,
//             style: TextStyle(
//               color: Colors.black87,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//               fontSize: 14,
//             ),
//           ),
//         ),
//       );
//     }).toList();
//   }
// }
