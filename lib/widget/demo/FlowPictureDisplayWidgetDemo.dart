import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picture_select/bean/ImageBean.dart';
import 'package:flutter_picture_select/widget/picture/flow/FlowPictureDisplayWidget.dart';
import 'package:flutter_picture_select/widget/picture/grid/GridPictureDisplayWidget.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:simple_permissions/simple_permissions.dart';

const String name1 = 'FlowPictureDisplayWidgetDemo';

class FlowPictureDisplayWidgetDemo extends StatefulWidget {
  FlowPictureDisplayWidgetDemo({Key key, this.title}) : super(key: key);
  final String title;

  @override
  FlowPictureDisplayWidgetDemoState createState() =>
      FlowPictureDisplayWidgetDemoState();
}

class FlowPictureDisplayWidgetDemoState
    extends State<FlowPictureDisplayWidgetDemo> {
  ImageBean imageBean = new ImageBean(); //保存数据的泛型实体

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    init();
  }

  void init() {
    String testJsonValue =
        '{"datas":[{"id":"1","url":"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1553505918721&di=30abbc97f9b299cad7de51a06cbee078&imgtype=0&src=http%3A%2F%2Fimg15.3lian.com%2F2015%2Ff2%2F57%2Fd%2F93.jpg"},{"id":"2","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=80538588,251590437&fm=26&gp=0.png"},{"id":"3","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3597303668,2750618423&fm=26&gp=0.png"},{"id":"4","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=61077523,1715146142&fm=26&gp=0.png"},{"id":"5","url":"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4087213632,1096565806&fm=26&gp=0.png"},{"id":"6","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3597303668,2750618423&fm=26&gp=0.png"}],"resMsg":{"message":"success !","method":null,"code":"1"}}';
    Map<String, dynamic> json;
    if (testJsonValue != null) {
      json = jsonDecode(testJsonValue);
      imageBean = ImageBean.fromJson(json);
    }
  }

  @override
  Widget build(BuildContext context) {
    double boxMarginLeft = 10;//盒子左边距
    double boxMarginTop = 14;//盒子顶边距
    double boxMarginRight = 10;//盒子右边距
    double boxMarginBottom = 14;//盒子底边距

    double itemWidth = 65;  //图片宽度
    double itemHeight = 65; //图片高度
    double itemHorizontalSpacing = 15; //水平间距
    double itemVerticalSpacing = 15;  //垂直间距
    double itemRoundArc = 5; //图片圆角弧度


    return Scaffold(
        appBar: AppBar(
          title: Text(name1),
        ),
        body: new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[

            new Container(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(boxMarginLeft, boxMarginTop, boxMarginRight, boxMarginBottom),
              child: new Wrap(
                textDirection: TextDirection.ltr,
                //从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
                alignment: WrapAlignment.start,
                //textDirection的正方向
                verticalDirection: VerticalDirection.down,
                //down:表示从上到下 up:表示从下到上
                runAlignment: WrapAlignment.start,
                //纵轴方向的对齐方式:top,start,bottom,end
                children: <Widget>[
                  new Flex(  //弹性布局
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    //down:表示从上到下 up:表示从下到上
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //参考verticalDirection start表示正方向，end表示反方向
                    children: <Widget>[  //比例10:38
                      new Expanded(
                        flex: 1,
                        child: new Container(
//                        color: Colors.blue,
                          alignment: Alignment.centerLeft, //内容位置
                          child: new Text(
                            "图         片",
                            style: new TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new Container(
                          alignment: Alignment.topLeft,
                          child: new FlowPictureDisplayWidget(
                              imageBean, itemWidth, itemHeight, itemHorizontalSpacing, itemVerticalSpacing, itemRoundArc),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            new Container(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(boxMarginLeft, boxMarginTop, boxMarginRight, boxMarginBottom),
              child: new Wrap(
                textDirection: TextDirection.ltr,
                //从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
                alignment: WrapAlignment.start,
                //textDirection的正方向
                verticalDirection: VerticalDirection.down,
                //down:表示从上到下 up:表示从下到上
                runAlignment: WrapAlignment.start,
                //纵轴方向的对齐方式:top,start,bottom,end
                children: <Widget>[
                  new Flex(  //弹性布局
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    //down:表示从上到下 up:表示从下到上
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //参考verticalDirection start表示正方向，end表示反方向
                    children: <Widget>[  //比例10:38
                      new Expanded(
                        flex: 1,
                        child: new Container(
//                        color: Colors.blue,
                          alignment: Alignment.centerLeft, //内容位置
                          child: new Text(
                            "图         片",
                            style: new TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new Container(
                          alignment: Alignment.topLeft,
                          child: new FlowPictureDisplayWidget(
                              imageBean, 90, 90, itemHorizontalSpacing, itemVerticalSpacing, itemRoundArc),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            new Container(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(boxMarginLeft, boxMarginTop, boxMarginRight, boxMarginBottom),
              child: new Wrap(
                textDirection: TextDirection.ltr,
                //从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
                alignment: WrapAlignment.start,
                //textDirection的正方向
                verticalDirection: VerticalDirection.down,
                //down:表示从上到下 up:表示从下到上
                runAlignment: WrapAlignment.start,
                //纵轴方向的对齐方式:top,start,bottom,end
                children: <Widget>[
                  new Flex(  //弹性布局
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    //down:表示从上到下 up:表示从下到上
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //参考verticalDirection start表示正方向，end表示反方向
                    children: <Widget>[  //比例10:38
                      new Expanded(
                        flex: 1,
                        child: new Container(
//                        color: Colors.blue,
                          alignment: Alignment.centerLeft, //内容位置
                          child: new Text(
                            "图         片",
                            style: new TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new Container(
                          alignment: Alignment.topLeft,
                          child: new FlowPictureDisplayWidget(
                              imageBean, 140, 140, itemHorizontalSpacing, itemVerticalSpacing, itemRoundArc),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
