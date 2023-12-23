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
          return buildQuestionWidget(displayedQuestions[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadNextQuestion,
        child: const Icon(Icons.navigate_next),
      ),
    );
  }

  Widget buildQuestionWidget(Question question) {
    switch (question.questionType) {
      case "MultipleChoice":
        return QuestionCard(
          question: question,
        );
      case "textInput":
        return TextInputCard(
          question: question,
          onTextChanged: (text) {
            // Handle text changes, if needed
          },
          onNextPressed: () {
            // _moveToNextQuestion(question.referTo);
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
        );
    }
    return Container();
  }


  void _loadNextQuestion() {
    if (displayedQuestions.isNotEmpty) {
      int currentQuestionId = displayedQuestions.last.referTo;
      if (currentQuestionId != -1) {
        Question? nextQuestion =
            allQuestions.firstWhere((q) => q.id == currentQuestionId);
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

class QuestionWidget extends StatelessWidget {
  final Question question;

  QuestionWidget({required this.question});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(question.questionText),
      ),
    );
  }
}






class QuestionCard extends StatelessWidget {
  final Question question;
  // final ValueChanged<int?> onOptionSelected;
  // final ScrollController scrollController;

  QuestionCard({
    required this.question,
    // required this.onOptionSelected,
    // required this.scrollController,
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
            // controller: scrollController,
            shrinkWrap: true,
            itemCount: question.options.length,
            itemBuilder: (context, index) {
              return OptionItem(
                option: question.options[index],
                onSelected: () {
                  // onOptionSelected(index);
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
  final VoidCallback? onNextPressed;

  NumberInputCard({
    required this.question,
    required this.onTextChanged,
     this.onNextPressed,
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