import 'package:flutter/material.dart';
import 'package:quizler/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
 
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  List<Icon> scoreKeeper = [];
  int totalCorrectAnswer = 0;

  
  void checkAnswer(bool userAnswer){
    bool correctAnswer = quizBrain.getAnswer();
    if( userAnswer == correctAnswer ){
      totalCorrectAnswer++;
      scoreKeeper.add(Icon(Icons.check, color: Colors.green,));
    } else {
      scoreKeeper.add(Icon(Icons.cancel, color: Colors.red,));
    }
    setState(() {                  
      quizBrain.nextQuestion();
    });
  }

  Alert alert(){
    int totalQuestion = quizBrain.totalQuestion();
    return Alert(
      context: context,
      type: AlertType.success,
      title: "Game Over",
      desc: "$totalCorrectAnswer/$totalQuestion",
      buttons: [
        DialogButton(
          child: Text(
            "Try Again!",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    );
  }
  QuizBrain quizBrain = QuizBrain();


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestion(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                if (quizBrain.isFinished()){
                  alert().show();
                  setState(() {
                    scoreKeeper.clear();
                    quizBrain.reset();
                    totalCorrectAnswer = 0;
                  });
                } else {
                  checkAnswer(true);
                }
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                if (quizBrain.isFinished()){
                  alert().show();
                  setState(() {
                    scoreKeeper.clear();
                    quizBrain.reset();
                  });
                } else {
                  checkAnswer(false);
                }
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}
