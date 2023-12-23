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
  List<AnswerModel> answerModelList = [];

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
        itemCount: displayedQuestions.length,
        itemBuilder: (context, index) {
          return QuestionWidget(question: displayedQuestions[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadNextQuestion,
        child: const Icon(Icons.navigate_next),
      ),
    );
  }

  void _loadNextQuestion() {
    if (displayedQuestions.isNotEmpty) {
      int currentQuestionId = displayedQuestions.last.referTo;
      if (currentQuestionId != -1) {
        Question? nextQuestion = allQuestions.firstWhere((q) => q.id == currentQuestionId);
        setState(() {
          displayedQuestions.add(nextQuestion);
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("All Done")));
      }
    }
  }
}

class QuestionWidget extends StatefulWidget {
  final Question question;

  const QuestionWidget({super.key, required this.question});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? _selectedOption;

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
          ...question.options.map((option) => RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });

            },
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildTextInputQuestion(Question question) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: question.questionText,
          ),
        ),
      ),
    );
  }
}

