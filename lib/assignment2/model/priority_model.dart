// lib/assignment2/model/priority_model.dart

class PriorityQuestion {
  final String id;
  final String imagePath;
  final String answer0;
  final String answer1;
  final String answer2;
  final int correctAnswer;
  final String category; // Added category field

  const PriorityQuestion({
    required this.id,
    required this.imagePath,
    required this.answer0,
    required this.answer1,
    required this.answer2,
    required this.correctAnswer,
    required this.category, // Added to constructor
  });

}