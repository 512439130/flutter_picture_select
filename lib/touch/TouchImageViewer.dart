import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picture_select/const/Constant.dart';
import 'package:flutter_picture_select/util/ToastUtil.dart';


const String title = '多图片详情';
const double _kMinFlingVelocity = 500.0; //放大缩小速率

class TouchImageViewer extends StatelessWidget {
  final String imgUrl;
  final String type; //网络图片，本地图片

  TouchImageViewer(this.imgUrl, this.type);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: new Stack(
        alignment: Alignment.bottomCenter, //指定未定位或部分定位widget的对齐方式
        overflow: Overflow.visible,
        children: <Widget>[

          new Scaffold(
            backgroundColor: Colors.blueGrey,
//            appBar: AppBar(
//              backgroundColor: const Color(0xFFFFFFFF),
//              title: Text(title),
//            ),
            body: new TouchViewerPage(imgUrl, type),
          ),
          new Container(
            margin: const EdgeInsets.all(30.0),
            child: new MaterialButton(
              child: Text("保存图片到本地"),
              color: Colors.blueGrey,
              height: 30,
              textColor: const Color(0xFFFFFFFF),
              onPressed: () {
                ToastUtil.toast('图片已保存到/sdcard/.../.../');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TouchViewerPage extends StatefulWidget {
  final String imgUrl;
  final String type;

  TouchViewerPage(this.imgUrl, this.type);

  @override
  State<StatefulWidget> createState() {
    return new TouchImageViewerPage();
  }
}

class TouchImageViewerPage extends State<TouchViewerPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _flingAnimation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this)
      ..addListener(_handleFlingAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The maximum offset value is 0,0. If the size of this renderer's box is w,h
  // then the minimum offset value is w - _scale * w, h - _scale * h.
  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    final Offset minOffset =
        new Offset(size.width, size.height) * (1.0 - _scale);
    return new Offset(
        offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
  }

  void _handleFlingAnimation() {
    setState(() {
      _offset = _flingAnimation.value;
    });
  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // The fling animation stops if an input gesture starts.
      _controller.stop();
    });
    print("_handleOnScaleStart");
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 4.0);
      // Ensure that image location under the focal point stays in the same place despite scaling.
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
    });
    print("_handleOnScaleUpdate");
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity) return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size).shortestSide;
    _flingAnimation = new Tween<Offset>(
        begin: _offset, end: _clampOffset(_offset + direction * distance))
        .animate(_controller);
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);

    print("_handleOnScaleEnd");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size; //获取屏幕宽高

    if (widget.type == Constant.image_type_sdcard) { //本地图片
      return new GestureDetector(
        onScaleStart: _handleOnScaleStart, //缩放开始状态
        onScaleUpdate: _handleOnScaleUpdate,
        onScaleEnd: _handleOnScaleEnd, //缩放结束状态
        child: new ClipRect(
          child: new Transform(
              transform: new Matrix4.identity()
                ..translate(_offset.dx, _offset.dy)
                ..scale(_scale),
              child: new Center(
                child: Image.file(new File(widget.imgUrl),
                ),
              )),
        ),
      );
    } else if (widget.type == Constant.image_type_network) { //网络图片
      return new GestureDetector(
        onScaleStart: _handleOnScaleStart, //缩放开始状态
        onScaleUpdate: _handleOnScaleUpdate,
        onScaleEnd: _handleOnScaleEnd, //缩放结束状态
        child: new ClipRect(
          child: new Transform(
              transform: new Matrix4.identity()
                ..translate(_offset.dx, _offset.dy)
                ..scale(_scale),
              child: new Center(
                child: new Image(image: new CachedNetworkImageProvider(
                    widget.imgUrl
                )
                ),
              )),
        ),
      );
    }
  }
}