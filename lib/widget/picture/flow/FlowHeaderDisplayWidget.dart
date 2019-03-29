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
  double count; //每行个数
  double maxWidth; //最大宽度

  FlowHeaderDisplayWidget(this.headerBean, this.count, this.maxWidth);

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
        alignment: Alignment.center,
//            color: Colors.greenAccent,
        child: getNetImage(id, true, url, name));
  }

  Widget getNetImage(int id, bool isVisible, String url, String name) {
    double imageWidthOrHeight;
    double count = widget.count;
    double maxWidth = widget.maxWidth;
    double mItemSpacing = 4;
    imageWidthOrHeight = (maxWidth / count) -
        ((count) * (mItemSpacing / count * 2)) -
        mItemSpacing * 1.5;
    imageWidthOrHeight = imageWidthOrHeight - (imageWidthOrHeight / 2);

    double fontSize = imageWidthOrHeight / 4;

    print("count:" + count.toString());
    print("mScreenWidth:" + maxWidth.toString());
    print("imageWidthOrHeight:" + imageWidthOrHeight.toString());

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
                    width: imageWidthOrHeight,
                    height: imageWidthOrHeight,

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
                padding: EdgeInsets.only(top: 5),
                child: new Text(
                  name,
                  style: new TextStyle(
                      color: Colors.black,
                      fontSize: fontSize,
                      fontStyle: FontStyle.normal,
                      decorationColor: Colors.green,),
                ),
              ),
            ],
          ),
        ));
  }

//本地图片，（加号）
  Widget localImage() {
    double addWidthOrHeight;
    double padding;
    double count = widget.count;
    double maxWidth = widget.maxWidth;

    double mItemSpacing = 4;
    padding = (25 - (count * 3)).toDouble();
    if (padding < 5) padding = 5;
    addWidthOrHeight = ((maxWidth / count) -
            ((count) * (mItemSpacing / count * 2)) -
            mItemSpacing * 1.5) /
        2;

    print("count:" + count.toString());
    print("padding:" + padding.toString());
    print("mScreenWidth:" + maxWidth.toString());
    print("addWidthOrHeight:" + addWidthOrHeight.toString());

    return new Stack(
      alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          top: 0,
          child: new Container(
            color: const Color(0xFFFFFFFF),
            padding: EdgeInsets.all(padding),
            width: addWidthOrHeight,
            height: addWidthOrHeight,
            child: new Image.asset('images/icon_add.png',
                width: addWidthOrHeight,
                height: addWidthOrHeight,
                fit: BoxFit.cover),
          ),
        ),
      ],
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
            color: const Color(0xFFFFFFFF),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: new Center(
                child: new GridView.count(
                crossAxisCount: widget.count.toInt() * 2,
                mainAxisSpacing: 10,//上下间距
                crossAxisSpacing: 0,//左右间距
                childAspectRatio: 2 / 3,//宽高比
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                primary: false,
                shrinkWrap: true,
                children: listWidget,
            )),
          ),
        ]);
  }


}
