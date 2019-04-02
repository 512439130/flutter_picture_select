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
  ImageBean imageBean;
  double count;  //每行个数
  double maxWidth;//最大宽度
  final double itemHorizontalSpacing; //水平间距
  final double itemVerticalSpacing;  //垂直间距
  final double itemRoundArc; //圆角弧度



  GridPictureDisplayWidget(this.imageBean, this.count,this.maxWidth,this.itemHorizontalSpacing, this.itemVerticalSpacing,this.itemRoundArc);
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


  void setList() {
    print('setList');

    listWidget = new List<Widget>();
    imageUrls = new List<String>();
    for (int i = 0; i < widget.imageBean.localImageBeanList.length; i++) {
      if (i < widget.imageBean.localImageBeanList.length - 1) {
        listWidget.add(displayNetworkImage(i, widget.imageBean.localImageBeanList[i].url));
        imageUrls.add(widget.imageBean.localImageBeanList[i].url);
      }
    }
  }

  Widget displayNetworkImage(int id, String url) {
    return new Stack(
      alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
      overflow: Overflow.visible,

      children: <Widget>[
        new Container(
            alignment: Alignment.center,
//            color: Colors.greenAccent,
            child: getDisplayNetworkImage(id, true, url)),
      ],
    );
  }

  Widget getDisplayNetworkImage(int id, bool isVisible, String url) {
    double imageWidthOrHeight;
    double count = widget.count;
    double maxWidth = widget.maxWidth;
    double mItemSpacing = 4;
    imageWidthOrHeight = (maxWidth / count) -
        ((count) * (mItemSpacing / count * 2)) -
        mItemSpacing * 1.5;

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
            topLeft: Radius.circular(widget.itemRoundArc),
            topRight: Radius.circular(widget.itemRoundArc),
            bottomLeft: Radius.circular(widget.itemRoundArc),
            bottomRight: Radius.circular(widget.itemRoundArc),
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
                  mainAxisSpacing: widget.itemVerticalSpacing, //上下间距
                  crossAxisSpacing: widget.itemHorizontalSpacing, //左右间距
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
