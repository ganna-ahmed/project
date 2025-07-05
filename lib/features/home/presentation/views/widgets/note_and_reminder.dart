// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project/features/home/presentation/views/widgets/colors.dart';
// import 'package:project/features/home/presentation/views/widgets/note_item.dart';
// import 'package:project/features/home/presentation/views/widgets/note_model.dart';
// import 'package:project/features/home/presentation/views/widgets/reminder_item.dart';
// import 'package:project/features/home/presentation/views/widgets/reminder_model.dart';
//
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:project/features/home/presentation/views/widgets/section_header.dart';
//
// import 'action_button.dart';
//
// class NotesAndRemindersSection extends StatefulWidget {
//   final bool isDarkMode;
//
//   const NotesAndRemindersSection({Key? key, required this.isDarkMode}) : super(key: key);
//
//   @override
//   State<NotesAndRemindersSection> createState() => _NotesAndRemindersSectionState();
// }
//
// class _NotesAndRemindersSectionState extends State<NotesAndRemindersSection> {
//   List<NoteModel> notes = [];
//   List<ReminderModel> reminders = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Notes and Reminders Action Buttons
//         Row(
//           children: [
//             Expanded(
//               child: ActionButton(
//                 color: CustomColors.lightTeal,
//                 icon: Icons.note_add,
//                 label: "Add Note",
//                 onPressed: _showAddNoteDialog,
//               ),
//             ),
//             SizedBox(width: 15.w),
//             Expanded(
//               child: ActionButton(
//                 color: CustomColors.stoneBlue,
//                 icon: Icons.schedule,
//                 label: "Add Reminder",
//                 onPressed: _showAddReminderDialog,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 25.h),
//
//         // Display Notes and Reminders
//         if (notes.isNotEmpty || reminders.isNotEmpty)
//           Column(
//             children: [
//               // Notes Section
//               if (notes.isNotEmpty) ...[
//                 SectionHeader(
//                   color: CustomColors.lightTeal,
//                   icon: Icons.note,
//                   title: "Notes",
//                 ),
//                 SizedBox(height: 12.h),
//                 ...notes.map((note) => NoteItem(
//                   note: note,
//                   onDelete: () {
//                     setState(() {
//                       notes.remove(note);
//                     });
//                   },
//                   onToggleCompleted: () {
//                     setState(() {
//                       note.isCompleted = !note.isCompleted;
//                     });
//                   },
//                 )),
//                 SizedBox(height: 20.h),
//               ],
//
//               // Reminders Section
//               if (reminders.isNotEmpty) ...[
//                 SectionHeader(
//                   color: CustomColors.stoneBlue,
//                   icon: Icons.alarm,
//                   title: "Reminders",
//                 ),
//                 SizedBox(height: 12.h),
//                 ...reminders
//                     .map((reminder) => ReminderItem(
//                   reminder: reminder,
//                   onDelete: () {
//                     setState(() {
//                       reminders.remove(reminder);
//                     });
//                   },
//                   onToggleCompleted: (val) {
//                     setState(() {
//                       reminder.isCompleted = val ?? false;
//                     });
//                   },
//                 ))
//                     .toList(),
//               ],
//             ],
//           ),
//       ],
//     );
//   }
//
//   void _showAddNoteDialog() {
//     final titleController = TextEditingController();
//     final contentController = TextEditingController();
//     String? imagePath;
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setDialogState) => Dialog(
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.white,
//                   CustomColors.lightTeal.withOpacity(0.05),
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(20.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: CustomColors.lightTeal.withOpacity(0.3),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(24.w),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Header
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(12.w),
//                           decoration: BoxDecoration(
//                             color: CustomColors.lightTeal.withOpacity(0.1),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.note_add,
//                             color: CustomColors.lightTeal,
//                             size: 20.sp,
//                           ),
//                         ),
//                         SizedBox(width: 12.w),
//                         Text(
//                           "Add New Note",
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.bold,
//                             color: CustomColors.lightTeal,
//                           ),
//                         ),
//                         const Spacer(),
//                         IconButton(
//                           onPressed: () => Navigator.pop(context),
//                           icon: const Icon(Icons.close, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20.h),
//
//                     // Title Field
//                     TextField(
//                       controller: titleController,
//                       decoration: InputDecoration(
//                         labelText: "Note Title",
//                         hintText: "Enter note title...",
//                         filled: true,
//                         fillColor: CustomColors.lightTeal.withOpacity(0.05),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: BorderSide(
//                               color: CustomColors.lightTeal.withOpacity(0.3)),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: BorderSide(
//                               color: CustomColors.lightTeal.withOpacity(0.3)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: const BorderSide(
//                               color: CustomColors.lightTeal, width: 2),
//                         ),
//                         prefixIcon:
//                         const Icon(Icons.title, color: CustomColors.lightTeal),
//                       ),
//                     ),
//                     SizedBox(height: 16.h),
//
//                     // Content Field
//                     TextField(
//                       controller: contentController,
//                       maxLines: 4,
//                       decoration: InputDecoration(
//                         labelText: "Note Content",
//                         hintText: "Enter note content...",
//                         filled: true,
//                         fillColor: CustomColors.lightTeal.withOpacity(0.05),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: BorderSide(
//                               color: CustomColors.lightTeal.withOpacity(0.3)),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: BorderSide(
//                               color: CustomColors.lightTeal.withOpacity(0.3)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: const BorderSide(
//                               color: CustomColors.lightTeal, width: 2),
//                         ),
//                         prefixIcon:
//                         const Icon(Icons.notes, color: CustomColors.lightTeal),
//                       ),
//                     ),
//                     SizedBox(height: 16.h),
//
//                     // Image Selection
//                     if (imagePath != null)
//                       Container(
//                         height: 100.h,
//                         width: double.infinity,
//                         margin: EdgeInsets.only(bottom: 16.h),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12.r),
//                           border: Border.all(
//                               color: CustomColors.lightTeal.withOpacity(0.3)),
//                           image: DecorationImage(
//                             image: FileImage(File(imagePath!)),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//
//                     // Image picker button
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: CustomColors.lightTeal.withOpacity(0.3),
//                           style: BorderStyle.solid,
//                         ),
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: TextButton.icon(
//                         onPressed: () async {
//                           final ImagePicker picker = ImagePicker();
//                           final XFile? image = await picker.pickImage(
//                               source: ImageSource.gallery);
//                           if (image != null) {
//                             setDialogState(() {
//                               imagePath = image.path;
//                             });
//                           }
//                         },
//                         icon: const Icon(Icons.image, color: CustomColors.lightTeal),
//                         label: Text(
//                           imagePath != null
//                               ? "Change Image"
//                               : "Add Image (Optional)",
//                           style: const TextStyle(color: CustomColors.lightTeal),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 24.h),
//
//                     // Action Buttons
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             style: TextButton.styleFrom(
//                               padding: EdgeInsets.symmetric(vertical: 16.h),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12.r),
//                                 side: BorderSide(color: Colors.grey[300]!),
//                               ),
//                             ),
//                             child: Text(
//                               "Cancel",
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 12.w),
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   CustomColors.lightTeal,
//                                   CustomColors.lightTeal.withOpacity(0.8),
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (titleController.text.isNotEmpty) {
//                                   final note = NoteModel(
//                                     id: DateTime.now()
//                                         .millisecondsSinceEpoch
//                                         .toString(),
//                                     title: titleController.text,
//                                     content: contentController.text,
//                                     imagePath: imagePath,
//                                     createdAt: DateTime.now(),
//                                     isCompleted: false,
//                                   );
//                                   setState(() {
//                                     notes.add(note);
//                                   });
//                                   Navigator.pop(context);
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.transparent,
//                                 shadowColor: Colors.transparent,
//                                 padding: EdgeInsets.symmetric(vertical: 16.h),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12.r),
//                                 ),
//                               ),
//                               child: const Text(
//                                 "Add Note",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showAddReminderDialog() {
//     final titleController = TextEditingController();
//     final descriptionController = TextEditingController();
//     DateTime selectedDate = DateTime.now();
//     TimeOfDay selectedTime = TimeOfDay.now();
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setDialogState) => Dialog(
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.white,
//                   CustomColors.stoneBlue.withOpacity(0.05),
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(20.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: CustomColors.stoneBlue.withOpacity(0.3),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(24.w),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Header
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(12.w),
//                           decoration: BoxDecoration(
//                             color: CustomColors.stoneBlue.withOpacity(0.1),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.schedule,
//                             color: CustomColors.stoneBlue,
//                             size: 20.sp,
//                           ),
//                         ),
//                         SizedBox(width: 12.w),
//                         Text(
//                           "Add New Reminder",
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.bold,
//                             color: CustomColors.stoneBlue,
//                           ),
//                         ),
//                         const Spacer(),
//                         IconButton(
//                           onPressed: () => Navigator.pop(context),
//                           icon: const Icon(Icons.close, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20.h),
//
//                     // Title Field
//                     TextField(
//                       controller: titleController,
//                       decoration: InputDecoration(
//                         labelText: "Reminder Title",
//                         hintText: "Enter reminder title...",
//                         filled: true,
//                         fillColor: CustomColors.stoneBlue.withOpacity(0.05),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: BorderSide(
//                               color: CustomColors.stoneBlue.withOpacity(0.3)),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: BorderSide(
//                               color: CustomColors.stoneBlue.withOpacity(0.3)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: const BorderSide(
//                               color: CustomColors.stoneBlue, width: 2),
//                         ),
//                         prefixIcon: const Icon(Icons.title, color: CustomColors.stoneBlue),
//                       ),
//                     ),
//                     SizedBox(height: 16.h),
//
//                     // Description Field
//                     TextField(
//                       controller: descriptionController,
//                       maxLines: 3,
//                       decoration: InputDecoration(
//                         labelText: "Description",
//                         hintText: "Enter reminder description...",
//                         filled: true,
//                         fillColor: CustomColors.stoneBlue.withOpacity(0.05),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: BorderSide(
//                               color: CustomColors.stoneBlue.withOpacity(0.3)),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: BorderSide(
//                               color: CustomColors.stoneBlue.withOpacity(0.3)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: const BorderSide(
//                               color: CustomColors.stoneBlue, width: 2),
//                         ),
//                         prefixIcon: const Icon(Icons.description,
//                             color: CustomColors.stoneBlue),
//                       ),
//                     ),
//                     SizedBox(height: 16.h),
//
//                     // Date and Time Selection
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                   color:
//                                   CustomColors.stoneBlue.withOpacity(0.3)),
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                             child: ListTile(
//                               leading: const Icon(Icons.calendar_today,
//                                   color: CustomColors.stoneBlue),
//                               title: Text(
//                                 "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
//                                 style: const TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                               onTap: () async {
//                                 final date = await showDatePicker(
//                                   context: context,
//                                   initialDate: selectedDate,
//                                   firstDate: DateTime.now(),
//                                   lastDate:
//                                   DateTime.now().add(const Duration(days: 365)),
//                                 );
//                                 if (date != null) {
//                                   setDialogState(() {
//                                     selectedDate = date;
//                                   });
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 12.w),
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                   color:
//                                   CustomColors.stoneBlue.withOpacity(0.3)),
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                             child: ListTile(
//                               leading: const Icon(Icons.access_time,
//                                   color: CustomColors.stoneBlue),
//                               title: Text(
//                                 "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}",
//                                 style: const TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                               onTap: () async {
//                                 final time = await showTimePicker(
//                                   context: context,
//                                   initialTime: selectedTime,
//                                 );
//                                 if (time != null) {
//                                   setDialogState(() {
//                                     selectedTime = time;
//                                   });
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 24.h),
//
//                     // Action Buttons
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             style: TextButton.styleFrom(
//                               padding: EdgeInsets.symmetric(vertical: 16.h),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12.r),
//                                 side: BorderSide(color: Colors.grey[300]!),
//                               ),
//                             ),
//                             child: Text(
//                               "Cancel",
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 12.w),
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   CustomColors.stoneBlue,
//                                   CustomColors.stoneBlue.withOpacity(0.8),
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (titleController.text.isNotEmpty) {
//                                   final reminderDateTime = DateTime(
//                                     selectedDate.year,
//                                     selectedDate.month,
//                                     selectedDate.day,
//                                     selectedTime.hour,
//                                     selectedTime.minute,
//                                   );
//                                   final reminder = ReminderModel(
//                                     id: DateTime.now()
//                                         .millisecondsSinceEpoch
//                                         .toString(),
//                                     title: titleController.text,
//                                     description: descriptionController.text,
//                                     reminderDate: reminderDateTime,
//                                     isCompleted: false,
//                                   );
//                                   setState(() {
//                                     reminders.add(reminder);
//                                   });
//                                   Navigator.pop(context);
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.transparent,
//                                 shadowColor: Colors.transparent,
//                                 padding: EdgeInsets.symmetric(vertical: 16.h),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12.r),
//                                 ),
//                               ),
//                               child: const Text(
//                                 "Add Reminder",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }