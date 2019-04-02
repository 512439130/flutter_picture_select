import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_picture_select/demo/bean/FileBean.dart';
import 'package:flutter_picture_select/demo/bean/LocalFileBean.dart';
import 'package:flutter_picture_select/demo/const/Constant.dart';
import 'package:flutter_picture_select/demo/util/FilePicker.dart';
import 'package:flutter_picture_select/demo/util/PermissionUtil.dart';
import 'package:flutter_picture_select/demo/util/ToastUtil.dart';
import 'package:flutter_picture_select/demo/dialog/ProgressDialog.dart';
import 'package:flutter_picture_select/demo/widget/FileDisplayWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_permissions/simple_permissions.dart';

const String title = 'FileDisplayWidgetDemo';

class FileDisplayWidgetDemo extends StatefulWidget {
  FileDisplayWidgetDemo({Key key, this.title}) : super(key: key);
  final String title;

  @override
  FileDisplayWidgetDemoState createState() => FileDisplayWidgetDemoState();
}

class FileDisplayWidgetDemoState extends State<FileDisplayWidgetDemo> {
  List<LocalFileBean> localFileBeanList;
  FileBean fileBean;
  ProgressDialog progressDialog;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    localFileBeanList = new List<LocalFileBean>();
    init();
  }

  //初始化
  void init() {
    fileBean = new FileBean();
    String testJsonValue =
        '{"datas":[{"id":"1","fileName":"工资单工资单工资单工资单工资单工资单工资单工资单工资单工资单工资单工资单工资单工资单工资单工资单.xlsx","fileUrl":"https://b-ssl.duitang.com/uploads/item/201703/30/20170330175756_5KzW3.thumb.700_0.jpeg"},{"id":"2","fileName":"账单.docx","fileUrl":"https://gss2.bdstatic.com/-fo3dSag_xI4khGkpoWK1HF6hhy/baike/s%3D220/sign=7a156e5ceccd7b89ed6c3d813f254291/2f738bd4b31c87010f99dc702d7f9e2f0708ff7d.jpg"},{"id":"3","fileName":"资金流水表.doc","fileUrl":"https://gss1.bdstatic.com/9vo3dSag_xI4khGkpoWK1HF6hhy/baike/w%3D268%3Bg%3D0/sign=3a64e2745c0fd9f9a017526f1d16b317/d31b0ef41bd5ad6e0c58a9e28ccb39dbb6fd3c11.jpg"}],"resMsg":{"message":"success !","method":null,"code":"1"}}';
    Map<String, dynamic> json;
    if (testJsonValue != null) {
      json = jsonDecode(testJsonValue);
      fileBean = FileBean.fromJson(json);
    }

    initProgress();
  }

  void initProgress() {
    progressDialog = new ProgressDialog(context);
    progressDialog.setMessage("Loading...");
    progressDialog.setTextColor(Colors.black);
    progressDialog.setTextSize(16);
  }

  @override
  Widget build(BuildContext context) {
    double boxPaddingLeft = ScreenUtil.getInstance().setHeight(30); //盒子左边距
    double boxPaddingTop = ScreenUtil.getInstance().setHeight(30); //盒子顶边距
    double boxPaddingRight = ScreenUtil.getInstance().setHeight(30); //盒子右边距
    double boxPaddingBottom = ScreenUtil.getInstance().setHeight(30); //盒子底边距

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(title),
        ),
        body: new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            //附件（展示（带删除按钮））
            new Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop,
                  boxPaddingRight, boxPaddingBottom),
              child: FileDisplayWidget(
                  localFileBeanList: localFileBeanList,
                  fileLeftUrl: 'images/icon_file_left.png',
                  type: Constant.file_type_edit,
                  onFileAddPress: onFileAddPress,
                  onFilePress: onFilePress,
                  onFileDeletePress: onFileDeletePress),
            ),



            //附件（只展示）
            new Container(
//              color: Colors.red,
              padding: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop,
                  boxPaddingRight, boxPaddingBottom),
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
                  new Flex(
                    //弹性布局
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    //down:表示从上到下 up:表示从下到上
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //参考verticalDirection start表示正方向，end表示反方向
                    children: <Widget>[
                      //比例10:38
                      new Expanded(
                        flex: 1,
                        child: new Container(
//                        color: Colors.blue,
                          padding: EdgeInsets.only(
                              top: ScreenUtil.getInstance().setHeight(25)),
                          //内部需要25padding
                          alignment: Alignment.centerLeft,
                          //内容位置
                          child: new Text(
                            "附         件", //letterSpacing属性不适合
                            style: new TextStyle(
                              color: const Color(0xFF999999),
                              fontSize: ScreenUtil.getInstance().setSp(42),
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new Container(
//                          color: Colors.red,
                          alignment: Alignment.topLeft,
                          child: new Container(
                            color: Colors.white,
//                            padding: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop,
//                                boxPaddingRight, boxPaddingBottom),
                            child: FileDisplayWidget(
                                fileBean: fileBean,
                                fileLeftUrl: 'images/icon_ppt.png',
                                type: Constant.file_type_display,
                                onFilePress: onDisplayFilePress,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> asyncAddFile() async {
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
                        openFileManager();
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

  Future<void> openFileManager() async {
    File chooseFile = await FilePicker.getFile(type: FileType.ANY);
    //文件管理器选择文件
    if (chooseFile != null) {
      setState(() {
        LocalFileBean localFileBean = new LocalFileBean();
        localFileBean.id = 1.toString();
        String path = chooseFile.path;
        print('path:' + path);
        String fileType = path.substring(path.lastIndexOf(".") + 1);
        print('fileType:' + fileType);

        String fileNameALL = path.substring(0,path.lastIndexOf("."));
        print('fileNameALL:' + fileNameALL);
        String fileName = fileNameALL.substring(path.lastIndexOf("/") + 1);
        print('fileName:' + fileName);


        localFileBean.fileName = fileName;
        localFileBean.fileUrl = path;

        localFileBeanList.add(localFileBean);
      });
    } else {
      print("未操作-openFileManager");
    }

  }


  Future<void> asyncDeleteFile(int id) async {
    try {
      progressDialog.show();
      await Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          localFileBeanList.removeAt(id);
        });
        progressDialog.hide();
      });
    } catch (e) {
      progressDialog.hide();
      print("faild:$e.toString()");
    }
  }

  Function onFileAddPress() {
//    ToastUtil.toast("onFileAddPress-id");
    asyncAddFile();
    return null;
  }

  Function onFilePress(int id, String fileName, String url) {
//    ToastUtil.toast("onFilePress-id=$id-fileName=$fileName-url=$url");
    return null;
  }

  Function onFileDeletePress(int id) {
//    ToastUtil.toast("onFileDeletePress-id=$id");
    asyncDeleteFile(id);
    return null;
  }




  Function onDisplayFilePress(int id, String fileName, String url) {
    ToastUtil.toast("下载文件-id=$id-fileName=$fileName-url=$url");
    return null;
  }
}
