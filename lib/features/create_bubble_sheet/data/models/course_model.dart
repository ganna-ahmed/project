class CourseModel {
  final String id;
  final String department;
  final String courseName;
  final String courseCode;
  final String courseLevel;
  final String semester;
  final String instructor;
  final String date;
  final String time;
  final String fullMark;
  final String form;
  final String numberOfQuestions;

  CourseModel({
    required this.id,
    required this.department,
    required this.courseName,
    required this.courseCode,
    required this.courseLevel,
    required this.semester,
    required this.instructor,
    required this.date,
    required this.time,
    required this.fullMark,
    required this.form,
    required this.numberOfQuestions,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'] ?? '',
      department: json['Department'] ?? '',
      courseName: json['CourseName'] ?? '',
      courseCode: json['CourseCode'] ?? '',
      courseLevel: json['CourseLevel'] ?? '',
      semester: json['Semester'] ?? '',
      instructor: json['Instructor'] ?? '',
      date: json['Date'] ?? '',
      time: json['Time'] ?? '',
      fullMark: json['FuLLMark'] ?? '',
      form: json['fORm'] ?? '',
      numberOfQuestions: (json['NumberofQuestions'] ?? '').toString(),
    );
  }
}
