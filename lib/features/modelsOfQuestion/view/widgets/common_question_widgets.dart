import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/core/constants/colors.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../infopage.dart';

// Build empty section placeholder
Widget buildEmptySection(String title) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(10.r),
      border: Border(
        left: BorderSide(
          color: AppColors.ceruleanBlue,
          width: 5.w,
        ),
      ),
    ),
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.ceruleanBlue,
      ),
    ),
  );
}

Widget _buildQuestion(dynamic question, String type, bool isSelected,
    Function(dynamic, String) toggleSelection) {
  return Container(
    margin: EdgeInsets.only(bottom: 16.h),
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.r),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: isSelected,
          onChanged: (_) => toggleSelection(question, type),
          activeColor: AppColors.ceruleanBlue,
        ),
        Expanded(
          child: Text(
            question['question'] ?? 'No question text',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        )],
        ),
        if (question['options'] != null && question['options'] is List) ...[
          SizedBox(height: 8.h),
          ...List.generate(
            (question['options'] as List).length,
                (index) {
              final option = question['options'][index];
              return Padding(
                padding: EdgeInsets.only(left: 30.w, top: 4.h),
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  margin: EdgeInsets.only(bottom: 5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf8faff),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    option.toString(),
                    style: TextStyle(fontSize: 14.sp),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              );
            },
          ),
        ],
      ],
    ),
  );
}

Widget _buildEssayQuestion(dynamic question, bool isSelected,
    Function(dynamic, String) toggleSelection) {
  return Container(
    margin: EdgeInsets.only(bottom: 16.h),
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.r),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Checkbox(
      value: isSelected,
      onChanged: (_) => toggleSelection(question, 'essay'),
      activeColor: AppColors.ceruleanBlue,
    ),
    const Icon(Icons.edit, size: 20),
    SizedBox(width: 10.w),
    Expanded(
      child: Text(
        question['question'] ?? 'No question text',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
    )],
    ),
  );
}

void showErrorAlert(BuildContext context, String title, String message) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.error,
    title: title,
    text: message,
    confirmBtnText: 'OK',
    cancelBtnText: 'Go Back',
    showCancelBtn: true,
    onCancelBtnTap: () {
      Navigator.pop(context); // إغلاق التنبيه
      Navigator.pop(context); // العودة للصفحة السابقة
    },
    onConfirmBtnTap: () {
      Navigator.pop(context); // إغلاق التنبيه فقط
    },
  );
}

void showSuccessDialog(BuildContext context, String idDoctor,
    String modelName, String courseName) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          backgroundColor: AppColors.ceruleanBlue,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
      ),
      content: const Text(
      'Questions added to the exam successfully!',
      style: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      ),
          );},
  );

  Future.delayed(const Duration(seconds: 1), () {
    Navigator.of(context).pop(); // إغلاق الرسالة أولًا
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InfoPage(
          idDoctor: idDoctor,
          modelName: modelName,
          courseName: courseName,
        ),
      ),
    );
  });
}