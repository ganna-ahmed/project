class QuestionModel {
  final String pdfName;
  final String question;
  final List<String> answers;
  final String correctAnswer;

  QuestionModel({
    required this.pdfName,
    required this.question,
    required this.answers,
    required this.correctAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'pdfName': pdfName,
      'question': question,
      'answer1': answers[0],
      'answer2': answers[1],
      'answer3': answers[2],
      'answer4': answers[3],
      'correctAnswer': correctAnswer,
    };
  }
}
