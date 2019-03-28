import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_picture_select/bean/ImageBean.dart';
import 'package:flutter_picture_select/const/Constant.dart';
import 'package:flutter_picture_select/util/PictureUtil.dart';
import 'package:oktoast/oktoast.dart';

import 'package:cached_network_image/cached_network_image.dart';



//图片GridView展示功能
class GridPictureDisplayWidget extends StatefulWidget {
  BuildContext mContext;
  ImageBean testBean;
  double count;  //每行个数
  double maxWidth;//最大宽度
  double roundArc;//圆角弧度



  GridPictureDisplayWidget(this.mContext, this.testBean, this.count,this.maxWidth,this.roundArc);
  @override
  _GridPictureDisplayWidgetState createState() => _GridPictureDisplayWidgetState();
}


class _GridPictureDisplayWidgetState extends State<GridPictureDisplayWidget> {
  List<Widget> listWidget;
  List<String> imageUrls;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
//  //初始化


  void setList() {
    print('setList');
    listWidget = new List<Widget>();
    imageUrls = new List<String>();
    for (int i = 0; i < widget.testBean.datas.length; i++) {
      if (i < widget.testBean.datas.length - 1) {
        listWidget.add(networkImage(i, widget.testBean.datas[i].url));
        imageUrls.add(widget.testBean.datas[i].url);
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
            child: getNetImage(id, true, url)),
      ],
    );
  }



  Widget getNetImage(int id, bool isVisible, String url) {
    double imageWidthOrHeight;
    double count = widget.count;
    double maxWidth = widget.maxWidth;
    double mItemSpacing = 4;
    imageWidthOrHeight = (maxWidth/count) - ((count) * (mItemSpacing/count * 2)) - mItemSpacing * 1.5;


    print("count:"+count.toString());
    print("mScreenWidth:"+maxWidth.toString());
    print("imageWidthOrHeight:"+imageWidthOrHeight.toString());

    return new GestureDetector(
      onTap:(){
//        ImageUtil.openLargeImage(context,url,Constant.image_type_network);
        PictureUtil.openLargeImages(context, imageUrls, Constant.image_type_network,id);
      },
      child: new Offstage(
        //使用Offstage 控制widget在tree中的显示和隐藏
        offstage: isVisible ? false : true,
        child: new ClipRRect(
          child: new Container(
            padding: const EdgeInsets.all(0),
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
          //圆角
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.roundArc),
            topRight: Radius.circular(widget.roundArc),
            bottomLeft: Radius.circular(widget.roundArc),
            bottomRight: Radius.circular(widget.roundArc),
          ),
        ),
      ),
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
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            margin:  const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: new Center(
                child: new GridView.count(
                  crossAxisCount: widget.count.toInt(),
                  mainAxisSpacing: 0,
                  //上下间距
                  crossAxisSpacing: 0,
                  //左右间距
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  primary: false,
                  shrinkWrap: true,
                  children: listWidget,
                )),
          ),
        ]);
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
}
