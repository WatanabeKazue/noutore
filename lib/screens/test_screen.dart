import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:source_span/source_span.dart';

class TestScreen extends StatefulWidget {
  late final numberOfQuestions;

  TestScreen({this.numberOfQuestions});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var numberOfRemaining;
  var numberOfCorrect;
  var correctRate;

  int questionLeft = 50;
  int questionRight = 50;
  String operator = "+";
  String answerString = "100";

  late Soundpool soundpool;
  int soundIdCorrect = 0;
  int soundIdInCorrect = 0;

  bool isCalcButtonsEnabled = false;
  bool isAnswerCheckButtonEnabled = false;
  bool isBackButtonEnabled = false;
  bool isCorrectInCorrectImageEnabled = false;
  bool isEndMessageEnabled = false;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    numberOfCorrect = 0;
    correctRate = 0;
    //widget.numberOfQuestions = widget.numberOfQuestions;
    numberOfRemaining = widget.numberOfQuestions;

    //TODO 効果音の準備
    initSounds();
    setQuestion();
  }

  void initSounds() async {
    soundpool = Soundpool.fromOptions();
    soundIdCorrect = await loadSound("assets/sounds/sound_correct.mp3");
    soundIdInCorrect = await loadSound("assets/sounds/sound_incorrect.mp3");
    setState(() {

    });


  } on IOException catch(error){
    print("エラーの内容は：$error");
  }

  Future<int> loadSound(String soundPath) {
    return rootBundle.load(soundPath).then((value) => soundpool.load(value));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    soundpool.release();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                //スコア表示部分
                _scorePart(),
                //問題表示部分
                _questionPart(),
                //電卓ボタン部分
                _calcButtons(),
                //答え合わせボタン
                _answerCheckButton(),

                _backButton(),
              ],
            ),
            _correctIncorrectImage(),
            //テスト終了メッセージ
            _endMessage(),
          ],
        ),
        // child: Center(child: Text(widget.numberOfQuestions.toString())),
      ),
    );
  }

//TODOスコア表示部分
  Widget _scorePart() {
    return Table(
      children: [
        TableRow(children: [
          Center(
              child: Text(
            "のこり問題数",
            style: TextStyle(fontSize: 10.0),
          )),
          Center(
              child: Text(
            "正解数",
            style: TextStyle(fontSize: 10.0),
          )),
          Center(
              child: Text(
            "正答率",
            style: TextStyle(fontSize: 10.0),
          )),
        ]),
        TableRow(children: [
          Center(
              child: Text(
            numberOfRemaining.toString(),
            style: TextStyle(fontSize: 18.0),
          )),
          Center(
              child: Text(
            numberOfCorrect.toString(),
            style: TextStyle(fontSize: 18.0),
          )),
          Center(
              child: Text(
            correctRate.toString(),
            style: TextStyle(fontSize: 18.0),
          )),
        ]),
      ],
    );
  }

//問題表示部分
  Widget _questionPart() {
    return Row(
      children: <Widget>[
        Text(
          questionLeft.toString(),
          style: TextStyle(fontSize: 36.0),
        ),
        Text(
          operator,
          style: TextStyle(fontSize: 30.0),
        ),
        Text(
          questionRight.toString(),
          style: TextStyle(fontSize: 36.0),
        ),
        Text(
          "=",
          style: TextStyle(fontSize: 30.0),
        ),
        Text(
          answerString,
          style: TextStyle(fontSize: 60.0),
        ),
      ],
    );
  }

  //電卓ボタン部分
  Widget _calcButtons() {
    return Table(
      children: [
        TableRow(children: [
          _calcButton("7"),
          _calcButton("8"),
          _calcButton("9"),
        ]),
        TableRow(children: [
          _calcButton("4"),
          _calcButton("5"),
          _calcButton("6"),
        ]),
        TableRow(children: [
          _calcButton("1"),
          _calcButton("2"),
          _calcButton("3"),
        ]),
        TableRow(children: [
          _calcButton("0"),
          _calcButton("-"),
          _calcButton("C"),
        ]),
      ],
    );
  }

  Widget _calcButton(String numString) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
      primary: Colors.amber),
      onPressed: () => inputAnswer(numString),
      child: Text(
        numString,
        style: TextStyle(fontSize: 24.0),
      ),
    );

     // padding: const EdgeInsr,
    //   padding: const EdgeInsets.all(8.0),
    //   child: ElevatedButton(
    //    //style: ElevatedButton.styleFrom  // (primary: Colors.brown),
    //     color: Colors.blue,
    //     onPressed: () => print(numString),
    //     child: Text(
    //       numString,
    //       style: TextStyle(fontSize: 24.0),
    //     ),
    //   ),
    // );
    //   primary: Colors.brown,
    // ),
    // onPressed: null,
    // child: Text(numString,style: TextStyle(fontSize: 24.0),),),
    // numString
    // style: TextStyle(fontSize: 24.0),
  }
  inputAnswer(String numString) {
    // setState(() {
    //   if(numString == "C"){
    //     answerString = "";
    //     return;
    //   }
    //   if(numString == "-"){
    //     if (answerString == "") answerString = "-";
    //     return;
    //   }
    //   if (numString == "0"){
    //     if (answerString != "0"&& answerString != "-")
    //       answerString = answerString + numString;
    //     return;
    //   }
    //   if (answerString == "0"){
    //    answerString = numString;
    //     return;
    // });
    //
    // answerString = answerString + numString;
  }
//TODO 問題を出す
  void setQuestion() {
    isCalcButtonsEnabled = true;
    isAnswerCheckButtonEnabled = true;
    isBackButtonEnabled = false;
    isCorrectInCorrectImageEnabled = false;
    isEndMessageEnabled = false;

    Random random = Random();
    questionLeft = random.nextInt(100) + 1;
    questionRight = random.nextInt(100) + 1;

    if (random.nextInt(2) + 1 == 1) {
      operator = "+";
    }else{
      operator = "-";
    }
  }

//TODO 〇・バツ画像
  Widget _correctIncorrectImage() {
    var isCorrectIncorrectImageEnabled;
    if (isCorrectIncorrectImageEnabled == true) {
      return Center(
        child: Image.asset("assets/images/pic_correct.png"),
      );
    } else {
      return Container();
    }
  }

  //TODO テスト終了メッセージ
  Widget _endMessage() {
    if (isEndMessageEnabled) {
      return Container(
        child: Text(
          "テスト終了",
          style: TextStyle(fontSize: 60.0),
        ),
      );
    } else {
      return Container();
    }
  }

//答え合わせボタン
  Widget _answerCheckButton() {
    var isCalcButtonsEnabled;

    return Padding(
      padding: const EdgeInsets.only(left: 80.0, right: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.brown,
          ),
          onPressed: isCalcButtonsEnabled ? () => answerCheck() : null,
          child: Text(
            "答え合わせボタン",
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  answerCheck() {
    if (answerString == "" || answerString == ""  ){
      return;
    }
    isCalcButtonsEnabled = false;
    isAnswerCheckButtonEnabled = false;
    isBackButtonEnabled = false;
    isCorrectInCorrectImageEnabled = true;
    isEndMessageEnabled = false;

    var myAnswer = int.parse(answerString).toInt();
    var realAnswer = 0;
    if (operator == "+") {
      realAnswer = questionLeft + questionRight;
    }else{
      realAnswer = questionLeft - questionRight;
    }

    if (myAnswer == realAnswer){
     isCorrect = true;
     soundpool.play(soundIdCorrect);
     numberOfCorrect += 1;
    } else {
      isCorrect = true;
      soundpool.play(soundIdInCorrect);
    }
    correctRate = (numberOfCorrect / (widget.numberOfQuestions - numberOfRemaining)*100).toInt();

    setState(() {

    });
  }

//TODO 戻るボタン
  Widget _backButton() {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: null,
          child: Text(
            "もどる",
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }


//160

// return SizedBox(
//   width: double.infinity,
//   child: ElevatedButton(
//       onPressed: null,
//       child: Text("答え合わせボタン",
//         style: TextStyle(fontSize: 14.0),),

}
