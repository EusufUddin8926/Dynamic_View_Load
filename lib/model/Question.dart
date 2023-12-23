


class Question {
  final int id;
  final String questionText;
  final List<String> options;
  final String questionType;
  final int referTo;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.questionType,
    required this.referTo,
  });

  static List<Question> getQuestionList() {
    List<Question> _questions = [
      Question(
        id: 1,
        questionText: 'What is the capital of France?',
        options: ['Berlin', 'Paris', 'Madrid', 'Rome'],
        questionType: "MultipleChoice",
        referTo: 3,
      ),
      Question(
        id: 2,
        questionText: 'Which programming language is your favourite?',
        options: [],
        questionType: "textInput",
        referTo: -1,
      ),
      Question(
        id: 3,
        questionText: 'Give the rating for your favourite language?',
        options: [],
        questionType: "textInput",
        referTo: 2,
      ),
    ];
    return _questions;
  }
}
