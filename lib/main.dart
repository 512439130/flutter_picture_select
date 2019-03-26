import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picture_select/refresh/refresh.dart';
import 'package:flutter_picture_select/widget/picture_display.dart';
import 'package:flutter_picture_select/widget/picture_select.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oktoast/oktoast.dart';

//常量定义
const String name1 = 'flutter_widget';
const String taskTitle = 'Flutter Test Layout Title';

//主函数
void main() {
  runApp(MyApp());
  //如果机型是Android 设置Android状态栏透明沉浸式
  checkPhoneType();
}

//如果机型是Android 设置Android状态栏透明沉浸式
void checkPhoneType() {
  if (Platform.isAndroid) {
    print('Devices is Android');
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  } else if (Platform.isIOS) {
    print('Devices is iOS');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      /// set toast style, optional
      child: MaterialApp(
        title: taskTitle, //唤出任务管理器title
        theme: new ThemeData(
          //状态栏颜色
          primaryColor: Colors.greenAccent,
          accentColor: const Color(0xFF00FFFF),
          hintColor: Colors.blue,
        ),
        home: MyHomePage(),
        routes: <String, WidgetBuilder>{
          // 定义静态路由，不能传递参数
          '/router/refresh/refresh': (_) => new RefreshWidget(),
          '/router/widget/picture_select': (_) => new PictureSelectWidget(),
          '/router/widget/picture_display': (_) => new PictureDisplayWidget(),
        },
      ),
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
  //生成MaterialButton
  MaterialButton buildButton(
      String value, Color textColor, Color background, String route) {
    return new MaterialButton(
      child: Text(value),
      color: background,
      textColor: textColor,
      onPressed: () {
        openView(route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name1),
        ),
        body: new ListView(
          physics: BouncingScrollPhysics(), //回弹效果
          children: <Widget>[
            new Container(
              color: const Color(0xFFFFFFFF),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: buildButton("RefreshWidget", Colors.white, Colors.deepOrangeAccent,
                  '/router/refresh/refresh'),
            ),
            new Container(
              color: const Color(0xFFFFFFFF),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: buildButton("PictureSelectWidget", Colors.white, Colors.deepOrangeAccent,
                  '/router/widget/picture_select'),
            ),
            new Container(
              color: const Color(0xFFFFFFFF),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child:  buildButton("PictureDisplayWidget", Colors.white, Colors.deepOrangeAccent,
                  '/router/widget/picture_display'),
            ),
          ],

        ));
  }

  openView(String route) {
    Navigator.of(context).pushNamed(route);
  }
}