import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_picture_select/bean/ImageBean.dart';
import 'package:flutter_picture_select/const/Constant.dart';
import 'package:flutter_picture_select/util/PictureUtil.dart';
import 'package:oktoast/oktoast.dart';

import 'package:cached_network_image/cached_network_image.dart';

//图片GridView展示功能
class FlowPictureDisplayWidget extends StatefulWidget {
  ImageBean testBean;
  final double itemWidth;  //图片宽度
  final double itemHeight; //图片高度
  final double itemHorizontalSpacing; //水平间距
  final double itemVerticalSpacing;  //垂直间距
  final double itemRoundArc; //圆角弧度

  FlowPictureDisplayWidget(
      this.testBean, this.itemWidth, this.itemHeight,this.itemHorizontalSpacing, this.itemVerticalSpacing,this.itemRoundArc);

  @override
  _FlowPictureDisplayWidgetState createState() =>
      _FlowPictureDisplayWidgetState();
}

class _FlowPictureDisplayWidgetState extends State<FlowPictureDisplayWidget> {
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
    for (int i = 0; i < widget.testBean.localImageBean.length; i++) {
      if (i < widget.testBean.localImageBean.length - 1) {
        listWidget.add(networkImage(i, widget.testBean.localImageBean[i].url));
        imageUrls.add(widget.testBean.localImageBean[i].url);
      }
    }
  }

  Widget networkImage(int id, String url) {
    return new Stack(
      alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
      overflow: Overflow.visible,
      children: <Widget>[
        new Container(
//            alignment: Alignment.center,
//            color: Colors.greenAccent,
            child: getNetImage(id, true, url)),
      ],
    );
  }

  Widget getNetImage(int id, bool isVisible, String url) {
    double imageWidth = widget.itemWidth;
    double imageHeight = widget.itemHeight;

    print("imageWidth:" + imageWidth.toString());
    print("imageHeight:" + imageHeight.toString());

    return new GestureDetector(
      onTap: () {
//        ImageUtil.openLargeImage(context,url,Constant.image_type_network);
        PictureUtil.openLargeImages(context, imageUrls, Constant.image_type_network, id);
      },
      child: new Offstage(
        //使用Offstage 控制widget在tree中的显示和隐藏
        offstage: isVisible ? false : true,
        child: new ClipRRect(
          child: new Container(
            padding: const EdgeInsets.all(0),
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
//            color: Colors.deepOrangeAccent,
            alignment: Alignment.centerLeft,  //保证内部为整体居左，未匹配单独图片靠左情况
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),//无法居中，暂时给整体内部加左内边距
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: new Wrap(
              spacing: widget.itemHorizontalSpacing, // 主轴(水平)方向间距
              runSpacing: widget.itemVerticalSpacing, // 纵轴（垂直）方向间距

              textDirection:TextDirection.ltr,  //从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
              alignment: WrapAlignment.start, //textDirection的正方向

              verticalDirection:VerticalDirection.down,  //down:表示从上到下 up:表示从下到上
              runAlignment:WrapAlignment.center,//纵轴方向的对齐方式:top,start,bottom,end
              children: listWidget,
            ),
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
