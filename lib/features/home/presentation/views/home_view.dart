
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';
import 'package:project/core/cubits/theme_cubit.dart';
import 'package:project/core/utils/assets.dart';
import 'package:project/features/auth/data/cubits/login_cubit/login_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:project/core/utils/app_router.dart';

import '../../../correction_bubble_sheet/presentation/views/upload_student_paper.dart';
import '../../../question/presentation/views/manual_questions.dart';
import '../../../question/presentation/views/question_bank.dart';
import '../../../update/presentation/view/update_view.dart';

// Custom Colors
class CustomColors {
  static const Color lightTeal = Color(0xff72B7C9);
  static const Color stoneBlue = Color(0xFF507687);
}

// Note Model
class NoteModel {
  String id;
  String title;
  String content;
  String? imagePath;
  DateTime createdAt;
  bool isCompleted;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.imagePath,
    required this.createdAt,
    this.isCompleted = false,
  });
}

// Reminder Model
class ReminderModel {
  String id;
  String title;
  String description;
  DateTime reminderDate;
  bool isCompleted;

  ReminderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.reminderDate,
    this.isCompleted = false,
  });
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String searchText = "";
  final TextEditingController _controller = TextEditingController();

  bool isDarkMode = false;
  List<NoteModel> notes = [];
  List<ReminderModel> reminders = [];
  List<Map<String, dynamic>> filteredSections = [];
  List<Map<String, dynamic>> allSections = [
    {
      'title': 'Update Page',
      'subtitle': 'Update your profile and settings',
      'icon': Icons.update,
      'widget': UpdatePage(),
    },
    {
      'title': 'Manual Exams',
      'subtitle': 'Create and manage manual exams',
      'icon': Icons.quiz,
      'widget': ManualQuestionScreen(
        courseName: '',
        doctorId: '',
        fileName: '',
      ),
    },
    {
      'title': 'Question bank',
      'subtitle': 'Browse and manage question bank',
      'icon': Icons.library_books,
      'widget': QuestionBank(),
    },
    {
      'title': 'correction bubble sheet',
      'subtitle': 'Correct and grade bubble sheets',
      'icon': Icons.assignment_turned_in,
      'widget': CorrectBubbleSheetForStudent(
        fileName: '',
      ),
    },
  ];

  void initState() {
    super.initState();

    filteredSections = allSections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        leading: Container(),
        title: const Text(
          "Home",
          style: TextStyle(color: AppColors.darkBlue),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppColors.darkBlue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsView()),
              );
            },
          ),
          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              if (state is LoginSuccess) {
                return Container(
                  margin: EdgeInsets.only(right: 16.w),
                  child: CircleAvatar(
                    radius: 25.r,
                    backgroundColor: AppColors.darkBlue,
                    child: ClipOval(
                      child: Image.network(
                        state.doctor.image.path,
                        width: 50.w,
                        height: 50.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            AssetsData.profile,
                            width: 50.w,
                            height: 50.h,
                            fit: BoxFit.cover,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  margin: EdgeInsets.only(right: 16.w),
                  child: CircleAvatar(
                    radius: 25.r,
                    backgroundColor: AppColors.darkBlue,
                    child: ClipOval(
                      child: Image.asset(
                        AssetsData.profile,
                        width: 50.w,
                        height: 50.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Search...",
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                prefixIcon: searchText.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.arrow_back,
                      color:
                      isDarkMode ? Colors.white70 : Colors.black45),
                  onPressed: () {
                    setState(() {
                      searchText = '';
                      _controller.clear();
                      filteredSections = allSections;
                    });
                  },
                )
                    : Icon(Icons.search,
                    color: isDarkMode ? Colors.white70 : Colors.black45),

                // 👈 نخلي الـ suffix فاضي أثناء البحث
                suffixIcon: null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              onChanged: (val) {
                setState(() {
                  searchText = val;
                  filteredSections = allSections
                      .where((section) => section['title']
                      .toLowerCase()
                      .contains(val.toLowerCase()))
                      .toList();
                });
              },
            ),
            SizedBox(height: 20.h),

            // Welcome Section - Always show when no search
            if (searchText.isEmpty) ...[
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  if (state is LoginSuccess) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back,",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: isDarkMode
                                ? Colors.white70
                                : AppColors.darkBlue.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          "Dr. ${state.doctor.nameDoctor}",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color:
                            isDarkMode ? Colors.white : AppColors.darkBlue,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Notes and Reminders Section
                        _buildNotesAndRemindersSection(),

                        SizedBox(height: 30.h),
                      ],
                    );
                  }
                  return SizedBox(height: 30.h);
                },
              ),
            ],

            // Search Results or Main Sections Grid
            if (searchText.isNotEmpty)
              _buildSearchResults()
            else
              _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (filteredSections.isEmpty) {
      return Container(
        padding: EdgeInsets.all(40.w),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 48.sp,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16.h),
              Text(
                "No results found",
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Try searching with different keywords",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: filteredSections
          .map((section) => Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isDarkMode ? Colors.grey[800]! : Colors.grey[50]!,
              isDarkMode ? Colors.grey[750]! : Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16.w),
          leading: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.darkBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              section['icon'],
              color: AppColors.darkBlue,
              size: 24.sp,
            ),
          ),
          title: Text(
            section['title'],
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : AppColors.darkBlue,
            ),
          ),
          subtitle: Text(
            section['subtitle'],
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.darkBlue,
            size: 16.sp,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => section['widget'],
              ),
            );
          },
        ),
      ))
          .toList(),
    );
  }

  Widget _buildMainContent() {
    // Since we removed all sections, we'll show a clean main content area
    // You can add new content here or just show the notes and reminders
    return Center(
      child: Column(
        children: [
          if (notes.isEmpty && reminders.isEmpty) ...[
            Container(
              padding: EdgeInsets.all(40.w),
              child: Column(
                children: [
                  Icon(
                    Icons.home_outlined,
                    size: 80.sp,
                    color: AppColors.darkBlue.withOpacity(0.3),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Welcome to your Dashboard",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Start by adding notes and reminders to organize your work",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotesAndRemindersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Notes and Reminders Action Buttons
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CustomColors.lightTeal,
                      CustomColors.lightTeal.withOpacity(0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.lightTeal.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _showAddNoteDialog(),
                  icon: Icon(Icons.note_add, size: 22.sp, color: Colors.white),
                  label: Text("Add Note",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CustomColors.stoneBlue,
                      CustomColors.stoneBlue.withOpacity(0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.stoneBlue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _showAddReminderDialog(),
                  icon: Icon(Icons.schedule, size: 22.sp, color: Colors.white),
                  label: Text("Add Reminder",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 25.h),

        // Display Notes and Reminders
        if (notes.isNotEmpty || reminders.isNotEmpty)
          Column(
            children: [
              // Notes Section
              if (notes.isNotEmpty) ...[
                Row(
                  children: [
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: CustomColors.lightTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                            color: CustomColors.lightTeal.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.note,
                              color: CustomColors.lightTeal, size: 16.sp),
                          SizedBox(width: 6.w),
                          Text(
                            "Notes",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.lightTeal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                ...notes.map((note) => _buildNoteItem(note)).toList(),
                SizedBox(height: 20.h),
              ],

              // Reminders Section
              if (reminders.isNotEmpty) ...[
                Row(
                  children: [
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: CustomColors.stoneBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                            color: CustomColors.stoneBlue.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.alarm,
                              color: CustomColors.stoneBlue, size: 16.sp),
                          SizedBox(width: 6.w),
                          Text(
                            "Reminders",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.stoneBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                ...reminders
                    .map((reminder) => _buildReminderItem(reminder))
                    .toList(),
              ],
            ],
          ),
      ],
    );
  }

  Widget _buildNoteItem(NoteModel note) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: note.isCompleted
              ? [Colors.grey[100]!, Colors.grey[50]!]
              : [
            CustomColors.lightTeal.withOpacity(0.08),
            CustomColors.lightTeal.withOpacity(0.03)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: note.isCompleted
              ? Colors.grey[300]!
              : CustomColors.lightTeal.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: note.isCompleted
                ? Colors.grey.withOpacity(0.1)
                : CustomColors.lightTeal.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  note.isCompleted = !note.isCompleted;
                });
              },
              child: Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: note.isCompleted
                      ? CustomColors.lightTeal
                      : Colors.transparent,
                  border: Border.all(
                    color:
                    note.isCompleted ? CustomColors.lightTeal : Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: note.isCompleted
                    ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                    : null,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      decoration:
                      note.isCompleted ? TextDecoration.lineThrough : null,
                      color: note.isCompleted
                          ? Colors.grey
                          : CustomColors.lightTeal,
                    ),
                  ),
                  if (note.content.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Text(
                      note.content,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color:
                        note.isCompleted ? Colors.grey : Colors.grey[700],
                        decoration: note.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        height: 1.3,
                      ),
                    ),
                  ],
                  if (note.imagePath != null) ...[
                    SizedBox(height: 10.h),
                    Container(
                      height: 70.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                            color: CustomColors.lightTeal.withOpacity(0.3)),
                        image: DecorationImage(
                          image: FileImage(File(note.imagePath!)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    notes.remove(note);
                  });
                },
                icon:
                Icon(Icons.delete_outline, color: Colors.red, size: 22.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderItem(ReminderModel reminder) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: reminder.isCompleted
              ? [Colors.grey[100]!, Colors.grey[50]!]
              : [
            CustomColors.stoneBlue.withOpacity(0.08),
            CustomColors.stoneBlue.withOpacity(0.03)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: reminder.isCompleted
              ? Colors.grey[300]!
              : CustomColors.stoneBlue.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: reminder.isCompleted
                ? Colors.grey.withOpacity(0.1)
                : CustomColors.stoneBlue.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: reminder.isCompleted
                    ? Colors.grey[400]
                    : CustomColors.stoneBlue,
                shape: BoxShape.circle,
              ),
              child: Checkbox(
                value: reminder.isCompleted,
                onChanged: (val) {
                  setState(() {
                    reminder.isCompleted = val ?? false;
                  });
                },
                activeColor: Colors.transparent,
                checkColor: Colors.white,
                side: BorderSide.none,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      decoration: reminder.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: reminder.isCompleted
                          ? Colors.grey
                          : CustomColors.stoneBlue,
                    ),
                  ),
                  if (reminder.description.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Text(
                      reminder.description,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: reminder.isCompleted
                            ? Colors.grey
                            : Colors.grey[700],
                        decoration: reminder.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        height: 1.3,
                      ),
                    ),
                  ],
                  SizedBox(height: 8.h),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: reminder.isCompleted
                          ? Colors.grey[300]
                          : CustomColors.stoneBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: reminder.isCompleted
                            ? Colors.grey[400]!
                            : CustomColors.stoneBlue.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14.sp,
                          color: reminder.isCompleted
                              ? Colors.grey
                              : CustomColors.stoneBlue,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "${reminder.reminderDate.day}/${reminder.reminderDate.month}/${reminder.reminderDate.year} at ${reminder.reminderDate.hour.toString().padLeft(2, '0')}:${reminder.reminderDate.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: reminder.isCompleted
                                ? Colors.grey
                                : CustomColors.stoneBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    reminders.remove(reminder);
                  });
                },
                icon:
                Icon(Icons.delete_outline, color: Colors.red, size: 22.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String? imagePath;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => StatefulBuilder(
            builder: (context, setDialogState) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      CustomColors.lightTeal.withOpacity(0.05)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.lightTeal.withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color:
                                CustomColors.lightTeal.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.note_add,
                                color: CustomColors.lightTeal,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "Add New Note",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.lightTeal,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.close, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // Title Field
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: "Note Title",
                            hintText: "Enter note title...",
                            filled: true,
                            fillColor:
                            CustomColors.lightTeal.withOpacity(0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                  color: CustomColors.lightTeal
                                      .withOpacity(0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                  color: CustomColors.lightTeal
                                      .withOpacity(0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                  color: CustomColors.lightTeal, width: 2),
                            ),
                            prefixIcon: Icon(Icons.title,
                                color: CustomColors.lightTeal),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Content Field
                        TextField(
                          controller: contentController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: "Note Content",
                            hintText: "Enter note content...",
                            filled: true,
                            fillColor:
                            CustomColors.lightTeal.withOpacity(0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                  color: CustomColors.lightTeal
                                      .withOpacity(0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                  color: CustomColors.lightTeal
                                      .withOpacity(0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                  color: CustomColors.lightTeal, width: 2),
                            ),
                            prefixIcon: Icon(Icons.notes,
                                color: CustomColors.lightTeal),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Image Selection
                        if (imagePath != null)
                          Container(
                            height: 100.h,
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 16.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                  color: CustomColors.lightTeal
                                      .withOpacity(0.3)),
                              image: DecorationImage(
                                image: FileImage(File(imagePath!)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                        // Image picker button
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                              CustomColors.lightTeal.withOpacity(0.3),
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: TextButton.icon(
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (image != null) {
                                setDialogState(() {
                                  imagePath = image.path;
                                });
                              }
                            },
                            icon: Icon(Icons.image,
                                color: CustomColors.lightTeal),
                            label: Text(
                              imagePath != null
                                  ? "Change Image"
                                  : "Add Image (Optional)",
                              style:
                              TextStyle(color: CustomColors.lightTeal),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  padding:
                                  EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12.r),
                                    side: BorderSide(
                                        color: Colors.grey[300]!),
                                  ),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      CustomColors.lightTeal,
                                      CustomColors.lightTeal
                                          .withOpacity(0.8)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (titleController.text.isNotEmpty) {
                                      final note = NoteModel(
                                        id: DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                        title: titleController.text,
                                        content: contentController.text,
                                        imagePath: imagePath,
                                        createdAt: DateTime.now(),
                                      );
                                      setState(() {
                                        notes.add(note);
                                      });
                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: Text(
                                    "Add Note",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }

  void _showAddReminderDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  CustomColors.stoneBlue.withOpacity(0.05)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: CustomColors.stoneBlue.withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: CustomColors.stoneBlue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.schedule,
                            color: CustomColors.stoneBlue,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          "Add New Reminder",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.stoneBlue,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Title Field
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Reminder Title",
                        hintText: "Enter reminder title...",
                        filled: true,
                        fillColor: CustomColors.stoneBlue.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                              color: CustomColors.stoneBlue.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                              color: CustomColors.stoneBlue.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                              color: CustomColors.stoneBlue, width: 2),
                        ),
                        prefixIcon:
                        Icon(Icons.title, color: CustomColors.stoneBlue),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Description Field
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Description",
                        hintText: "Enter reminder description...",
                        filled: true,
                        fillColor: CustomColors.stoneBlue.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                              color: CustomColors.stoneBlue.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                              color: CustomColors.stoneBlue.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                              color: CustomColors.stoneBlue, width: 2),
                        ),
                        prefixIcon: Icon(Icons.description,
                            color: CustomColors.stoneBlue),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Date and Time Selection
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                  CustomColors.stoneBlue.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.calendar_today,
                                  color: CustomColors.stoneBlue),
                              title: Text(
                                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime.now(),
                                  lastDate:
                                  DateTime.now().add(Duration(days: 365)),
                                );
                                if (date != null) {
                                  setDialogState(() {
                                    selectedDate = date;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                  CustomColors.stoneBlue.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.access_time,
                                  color: CustomColors.stoneBlue),
                              title: Text(
                                "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime,
                                );
                                if (time != null) {
                                  setDialogState(() {
                                    selectedTime = time;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                side: BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  CustomColors.stoneBlue,
                                  CustomColors.stoneBlue.withOpacity(0.8)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (titleController.text.isNotEmpty) {
                                  final reminderDateTime = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedTime.hour,
                                    selectedTime.minute,
                                  );
                                  final reminder = ReminderModel(
                                    id: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    reminderDate: reminderDateTime,
                                  );
                                  setState(() {
                                    reminders.add(reminder);
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                "Add Reminder",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDarkMode ? Colors.white : Colors.black87,
              size: 20.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2196F3),
                    const Color(0xFF1976D2),
                  ],
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2196F3).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Preferences",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Customize your experience",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Settings Cards
            _buildSettingsCard(
              context: context,
              isDarkMode: isDarkMode,
              icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
              title: isDarkMode ? "Light Mode" : "Dark Mode",
              subtitle: "Toggle between light and dark theme",
              trailing: _buildCustomSwitch(
                value: isDarkMode,
                onChanged: (val) {
                  context.read<ThemeCubit>().toggleTheme(val);
                },
              ),
            ),

            SizedBox(height: 15.h),

            _buildSettingsCard(
              context: context,
              isDarkMode: isDarkMode,
              icon: Icons.notifications_outlined,
              title: "Notifications",
              subtitle: "Enable or disable push notifications",
              trailing: _buildCustomSwitch(
                value: notificationsEnabled,
                onChanged: (val) {
                  setState(() {
                    notificationsEnabled = val;
                  });
                },
              ),
            ),

            SizedBox(height: 15.h),

            _buildSettingsCard(
              context: context,
              isDarkMode: isDarkMode,
              icon: Icons.language_outlined,
              title: "Language",
              subtitle: "Change app language",
              trailing: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: const Color(0xFF2196F3),
                ),
              ),
              onTap: () {
                _showLanguageDialog(context, isDarkMode);
              },
            ),

            SizedBox(height: 30.h),

            // Logout Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: () => _showLogoutDialog(context, isDarkMode),
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.logout_outlined,
                            color: Colors.red,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                "Sign out of your account",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.sp,
                          color: Colors.red.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required BuildContext context,
    required bool isDarkMode,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF2196F3),
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60.w,
        height: 32.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: value ? const Color(0xFF2196F3) : Colors.grey[300],
          boxShadow: [
            BoxShadow(
              color: value
                  ? const Color(0xFF2196F3).withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 28.w,
            height: 28.h,
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.language,
                color: const Color(0xFF2196F3),
                size: 24.sp,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              "Coming Soon",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          "Language settings will be available in the next update.",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3).withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              "OK",
              style: TextStyle(
                color: const Color(0xFF2196F3),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.logout,
                color: Colors.red,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              "Logout",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to logout from your account?",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              // مسح البيانات المحفوظة (لو موجودة)
              // SharedPreferences.getInstance().then((prefs) => prefs.clear());

              // لو عندك LoginCubit للـ logout
              // context.read<LoginCubit>().logout();

              // استخدام GoRouter للخروج والرجوع للـ Login
              context.go(AppRouter.kLoginView);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Logged out successfully"),
                  backgroundColor: const Color(0xFF2196F3),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project/core/constants/colors.dart';
// import 'package:project/features/auth/data/cubits/login_cubit/login_cubit.dart';
// import 'package:project/features/home/presentation/views/widgets/empty_state.dart';
// import 'package:project/features/home/presentation/views/widgets/home_search_field.dart';
// import 'package:project/features/home/presentation/views/widgets/search_result.dart';
// import 'package:project/features/home/presentation/views/widgets/settings_view.dart';
// import 'package:project/features/home/presentation/views/widgets/welcome.dart';
//
// class HomeView extends StatefulWidget {
//   const HomeView({Key? key}) : super(key: key);
//
//   @override
//   State<HomeView> createState() => _HomeViewState();
// }
//
// class _HomeViewState extends State<HomeView> {
//   String searchText = "";
//   final TextEditingController _controller = TextEditingController();
//
//   // Add lists for notes and reminders
//   List<String> notes = [];
//   List<String> reminders = [];
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         centerTitle: true,
//         leading: Container(),
//         title: const Text(
//           "Home",
//           style: TextStyle(color: AppColors.darkBlue),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings, color: AppColors.darkBlue),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const SettingsView()),
//               );
//             },
//           ),
//           BlocBuilder<LoginCubit, LoginState>(
//             builder: (context, state) {
//               Widget avatar = const CircleAvatar(
//                 radius: 25,
//                 backgroundColor: AppColors.darkBlue,
//               );
//
//               if (state is LoginSuccess) {
//                 avatar = CircleAvatar(
//                   radius: 25.r,
//                   backgroundColor: AppColors.darkBlue,
//                   child: ClipOval(
//                     child: Image.network(
//                       state.doctor.image.path,
//                       width: 50.w,
//                       height: 50.h,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return const Icon(Icons.error);
//                       },
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return const CircularProgressIndicator();
//                       },
//                     ),
//                   ),
//                 );
//               }
//
//               return avatar;
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(25.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Search Field
//             HomeSearchField(
//               controller: _controller,
//               isDarkMode: isDarkMode,
//               onChanged: (val) {
//                 setState(() {
//                   searchText = val;
//                 });
//               },
//               onClearSearch: () {
//                 setState(() {
//                   searchText = '';
//                   _controller.clear();
//                 });
//               },
//               searchText: searchText,
//             ),
//             SizedBox(height: 20.h),
//
//             // Conditional Content
//             if (searchText.isEmpty) ...[
//               // Welcome Section
//               BlocBuilder<LoginCubit, LoginState>(
//                 builder: (context, state) {
//                   if (state is LoginSuccess) {
//                     return WelcomeSection(
//                         doctorName: state.doctor.nameDoctor,
//                         isDarkMode: isDarkMode
//                     );
//                   } else {
//                     return const SizedBox.shrink();
//                   }
//                 },
//               ),
//               SizedBox(height: 20.h),
//               // Main Content Section
//               _buildMainContent(),
//             ] else if (searchText.isNotEmpty)
//               SearchResultList(searchText: searchText, isDarkMode: isDarkMode)
//             else
//               EmptyStateDashboard(),
//           ],
//         ),
//       ),
//
//     );
//   }
//
//   Widget _buildMainContent() {
//     return Column(
//       children: [
//         // Show welcome message only when both lists are empty
//         if (notes.isEmpty && reminders.isEmpty) ...[
//           Center(
//             child: Container(
//               padding: EdgeInsets.all(40.w),
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.home_outlined,
//                     size: 80.sp,
//                     color: AppColors.darkBlue.withOpacity(0.3),
//                   ),
//                   SizedBox(height: 20.h),
//                   Text(
//                     "Welcome to your Dashboard",
//                     style: TextStyle(
//                       fontSize: 20.sp,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.darkBlue,
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                   Text(
//                     "Start by adding notes and reminders to organize your work",
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: Colors.grey[600],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//
//         // Show notes section when there are notes
//         if (notes.isNotEmpty) ...[
//           _buildSectionHeader("Notes", Icons.note),
//           SizedBox(height: 10.h),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: notes.length,
//             itemBuilder: (context, index) {
//               return _buildItemCard(notes[index], index, true);
//             },
//           ),
//           SizedBox(height: 20.h),
//         ],
//
//         // Show reminders section when there are reminders
//         if (reminders.isNotEmpty) ...[
//           _buildSectionHeader("Reminders", Icons.alarm),
//           SizedBox(height: 10.h),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: reminders.length,
//             itemBuilder: (context, index) {
//               return _buildItemCard(reminders[index], index, false);
//             },
//           ),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildSectionHeader(String title, IconData icon) {
//     return Row(
//       children: [
//         Icon(icon, color: AppColors.darkBlue, size: 20.sp),
//         SizedBox(width: 8.w),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.bold,
//             color: AppColors.darkBlue,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildItemCard(String content, int index, bool isNote) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 10.h),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.r),
//       ),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: AppColors.darkBlue.withOpacity(0.1),
//           child: Icon(
//             isNote ? Icons.note : Icons.alarm,
//             color: AppColors.darkBlue,
//           ),
//         ),
//         title: Text(
//           content,
//           style: TextStyle(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         trailing: IconButton(
//           icon: const Icon(Icons.delete_outline, color: Colors.red),
//           onPressed: () {
//             _showDeleteDialog(index, isNote);
//           },
//         ),
//       ),
//     );
//   }
//
//   void _showDeleteDialog(int index, bool isNote) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Delete ${isNote ? 'Note' : 'Reminder'}'),
//         content: Text('Are you sure you want to delete this ${isNote ? 'note' : 'reminder'}?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 if (isNote) {
//                   notes.removeAt(index);
//                 } else {
//                   reminders.removeAt(index);
//                 }
//               });
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Delete', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showAddItemDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         String selectedType = 'note';
//         TextEditingController dialogController = TextEditingController();
//
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return AlertDialog(
//               title: Row(
//                 children: [
//                   Icon(
//                     selectedType == 'note' ? Icons.note : Icons.alarm,
//                     color: AppColors.darkBlue,
//                   ),
//                   SizedBox(width: 10.w),
//                   const Text('Add New Item'),
//                 ],
//               ),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   DropdownButtonFormField<String>(
//                     value: selectedType,
//                     decoration: const InputDecoration(
//                       labelText: 'Type',
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: (String? value) {
//                       setDialogState(() {
//                         selectedType = value!;
//                       });
//                     },
//                     items: const [
//                       DropdownMenuItem(value: 'note', child: Text('📝 Note')),
//                       DropdownMenuItem(value: 'reminder', child: Text('⏰ Reminder')),
//                     ],
//                   ),
//                   SizedBox(height: 15.h),
//                   TextField(
//                     controller: dialogController,
//                     decoration: InputDecoration(
//                       labelText: 'Enter your ${selectedType}...',
//                       border: const OutlineInputBorder(),
//                       hintText: selectedType == 'note'
//                           ? 'Write your note here...'
//                           : 'What do you want to be reminded of?',
//                     ),
//                     maxLines: 3,
//                     maxLength: 200,
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (dialogController.text.trim().isNotEmpty) {
//                       setState(() {
//                         if (selectedType == 'note') {
//                           notes.add(dialogController.text.trim());
//                         } else {
//                           reminders.add(dialogController.text.trim());
//                         }
//                       });
//                       Navigator.pop(context);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('${selectedType == 'note' ? 'Note' : 'Reminder'} added successfully!'),
//                           backgroundColor: AppColors.darkBlue,
//                         ),
//                       );
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkBlue),
//                   child: const Text('Add', style: TextStyle(color: Colors.white)),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }