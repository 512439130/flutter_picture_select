import 'dart:io';


import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_picture_select/demo/bean/HeaderBean.dart';
import 'package:flutter_picture_select/demo/bean/ImageBean.dart';
import 'package:flutter_picture_select/demo/bean/LocalImageBean.dart';
import 'package:flutter_picture_select/demo/const/Constant.dart';
import 'package:flutter_picture_select/demo/util/PictureUtil.dart';
import 'package:flutter_picture_select/demo/dialog/BottomPickerHandler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

//图片GridView展示功能
class GridGeneralWidget extends StatefulWidget {
  final String type;
  ImageBean imageBean; //select picture
  HeaderBean headerBean;  //header:add,right
  List<LocalImageBean> dataBeanList; //display picture
  final double count; //每行个数
  final double maxWidth; //最大宽度
  final double itemHorizontalSpacing; //水平间距
  final double itemVerticalSpacing; //垂直间距
  final double itemRoundArc; //圆角弧度

  //display picture add interval image
  final String intervalImageType; //间隔类型
  final String intervalImageUrl; //间隔图访问Url

  final Function() onAddPress; //加号按钮回调
  final Function(int id, List<String> urls) onReplacePress; //替换回调
  final Function(int) onDeletePress; //删除按钮回调

  GridGeneralWidget({
    this.type,
    this.imageBean,
    this.dataBeanList,
    this.count,
    this.maxWidth,
    this.itemHorizontalSpacing,
    this.itemVerticalSpacing,
    this.itemRoundArc,
    this.headerBean,
    this.intervalImageType,
    this.intervalImageUrl,
    this.onAddPress,
    this.onReplacePress,
    this.onDeletePress,
  });

  @override
  _GridGeneralWidgetState createState() =>
      _GridGeneralWidgetState();
}

class _GridGeneralWidgetState extends State<GridGeneralWidget> {
  List<Widget> listWidget;
  List<String> imageUrls;
  List<String> names;


  AnimationController _controller;
  BottomPickerHandler bottomPicker;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  void init(){

  }


  void setList() {
    print('setList');
    listWidget = new List<Widget>();
    imageUrls = new List<String>();
    names = new List<String>();

    if(widget.type == Constant.grid_general_display){
      //display
      for (int i = 0; i < widget.imageBean.localImageBeanList.length; i++) {
        if (i < widget.imageBean.localImageBeanList.length - 1) {
          listWidget
              .add(displayNetworkImage(i, widget.imageBean.localImageBeanList[i].url));
          imageUrls.add(widget.imageBean.localImageBeanList[i].url);
        }
      }
    }else if(widget.type == Constant.grid_general_select){
      if (widget.dataBeanList != null &&
          widget.dataBeanList.length > 0) {
        for (int i = 0; i < widget.dataBeanList.length; i++) {
          listWidget.add(selectSdCardImage(i, widget.dataBeanList[i].url));
          imageUrls.add(widget.dataBeanList[i].url);
          print("test:" + widget.dataBeanList[i].url);
        }
        //每次在尾部加添加图片
        listWidget.add(addLocalImage());
      } else {
        listWidget.add(addLocalImage());
      }
    }else if(widget.type == Constant.grid_general_header){
      for (int i = 0; i < widget.headerBean.datas.length; i++) {
        listWidget.add(headerNetworkImage(i, widget.headerBean.datas[i].url, widget.headerBean.datas[i].name));
        if (i != widget.headerBean.datas.length - 1) {
          listWidget.add(headerLocalImage());
        }
        imageUrls.add(widget.headerBean.datas[i].url);
        names.add(widget.headerBean.datas[i].name);
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



  //sdcard图片，携带删除控制按钮
  Widget selectSdCardImage(int id, String path) {
    double margin =ScreenUtil.getInstance().setHeight(30) - (widget.count*0.4).toDouble();
    print("test-margin:"+margin.toString());
    return new Stack(
      alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
      overflow: Overflow.visible,
      children: <Widget>[
        new Container(
            alignment: Alignment.center,
//            color: Colors.amberAccent,
//            padding: const EdgeInsets.all(10),
            padding: EdgeInsets.all(margin),

            child: getSelectSdCardImage(id, false, path)),
        Positioned(
          //删除按钮距离右，顶的距离
          right: 0,
          top: 0,
          child: getDeleteIcon(id),
        )
      ],
    );



  }

  Widget getSelectSdCardImage(int id, bool offstage, String path) {
    double imageWidthOrHeight;
    double count = widget.count;
    double maxWidth = widget.maxWidth;
    imageWidthOrHeight = (widget.maxWidth/widget.count) - ((widget.count) * (4/widget.count * 2)) - 4 * 1.5;
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
  Widget addLocalImage() {
    double addWidthOrHeight ;
    double padding ;

    double count = widget.count;
    double maxWidth = widget.maxWidth;

    padding = (25 - (count*2)).toDouble();
    addWidthOrHeight = (widget.maxWidth/widget.count) - ((widget.count) * (4/widget.count * 2)) - 4 * 1.5;
    double margin = addWidthOrHeight/18;

    print("count:"+count.toString());
    print("padding:"+padding.toString());
    print("mScreenWidth:"+maxWidth.toString());
    print("addWidthOrHeight:"+addWidthOrHeight.toString());

    return new Stack(
      alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
      overflow: Overflow.visible,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.all(margin),
          child: new GestureDetector(
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
                    width: addWidthOrHeight/1.4,
                    height: addWidthOrHeight/1.4,
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
        'images/icon_delete.png',
        width: deleteWidthOrHeight,
        height: deleteWidthOrHeight,
        fit: BoxFit.cover,
      ),
    );
  }



  Widget headerNetworkImage(int id, String url, String name) {
    return new Container(
        alignment: Alignment.center,
//            color: Colors.greenAccent,
        child: getHeaderNetworkImage(id, true, url, name));
  }

  Widget getHeaderNetworkImage(int id, bool isVisible, String url, String name) {
    double imageWidthOrHeight;
    double count = widget.count;
    double maxWidth = widget.maxWidth;
    double mItemSpacing = 4;
    imageWidthOrHeight = (maxWidth / count) -
        ((count) * (mItemSpacing / count * 2)) -
        mItemSpacing * 1.5;
    imageWidthOrHeight = imageWidthOrHeight / 2.6;

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
                    decorationColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

//本地图片
  Widget headerLocalImage() {
    bool isVisible = true;
    double widthOrHeight;
    double padding;
    double count = widget.count;
    double maxWidth = widget.maxWidth;

    double mItemSpacing = 4;

    widthOrHeight = (maxWidth / count) - ((count) * (mItemSpacing / count * 2)) - mItemSpacing * 1.5;
    widthOrHeight = widthOrHeight / 2.6;

    double intervalWidth = widthOrHeight /3;
    double intervalHeight = widthOrHeight /3;
    if(widget.intervalImageType == Constant.grid_general_header_add){
      intervalWidth = widthOrHeight /2;
      intervalHeight = widthOrHeight /2;
    }else if(widget.intervalImageType == Constant.grid_general_header_right){
      intervalWidth = widthOrHeight/3.5;
      intervalHeight = widthOrHeight/2;
    }


    print("count:" + count.toString());
    print("padding:" + padding.toString());
    print("mScreenWidth:" + maxWidth.toString());
    print("WidthOrHeight:" + widthOrHeight.toString());
    print("imageWidth:" + intervalWidth.toString());
    print("imageHeight:" + intervalHeight.toString());
    return new Offstage(
      //使用Offstage 控制widget在tree中的显示和隐藏
        offstage: isVisible ? false : true,
        child: new Stack(
          alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              top: 0,
              child: new Container(
                alignment: Alignment.center,
                color: const Color(0xFFFFFFFF),

                width: widthOrHeight,
                height: widthOrHeight,
                child: new Image.asset(widget.intervalImageUrl,
                    width: intervalWidth,
                    height: intervalHeight,
                    fit: BoxFit.cover),
              ),
            ),
          ],
        ));
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
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: new Center(
                child: new GridView.count(
                  crossAxisCount: widget.type == Constant.grid_general_header?widget.intervalImageType == Constant.grid_general_header_right?widget.count.toInt() * 2: widget.count.toInt() * 2-1:widget.count.toInt(),
                  mainAxisSpacing: widget.itemVerticalSpacing,
                  //上下间距
                  crossAxisSpacing: widget.itemHorizontalSpacing,
                  //左右间距
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  primary: false,
                  shrinkWrap: true,
                  childAspectRatio: widget.type == Constant.grid_general_header? 2 / 3:1,
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
