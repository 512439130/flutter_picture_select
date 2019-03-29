import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picture_select/const/Constant.dart';
import 'package:flutter_picture_select/util/ToastUtil.dart';
import 'package:flutter_picture_select/util/dioHttpUtil.dart';
import 'package:path_provider/path_provider.dart';

const String title = '多图片详情';
const double _kMinFlingVelocity = 500.0; //放大缩小速率

int _selectIndex;

class TouchImagesViewer extends StatelessWidget {
  final List<String> imageUrls;
  final String type; //网络图片，本地图片
  final int startIndex;

  TouchImagesViewer(this.imageUrls, this.type, this.startIndex);

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
            body: new TouchViewerPage(imageUrls, type, startIndex),
          ),
          new Offstage(
            //使用Offstage 控制widget在tree中的显示和隐藏
            offstage: type == Constant.image_type_network ? false : true,
            child: new Container(
              margin: const EdgeInsets.all(30.0),
              child: new MaterialButton(
                child: Text("保存图片到本地"),
                color: Colors.blueGrey,
                height: 30,
                textColor: const Color(0xFFFFFFFF),
                onPressed: () {
                  saveImage();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future saveImage() async {
    var sdcard = await getExternalStorageDirectory();
    String sdCardPath = sdcard.path;
    String directoryPath = sdCardPath + Constant.image_save_path;
    print("directoryPath:" + directoryPath);
    var directory = await new Directory(directoryPath)
        .create(recursive: true); ////如果有子文件夹，需要设置recursive: true

    //absolute返回path为绝对路径的Directory对象
    String path = directory.absolute.path;
    print("path:" + path);

    String fileNamePath = path +"$title"+"_"+'$_selectIndex.png';
    print("fileNamePath:" + fileNamePath);
    String url = imageUrls[_selectIndex];
    CancelToken cancelToken = new CancelToken();
    Response response = await dioHttpUtil().downLoadFile(url,fileNamePath,doLoading(),cancelToken: cancelToken);
    if(response != null){
      if(response.statusCode == 200){
        ToastUtil.toast("保存成功：$fileNamePath");
      }else{
        ToastUtil.toast('保存失败:$response.statusCode-$response.data');
      }
    }else{
      ToastUtil.toast('response == null');
    }

  }

  Function doLoading() {
    new CircularProgressIndicator();
    return null;
  }
}



class TouchViewerPage extends StatefulWidget {
  final List<String> imageUrls;
  final String type;
  final int startIndex;
  int selectIndex;
  bool isVisibleTip = true; //是否显示tip  true:显示  false:隐藏

  TouchViewerPage(this.imageUrls, this.type, this.startIndex);

  @override
  State<StatefulWidget> createState() {
    return new TouchImagesViewerPage();
  }
}

class TouchImagesViewerPage extends State<TouchViewerPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _flingAnimation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    init();
    initControl();
  }

  void init() {
    _selectIndex = widget.startIndex; //初始化为点击进入index
    print("widget.imageUrls.length:" + widget.imageUrls.length.toString());

    for(int i = 0 ; i<widget.imageUrls.length;i++){
      print("widget.imageUrls[]:" + widget.imageUrls[i].toString());
    }
  }

  void initControl() {
    _animationController = new AnimationController(vsync: this)..addListener(_handleFlingAnimation);
    _pageController = PageController(initialPage: widget.startIndex); //指定position打开
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
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
      _animationController.stop();
    });
    print("_handleOnScaleStart-_previousScale$_previousScale");
    print("_handleOnScaleStart-_normalizedOffset$_normalizedOffset");
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 4.0);
      // Ensure that image location under the focal point stays in the same place despite scaling.
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
    });
    print("_handleOnScaleUpdate-_scale$_scale");
    print("_handleOnScaleUpdate-_offset$_offset");
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity) return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size).shortestSide;
    _flingAnimation = new Tween<Offset>(begin: _offset, end: _clampOffset(_offset + direction * distance)).animate(_animationController);
    _animationController..value = 0.0..fling(velocity: magnitude / 1000.0);

    print("_handleOnScaleEnd-_flingAnimation$_flingAnimation");
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == Constant.image_type_sdcard) {
      //本地图片
      return new GestureDetector(
        onScaleStart: _handleOnScaleStart, //缩放开始状态
        onScaleUpdate: _handleOnScaleUpdate,
        onScaleEnd: _handleOnScaleEnd, //缩放结束状态

        child: new ClipRect(
          child: new Transform(
            transform: new Matrix4.identity()
              ..translate(_offset.dx, _offset.dy)
              ..scale(_scale),
            //
            child: new PageView.builder(
                itemCount: widget.imageUrls.length,
                controller: _pageController,
                onPageChanged: onPageChanged, //滑动
                itemBuilder: (context, index) {
                  return Center(
                      child: Image.file(
                        new File(widget.imageUrls[index]),
                        fit: BoxFit.contain,
                        height: 300,
                      ),
                  );
                }),
          ),
        ),
      );
    } else if (widget.type == Constant.image_type_network) {
      //网络图片
      return new GestureDetector(
        onScaleStart: _handleOnScaleStart, //缩放开始状态
        onScaleUpdate: _handleOnScaleUpdate,
        onScaleEnd: _handleOnScaleEnd, //缩放结束状态

        child: new ClipRect(
          child: new Transform(
            transform: new Matrix4.identity()
              ..translate(_offset.dx, _offset.dy)
              ..scale(_scale),
            child: new PageView.builder(
                itemCount: widget.imageUrls.length,
                controller: _pageController,
                onPageChanged: onPageChanged, //滑动
                itemBuilder: (context, index) {
                  return Center(
                      child: new Image(
                          fit: BoxFit.contain,
                          height: 400,
                          image: new CachedNetworkImageProvider(widget.imageUrls[index],)
                      ),
                  );
                }),
          ),
        ),
      );
    }
  }

  onPageChanged(index) {
    setState(() {
      _selectIndex = index;
      widget.selectIndex = index;

      resetImageState();
      print('选择第$index图片');
    });
  }

  //重置图片缩放状态
  void resetImageState() {
    _scale = 1.0;
    _offset = new Offset(0.0, 0.0);
  }
}
