import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picture_select/widget/demo/CardWidgetDemo.dart';
import 'package:flutter_picture_select/widget/demo/FileDisplayWidgetDemo.dart';
import 'package:flutter_picture_select/widget/demo/FlowHeaderDisplayWidgetDemo.dart';
import 'package:flutter_picture_select/widget/demo/FlowPictureDisplayWidgetDemo.dart';
import 'package:flutter_picture_select/widget/demo/FlowSelectPictureWidgetDemo.dart';
import 'package:flutter_picture_select/widget/demo/GridGeneralWidgetDemo.dart';
import 'package:flutter_picture_select/widget/demo/GridHeaderDisplayWidgetDemo.dart';
import 'package:flutter_picture_select/widget/demo/GridPictureDisplayWidgetDemo.dart';
import 'package:flutter_picture_select/widget/demo/GridSelectPictureWidgetDemo.dart';
import 'package:flutter_picture_select/widget/demo/NetworkDemo.dart';
import 'package:flutter_picture_select/widget/demo/RefreshDemo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          '/router/widget/demo/GridSelectPictureWidgetDemo': (_) => new GridSelectPictureWidgetDemo(),
          '/router/widget/demo/GridPictureDisplayWidgetDemo': (_) => new GridPictureDisplayWidgetDemo(),
          '/router/widget/demo/GridHeaderDisplayWidgetDemo': (_) => new GridHeaderDisplayWidgetDemo(),
          '/router/widget/demo/FlowPictureDisplayWidgetDemo': (_) => new FlowPictureDisplayWidgetDemo(),
          '/router/widget/demo/FlowSelectPictureWidgetDemo': (_) => new FlowSelectPictureWidgetDemo(),
          '/router/widget/demo/FlowHeaderDisplayWidgetDemo': (_) => new FlowHeaderDisplayWidgetDemo(),
          '/router/widget/demo/FileDisplayWidgetDemo': (_) => new FileDisplayWidgetDemo(),
          '/router/widget/demo/RefreshDemo': (_) => new RefreshWidget(),
          '/router/widget/demo/NetworkDemo': (_) => new NetworkWidget(),
          '/router/widget/demo/CardWidgetDemo': (_) => new CardWidgetDemo(),
          '/router/widget/demo/GridGeneralWidgetDemo': (_) => new GridGeneralWidgetDemo(),

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
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920,allowFontScaling: false)..init(context);
    print('设备宽度:${ScreenUtil.screenWidth}'); //Device width
    print('设备高度:${ScreenUtil.screenHeight}'); //Device height
    print('设备的像素密度:${ScreenUtil.pixelRatio}'); //Device pixel density
    print('底部安全区距离:${ScreenUtil.bottomBarHeight}'); //Bottom safe zone distance，suitable for buttons with full screen
    print('状态栏高度:${ScreenUtil.statusBarHeight}px'); //Status bar height , Notch will be higher Unit px
    print('实际宽度的dp与设计稿px的比例:${ScreenUtil.getInstance().scaleWidth}');
    print('实际高度的dp与设计稿px的比例:${ScreenUtil.getInstance().scaleHeight}');
    print('宽度和字体相对于设计稿放大的比例:${ScreenUtil.getInstance().scaleWidth * ScreenUtil.pixelRatio}');
    print('高度相对于设计稿放大的比例:${ScreenUtil.getInstance().scaleHeight * ScreenUtil.pixelRatio}');
    print('系统的字体缩放比例:${ScreenUtil.textScaleFactory}');
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
              child: buildButton("GridPictureDisplayWidget", Colors.white, Colors.deepOrangeAccent,
                  '/router/widget/demo/GridPictureDisplayWidgetDemo'),
            ),
            new Container(
              color: const Color(0xFFFFFFFF),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: buildButton("GridHeaderDisplayWidgetDemo", Colors.white, Colors.deepOrangeAccent,
                  '/router/widget/demo/GridHeaderDisplayWidgetDemo'),
            ),
            new Container(
              color: const Color(0xFFFFFFFF),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: buildButton("GridSelectPictureWidget", Colors.white, Colors.deepOrangeAccent,
                  '/router/widget/demo/GridSelectPictureWidgetDemo'),
            ),

            new Container(
              color: const Color(0xFFFFFFFF),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: buildButton("FlowPictureDisplayWidgetDemo", Colors.white, Colors.deepOrangeAccent,
                  '/router/widget/demo/FlowPictureDisplayWidgetDemo'),
            ),
            new Container(
              color: const Color(0xFFFFFFFF),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: buildButton("FlowSelectPictureWidgetDemo", Colors.white, Colors.deepOrangeAccent,
                  '/router/widget/demo/FlowSelectPictureWidgetDemo'),
            ),
            new Container(
              color: const Color(0xFFFFFFFF),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: buildButton("FlowHeaderDisplayWidgetDemo", Colors.white, Colors.deepOrangeAccent,
              '/router/widget/demo/FlowHeaderDisplayWidgetDemo'),
            ),

            new Container(
              color: const Color(0xFFFFFFFF),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: buildButton("FileDisplayWidgetDemo", Colors.white, Colors.deepOrangeAccent,
                  '/router/widget/demo/FileDisplayWidgetDemo'),
            ),

            new Container(
              color: const Color(0xFFFFFFFF),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: buildButton("RefreshWidget", Colors.white, Colors.deepOrangeAccent,
                  '/router/widget/demo/RefreshDemo'),
            ),
            new Container(
              color: const Color(0xFFFFFFFF),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: buildButton("NetworkWidget", Colors.white, Colors.deepOrangeAccent,
                  '/router/widget/demo/NetworkDemo'),
            ),

            new Container(
              color: const Color(0xFFFFFFFF),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: buildButton("CardWidget", Colors.white, Colors.deepOrangeAccent,
                  '/router/widget/demo/CardWidgetDemo'),
            ),
            new Container(
            color: const Color(0xFFFFFFFF),
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: buildButton("GridGeneralWidgetDemo", Colors.white, Colors.deepOrangeAccent,
            '/router/widget/demo/GridGeneralWidgetDemo'),
            ),

          ],

        ));
  }

  openView(String route) {
    Navigator.of(context).pushNamed(route);
  }
}
