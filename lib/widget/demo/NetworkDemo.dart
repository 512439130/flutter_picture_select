import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picture_select/const/Constant.dart';
import 'package:flutter_picture_select/util/PermissionUtil.dart';
import 'package:flutter_picture_select/util/ToastUtil.dart';
import 'package:flutter_picture_select/util/dioHttpUtil.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';


const String name1 = 'NetworkWidget';

class NetworkWidget extends StatefulWidget {
  NetworkWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _NetworkWidgetState createState() => _NetworkWidgetState();
}

class _NetworkWidgetState extends State<NetworkWidget> {
  String requestGETText = "requestGETText";
  String requestPOSTText = "requestPOSTText";
  String requestFormDataText = "requestFormDataText";
  String requestJsonBodyText = "requestJsonBodyText";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name1),
        ),
        body: new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            buildButton("requestGET", Colors.black, Colors.greenAccent,
                requestGETClick),
            new Text(requestGETText),
            buildButton("requestPOST", Colors.black, Colors.greenAccent,
                requestPOSTClick),
            new Text(requestPOSTText),
            buildButton("requestFormData", Colors.black, Colors.greenAccent,
                requestFormDataClick),
            new Text(requestFormDataText),
            buildButton("requestJsonBody", Colors.black, Colors.greenAccent,
                requestJsonBodyClick),
            new Text(requestJsonBodyText),
            buildButton("obtainPermission", Colors.black, Colors.greenAccent,
                obtainPermissionClick),
            buildButton("downLoadFile", Colors.black, Colors.greenAccent,
                downLoadFileClick),

          ],
        ));
  }

  //生成MaterialButton
  Container buildButton(
      String value, Color textColor, Color background, Function clickEvent()) {
    return new Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: new MaterialButton(
        child: Text(value),
        color: background,
        textColor: textColor,
        onPressed: () {
          clickEvent();
        },
      ),
    );
  }

  Function requestGETClick() {
    requestGETText = "requestGETText";
    requestGET();
    return null;
  }

  Function requestPOSTClick() {
    requestPOSTText = "requestPOSTText";
    requestPOST();
    return null;
  }



  Function requestFormDataClick() {
    requestFormDataText = "requestFormDataText";
    requestFormData();
    return null;
  }

  Function requestJsonBodyClick() {
    requestJsonBodyText = "requestJsonBodyText";
    requestJsonBody();
    return null;
  }

  Function obtainPermissionClick() {
    obtainPermission();
    return null;
  }

  Function downLoadFileClick() {
    downLoadFile();
    return null;
  }

  Future requestGET() async {
//    String url = 'api/test';
    String url = '';
    CancelToken cancelToken = new CancelToken();
    Response response =
        await dioHttpUtil().doGet(url, cancelToken: cancelToken);
    if (response != null) {
      if (response.statusCode == 200) {
        ToastUtil.toast("请求成功");
        setState(() {
          requestGETText = response.data.toString();
        });
      } else {
        ToastUtil.toast('request-error-code:'+response.statusCode.toString());
      }
    } else {
      print('request-error');
    }
  }

  Future requestPOST() async {
    //    String url = 'api/test';
    String url = '';
    CancelToken cancelToken = new CancelToken();
    Response response =
        await dioHttpUtil().doPost(url, cancelToken: cancelToken);
    if (response != null) {
      if (response.statusCode == 200) {
        ToastUtil.toast("请求成功");
        setState(() {
          requestPOSTText = response.data.toString();
        });
      } else {
        ToastUtil.toast('request-error-code:'+response.statusCode.toString());
      }
    } else {
      print('request-error');
    }
  }



  Future requestFormData() async {
    //    String url = 'api/test';
    String url = '';
    CancelToken cancelToken = new CancelToken();
    FormData formData = new FormData.from({
      "name": "wendux",
      "age": 25,
    });
//    //单文件上传
//    FormData formData1 = new FormData.from({
//      "name": "wendux",
//      "age": 25,
//      "file1": new UploadFileInfo(new File("./upload.txt"), "upload1.txt"),
//      //支持直接上传字节数组 (List<int>) ，方便直接上传内存中的内容
//      "file2": new UploadFileInfo.fromBytes(
//          utf8.encode("hello world"), "word.txt"),
//      // 支持文件数组上传
//      "files": [
//        new UploadFileInfo(new File("./example/upload.txt"), "upload.txt"),
//        new UploadFileInfo(new File("./example/upload.txt"), "upload.txt")
//      ]
//    });
//    //多文件上传（组文件上传）
//    FormData formData2 = new FormData.from({
//      "name": "wendux",
//      "age": 25,
//      "file1": new UploadFileInfo(new File("./upload.txt"), "upload1.txt"),
//      //支持直接上传字节数组 (List<int>) ，方便直接上传内存中的内容
//      "file2": new UploadFileInfo.fromBytes(
//          utf8.encode("hello world"), "word.txt"),
//      // 支持文件数组上传
//      "files": [
//        new UploadFileInfo(new File("./example/upload.txt"), "upload.txt"),
//        new UploadFileInfo(new File("./example/upload.txt"), "upload.txt")
//      ]
//    });

    Response response = await dioHttpUtil().requestFormData(url, formData: formData, cancelToken: cancelToken);
    if (response != null) {
      if (response.statusCode == 200) {
        ToastUtil.toast("api/test");
        setState(() {
          requestFormDataText = response.data.toString();
        });
      } else {
        print('request-error-code:'+response.statusCode.toString());
        ToastUtil.toast('request-error-code:'+response.statusCode.toString());
      }
    } else {
      print('request-error');
    }
  }
  Future requestJsonBody() async {
    //    String url = 'api/test';
    String url = '';
    var jsonBody = '{\pageIndex\': 1, \'pageSize\': 10}';
    CancelToken cancelToken = new CancelToken();
    Response response = await dioHttpUtil()
        .requestJsonBody(url, jsonBody: jsonBody, cancelToken: cancelToken);
    if (response != null) {
      if (response.statusCode == 200) {
        ToastUtil.toast("请求成功");
        setState(() {
          requestJsonBodyText = response.data.toString();
        });
      } else {
        ToastUtil.toast('request-error-code:'+response.statusCode.toString());
      }
    } else {
      print('request-error');
    }
  }


  //需要先获取读写权限 参考obtainPermission()
  Future<void> downLoadFile() async {
    //无则创建文件夹，有则直接保存
    var sdcard = await getExternalStorageDirectory();
    String directoryPath = sdcard.path + Constant.image_save_path;
    print("directoryPath:" + directoryPath);
    var directory = await new Directory(directoryPath).create(recursive: true); ////如果有子文件夹，需要设置recursive: true
    //absolute返回path为绝对路径的Directory对象
    String path = directory.absolute.path;
    print("path:" + path);

    Response response;
    Dio dio = new Dio();
    String fileName = directory.absolute.path + 'test_123.jpeg';
    response = await dio.download(
        'https://b-ssl.duitang.com/uploads/item/201703/30/20170330175756_5KzW3.thumb.700_0.jpeg',
        fileName);
    if (response != null) {
      if (response.statusCode == 200) {
        print("request-succes");
        ToastUtil.toast("保存成功：$fileName");
      } else {print("request-error");
        print('request-error-code:'+response.statusCode.toString());
      }
    } else {
      print('request-error');
    }
  }

  Future<void> obtainPermission() async {
    try {
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
                  PermissionUtil.requestPermission(
                          Permission.ReadExternalStorage)
                      .then((result2) {
                    print("ReadExternalStorage-Camera$result2");
                    if (result2 == PermissionStatus.deniedNeverAsk) {
                      //setting
                      ToastUtil.toast(
                          '由于用户您选择不在提醒，并且拒绝了权限，请您去系统设置修改相关权限后再进行功能尝试');
                      PermissionUtil.openPermissionSetting();
                    } else if (result2 == PermissionStatus.authorized) {
                      ToastUtil.toast('权限获取成功');
                    }
                  });
                });
              }
            });
          });
        });
      });
    } catch (e) {
      print("faild:$e.toString()");
    }
  }
}
