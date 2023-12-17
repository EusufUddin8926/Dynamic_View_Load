class Question {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });

  static List<Question> getQuestionList(){
    List<Question> _questions = [
      Question(
        questionText: 'What is the capital of France?',
        options: ['Berlin', 'Paris', 'Madrid', 'Rome'],
        correctOptionIndex: 1,
      ),
      Question(
        questionText: 'Which programming language is Flutter based on?',
        options: ['Java', 'Dart', 'Python', 'C#'],
        correctOptionIndex: 1,
      ),

      Question(
        questionText: 'Which programming language is Flutter based on1?',
        options: ['Java', 'Dart', 'Python', 'C#'],
        correctOptionIndex: 1,
      ),

      Question(
        questionText: 'Which programming language is Flutter based on2?',
        options: ['Java', 'Dart', 'Python', 'C#'],
        correctOptionIndex: 1,
      ),
      // Add more questions as needed
    ];
    return _questions;
  }
}