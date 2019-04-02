import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_picture_select/bean/LocalImageBean.dart';
import 'package:flutter_picture_select/const/Constant.dart';
import 'package:flutter_picture_select/util/ListUtil.dart';
import 'package:flutter_picture_select/util/PermissionUtil.dart';
import 'package:flutter_picture_select/util/PictureUtil.dart';
import 'package:flutter_picture_select/util/ToastUtil.dart';
import 'package:flutter_picture_select/widget/dialog/BottomPickerHandler.dart';
import 'package:flutter_picture_select/widget/dialog/ProgressDialog.dart';
import 'package:flutter_picture_select/widget/picture/flow/FlowPictureSelectWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
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
        localImageBeanList[id].url = image.path;
        //去重复
        localImageBeanList = ListUtil.deduplication(localImageBeanList);
      } else {
        print('replaceSdCard-未选择');
      }
    });
  }

  Future<void> asyncAddImage() async {
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
    double boxPaddingLeft = ScreenUtil.getInstance().setHeight(5); //盒子左边距
    double boxPaddingTop = ScreenUtil.getInstance().setHeight(12); //盒子顶边距
    double boxPaddingRight = ScreenUtil.getInstance().setHeight(5); //盒子右边距
    double boxPaddingBottom = ScreenUtil.getInstance().setHeight(12); //盒子底边距
    double itemHorizontalSpacing = ScreenUtil.getInstance().setHeight(17); //水平间距
    double itemVerticalSpacing = ScreenUtil.getInstance().setHeight(17); //垂直间距


    double itemRoundArc = ScreenUtil.getInstance().setHeight(5); //图片圆角弧度

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(name1),
      ),
      body: new Container(
//          color: Colors.greenAccent,
          child: new ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              //每行2个(包括加号)
              new Container(
                color: Colors.white,
//                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop,
                    boxPaddingRight, boxPaddingBottom),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: new FlowPictureSelectWidget(
                    localImageBeanList,
                    ScreenUtil.getInstance().setHeight(420),
                    ScreenUtil.getInstance().setHeight(420),
                    itemHorizontalSpacing,
                    itemVerticalSpacing,
                    itemRoundArc,
                    addClick,
                    replaceClick,
                    deleteClick),
              ),
              //每行3个(包括加号)
              new Container(
//                alignment: Alignment.center,
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop,
                    boxPaddingRight, boxPaddingBottom),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: new FlowPictureSelectWidget(
                    localImageBeanList,
                    ScreenUtil.getInstance().setHeight(270),
                    ScreenUtil.getInstance().setHeight(270),
                    itemHorizontalSpacing,
                    itemVerticalSpacing,
                    itemRoundArc,
                    addClick,
                    replaceClick,
                    deleteClick),
              ),
              //每行4个(包括加号)
              new Container(
//                alignment: Alignment.topLeft,
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop,
                    boxPaddingRight, boxPaddingBottom),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: new FlowPictureSelectWidget(
                    localImageBeanList,
                    ScreenUtil.getInstance().setHeight(200),
                    ScreenUtil.getInstance().setHeight(200),
                    itemHorizontalSpacing,
                    itemVerticalSpacing,
                    itemRoundArc,
                    addClick,
                    replaceClick,
                    deleteClick),
              ),

              //每行5个(包括加号)
              new Container(
//                alignment: Alignment.topLeft,
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop,
                    boxPaddingRight, boxPaddingBottom),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: new FlowPictureSelectWidget(
                    localImageBeanList,
                    ScreenUtil.getInstance().setHeight(160),
                    ScreenUtil.getInstance().setHeight(170),
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
    asyncAddImage();
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
        localImageBean.url = _image.path;
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
