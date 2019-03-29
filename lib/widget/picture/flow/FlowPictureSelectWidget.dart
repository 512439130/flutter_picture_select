import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_picture_select/bean/LocalImageBean.dart';
import 'package:flutter_picture_select/widget/dialog/BottomPickerHandler.dart';
import 'package:flutter_picture_select/widget/dialog/ProgressDialog.dart';
import 'package:flutter_picture_select/util/ListUtil.dart';
import 'package:oktoast/oktoast.dart';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


//图片GridView选择功能
class FlowPictureSelectWidget extends StatefulWidget {
  List<LocalImageBean> localImageBeanList;
  final double itemWidth; //图片宽度
  final double itemHeight; //图片高度
  final double itemHorizontalSpacing; //水平间距
  final double itemVerticalSpacing; //垂直间距
  final double itemRoundArc; //圆角弧度
  final Function() onAddPress; //加号按钮回调
  final Function(int id, List<String> urls) onReplacePress; //替换回调
  final Function(int) onDeletePress; //删除按钮回调

  FlowPictureSelectWidget(this.localImageBeanList, this.itemWidth,
      this.itemHeight, this.itemHorizontalSpacing, this.itemVerticalSpacing,
      this.itemRoundArc, this.onAddPress, this.onReplacePress,
      this.onDeletePress);

  @override
  _FlowPictureSelectWidgetState createState() =>
      _FlowPictureSelectWidgetState();
}


class _FlowPictureSelectWidgetState extends State<FlowPictureSelectWidget>
    with TickerProviderStateMixin
    implements BottomPickerListener {
  List<Widget> listWidget;
  List<String> imageUrls;

  ProgressDialog progressDialog;

  AnimationController _controller;
  BottomPickerHandler bottomPicker;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    init();
    initProgress();
    initBottomPicker();
  }

  //获取屏幕宽高
  void init() {
//   Size mScreenSize = MediaQuery.of(widget.mContext).size;
  }

  void initProgress() {
    progressDialog = new ProgressDialog(context);
    progressDialog.setMessage("Loading...");
    progressDialog.setTextColor(Colors.black);
    progressDialog.setTextSize(16);
  }

  void initBottomPicker() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    bottomPicker = new BottomPickerHandler(this, _controller);
    bottomPicker.init();
  }

  @override
  bottomSelectImage(File _image) {
    //选择图片后的回调
    // TODO: implement useImage
    int length;
    if (widget.localImageBeanList != null &&
        widget.localImageBeanList.length > 0) {
      length = widget.localImageBeanList.length + 1;
    } else {
      length = 1;
    }
    setState(() {
      if (_image != null) {
        print('addSdCard');
        LocalImageBean localImageBean = new LocalImageBean();
        localImageBean.id = length.toString();
        localImageBean.path = _image.path;
        //type
        widget.localImageBeanList.add(localImageBean);
        //去重复
        widget.localImageBeanList =
            ListUtil.deduplication(widget.localImageBeanList);
      } else {
        print('addSdCard-未选择');
      }
    });
    return null;
  }

  void setList() {
    print('setList');
    listWidget = new List<Widget>();
    imageUrls = new List<String>();
    if (widget.localImageBeanList != null &&
        widget.localImageBeanList.length > 0) {
      for (int i = 0; i < widget.localImageBeanList.length; i++) {
        listWidget.add(sdCardImage(i, widget.localImageBeanList[i].path));
        imageUrls.add(widget.localImageBeanList[i].path);
        print("test:" + widget.localImageBeanList[i].path);
      }
      //每次在尾部加添加图片
      listWidget.add(localImage());
    } else {
      listWidget.add(localImage());
    }
  }

  //sdcard图片，携带删除控制按钮
  Widget sdCardImage(int id, String path) {
    double margin = widget.itemWidth/10;
    return new Stack(
//      alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
      overflow: Overflow.visible,
      children: <Widget>[
        new Container(
//            alignment: Alignment.center,
//            color: Colors.amberAccent,
            padding: EdgeInsets.all(margin),

            child: getSdCardImage(id, false, path)),
        Positioned(
          //删除按钮距离右，顶的距离
          right: 0,
          top: 0,
          child: getDeleteIcon(id),
        )
      ],
    );
  }

  Widget getSdCardImage(int id, bool offstage, String path) {
    double imageWidth = widget.itemWidth;
    double imageHeight = widget.itemHeight;

    print("imageWidth:" + imageWidth.toString());
    print("imageHeight:" + imageHeight.toString());


    return new GestureDetector(
      onTap: () {
        widget.onReplacePress(id, imageUrls);
      },
      child: new Offstage(
        //使用Offstage 控制widget在tree中的显示和隐藏
        offstage: offstage,
        child: new ClipRRect(
          child: new Container(
//            padding: const EdgeInsets.all(5),
//            color: Colors.deepOrange,
            child: new Image.file(
              new File(path),
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.cover,
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

//本地图片，（加号）
  Widget localImage() {
    double imageWidth = widget.itemWidth;
    double imageHeight = widget.itemHeight;
    double padding = imageWidth / 5;
    double margin = widget.itemWidth/10;

    print("imageWidth:" + imageWidth.toString());
    print("imageHeight:" + imageHeight.toString());
    print("padding:" + padding.toString());


    return new Stack(
      alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
      overflow: Overflow.visible,
      children: <Widget>[
        new Container(
//            color: Colors.red,
          padding: EdgeInsets.all(margin),
            child: new GestureDetector(
              onTap: () {
                widget.onAddPress();
              },
              child: new ClipRRect(
                child: new Container(
                  color: const Color(0xFFF7F8FA),
                  padding: EdgeInsets.all(padding),
                  width: imageWidth + padding/2 -7,
                  height: imageWidth + padding/2 -7,
                  child: new Image.asset('images/icon_add.png',
                      width: imageWidth,
                      height: imageWidth,
                      fit: BoxFit.cover),
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
        ),


      ],
    );
  }

  Widget getDeleteIcon(int id) {
    double imageWidth = widget.itemWidth / 4;
    double imageHeight = widget.itemHeight / 4;

    print("imageWidth:" + imageWidth.toString());
    print("imageHeight:" + imageHeight.toString());


    return new GestureDetector(
      onTap: () {
        widget.onDeletePress(id);
        //调用delete
      },
      child: Image.asset(
        'images/icon_close.png',
        width: imageWidth,
        height: imageWidth,
        fit: BoxFit.cover,
      ),
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    setList();
//    return new ListView(
//        shrinkWrap: true,
//        physics: BouncingScrollPhysics(),
//        children: <Widget>[
//          new Container(
//            color: const Color(0xFFFFFFFF),
//            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//            margin:  const EdgeInsets.fromLTRB(0, 0, 0, 0),
//            child: new Center(
//                child: new GridView.count(
//                  crossAxisCount: widget.count.toInt(),
//                  mainAxisSpacing: 0, //上下间距
//                  crossAxisSpacing: 0, //左右间距
//                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                  primary: false,
//                  shrinkWrap: true,
//                  children: listWidget,
//                )),
//          ),
//        ]);
//  }


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
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: new Wrap(
              spacing: widget.itemHorizontalSpacing,
              // 主轴(水平)方向间距
              runSpacing: widget.itemVerticalSpacing,
              // 纵轴（垂直）方向间距

              textDirection: TextDirection.ltr,
              //从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
              alignment: WrapAlignment.start,
              //textDirection的正方向

              verticalDirection: VerticalDirection.down,
              //down:表示从上到下 up:表示从下到上
              runAlignment: WrapAlignment.center,
              //纵轴方向的对齐方式:top,start,bottom,end
              children: listWidget,
            ),
          ),
        ]);
  }


}
