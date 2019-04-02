import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_picture_select/bean/HeaderBean.dart';
import 'package:flutter_picture_select/bean/ImageBean.dart';
import 'package:flutter_picture_select/bean/LocalImageBean.dart';
import 'package:flutter_picture_select/const/Constant.dart';
import 'package:flutter_picture_select/util/ListUtil.dart';
import 'package:flutter_picture_select/util/PermissionUtil.dart';
import 'package:flutter_picture_select/util/PictureUtil.dart';
import 'package:flutter_picture_select/util/ToastUtil.dart';
import 'package:flutter_picture_select/widget/dialog/BottomPickerHandler.dart';
import 'package:flutter_picture_select/widget/dialog/ProgressDialog.dart';
import 'package:flutter_picture_select/widget/picture/grid/general/GridGeneralWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_permissions/simple_permissions.dart';


const String title = 'GridPictureDisplayWidgetDemo';

class GridGeneralWidgetDemo extends StatefulWidget {
  GridGeneralWidgetDemo({Key key, this.title}) : super(key: key);
  final String title;

  @override
  GridGeneralWidgetDemoState createState() => GridGeneralWidgetDemoState();
}

class GridGeneralWidgetDemoState extends State<GridGeneralWidgetDemo> with TickerProviderStateMixin implements BottomPickerListener {
  //display
  ImageBean imageBean = new ImageBean();//保存数据的泛型实体
  //header
  HeaderBean headerBean = new HeaderBean();

  //select
  List<LocalImageBean> localImageBeanList;
  ProgressDialog progressDialog;
  BottomPickerHandler bottomPicker;
  AnimationController bottomAnimationController;

  Size parentSize;  //最大宽度
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    init();
  }
  void init() {

    //display
    String imageJsonValue ='{"datas":[{"id":"1","url":"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1553505918721&di=30abbc97f9b299cad7de51a06cbee078&imgtype=0&src=http%3A%2F%2Fimg15.3lian.com%2F2015%2Ff2%2F57%2Fd%2F93.jpg"},{"id":"2","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=80538588,251590437&fm=26&gp=0.png"},{"id":"3","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3597303668,2750618423&fm=26&gp=0.png"},{"id":"4","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=61077523,1715146142&fm=26&gp=0.png"},{"id":"5","url":"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4087213632,1096565806&fm=26&gp=0.png"},{"id":"6","url":"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3597303668,2750618423&fm=26&gp=0.png"}],"resMsg":{"message":"success !","method":null,"code":"1"}}';
    Map<String, dynamic> imageJson;
    if (imageJsonValue != null) {
      imageJson = jsonDecode(imageJsonValue);
      imageBean = ImageBean.fromJson(imageJson);
    }
    //header
    String headerJsonValue ='{"datas":[{"id":"1","url":"https://gss1.bdstatic.com/9vo3dSag_xI4khGkpoWK1HF6hhy/baike/w%3D268%3Bg%3D0/sign=517d540e8e18367aad8978db1648ece9/b58f8c5494eef01fdb0581e2e8fe9925bc317d80.jpg","name":"张一鸣"},{"id":"2","url":"https://gss3.bdstatic.com/-Po3dSag_xI4khGkpoWK1HF6hhy/baike/w%3D268%3Bg%3D0/sign=743300c78dd6277fe912353e1003780d/5d6034a85edf8db13821e8180323dd54564e74bb.jpg","name":"张小龙"},{"id":"3","url":"https://gss0.bdstatic.com/94o3dSag_xI4khGkpoWK1HF6hhy/baike/w%3D268%3Bg%3D0/sign=bf1f9fba0f082838680ddb1280a2ce3c/8cb1cb1349540923453457db9a58d109b3de4931.jpg","name":"马化腾"},{"id":"4","url":"https://gss3.bdstatic.com/-Po3dSag_xI4khGkpoWK1HF6hhy/baike/w%3D268%3Bg%3D0/sign=d6d431bf9aef76c6d0d2fc2da52d9ac7/2f738bd4b31c8701928251782d7f9e2f0708ff7c.jpg","name":"李彦宏"},{"id":"5","url":"https://gss2.bdstatic.com/9fo3dSag_xI4khGkpoWK1HF6hhy/baike/s%3D220/sign=ef281d4357da81cb4ae684cf6267d0a4/f703738da9773912f15d70d6fe198618367ae20a.jpg","name":"范冰冰"},{"id":"6","url":"https://gss0.bdstatic.com/-4o3dSag_xI4khGkpoWK1HF6hhy/baike/w%3D268%3Bg%3D0/sign=0003b03088b1cb133e693b15e56f3173/0bd162d9f2d3572c257447038f13632763d0c35f.jpg","name":"马云"},{"id":"7","url":"https://gss1.bdstatic.com/9vo3dSag_xI4khGkpoWK1HF6hhy/baike/w%3D268%3Bg%3D0/sign=3a64e2745c0fd9f9a017526f1d16b317/d31b0ef41bd5ad6e0c58a9e28ccb39dbb6fd3c11.jpg","name":"王力宏"},{"id":"8","url":"https://gss3.bdstatic.com/7Po3dSag_xI4khGkpoWK1HF6hhy/baike/w%3D268%3Bg%3D0/sign=8015dac14fa7d933bfa8e3759570b62e/5882b2b7d0a20cf4be0b1e0a7b094b36adaf9948.jpg","name":"潘玮柏"},{"id":"9","url":"https://gss2.bdstatic.com/-fo3dSag_xI4khGkpoWK1HF6hhy/baike/s%3D220/sign=7a156e5ceccd7b89ed6c3d813f254291/2f738bd4b31c87010f99dc702d7f9e2f0708ff7d.jpg","name":"陈乔恩"},{"id":"10","url":"https://b-ssl.duitang.com/uploads/item/201703/30/20170330175756_5KzW3.thumb.700_0.jpeg","name":"戚薇"},{"id":"11","url":"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1553766301424&di=7c577a52b425f6f44fedc438a6195cf3&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201305%2F04%2F20130504022246_YvfsZ.thumb.700_0.jpeg","name":"路飞"},{"id":"12","url":"http://h.hiphotos.baidu.com/baike/s%3D220/sign=27f10ce946086e066ea8384932097b5a/eaf81a4c510fd9f94842c5b12f2dd42a2934a495.jpg","name":"索隆"}],"resMsg":{"message":"success !","method":null,"code":"1"}}';
    Map<String, dynamic> headerJson;
    if (headerJsonValue != null) {
      headerJson = jsonDecode(headerJsonValue);
      headerBean = HeaderBean.fromJson(headerJson);
    }
    //select
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





  @override
  Widget build(BuildContext context) {
    double boxPaddingLeft = ScreenUtil.getInstance().setHeight(10); //盒子左边距
    double boxPaddingTop = ScreenUtil.getInstance().setHeight(14); //盒子顶边距
    double boxPaddingRight = ScreenUtil.getInstance().setHeight(10); //盒子右边距
    double boxPaddingBottom = ScreenUtil.getInstance().setHeight(14); //盒子底边距
    double itemHorizontalSpacing = ScreenUtil.getInstance().setHeight(12); //水平间距
    double itemVerticalSpacing = ScreenUtil.getInstance().setHeight(12); //垂直间距

    double parentWidth = ScreenUtil.getInstance().setWidth(1440);
    double itemRoundArc = ScreenUtil.getInstance().setHeight(5); //图片圆角弧度
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(title),
        ),
        body: new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[


            //display
            new Container(
              color: Colors.white,
              margin:EdgeInsets.only(top: 10),
              padding: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: new Wrap(
                textDirection: TextDirection.ltr,
                //从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
                alignment: WrapAlignment.start,
                //textDirection的正方向
                verticalDirection: VerticalDirection.down,
                //down:表示从上到下 up:表示从下到上
                runAlignment: WrapAlignment.start,
                //纵轴方向的对齐方式:top,start,bottom,end
                children: <Widget>[
                  new Flex(  //弹性布局
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    //down:表示从上到下 up:表示从下到上
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //参考verticalDirection start表示正方向，end表示反方向
                    children: <Widget>[  //比例1:4
                      new Expanded(
//                        flex: (size.width~/4).toInt(),
                        flex: 1,
                        child: new Container(
//                        color: Colors.blue,
                          alignment: Alignment.centerLeft, //内容位置
                          child: new Text(
                            "图         片",
                            style: new TextStyle(
                              color: const Color(0xFF999999),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new Container(
                          alignment: Alignment.topLeft,
                          child:
                          new GridGeneralWidget(type:Constant.grid_general_display,
                            imageBean:imageBean,
                            headerBean:null,
                            dataBeanList:null,
                            count:4,
                            maxWidth:parentWidth,
                            itemHorizontalSpacing:itemHorizontalSpacing,
                            itemVerticalSpacing:itemVerticalSpacing,
                            itemRoundArc:itemRoundArc,

                            intervalImageType:null,
                            intervalImageUrl:null,
                            onAddPress:null,
                            onReplacePress:null,
                            onDeletePress:null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //header_add
            new Container(
              color:Colors.white,
              margin:EdgeInsets.only(top: 10),
              padding:EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: new GridGeneralWidget(type:Constant.grid_general_header,
                imageBean:null,
                headerBean:headerBean,
                dataBeanList:null,
                count:4,
                maxWidth:parentWidth,
                itemHorizontalSpacing:itemHorizontalSpacing,
                itemVerticalSpacing:itemVerticalSpacing,
                itemRoundArc:itemRoundArc,

                intervalImageType:Constant.grid_general_header_add,
                intervalImageUrl:'images/icon_add.png',
                onAddPress:null,
                onReplacePress:null,
                onDeletePress:null,
              ),
            ),

            //header_right
            new Container(
              color:Colors.white,
              margin:EdgeInsets.only(top: 10),
              padding:EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: new GridGeneralWidget(type:Constant.grid_general_header,
                imageBean:null,
                headerBean:headerBean,
                dataBeanList:null,
                count:4,
                maxWidth:parentWidth,
                itemHorizontalSpacing:itemHorizontalSpacing,
                itemVerticalSpacing:itemVerticalSpacing,
                itemRoundArc:itemRoundArc,

                intervalImageType:Constant.grid_general_header_right,
                intervalImageUrl:'images/icon_right.png',
                onAddPress:null,
                onReplacePress:null,
                onDeletePress:null,
              ),
            ),
            new Container(
              color:Colors.white,
              margin:EdgeInsets.only(top: 10),
              child: //select
              new GridGeneralWidget(type:Constant.grid_general_select,
                imageBean:null,
                headerBean:null,
                dataBeanList:localImageBeanList,
                count:4,
                maxWidth:parentWidth,
                itemHorizontalSpacing:itemHorizontalSpacing,
                itemVerticalSpacing:itemVerticalSpacing,
                itemRoundArc:itemRoundArc,

                intervalImageType:null,
                intervalImageUrl:null,
                onAddPress:addClick,
                onReplacePress:replaceClick,
                onDeletePress:deleteClick,
              ),
            ),




          ],
        ));
  }

  Function addClick() {
    asyncAddImage();
    return null;
  }

  Function replaceClick( int id,List<String> imageUrls) {
    PictureUtil.openLargeImages(context, imageUrls, Constant.image_type_sdcard, id);
    return null;
  }

  Function deleteClick(int id) {
    asyncDeleteImage(id);
    return null;
  }




  //底部弹窗回调
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
                      ToastUtil.toast('由于用户您选择不在提醒，并且拒绝了权限，请您去系统设置修改相关权限后再进行功能尝试');
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


}
