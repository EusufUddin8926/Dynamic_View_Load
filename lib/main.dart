import 'package:dynamic_view/model/AnswerModel.dart';
import 'package:flutter/material.dart';
import 'model/Question.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> allQuestions = Question.getQuestionList();
  List<Question> displayedQuestions = [];
  List<AnswerModel> answers = [];
  bool allQuestionsAnswered = false;

  @override
  void initState() {
    super.initState();
    if (allQuestions.isNotEmpty) {
      displayedQuestions.add(allQuestions.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: ListView.builder(
        itemCount: displayedQuestions.length + (allQuestionsAnswered ? 1 : 0),
        // Add space for the Submit button
        itemBuilder: (context, index) {
          if (index < displayedQuestions.length) {
            return QuestionWidget(
              question: displayedQuestions[index],
              onAnswered: _loadNextQuestion,
            );
          } else if (allQuestionsAnswered) {
            return ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                    content: Text(
                      answers.map((a) => "${a.questionText}: ${a.answerText}").join("\n"),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              child: const Text("Submit"),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  void _loadNextQuestion(AnswerModel answer) {
    if (displayedQuestions.isNotEmpty) {
      int currentQuestionId = displayedQuestions.last.referTo;

      setState(() {
        answers.add(answer);
      });

      if (currentQuestionId != -1) {
        Question? nextQuestion = allQuestions.firstWhere((q) => q.id == currentQuestionId);

          setState(() {
            displayedQuestions.add(nextQuestion);
            if (allQuestions.length == displayedQuestions.length) {
              allQuestionsAnswered = true;
            }
          });
        }
      }
  }
}

class QuestionWidget extends StatefulWidget {
  final Question question;
  final Function(AnswerModel) onAnswered;

  const QuestionWidget(
      {super.key, required this.question, required this.onAnswered});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? _selectedOption;
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    switch (widget.question.questionType) {
      case 'MultipleChoice':
        return _buildMultipleChoiceQuestion(widget.question);
      case 'textInput':
        return _buildTextInputQuestion(widget.question);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMultipleChoiceQuestion(Question question) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question.questionText),
          ...question.options
              .map((option) => RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value;
                      });

                      widget.onAnswered(AnswerModel(question.id,
                          question.questionText, _selectedOption!));
                    },
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildTextInputQuestion(Question question) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: question.questionText,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  widget.onAnswered(AnswerModel(question.id,
                      question.questionText, _textEditingController.text));
                },
                child: const Text("Next")),
          ],
        ),
      ),
    );
  }
}
