import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picture_select/bean/FileBean.dart';
import 'package:flutter_picture_select/bean/HeaderBean.dart';
import 'package:flutter_picture_select/const/Constant.dart';
import 'package:flutter_picture_select/util/ToastUtil.dart';
import 'package:flutter_picture_select/widget/dialog/BottomPickerHandler.dart';
import 'package:flutter_picture_select/widget/dialog/ProgressDialog.dart';
import 'package:flutter_picture_select/widget/file/FileDisplayWidget.dart';
import 'package:flutter_picture_select/widget/picture/flow/FlowHeaderDisplayWidget.dart';
import 'package:flutter_picture_select/widget/picture/grid/GridHeaderDisplayWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


const String title = 'FileDisplayWidgetDemo';

class FileDisplayWidgetDemo extends StatefulWidget {
  FileDisplayWidgetDemo({Key key, this.title}) : super(key: key);
  final String title;

  @override
  FileDisplayWidgetDemoState createState() => FileDisplayWidgetDemoState();
}

class FileDisplayWidgetDemoState extends State<FileDisplayWidgetDemo> {
  FileBean fileBean;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    init();
  }
  //初始化
  void init() {
    fileBean = new FileBean();
    String testJsonValue ='{"datas":[{"id":"1","fileName":"工资单工资单工资单工资单工资单工资单工资单工资单工资单工资单工资单工资单工资单工资单工资单工资单.xlsx","fileUrl":"https://b-ssl.duitang.com/uploads/item/201703/30/20170330175756_5KzW3.thumb.700_0.jpeg"},{"id":"2","fileName":"账单.docx","fileUrl":"https://gss2.bdstatic.com/-fo3dSag_xI4khGkpoWK1HF6hhy/baike/s%3D220/sign=7a156e5ceccd7b89ed6c3d813f254291/2f738bd4b31c87010f99dc702d7f9e2f0708ff7d.jpg"},{"id":"3","fileName":"资金流水表.doc","fileUrl":"https://gss1.bdstatic.com/9vo3dSag_xI4khGkpoWK1HF6hhy/baike/w%3D268%3Bg%3D0/sign=3a64e2745c0fd9f9a017526f1d16b317/d31b0ef41bd5ad6e0c58a9e28ccb39dbb6fd3c11.jpg"}],"resMsg":{"message":"success !","method":null,"code":"1"}}';
    Map<String, dynamic> json;
    if (testJsonValue != null) {
      json = jsonDecode(testJsonValue);
      fileBean = FileBean.fromJson(json);
    }
  }

  @override
  Widget build(BuildContext context) {
    double boxPaddingLeft = ScreenUtil.getInstance().setHeight(20); //盒子左边距
    double boxPaddingTop = ScreenUtil.getInstance().setHeight(50); //盒子顶边距
    double boxPaddingRight = ScreenUtil.getInstance().setHeight(20); //盒子右边距
    double boxPaddingBottom = ScreenUtil.getInstance().setHeight(50); //盒子底边距
    return Scaffold(
      backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Text(title),
        ),
        body: new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            new Container(
              color:Colors.white,
              padding:EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: FileDisplayWidget(fileBean,'images/icon_file_left.png',onFilePress,onFileDeletePress),
            ),
            new Container(
              color:Colors.white,
              padding:EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: FileDisplayWidget(fileBean,'images/icon_word.png',onFilePress,onFileDeletePress),
            ),
            new Container(
              color:Colors.white,
              padding:EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: FileDisplayWidget(fileBean,'images/icon_ppt.png',onFilePress,onFileDeletePress),
            ),
            new Container(
              color:Colors.white,
              padding:EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: FileDisplayWidget(fileBean,'images/icon_excel.png',onFilePress,onFileDeletePress),
            ),
          ],
        ));
  }

  Function onFilePress(int id,String fileName,String url){
    ToastUtil.toast("onFilePress-id=$id-fileName=$fileName-url=$url");
    return null;
  }
  Function onFileDeletePress(int id){
    ToastUtil.toast("onFileDeletePress-id=$id");
    return null;
  }

}
