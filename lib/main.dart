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

  var _questions = Question.getQuestionList();

  int _currentQuestionIndex = 0;
  List<int?> _selectedOptions = List.filled(4, null);
  ScrollController _scrollController = ScrollController();

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
        title: Text(
          'Flutter Dynamic List App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        addAutomaticKeepAlives: true,
        itemCount: _currentQuestionIndex + 1,
        itemBuilder: (context, index) {
          if (index >= _questions.length) {
            return SubmitCard();
          } else {
            return buildQuestionWidget(_questions[index]);
          }
        },
      ),
    );
  }

  Widget buildQuestionWidget(Question question) {
    print("Question id: ${question.id}");
    switch (question.questionType) {
      case "MultipleChoice":
        return QuestionCard(
          question: question,
          onOptionSelected: (selectedOption) {
            setState(() {
              _selectedOptions[_currentQuestionIndex] = selectedOption;
            });
            if (selectedOption != null) {
              _moveToNextQuestion(question.referTo);
            }
          },
          scrollController: _scrollController,
        );
      case "textInput":
        return TextInputCard(
          question: question,
          onTextChanged: (text) {
            // Handle text changes, if needed
          },
          onNextPressed: () {
            _moveToNextQuestion(question.referTo);
          },
        );
      case "checkBox":
      // Handle checkBox case
        break;
      case "numberInput":
        return NumberInputCard(
          question: question,
          onTextChanged: (number) {
            // Handle number changes, if needed
          },
          onNextPressed: () {
            _moveToNextQuestion(question.referTo);
          },
        );
    }
    return Container();
  }

  void _scrollToNextPosition() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _moveToNextQuestion(String referTo) {
    int nextQuestionIndex = _findQuestionIndex(referTo);

    print("Next Question index is ${nextQuestionIndex}");
    if (nextQuestionIndex != -1) {
      setState(() {
        _currentQuestionIndex = nextQuestionIndex;
        _scrollToNextPosition();
      });
    } else if (referTo == "Submit") {
      // Handle the case where the next question is the Submit screen
      setState(() {
        _currentQuestionIndex++;
        _scrollToNextPosition();
      });
    } else {
      print("Next question not found for referTo: $referTo");
    }
  }

  int _findQuestionIndex(String referTo) {
    if (referTo == "Submit") {
      return _questions.length;
    }

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
  final ScrollController scrollController;

  QuestionCard({
    required this.question,
    required this.onOptionSelected,
    required this.scrollController,
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
            controller: scrollController,
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
  final ValueChanged<int?> onTextChanged;
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
    // Create a new instance of TextEditingController for each TextInputCard
    _textEditingController = TextEditingController();

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
              widget.onTextChanged(text as int?);
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



class NumberInputCard extends StatefulWidget {
  final Question question;
  final ValueChanged<String?> onTextChanged;
  final VoidCallback onNextPressed;

  NumberInputCard({
    required this.question,
    required this.onTextChanged,
    required this.onNextPressed,
  });

  @override
  _NumberInputCardState createState() => _NumberInputCardState();
}

class _NumberInputCardState extends State<NumberInputCard> {
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
            keyboardType: TextInputType.number,
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