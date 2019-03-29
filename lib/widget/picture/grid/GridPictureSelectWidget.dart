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
class GridPictureSelectWidget extends StatefulWidget {
  List<LocalImageBean> localImageBeanList;
  double count;  //每行个数
  double maxWidth;//最大宽度
  double roundArc;//圆角弧度
  Function() onAddPress;  //加号按钮回调
  Function(int id, List<String> urls) onReplacePress;  //替换回调
  Function(int) onDeletePress;  //删除按钮回调

  GridPictureSelectWidget(this.localImageBeanList, this.count,this.maxWidth,this.roundArc, this.onAddPress, this.onReplacePress, this.onDeletePress);
  @override
  _GridPictureSelectWidgetState createState() => _GridPictureSelectWidgetState();
}


class _GridPictureSelectWidgetState extends State<GridPictureSelectWidget> with TickerProviderStateMixin implements BottomPickerListener{
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
    if (widget.localImageBeanList != null && widget.localImageBeanList.length > 0) {
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
        widget.localImageBeanList = ListUtil.deduplication(widget.localImageBeanList);
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

    return new Stack(
      alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
      overflow: Overflow.visible,
      children: <Widget>[
        new Container(
            alignment: Alignment.center,
//            color: Colors.amberAccent,
//            padding: const EdgeInsets.all(10),

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
    double imageWidthOrHeight;
    double count = widget.count;
    double maxWidth = widget.maxWidth;
      double mItemSpacing = 4;
      imageWidthOrHeight = (maxWidth/count) - ((count) * (mItemSpacing/count * 2)) - mItemSpacing * 1.5;


    print("count:"+count.toString());
    print("mScreenWidth:"+maxWidth.toString());
    print("imageWidthOrHeight:"+imageWidthOrHeight.toString());


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
              //image大小，暂时必须写死
              width: imageWidthOrHeight,
              height: imageWidthOrHeight,
              fit: BoxFit.cover,
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

//本地图片，（加号）
  Widget localImage() {
    double addWidthOrHeight ;
    double padding ;
    double margin = 7;
    double count = widget.count;
    double maxWidth = widget.maxWidth;

      double mItemSpacing = 4;
      padding = (25 - (count*2)).toDouble();
      addWidthOrHeight = (maxWidth/count) - ((count) * (mItemSpacing/count * 2)) - mItemSpacing * 1.5;


    print("count:"+count.toString());
    print("padding:"+padding.toString());
    print("mScreenWidth:"+maxWidth.toString());
    print("addWidthOrHeight:"+addWidthOrHeight.toString());



    return new Stack(
      alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
      overflow: Overflow.visible,
      children: <Widget>[
        new GestureDetector(
          onTap: () {
            widget.onAddPress();
          },
          child: new ClipRRect(
            child: new Container(
              color: const Color(0xFFF7F8FA),
              padding: EdgeInsets.all(padding),
              width: addWidthOrHeight,
              height: addWidthOrHeight,
              child: new Image.asset('images/icon_add.png',
                  width: addWidthOrHeight,
                  height: addWidthOrHeight,
                  fit: BoxFit.cover),
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
      ],
    );
  }

  Widget getDeleteIcon(int id) {
    double deleteWidthOrHeight = 0;
    double count = widget.count;
    deleteWidthOrHeight = (25 - (count*1.2)).toDouble();


    print("count:"+count.toString());

    print("deleteWidthOrHeight:"+deleteWidthOrHeight.toString());



    return new GestureDetector(
      onTap: () {
        widget.onDeletePress(id);
        //调用delete
      },
      child: Image.asset(
        'images/icon_close.png',
        width: deleteWidthOrHeight,
        height: deleteWidthOrHeight,
        fit: BoxFit.cover,
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
                  mainAxisSpacing: 0, //上下间距
                  crossAxisSpacing: 0, //左右间距
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  primary: false,
                  shrinkWrap: true,
                  children: listWidget,
                )),
          ),
        ]);
  }






}
