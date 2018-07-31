import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class UIpage1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new UIpageState1();
  }
}

class UIpageState1 extends State<UIpage1> {
  static String buttonString;
  static String inputString;
  static int num = 0;
  static bool fontSelect = false;
  double fontSize = 18.0;
  int intSize = 18;
  static bool underlineSelect = false;
  int rvalue = 1;
  Color fontColor = Colors.white;
  bool _lights = false;
  //根据单选框选择颜色
  void method1(value) {
    setState(() {
      rvalue = value;
      switch (rvalue) {
        case 1:
          fontColor = Colors.white;
          break;
        case 2:
          fontColor = Colors.redAccent;
          break;
        case 3:
          fontColor = Colors.yellow;
          break;
        case 4:
          fontColor = Colors.blueAccent;
          break;

        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (buttonString == null) {
      buttonString = '点击按钮';
    }
    if (inputString == null) {
      inputString = '输入文字';
    }
    return new ListView(
      children: <Widget>[
        //按钮
        new Container(
          margin: EdgeInsets.fromLTRB(200.0, 30.0, 200.0, 30.0),
          width: 60.0,
          height: 60.0,
          child: new CupertinoButton(
            child: Text('按钮'),
            color: Colors.blueGrey,
            onPressed: () {
              setState(() {
                num++;
                buttonString = 'Hello Flutter * $num';
              });
            },
          ),
        ),
        //每按一次加一的文字
        new Text(
          buttonString,
          style: TextStyle(fontSize: 30.0),
          textAlign: TextAlign.center,
        ),
        //文字输入框
        new Container(
          margin: EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 30.0),
          width: 100.0,
          height: 40.0,
          child: new TextField(
            //controller: TextEditingController(),
            onSubmitted: (text) {
              setState(() {
                inputString = text;
              });
            },
          ),
        ),
        //复选框
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Checkbox(
              value: fontSelect,
              activeColor: Colors.greenAccent,
              onChanged: (sel) {
                setState(() {
                  fontSelect = sel;
                });
              },
            ),
            new Text(
              '字体缩放',
              style: TextStyle(fontSize: 18.0),
              //textAlign: TextAlign.center,
            ),
            new Container(
              width: 40.0,
            ),
            new Checkbox(
              value: underlineSelect,
              activeColor: Colors.greenAccent,
              onChanged: (sel) {
                setState(() {
                  underlineSelect = sel;
                });
              },
            ),
            new Text(
              '下划线',
              style: TextStyle(fontSize: 18.0),
              //textAlign: TextAlign.center,
            ),
          ],
        ),
        //滑块
        new Container(
          margin: EdgeInsets.all(30.0),
          child: new Slider(
            value: fontSize,
            min: 6.0,
            max: 100.0,
            divisions: 94,
            label: '$intSize px',
            activeColor: Color(0xffb3e5fc),
            inactiveColor: Colors.white24,
            onChanged: (size) {
              setState(() {
                fontSize = size;
                intSize = fontSize.toInt();
              });
            },
          ),
        ),
        //单选框
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Radio(
                value: 1,
                groupValue: rvalue,
                onChanged: (int rval) {
                  method1(rval);
                }),
            new Text('白色'),
            new Container(
              width: 30.0,
            ),
            new Radio(
                value: 2,
                groupValue: rvalue,
                onChanged: (int rval) {
                  method1(rval);
                }),
            new Text('红色'),
            new Container(
              width: 30.0,
            ),
            new Radio(
                value: 3,
                groupValue: rvalue,
                onChanged: (int rval) {
                  method1(rval);
                }),
            new Text('黄色'),
            new Container(
              width: 30.0,
            ),
            new Radio(
                value: 4,
                groupValue: rvalue,
                onChanged: (int rval) {
                  method1(rval);
                }),
            new Text('蓝色'),
          ],
        ),
        new Text(
          inputString,
          style: TextStyle(
            fontSize: fontSelect ? fontSize : 30.0,
            decoration: underlineSelect
                ? TextDecoration.underline
                : TextDecoration.none,
            color: fontColor,
          ),
          textAlign: TextAlign.center,
        ),
        new MergeSemantics(
          child: new ListTile(
            title: new Text('按钮禁用'),
            trailing: new CupertinoSwitch(
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
            ),
            onTap: () {
              setState(() {
                _lights = !_lights;
              });
            },
          ),
        ),
        new Container(
          margin: EdgeInsets.fromLTRB(200.0, 30.0, 200.0, 30.0),
          width: 60.0,
          height: 60.0,
          child: new CupertinoButton(
            child: new Text('显示snackBar'),
            color: Colors.blueGrey,
            onPressed: () {
              if (!_lights) {
                final snackBar = new SnackBar(
                  content: new Text(
                    '这是一个\nSnackBar',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.teal,
                );
                Scaffold.of(context).showSnackBar(snackBar);
              }
            },
          ),
        ),
      ],
    );
  }
}
