import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picture_select/bean/ImageBean.dart';
import 'package:flutter_picture_select/widget/card/CardWidget.dart';
import 'package:flutter_picture_select/widget/picture/grid/GridPictureDisplayWidget.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:simple_permissions/simple_permissions.dart';

const String title = 'CardWidgetDemo';

class CardWidgetDemo extends StatefulWidget {
  CardWidgetDemo({Key key, this.title}) : super(key: key);
  final String title;

  @override
  CardWidgetDemoState createState() => CardWidgetDemoState();
}

class CardWidgetDemoState extends State<CardWidgetDemo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            new Container(
              color: Colors.white,
              padding: EdgeInsets.all(0),
              child: new Wrap(
                textDirection: TextDirection.ltr,
                alignment: WrapAlignment.start,
                verticalDirection: VerticalDirection.down,
                runAlignment: WrapAlignment.start,
                children: <Widget>[
                  new Flex(
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //比例1:4
                      new Expanded(
                        flex: 1,
                        child: new Container(
                          alignment: Alignment.center, //内容位置
                          child: new Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              child: new Column(
                                children: <Widget>[
                                  new ClipOval(
                                    child: new Container(
                                      padding: EdgeInsets.all(0),
                                      child: new Image.asset(
                                          'images/icon_circle.png',
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  new Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    color: Colors.black,
                                    width: 2,
                                    height: 100,
                                  )
                                ],
                              )),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new Container(
                          margin: EdgeInsets.fromLTRB(15, 50, 15, 0),
                          alignment: Alignment.centerLeft,
                          child: new ClipRRect(
                            child: new Container(
                              width: double.infinity,
                              height: 100,
                              color: Colors.black,
                              padding: EdgeInsets.all(2),
                              margin: EdgeInsets.all(0),
                              child: ClipRRect(
                                child: new Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(2),
                                  margin: EdgeInsets.all(0),
                                  child: new Column(
                                    children: <Widget>[
//                                      new Container(
//                                        height: 20,
//                                        color: Colors.greenAccent,
//                                        child: new Stack(
//                                          alignment: Alignment.center,
//                                          overflow: Overflow.visible,
//                                          children: <Widget>[
//                                            Positioned(
//                                              left: 0,
//                                              top: 0,
//                                              child: new Container(
//                                                  padding: EdgeInsets.all(0),
//                                                  child: new Text("深红骑士")),
//                                            ),
//                                            Positioned(
//                                              right: 0,
//                                              top: 0,
//                                              child: new Container(
//                                                  padding: EdgeInsets.all(0),
//                                                  child: new Text("2019-4-1")),
//                                            )
//                                          ],
//                                        ),
//                                      ),
                                      new Flex(
                                          direction: Axis.horizontal,
                                          verticalDirection:
                                              VerticalDirection.down,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Expanded(
                                              flex: 1,
                                              child: new Container(
                                                color: Colors.red,
                                                alignment: Alignment.topLeft,
                                                child: new Text("深红骑士"),
                                              ),
                                            ),
                                            new Expanded(
                                              flex: 1,
                                              child: new Container(
                                                color: Colors.green,
                                                alignment: Alignment.topRight,
                                                child: new Text("2019-4-1"),
                                              ),
                                            ),
                                          ]),

                                      new Container(
                                          width: double.infinity,
                                          alignment: Alignment.centerLeft,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: new Text("文字")),
                                      new Container(
                                          width: double.infinity,
                                          alignment: Alignment.centerLeft,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: new Text("文字内容")),
                                    ],
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            titleWidget,
          ],
        ));
  }

  //实现标题栏
  Widget titleWidget = new Container(
    //内边距
    padding: const EdgeInsets.all(30.0),
    //整体是一个水平的布局
    child: new Row(
      //只有一个孩子
      children: <Widget>[
        //用Expanded 会占用icon之外剩余空间
        new Expanded(
          //垂直布局 放置两个文本
          child: new Column(
            //设置文本一起始端对齐
            crossAxisAlignment: CrossAxisAlignment.start,
            //有两个孩子
            children: <Widget>[
              new Container(
                //底部内边距
                padding: const EdgeInsets.only(bottom: 10.0),
                //孩子 设置字体样式
                child: new Text(
                  'Oeschinen Lake Campground',
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              new Text(
                'Kandersteg, Switzerland',
                style: new TextStyle(
                  color: Colors.grey[450], //设置颜色透明度
                ),
              )
            ],
          ),
        ),
        new Icon(
          Icons.star,
          color: Colors.red[400],
        ),

        new Text('41'),
      ],
    ),
  );
}
