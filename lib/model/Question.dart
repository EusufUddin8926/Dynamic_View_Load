class Question {
  final String questionText;
  final List<String> options;
  final String questionType;

  Question({
    required this.questionText,
    required this.options,
    required this.questionType,
  });

  static List<Question> getQuestionList(){
    List<Question> _questions = [
      Question(
          questionText: 'What is the capital of France?',
          options: ['Berlin', 'Paris', 'Madrid', 'Rome'],
          questionType: "MultipleChoice"),
      Question(
          questionText:
          'Which programming language is used for Android Development',
          options: [],
          questionType: "textInput"),

      Question(
          questionText: 'Which programming language is your favourite?',
          options: ['Java', 'Dart', 'Python', 'C#'],
          questionType: "checkBox"),

      Question(
          questionText: 'Give the rating for your favourite language?',
          options: [],
          questionType: "numberInput"),
      // Add more questions as needed
    ];
    return _questions;
  }
}