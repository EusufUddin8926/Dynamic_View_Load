import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/Question.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
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
      options: [],
      questionType: "textInput",
      referTo: "2",
    ),
    Question(
      id: 3,
      questionText: 'Which programming language is your favourite?',
      options: ['Java', 'Dart', 'Python', 'C#'],
      questionType: "checkBox",
      referTo: "4",
    ),
    Question(
      id: 4,
      questionText: 'Give the rating for your favourite language?',
      options: [],
      questionType: "numberInput",
      referTo: "3",
    ),
  ];

  int _currentQuestionIndex = 0;
  List<int?> _selectedOptions = List.filled(4, null);
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Dynamic List App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: _currentQuestionIndex + 1,
        itemBuilder: (context, index) {
          if (index >= _questions.length) {
            return SubmitCard();
          } else {
            if (_questions[index].questionType == "MultipleChoice") {
              return QuestionCard(
                question: _questions[index],
                onOptionSelected: (selectedOption) {
                  setState(() {
                    _selectedOptions[index] = selectedOption;
                  });
                  if (selectedOption != null) {
                    if (_currentQuestionIndex < _questions.length) {
                      setState(() {
                        _currentQuestionIndex++;
                      });
                      WidgetsBinding.instance?.addPostFrameCallback((_) {
                        _scrollToNextPosition();
                      });
                    }
                  }
                },
              );
            } else if (_questions[index].questionType == "textInput") {
              return TextInputCard(
                question: _questions[index],
                onTextChanged: (text) {
                  // Handle text changes, if needed
                },
                onNextPressed: () {
                  _moveToNextQuestion();
                },
              );
            }
          }
          return Container();
        },
      ),
    );
  }

  void _scrollToNextPosition() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _moveToNextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length) {
        _currentQuestionIndex++;
        int nextQuestionIndex = _findQuestionIndex(_questions[_currentQuestionIndex].referTo);
        if (nextQuestionIndex != -1) {
         // _textEditingController.text = _answers[nextQuestionIndex];
        }
      }
    });
  }

  int _findQuestionIndex(String referTo) {
    for (int i = 0; i < _questions.length; i++) {
      if (_questions[i].id.toString() == referTo) {
        return i;
      }
    }
    return -1;
  }
}

class QuestionCard extends StatelessWidget {
  final Question question;
  final ValueChanged<int?> onOptionSelected;

  QuestionCard({
    required this.question,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question.questionText,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: question.options.length,
            itemBuilder: (context, index) {
              return OptionItem(
                option: question.options[index],
                onSelected: () {
                  onOptionSelected(index);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class TextInputCard extends StatefulWidget {
  final Question question;
  final ValueChanged<String?> onTextChanged;
  final VoidCallback onNextPressed;

  TextInputCard({
    required this.question,
    required this.onTextChanged,
    required this.onNextPressed,
  });

  @override
  State<TextInputCard> createState() => _TextInputCardState();
}

class _TextInputCardState extends State<TextInputCard> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question.questionText,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            controller: _textEditingController,
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue),
              ),
              isDense: true,
            ),
            onChanged: (text) {
              widget.onTextChanged(text);
            },
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: MaterialButton(
              onPressed: widget.onNextPressed,
              height: 40,
              minWidth: 100,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text("Next", style: TextStyle(color: Colors.white)),
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final String option;
  final VoidCallback onSelected;

  OptionItem({
    required this.option,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(option),
      onTap: () {
        onSelected();
      },
    );
  }
}

class SubmitCard extends StatefulWidget {
  const SubmitCard({Key? key}) : super(key: key);

  @override
  State<SubmitCard> createState() => _SubmitCardState();
}

class _SubmitCardState extends State<SubmitCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MaterialButton(
              onPressed: () {
                setState(() {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("All Done")));
                });
              },
              child: Text("Submit"),
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))),
        ],
      ),
    );
  }
}