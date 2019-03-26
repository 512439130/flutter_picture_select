import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_picture_select/bean/LocalImageBean.dart';
import 'package:flutter_picture_select/dialog/BottomPickerHandler.dart';
import 'package:flutter_picture_select/dialog/ProgressDialog.dart';
import 'package:flutter_picture_select/util/PermissionUtil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_permissions/simple_permissions.dart';

//常量定义
const String name1 = '图片选择';

class PictureSelectWidget extends StatefulWidget {
  PictureSelectWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PictureSelectWidgetState createState() => _PictureSelectWidgetState();
}

class _PictureSelectWidgetState extends State<PictureSelectWidget>with TickerProviderStateMixin implements BottomPickerListener {
  final TextEditingController _textFieldController =
      new TextEditingController();
  List<Widget> listWidget;
  List<LocalImageBean> localImageBeanList;
  ProgressDialog progressDialog;
  AnimationController _controller;
  BottomPickerHandler bottomPicker;

  //选择器

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    init();
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
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    bottomPicker=new BottomPickerHandler(this,_controller);
    bottomPicker.init();
  }

  @override
  useImage(File _image) {
    // TODO: implement useImage
    int length;
    if (localImageBeanList != null && localImageBeanList.length > 0) {
      length = localImageBeanList.length + 1;
    } else {
      length = 1;
    }
    setState(() {
      if(_image != null){
        print('addSdCard');
        LocalImageBean localImageBean = new LocalImageBean();
        localImageBean.id = length.toString();
        localImageBean.path = _image.path;
        //type
        localImageBeanList.add(localImageBean);
        //去重复
        localImageBeanList = deduplication(localImageBeanList);
      }else{
        print('addSdCard-未选择');
      }

    });
    return null;
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("didChangeDependencies");
  }

  @override
  void didUpdateWidget(PictureSelectWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print("deactivate");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose");
  }

//  //初始化
  void init() {
    localImageBeanList = new List<LocalImageBean>();
  }




  void setList() {
    print('setList');
    //listWidget
    //每次生成新的图片数组
    listWidget = new List<Widget>();
    if (localImageBeanList != null && localImageBeanList.length > 0) {
      print('localImageBeanList!=0');
      for (int i = 0; i < localImageBeanList.length; i++) {
        listWidget.add(sdCardImage(i, localImageBeanList[i].path));
        print('localImageBeanList-path:' + localImageBeanList[0].path);
      }
      //每次在尾部加添加图片
      listWidget.add(localImage('images/icon_add.png', BoxFit.cover));
    } else {
      print('localImageBeanList==0');
      listWidget.add(localImage('images/icon_add.png', BoxFit.cover));
    }
  }



  Widget sdCardImage(int id, String path) {
    return new Stack(
      alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
      overflow: Overflow.visible,

      children: <Widget>[
        new Container(
            alignment: Alignment.center,
//            color: Colors.greenAccent,
            child: getSdCardImage(id, false, path, BoxFit.cover)),
        Positioned(
          right: 0,
          top: 0,
          child: getDeleteIcon(id),
        )
      ],
    );
  }

  Widget localImage(String path, BoxFit fit) {
    return new Stack(
      alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
      overflow: Overflow.visible,
      children: <Widget>[
        new Container(
            color: const Color(0xFFF7F8FA),
            padding: const EdgeInsets.all(15),
            child: getLocalImage(path, fit)),
      ],
    );
  }

  Widget getLocalImage(String path, BoxFit fit) {
    return new GestureDetector(
      onTap: () {
        int defaultLength = 1;
        if (localImageBeanList != null && localImageBeanList.length > 0) {
          asyncAddImage(localImageBeanList.length + 1);
        } else {
          asyncAddImage(defaultLength);
        }

        //调用replace
      },
      child: new Image.asset(
        path,
        width: 30,
        height: 30,
        fit: BoxFit.fitWidth,
        //alignment：摆放位置
//        alignment: Alignment.center,
      ),
    );
  }

  Widget getSdCardImage(int id, bool offstage, String path, BoxFit fit) {
    return new GestureDetector(
      onTap: () {
        asyncReplaceImage(id);
      },
      child: new Offstage(
        //使用Offstage 控制widget在tree中的显示和隐藏
        offstage: offstage,
        child: new ClipRRect(
          child: new Container(
            padding: const EdgeInsets.all(0),
            child: new Image.file(
              new File(path),
              width: 55,
              height: 55,
              fit: fit,
            ),
          ),
          //圆角
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
      ),
    );
  }


  Widget getDeleteIcon(int id) {
    return new GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                    title: new Text("提示"),
                    content: new Text("确认删除？"),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("取消"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      new FlatButton(
                        child: new Text("确定"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          asyncDeleteImage(id);
                        },
                      )
                    ]));

        //调用delete
      },
      child: Image.asset(
        'images/icon_image_delete.png',
        width: 15,
        height: 15,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildGrid(List<Widget> listWidget) {
    return new GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 24,
      //上下间距
      crossAxisSpacing: 24,
      //左右间距
      padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
      primary: false,
      shrinkWrap: true,
      children: listWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    setList();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F5),
          title: Text(name1),
        ),
        body: new ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: <Widget>[

            //textTitle
            new Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.only(top: 20, left: 24, bottom: 20),
              color: const Color(0xFFFFFFFF),
              child: new Text(
                '图片',
                style: new TextStyle(
                  color: const Color(0xFF1A1A1A),
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),

            //GradView
            new Container(
              color: const Color(0xFFFFFFFF),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: buildGrid(listWidget),
            ),

            //按钮
            new Container(
              margin: const EdgeInsets.only(
                  top: 40, bottom: 40, left: 10, right: 10),
              child: buildButton("确认", const Color(0xFFFFFFFF),
                  const Color(0x803068E8), buttonClick1),
            ),
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
        height: 50,
        textColor: textColor,
        onPressed: () {
          clickEvent();
        },
      ),
    );
  }

  Function buttonClick1() {
    setState(() {
      if(localImageBeanList != null && localImageBeanList.length > 0){
        toast('已选择：$localImageBeanList');
      }else{
        toast('你还未选择图片');
      }

    });
    return null;
  }

  Function buttonClick2() {
    setState(() {
      //click
    });
    return null;
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
              if(result == PermissionStatus.deniedNeverAsk){
                //setting
                toast('由于用户您选择不在提醒，并且拒绝了权限，请您去系统设置修改相关权限后再进行功能尝试');
                PermissionUtil.openPermissionSetting();
              }else if(result == PermissionStatus.authorized){
                Future future2 = new Future(() => null);
                future2.then((_) {
                  PermissionUtil.requestPermission(Permission.Camera)
                      .then((result2) {
                    print("requestPermission-Camera$result2");
                    if(result2 == PermissionStatus.deniedNeverAsk){
                      //setting
                      toast('由于用户您选择不在提醒，并且拒绝了权限，请您去系统设置修改相关权限后再进行功能尝试');
                      PermissionUtil.openPermissionSetting();

                    }else if(result2 == PermissionStatus.authorized){
//                      addSdCard(id);
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



//  Future<void> addSdCard(int id) async {
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    setState(() {
//      if(image != null){
//        print('addSdCard');
//        LocalImageBean localImageBean = new LocalImageBean();
//        localImageBean.id = id.toString();
//        localImageBean.path = image.path;
//        //type
//        localImageBeanList.add(localImageBean);
//        //去重复
//        localImageBeanList = deduplication(localImageBeanList);
//
//      }else{
//        print('addSdCard-未选择');
//      }
//
//    });
//  }

  Future<void> replaceSdCard(int id) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(image != null){
        print('replaceSdCard');
        //type
        localImageBeanList[id].path=image.path;
        //去重复
        localImageBeanList = deduplication(localImageBeanList);
      }else{
        print('replaceSdCard-未选择');
      }
    });
  }

  //List去重复(Set方式)
  List<LocalImageBean> deduplication(List<LocalImageBean> list){
    Set<String> localImageBeanSet = new Set<String>();
    for(int i = 0;i<list.length;i++){
      localImageBeanSet.add(list[i].path);
    }
    print('set:'+localImageBeanSet.toString());
    list.clear();
    List setToList = localImageBeanSet.toList(growable: true);

    for(int i = 0 ; i<setToList.length;i++){
      LocalImageBean localImageBean = new LocalImageBean();
      localImageBean.id = i.toString();
      localImageBean.path = setToList[i];
      list.add(localImageBean);
    }
    return list;
  }




}
