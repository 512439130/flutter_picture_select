import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picture_select/bean/LocalImageBean.dart';
import 'package:flutter_picture_select/const/Constant.dart';
import 'package:flutter_picture_select/widget/dialog/BottomPickerHandler.dart';
import 'package:flutter_picture_select/widget/dialog/ProgressDialog.dart';
import 'package:flutter_picture_select/util/ListUtil.dart';
import 'package:flutter_picture_select/util/PermissionUtil.dart';
import 'package:flutter_picture_select/util/PictureUtil.dart';
import 'package:flutter_picture_select/util/ToastUtil.dart';
import 'package:flutter_picture_select/widget/picture/flow/FlowPictureSelectWidget.dart';
import 'package:flutter_picture_select/widget/picture/grid/GridPictureSelectWidget.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:simple_permissions/simple_permissions.dart';

const String name1 = 'FlowSelectPictureWidgetDemo';

class FlowSelectPictureWidgetDemo extends StatefulWidget {
  FlowSelectPictureWidgetDemo({Key key, this.title}) : super(key: key);
  final String title;

  @override
  FlowSelectPictureWidgetDemoState createState() =>
      FlowSelectPictureWidgetDemoState();
}

class FlowSelectPictureWidgetDemoState
    extends State<FlowSelectPictureWidgetDemo>
    with TickerProviderStateMixin
    implements BottomPickerListener {
  List<LocalImageBean> localImageBeanList; //保存数据的泛型实体

  ProgressDialog progressDialog; //加载进度条可选添加

  //底部拍照/相册功能
  BottomPickerHandler bottomPicker;
  AnimationController bottomAnimationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    init();
  }

  void init() {
    localImageBeanList = new List<LocalImageBean>();
    initProgress();
    initBottomPicker();
  }

  void initProgress() {
    progressDialog = new ProgressDialog(context);
    progressDialog.setMessage("Loading...");
    progressDialog.setTextColor(Colors.black);
    progressDialog.setTextSize(16);
  }

  void initBottomPicker() {
    bottomAnimationController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    bottomPicker = new BottomPickerHandler(this, bottomAnimationController);
    bottomPicker.init();
  }

  Future<void> asyncDeleteImage(int id) async {
    try {
      progressDialog.show();
      await Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          localImageBeanList.removeAt(id);
        });
        progressDialog.hide();
      });
    } catch (e) {
      progressDialog.hide();
      print("faild:$e.toString()");
    }
  }

  Future<void> asyncReplaceImage(int id) async {
    try {
      progressDialog.show();
      await Future.delayed(Duration(milliseconds: 500), () {
        progressDialog.hide();
        replaceSdCard(id);
      });
    } catch (e) {
      progressDialog.hide();
      print("faild:$e.toString()");
    }
  }

  Future<void> replaceSdCard(int id) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        print('replaceSdCard');
        //type
        localImageBeanList[id].path = image.path;
        //去重复
        localImageBeanList = ListUtil.deduplication(localImageBeanList);
      } else {
        print('replaceSdCard-未选择');
      }
    });
  }

  Future<void> asyncAddImage(int id) async {
    try {
      progressDialog.show();
      await Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          Future future1 = new Future(() => null);
          future1.then((_) {
            PermissionUtil.requestPermission(Permission.WriteExternalStorage)
                .then((result) {
              print("requestPermission-WriteExternalStorage$result");
              if (result == PermissionStatus.deniedNeverAsk) {
                //setting
                ToastUtil.toast('由于用户您选择不在提醒，并且拒绝了权限，请您去系统设置修改相关权限后再进行功能尝试');
                PermissionUtil.openPermissionSetting();
              } else if (result == PermissionStatus.authorized) {
                Future future2 = new Future(() => null);
                future2.then((_) {
                  PermissionUtil.requestPermission(Permission.Camera)
                      .then((result2) {
                    print("requestPermission-Camera$result2");
                    if (result2 == PermissionStatus.deniedNeverAsk) {
                      //setting
                      ToastUtil.toast(
                          '由于用户您选择不在提醒，并且拒绝了权限，请您去系统设置修改相关权限后再进行功能尝试');
                      PermissionUtil.openPermissionSetting();
                    } else if (result2 == PermissionStatus.authorized) {
                      bottomPicker.showDialog(context);
                    }
                  });
                });
              }
            });
          });
        });
        progressDialog.hide();
      });
    } catch (e) {
      progressDialog.hide();
      print("faild:$e.toString()");
    }
  }

  @override
  Widget build(BuildContext context) {
    double boxMarginLeft = 18; //盒子左边距
    double boxMarginTop = 14; //盒子顶边距
    double boxMarginRight = 18; //盒子右边距
    double boxMarginBottom = 14; //盒子底边距

    double itemWidth = 65; //图片宽度
    double itemHeight = 65; //图片高度
    double itemHorizontalSpacing = 18; //水平间距
    double itemVerticalSpacing = 18; //垂直间距
    double itemRoundArc = 5; //图片圆角弧度

    return Scaffold(
      appBar: AppBar(
        title: Text(name1),
      ),
      body: new Container(
//          color: Colors.greenAccent,
          child: new ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              new Container(
                color: Colors.white,
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(boxMarginLeft, boxMarginTop,
                    boxMarginRight, boxMarginBottom),
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: new FlowPictureSelectWidget(
                    localImageBeanList,
                    itemWidth,
                    itemHeight,
                    itemHorizontalSpacing,
                    itemVerticalSpacing,
                    itemRoundArc,
                    addClick,
                    replaceClick,
                    deleteClick),
              ),
              new Container(
                alignment: Alignment.center,
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(boxMarginLeft, boxMarginTop,
                    boxMarginRight, boxMarginBottom),
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: new FlowPictureSelectWidget(
                    localImageBeanList,
                    90,
                    90,
                    itemHorizontalSpacing,
                    itemVerticalSpacing,
                    itemRoundArc,
                    addClick,
                    replaceClick,
                    deleteClick),
              ),
              new Container(
                alignment: Alignment.topLeft,
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(boxMarginLeft, boxMarginTop,
                    boxMarginRight, boxMarginBottom),
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: new FlowPictureSelectWidget(
                    localImageBeanList,
                    146,
                    146,
                    itemHorizontalSpacing,
                    itemVerticalSpacing,
                    itemRoundArc,
                    addClick,
                    replaceClick,
                    deleteClick),
              ),
            ],
          )),
    );
  }

  Function addClick() {
    int defaultLength = 1;
    if (localImageBeanList != null && localImageBeanList.length > 0) {
      asyncAddImage(localImageBeanList.length + 1);
    } else {
      asyncAddImage(defaultLength);
    }
    return null;
  }

  Function replaceClick(int id, List<String> imageUrls) {
    PictureUtil.openLargeImages(
        context, imageUrls, Constant.image_type_sdcard, id);
    return null;
  }

  Function deleteClick(int id) {
    asyncDeleteImage(id);
    return null;
  }

  @override
  bottomSelectImage(File _image) {
    //选择图片后的回调
    // TODO: implement useImage
    int length;
    if (localImageBeanList != null && localImageBeanList.length > 0) {
      length = localImageBeanList.length + 1;
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
        localImageBeanList.add(localImageBean);
        //去重复
        localImageBeanList = ListUtil.deduplication(localImageBeanList);
      } else {
        print('addSdCard-未选择');
      }
    });
    return null;
  }
}
