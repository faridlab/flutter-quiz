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

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Container questionTextBox(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'One Piece Quiz',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'The first question for you is? bla bla bla bla',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ));
  }

  Expanded answerChoicesBox(BuildContext context) {
    return Expanded(
        flex: 8,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                  'Multiline answer Multiline answer Multiline answer Multiline answer Multiline answer Multiline answer',
                  style: TextStyle(fontSize: 16)),
              leading: Radio(
                value: 'a',
                groupValue: 'anu',
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: Text('Thomas Jefferson', style: TextStyle(fontSize: 16)),
              leading: Radio(
                value: 'b',
                groupValue: 'anu',
                onChanged: (value) {},
              ),
            ),
          ],
        ));
  }

  Future<String> _loadFromAsset() async {
    return await rootBundle.loadString("assets/quiz.json");
  }

  Future parseJson() async {
    String jsonString = await _loadFromAsset();
    final jsonResponse = jsonDecode(jsonString);
    print(jsonResponse);
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
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
            icon: Icon(Icons.not_listed_location),
            label: '1 of 10',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: 'Next',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        // onTap: () => {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
