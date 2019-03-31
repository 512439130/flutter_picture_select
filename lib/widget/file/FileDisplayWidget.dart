import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_picture_select/bean/FileBean.dart';
import 'package:flutter_picture_select/bean/HeaderBean.dart';
import 'package:flutter_picture_select/const/Constant.dart';
import 'package:flutter_picture_select/util/PictureUtil.dart';
import 'package:flutter_picture_select/util/ToastUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import 'package:cached_network_image/cached_network_image.dart';

//文件展示功能
class FileDisplayWidget extends StatefulWidget {
  final FileBean fileBean;
  final String fileLeftUrl; //文件图访问Url
  final Function(int id,String fileName,String url) onFilePress;
  final Function(int id) onFileDeletePress;
  FileDisplayWidget(this.fileBean, this.fileLeftUrl, this.onFilePress, this.onFileDeletePress);

  @override
  _FileDisplayWidgetState createState() => _FileDisplayWidgetState();
}

class _FileDisplayWidgetState extends State<FileDisplayWidget> {
  List<Widget> listWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void setList() {
    print('setList');
    listWidget = new List<Widget>();
    for (int i = 0; i < widget.fileBean.datas.length; i++) {
      listWidget.add(createFileWidget(i, widget.fileBean.datas[i].fileName, widget.fileBean.datas[i].fileName));
    }
  }

  Widget createFileWidget(int id, String fileName, String fileLeftUrl) {
    return new Container(
//      color: Colors.deepPurple,
      child: new Row(
        children: <Widget>[
          new Expanded(//左边区域
            child: new Container(
              alignment: Alignment.center,
              child:  getFileWidget(id, true, fileName, fileLeftUrl),
            ),
          ),
          new Container(//右边区域
            margin: EdgeInsets.all(
              ScreenUtil.getInstance().setHeight(25),
            ),
            child: new GestureDetector(
              onTap: () {
                widget.onFileDeletePress(id);
              },
              child: Image.asset(
                'images/icon_close.png',
                width: ScreenUtil.getInstance().setWidth(60),
                height: ScreenUtil.getInstance().setHeight(60),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFileWidget(int id, bool isVisible, String fileName, String url) {
    double fontSize = ScreenUtil.getInstance().setSp(52);
    print("fontSize:" + fontSize.toString());

    return new GestureDetector(
        onTap: () {
          widget.onFilePress(id,fileName, url);
        },
        child: new Offstage(
          //使用Offstage 控制widget在tree中的显示和隐藏
          offstage: isVisible ? false : true,
          child: new Container(
            //左侧
            alignment: Alignment.centerLeft,
            color: const Color(0xFFF7F8FA),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil.getInstance().setHeight(10),
                ScreenUtil.getInstance().setHeight(25),
                ScreenUtil.getInstance().setHeight(10),
                ScreenUtil.getInstance().setHeight(25)),
            margin: EdgeInsets.fromLTRB(
                ScreenUtil.getInstance().setHeight(20),
                ScreenUtil.getInstance().setHeight(30),
                ScreenUtil.getInstance().setHeight(20),
                ScreenUtil.getInstance().setHeight(30)),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(
                      left: ScreenUtil.getInstance().setHeight(15),
                      right: ScreenUtil.getInstance().setHeight(15)),
                  width: ScreenUtil.getInstance().setHeight(135),
                  child: new Image.asset(
                    widget.fileLeftUrl,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                new Expanded(
                  child: new Container(
                    padding: EdgeInsets.only(
                        left: ScreenUtil.getInstance().setHeight(10)),
                    child: new Text(
                      fileName,
                      softWrap: true,
                      style: new TextStyle(
                        color: const Color(0xFF1A1A1A),
                        fontSize: fontSize,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    setList();
    return new ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          new Container(
//              color: Colors.deepOrange,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child:  new Wrap(  //流式布局，垂直向下排列
                    spacing: 0,
                    // 主轴(水平)方向间距
                    runSpacing: 0,
                    // 纵轴（垂直）方向间距
                    textDirection: TextDirection.ltr,
                    //从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
                    alignment: WrapAlignment.start,
                    //textDirection的正方向
                    verticalDirection: VerticalDirection.down,
                    //down:表示从上到下 up:表示从下到上
                    runAlignment: WrapAlignment.start,
                    //纵轴方向的对齐方式:top,start,bottom,end
                    children: listWidget,
                  ),
                ),
        ]);
  }
}
