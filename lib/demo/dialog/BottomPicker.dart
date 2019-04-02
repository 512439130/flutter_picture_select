import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_picture_select/demo/dialog/BottomPickerHandler.dart';


class BottomPicker extends StatelessWidget {
  BottomPickerHandler _listener;
  AnimationController _controller;
  BuildContext context;

  BottomPicker(this._listener, this._controller);

  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;

  void initState() {
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = new Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      //添加动画
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  getImage(BuildContext context) {
    if (_controller == null ||
        _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    _controller.forward();
    showDialog(
      context: context,
      builder: (BuildContext context) => new SlideTransition(
            position: _drawerDetailsPosition,
            child: new FadeTransition(
              opacity: new ReverseAnimation(_drawerContentsOpacity),
              child: this,
            ),
          ),
    );
  }

  void dispose() {
    _controller.dispose();
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context);
  }

  dismissDialog() {
    _controller.reverse();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new GestureDetector(
      onTap: () => dismissDialog(),  //屏幕外消失
      child: new Material(
          type: MaterialType.transparency,
          child: new Opacity(
            opacity: 1, //包含widget的透明度
            child: new GestureDetector(
              onTap: () => dismissDialog(),
              child: new Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new GestureDetector(
                      onTap: () => _listener.openCamera(),
                      child: roundedTopButton(
                          "相机",
                          EdgeInsets.fromLTRB(0.0,  0.0, 0.0, 0.0),
                          const Color(0xFFFFFFFF),
                          const Color(0xFF3068E8)),
                    ),
                    new Container(
                      height: 1,
                      color: const Color(0xFFF5F5F5),
                    ),
                    new GestureDetector(
                      onTap: () => _listener.openGallery(),
                      child: roundedNoRadiusButton(
                          "从本地相册获取",
                          EdgeInsets.fromLTRB(0.0,  0.0, 0.0, 0.0),
                          const Color(0xFFFFFFFF),
                          const Color(0xFF3068E8)),
                    ),
                    new Container(
                      height: 5,
                      color: const Color(0xFFF5F5F5),
                    ),
                    new GestureDetector(
                      onTap: () => dismissDialog(),
                      child: new Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: roundedBottomButton(
                            "取消",
                            EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            const Color(0xFFFFFFFF),
                            const Color(0xFF1A1A1A)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget roundedTopButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(10.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.only(topLeft:const Radius.circular(10.0),topRight:const Radius.circular(10.0)),
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.w100),
      ),
    );
    return loginBtn;
  }
  Widget roundedBottomButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(10.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.only(bottomLeft:const Radius.circular(10.0),bottomRight:const Radius.circular(10.0)),
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.w100),
      ),
    );
    return loginBtn;
  }

  Widget roundedNoRadiusButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(10.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(0.0)),
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.w100),
      ),
    );
    return loginBtn;
  }
}
