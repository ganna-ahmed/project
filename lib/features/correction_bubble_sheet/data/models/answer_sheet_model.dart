class AnswerSheetResponse {
  final String message;
  final String fileName;

  AnswerSheetResponse({required this.message, required this.fileName});

  factory AnswerSheetResponse.fromJson(Map<String, dynamic> json) {
    return AnswerSheetResponse(
      message: json['message'] ?? '',
      fileName: json['fileName'] ?? '',
    );
  }
}
