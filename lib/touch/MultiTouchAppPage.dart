import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picture_select/util/ToastUtil.dart';

const String title = '图片详情';
const double _kMinFlingVelocity = 500.0; //放大缩小速率

class MultiTouchPage extends StatelessWidget {
  final String imgUrl;

  MultiTouchPage(this.imgUrl);

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
            body: new MultiTouchAppPage(imgUrl),
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

class MultiTouchAppPage extends StatefulWidget {
  final String imgUrl;

  MultiTouchAppPage(this.imgUrl);

  @override
  State<StatefulWidget> createState() {
    return new _MultiTouchAppPage();
  }
}

class _MultiTouchAppPage extends State<MultiTouchAppPage>
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
    Size size = MediaQuery.of(context).size; //获取屏幕宽高
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
//              child: new CachedNetworkImage(
////                width: double.infinity,
//                height: size.height - 300,  //保证底部保留100高度给按钮部分
//                fit: BoxFit.contain, //保持原比例
//                fadeInCurve: Curves.ease,
//                fadeInDuration: Duration(milliseconds: 800),
//                fadeOutCurve: Curves.ease,
//                fadeOutDuration: Duration(milliseconds: 400),
//                imageUrl: widget.imgUrl,
////        placeholder: (context, url) => Image(image: AssetImage('images/icon_image_default.png')),
//                placeholder: (context, url) => CircularProgressIndicator(),
//                errorWidget: (context, url, error) => new Icon(Icons.error),
//              ),
            )),
      ),
    );
  }
}
