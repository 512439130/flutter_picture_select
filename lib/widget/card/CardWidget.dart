import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_picture_select/bean/HeaderBean.dart';
import 'package:flutter_picture_select/const/Constant.dart';
import 'package:flutter_picture_select/util/PictureUtil.dart';
import 'package:oktoast/oktoast.dart';

import 'package:cached_network_image/cached_network_image.dart';

//Card
class CardWidget extends StatefulWidget {
  CardWidget();

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new ClipRRect(

      child: new Container(
        width: double.infinity,
        height: 100,
        color: Colors.black,
        padding: EdgeInsets.all(2),
        margin: EdgeInsets.all(0),
        child: ClipRRect(
          child: new Container(
            color: Colors.greenAccent,
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.all(0),
            child:new Column(
              children: <Widget>[
                new Container(
                  height:20,
                  color: Colors.blue,
                  child:  new Stack(
                    alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        //删除按钮距离右，顶的距离
                        left: 0,
                        top: 0,
                        child: new Container(
//            color: Colors.blueAccent,
                            padding: EdgeInsets.all(0),
                            child: new Text("深红骑士")),
                      ),
                      Positioned(
                        //删除按钮距离右，顶的距离
                        right: 0,
                        top: 0,
                        child: new Container(
//            color: Colors.blueAccent,
                            padding: EdgeInsets.all(0),
                            child: new Text("2019-4-1")),
                      )

                    ],
                  ),
                ),

                new Container(
//            color: Colors.blueAccent,
                width: double.infinity,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(0,5,0,0),
                    child: new Text("文字")),
                new Container(
//            color: Colors.blueAccent,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(0,5,0,0),
                    child: new Text("文字内容")),
              ],
            ),

          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(2),
            bottomLeft: Radius.circular(2),
            bottomRight: Radius.circular(2),
          ),
        ),
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(2),
        topRight: Radius.circular(2),
        bottomLeft: Radius.circular(2),
        bottomRight: Radius.circular(2),
      ),
    );
  }
}
