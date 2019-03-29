import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_picture_select/widget/dialog/BottomPickerHandler.dart';

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
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new GestureDetector(
                      onTap: () => _listener.openCamera(),
                      child: roundedButton(
                          "相机",
                          EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                          const Color(0xFFA9A9A9),
                          const Color(0xFFFFFFFF)),
                    ),
                    new GestureDetector(
                      onTap: () => _listener.openGallery(),
                      child: roundedButton(
                          "相册",
                          EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                          const Color(0xFFA9A9A9),
                          const Color(0xFFFFFFFF)),
                    ),
                    const SizedBox(height: 5.0),
                    new GestureDetector(
                      onTap: () => dismissDialog(),
                      child: new Padding(
                        padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                        child: roundedButton(
                            "取消",
                            EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                            const Color(0xFFA9A9A9),
                            const Color(0xFFFFFFFF)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget roundedButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(10.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(100.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 5.0), //阴影
            blurRadius: 0.001, //延伸距离,会有模糊效果
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }
}
