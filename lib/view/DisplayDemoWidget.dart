import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picture_select/bean/ImageBean.dart';
import 'package:flutter_picture_select/view/GridPictureDisplayWidget.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:simple_permissions/simple_permissions.dart';

//数据传递
//原生&flutter互掉
//常量定义
const String name1 = 'display_demo';

class DisplayDemoWidget extends StatefulWidget {
  DisplayDemoWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  DisplayDemoWidgetState createState() => DisplayDemoWidgetState();
}

class DisplayDemoWidgetState extends State<DisplayDemoWidget>{
  ImageBean imageBean = new ImageBean();//保存数据的泛型实体

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    init();
  }
  void init() {
    String testJsonValue ='{"datas":[{"id":"1","url":"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1553505918721&di=30abbc97f9b299cad7de51a06cbee078&imgtype=0&src=http%3A%2F%2Fimg15.3lian.com%2F2015%2Ff2%2F57%2Fd%2F93.jpg"},{"id":"2","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=80538588,251590437&fm=26&gp=0.png"},{"id":"3","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3597303668,2750618423&fm=26&gp=0.png"},{"id":"4","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=61077523,1715146142&fm=26&gp=0.png"},{"id":"5","url":"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4087213632,1096565806&fm=26&gp=0.png"},{"id":"6","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3597303668,2750618423&fm=26&gp=0.png"}],"resMsg":{"message":"success !","method":null,"code":"1"}}';
    Map<String, dynamic> json;
    if (testJsonValue != null) {
      json = jsonDecode(testJsonValue);
      imageBean = ImageBean.fromJson(json);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name1),
        ),
        body: new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            GridPictureDisplayWidget(context,imageBean, 2,360,5),
            GridPictureDisplayWidget(context,imageBean, 3,360,5),
            GridPictureDisplayWidget(context,imageBean, 4,360,5),
            GridPictureDisplayWidget(context,imageBean, 5,360,5),
            GridPictureDisplayWidget(context,imageBean, 6,360,5),
          ],
        ));
  }





}
