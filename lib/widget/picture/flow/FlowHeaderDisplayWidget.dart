import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_picture_select/bean/HeaderBean.dart';
import 'package:flutter_picture_select/const/Constant.dart';
import 'package:flutter_picture_select/util/PictureUtil.dart';
import 'package:oktoast/oktoast.dart';

import 'package:cached_network_image/cached_network_image.dart';


//图片GridView展示功能
class FlowHeaderDisplayWidget extends StatefulWidget {
  HeaderBean headerBean = new HeaderBean();
  final double itemWidth;  //图片宽度
  final double itemHeight; //图片高度
  final double itemHorizontalSpacing; //水平间距
  final double itemVerticalSpacing;  //垂直间距
  final double itemRoundArc; //圆角弧度
  FlowHeaderDisplayWidget(this.headerBean, this.itemWidth, this.itemHeight, this.itemHorizontalSpacing, this.itemVerticalSpacing, this.itemRoundArc, );

  @override
  _FlowHeaderDisplayWidgetState createState() =>
      _FlowHeaderDisplayWidgetState();
}

class _FlowHeaderDisplayWidgetState extends State<FlowHeaderDisplayWidget> {
  List<Widget> listWidget;
  List<String> imageUrls;
  List<String> names;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void setList() {
    print('setList');
    listWidget = new List<Widget>();
    imageUrls = new List<String>();
    names = new List<String>();
    for (int i = 0; i < widget.headerBean.datas.length; i++) {

        listWidget.add(networkImage(i, widget.headerBean.datas[i].url, widget.headerBean.datas[i].name));
        //末尾不加"加号"
        if (i != widget.headerBean.datas.length - 1) {
          listWidget.add(localImage());
        }

        imageUrls.add(widget.headerBean.datas[i].url);
        names.add(widget.headerBean.datas[i].name);

    }
  }

  Widget networkImage(int id, String url, String name) {
    return new Container(
//        alignment: Alignment.center,
//            color: Colors.greenAccent,

        child: getNetImage(id, true, url, name));
  }

  Widget getNetImage(int id, bool isVisible, String url, String name) {
    double imageWidth = widget.itemWidth;
    double imageHeight = widget.itemHeight;
    double fontSize = imageWidth / 3.5;

    print("imageWidth:" + imageWidth.toString());
    print("imageHeight:" + imageHeight.toString());
    print("fontSize:" + fontSize.toString());

    return new GestureDetector(
        onTap: () {
//        ImageUtil.openLargeImage(context,url,Constant.image_type_network);
          PictureUtil.openLargeImages(
              context, imageUrls, Constant.image_type_network, id);
        },
        child: new Offstage(
          //使用Offstage 控制widget在tree中的显示和隐藏
          offstage: isVisible ? false : true,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new ClipOval(
                child: new Container(
                  padding: EdgeInsets.all(0),
                  child: new CachedNetworkImage(
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    fadeInCurve: Curves.ease,
                    fadeInDuration: Duration(milliseconds: 500),
                    fadeOutCurve: Curves.ease,
                    fadeOutDuration: Duration(milliseconds: 300),
                    imageUrl: url,
//        placeholder: (context, url) => Image(image: AssetImage('images/icon_image_default.png')),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              ),
              new Container(
                padding: EdgeInsets.only(top: 3),
                child: new Text(
                  name,
                  style: new TextStyle(
                      color: const Color(0xFF999999),
                      fontSize: fontSize,
                      fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

//本地图片，（加号）
  Widget localImage() {
    double imageWidth = widget.itemWidth;
    double imageHeight = widget.itemHeight;
    double padding = imageWidth/3.5;
    if (padding < 3) padding = 3;
    print("localImage-imageWidth:" + imageWidth.toString());
    print("localImage-imageHeight:" + imageHeight.toString());
    print("localImage-padding:" + padding.toString());

    return new Stack(
//      alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
      overflow: Overflow.visible,
      children: <Widget>[
        new Container(
            color: const Color(0xFFFFFFFF),
            padding: EdgeInsets.all(padding),
            width: imageWidth,
            height: imageHeight,
            child: new Image.asset(
                'images/icon_add.png',
                fit: BoxFit.cover),
        ),
      ]
    );
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
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: new Wrap(
              spacing: widget.itemHorizontalSpacing, // 主轴(水平)方向间距
              runSpacing: widget.itemVerticalSpacing, // 纵轴（垂直）方向间距
              textDirection: TextDirection.ltr, //从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
              alignment: WrapAlignment.start, //textDirection的正方向
              verticalDirection: VerticalDirection.down, //down:表示从上到下 up:表示从下到上
              runAlignment: WrapAlignment.start, //纵轴方向的对齐方式:top,start,bottom,end
              children: listWidget,

            ),
          ),

        ]);
  }
}
