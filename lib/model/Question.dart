class Question {
  final int id;
  final String questionText;
  final List<String> options;
  final String questionType;
  final String referTo;

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
        referTo: "3",
      ),
      Question(
        id: 2,
        questionText: 'Which programming language is used for Android Development',
        options: ['Java', 'Dart', 'Python', 'C#'],
        questionType: "textInput",
        referTo: "4",
      ),
      Question(
        id: 3,
        questionText: 'Which programming language is your favourite?',
        options: [],
        questionType: "textInput",
        referTo: "2",
      ),
      Question(
        id: 4,
        questionText: 'Give the rating for your favourite language?',
        options: [],
        questionType: "numberInput",
        referTo: "Submit",
      ),
      // Add more questions as needed
    ];
    return _questions;
  }
}
