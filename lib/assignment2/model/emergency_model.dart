// lib/assignment2/model/emergency_model.dart

class EmergencyQuestion {
  final int id;
  final String question;
  final String answer1;
  final String answer2;
  final String answer3;
  final int correctAnswer;
  final String category;

  const EmergencyQuestion({
    required this.id,
    required this.question,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.correctAnswer,
    required this.category,
  });

}