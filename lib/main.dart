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
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  var _questions = Question.getQuestionList();
  final List<int?> _selectedOptions = List.filled(4, null);
  ScrollController _scrollController = ScrollController();
  int jsonPosition = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Dynamic List App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _currentQuestionIndex + 1, // Show only answered questions
        itemBuilder: (context, index) {
          if (index >= _questions.length) {
            return const SubmitCard();
          } else {
            if (_questions[jsonPosition].questionType == "MultipleChoice") {
              return QuestionCard(
                question: _questions[index],
                onOptionSelected: (selectedOption) {
                  setState(() {
                    _selectedOptions[index] = selectedOption;
                  });
                  // Move to the next question after the current one is answered
                  if (selectedOption != null) {
                    // Check if there are more questions to display
                   /* if (_currentQuestionIndex < _questions.length) {
                      setState(() {
                        _currentQuestionIndex++;
                        //   print("_currentQuestionIndex: $_currentQuestionIndex");
                      });

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToNextPosition();
                      });
                    } else {

                    }*/
                    _moveToNextQuestion();
                  }
                },
                scrollController: _scrollController,
              );
            } else if (_questions[jsonPosition].questionType == "textInput") {
              return TextInputCard(
                question: _questions[index],
                onNextPressed: (){
                  _moveToNextQuestion();
                },
              );
            } else if (_questions[jsonPosition].questionType == "checkBox") {

            } else if (_questions[jsonPosition].questionType == "numberInput") {

            }
          }
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToNextPosition();
        });
      }
    });
  }
}

class TextInputCard extends StatefulWidget {
  final Question question;
  final VoidCallback onNextPressed; // Add this line
  TextInputCard({
    required this.question,
    required this.onNextPressed, // Add this line
  });

  @override
  State<TextInputCard> createState() => _TextInputCardState();
}

class _TextInputCardState extends State<TextInputCard> {
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

class QuestionCard extends StatefulWidget {
  final Question question;
  final ValueChanged<int?> onOptionSelected;
  final ScrollController scrollController; // Add this line'

  QuestionCard({
    required this.question,
    required this.onOptionSelected,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.question.questionText,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          ListView.builder(
            controller: widget.onOptionSelected != null
                ? null
                : widget.scrollController,
            shrinkWrap: true,
            itemCount: widget.question.options.length,
            itemBuilder: (context, index) {
              return OptionItem(
                option: widget.question.options[index],
                onSelected: () {
                  widget.onOptionSelected(index);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final String option;
  final VoidCallback onSelected;

  OptionItem({required this.option, required this.onSelected});

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
  const SubmitCard({super.key});

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
