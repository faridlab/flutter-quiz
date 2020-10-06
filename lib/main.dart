import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizzy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Quizzy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  Future<String> _loadFromAsset() async {
    return await rootBundle.loadString("assets/quiz.json");
  }

  Future quizzes() async {
    String jsonString = await _loadFromAsset();
    final jsonResponse = jsonDecode(jsonString);
    return jsonResponse;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  var quizzes;
  var quiz;
  var questions;
  String selected;
  String choice = 'z';

  String category;
  String questionText;
  var question;
  List choices = [];

  int numberOfQuestions = 0;

  @override
  void initState() {
    super.initState();
    widget.quizzes().then((value) {
      setState(() {
        quizzes = value;
        quiz = quizzes[0];
        category = quiz['category'];
        questions = quiz['questions'];
        question = questions[index];
        questionText = question['question'];
        choices = question['choices'];

        numberOfQuestions = questions.length;
      });
    });
  }

  Container questionTextBox(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$category',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '$questionText',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ));
  }

  Widget answerChoicesBox(BuildContext context) {
    return Column(
        children: choices
            .map((value) => Row(
                  children: <Widget>[
                    Radio(
                      groupValue: selected,
                      value: value['key'],
                      onChanged: (value) {
                        setState(() {
                          quiz['questions'][index]['selected'] = value;
                          selected = value;
                        });
                      },
                    ),
                    Text(value['choise'])
                  ],
                ))
            .toList());
  }

  void changePageQuestion(int page) {
    if (index == 0 && page == -1) return;
    if (index == (questions.length - 1) && page == 1) return;
    setState(() {
      index += page;
      question = questions[index];
      selected = question['selected'] ?? 'z';
      questionText = question['question'];
      choices = question['choices'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            questionTextBox(context),
            answerChoicesBox(context),
            // Row(
            //   children: <Widget>[
            //   Text(
            //     '$_counter',
            //     style: Theme.of(context).textTheme.headline4,
            //   ),
            //   ]
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Prev',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: 'Next',
          ),
        ],
        // currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          if (index == 0) index = -1;
          changePageQuestion(index);
        },
      ),
    );
  }
}
