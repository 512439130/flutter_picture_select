import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picture_select/bean/ImageBean.dart';

import 'package:flutter_picture_select/const/Constant.dart';
import 'package:flutter_picture_select/widget/dialog/ProgressDialog.dart';
import 'package:flutter_picture_select/widget/touch/TouchImageViewer.dart';
import 'package:flutter_picture_select/util/PictureUtil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:image_picker/image_picker.dart';

//jsonDecode
import 'dart:convert';

import 'package:simple_permissions/simple_permissions.dart';

//常量定义
const String title = '图片展示GridView';

class PictureDisplayWidget extends StatefulWidget {
  PictureDisplayWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PictureDisplayWidgetState createState() => _PictureDisplayWidgetState();
}

class _PictureDisplayWidgetState extends State<PictureDisplayWidget> {
  List<Widget> listWidget;
  String testJsonValue;
  Map<String, dynamic> json;
  ImageBean imageBean = new ImageBean();
  ProgressDialog progressDialog;

  List<String> imageUrls;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    initProgress();

    init();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("didChangeDependencies");
  }

  @override
  void didUpdateWidget(PictureDisplayWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print("deactivate");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose");
  }

//  //初始化
  void init() {
    testJsonValue =
        '{"datas":[{"id":"1","url":"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1553505918721&di=30abbc97f9b299cad7de51a06cbee078&imgtype=0&src=http%3A%2F%2Fimg15.3lian.com%2F2015%2Ff2%2F57%2Fd%2F93.jpg"},{"id":"2","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=80538588,251590437&fm=26&gp=0.png"},{"id":"3","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3597303668,2750618423&fm=26&gp=0.png"},{"id":"4","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=61077523,1715146142&fm=26&gp=0.png"},{"id":"5","url":"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4087213632,1096565806&fm=26&gp=0.png"},{"id":"6","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3597303668,2750618423&fm=26&gp=0.png"}],"resMsg":{"message":"success !","method":null,"code":"1"}}';
    if (testJsonValue != null) {
      json = jsonDecode(testJsonValue);
      imageBean = ImageBean.fromJson(json);
      setList();
    }
  }

  void initProgress() {
    progressDialog = new ProgressDialog(context);
    progressDialog.setMessage("Loading...");
    progressDialog.setTextColor(Colors.black);
    progressDialog.setTextSize(16);
  }

  void setList() {
    //listWidget
    listWidget = new List<Widget>();
    imageUrls = new List<String>();
    for (int i = 0; i < imageBean.datas.length; i++) {
      if (i < imageBean.datas.length - 1) {
        listWidget.add(networkImage(i, imageBean.datas[i].url));
        imageUrls.add(imageBean.datas[i].url);
      }
    }
  }

  Widget networkImage(int id, String url) {
    return new Stack(
      alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
      overflow: Overflow.visible,

      children: <Widget>[
        new Container(
            alignment: Alignment.center,
//            color: Colors.greenAccent,
            child: getNetImage(id, false, url, BoxFit.cover)),
      ],
    );
  }

  Widget getNetImage(int id, bool offstage, String url, BoxFit fit) {
    return new GestureDetector(
      onTap: () {
        PictureUtil.openLargeImages(context, imageUrls,Constant.image_type_network,id);
      },
      child: new Offstage(
        //使用Offstage 控制widget在tree中的显示和隐藏
        offstage: offstage,
        child: new ClipRRect(
          child: new Container(
            padding: const EdgeInsets.all(0),
            child: new CachedNetworkImage(
              width: 55,
              height: 55,

              fit: fit,
              fadeInCurve: Curves.ease,
              fadeInDuration: Duration(milliseconds: 800),
              fadeOutCurve: Curves.ease,
              fadeOutDuration: Duration(milliseconds: 400),
              imageUrl: url,
//        placeholder: (context, url) => Image(image: AssetImage('images/icon_image_default.png')),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
          //圆角
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
      ),
    );
  }

//  Widget getDeleteIcon(int id) {
//    return new GestureDetector(
//      child: Image.asset(
//        'images/icon_image_delete.png',
//        width: 20,
//        height: 20,
//        fit: BoxFit.cover,
//      ),
//    );
//  }

  Widget buildGrid(List<Widget> listWidget) {
    return new GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 24,
      //上下间距
      crossAxisSpacing: 24,
      //左右间距
      padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
      primary: false,
      shrinkWrap: true,
      children: listWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build");

    setList();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F5),
          title: Text(title),
        ),
        body: new ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            //textTitle
            new Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.only(top: 17, left: 24, bottom: 12),
              color: const Color(0xFFFFFFFF),
              child: new Text(
                '图片',
                style: new TextStyle(
                  color: const Color(0xFF1A1A1A),
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),

            //GradView
            new Container(
              color: const Color(0xFFFFFFFF),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: buildGrid(listWidget),
            ),

//            //按钮
//            new Container(
//              margin: const EdgeInsets.only(
//                  top: 40, bottom: 40, left: 10, right: 10),
//              child: buildButton("确认", const Color(0xFFFFFFFF),
//                  const Color(0x803068E8), buttonClick1),
//            ),
          ],
        ));
  }

//生成MaterialButton
  Container buildButton(
      String value, Color textColor, Color background, Function clickEvent()) {
    return new Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: new MaterialButton(
        child: Text(value),
        color: background,
        height: 50,
        textColor: textColor,
        onPressed: () {
          clickEvent();
        },
      ),
    );
  }

  Function buttonClick1() {
    setState(() {
      showProgress();
    });
    return null;
  }

  void toast(String value) {
    showToast(value,
        duration: Duration(seconds: 2),
        position: ToastPosition.bottom,
        textDirection: TextDirection.ltr,
        backgroundColor: Colors.grey,
        textStyle: new TextStyle(
          color: Colors.white,
          fontSize: 14,
        ));
  }

  Future<void> showProgress() async {
    progressDialog.show();
//    await Future.delayed(Duration(microseconds: 1000), () {
//      progressDialog.hide();
//    });
  }


}
