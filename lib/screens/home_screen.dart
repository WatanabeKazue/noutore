import 'package:flutter/material.dart';
import 'package:noutore/screens/test_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DropdownMenuItem<int>> _memuItems = [];
  int _numberOfQuestions = 0;

  @override
  void initState() {
    super.initState();
    setMenuItems();

    _numberOfQuestions = _memuItems[0].value!;
  }
  void setMenuItems() {
   _memuItems.add(DropdownMenuItem(value: 10, child: Text ("10"),));
   _memuItems.add(DropdownMenuItem(value: 20, child: Text ("20"),));
   _memuItems.add(DropdownMenuItem(value: 30, child: Text ("30"),));

   // _memuItems
   // ..add(DropdownMenuItem(value: 10, child: Text (10.toString()),))
   // ..add(DropdownMenuItem(value: 10, child: Text (10.toString()),))
   // ..add(DropdownMenuItem(value: 10, child: Text (10.toString()),));
//    _memuItems = [DropdownMenuItem(value: 10, child: Text (10.toString()),),
//     DropdownMenuItem(value: 10, child: Text (10.toString()),),
//     DropdownMenuItem(value: 10, child: Text (10.toString()),),];
  }
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    print("ヨコ幅の論理ピクセル : $screenWidth");
    print("タテ幅の論理ピクセル : $screenHeight");

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Image.asset("assets/images/image_title.png"),
              SizedBox(
                height: 16.0,
              ),
              Text("問題数を選択して「スタート」ボタンを押してください"),
              //TODO プルダウン選択
              SizedBox(
                height: 50.0,
              ),
              DropdownButton(
                items: _memuItems,
                value: _numberOfQuestions,
                onChanged: (int? selectedValue){
                  setState(() {
                    _numberOfQuestions = selectedValue!;
                  });
                },
                  // childの後にchildをつけてはいけない
              ),
              Expanded(
                // CenterじゃなくてContainer
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 16.0),
                  // RaiseButtonは使わないようにする
                  // ElevatedButtonを使う
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.skip_next),
                    label: Text("スタート"),
                    onPressed: () => startTestScreen(context),
                    // RaisedButtonだとstyleが使えない
                    style: ElevatedButton.styleFrom(
                      primary: Colors.greenAccent,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  startTestScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TestScreen(numberOfQuestions: _numberOfQuestions,)));
  }




}



//TODO 155 4:34
