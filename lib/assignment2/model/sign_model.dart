class SignQuestion {
  final String id;
  final String imagePath; // maps to "question" (e.g., 'drink.png')
  final String answer0;   // maps to "0"
  final String answer1;   // maps to "1"
  final String answer2;   // maps to "2"
  final int correctAnswer; // parsed from "answer" string into an int
  final String category;
  const SignQuestion({
    required this.id,
    required this.imagePath,
    required this.answer0,
    required this.answer1,
    required this.answer2,
    required this.correctAnswer,
    required this.category,
  });
}