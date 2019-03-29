import 'package:flutter/material.dart';
import 'package:flutter_picture_select/widget/touch/TouchImageViewer.dart';
import 'package:flutter_picture_select/widget/touch/TouchImagesViewer.dart';
import 'package:path/path.dart';

class PictureUtil{
  /**
   * context：上下文
   * imageUrls：url
   * type:图片类型
   * startIndex:初始位置
   * 渐现方式查看大图（支持缩放）
   * 单图加载
   */
  static void openLargeImage(BuildContext context,String url,String type) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new TouchImageViewer(url,type);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget widget) {
          return new FadeTransition(
              opacity: animation,
              child: new AnimatedOpacity(
                opacity: 1.0, //1.0不透明，0.0透明
                duration: new Duration(seconds: 10),
                child: widget,
              )
          );
        }));
  }


  /**
   * context：上下文
   * imageUrls：urls
   * type:图片类型
   * startIndex:初始位置
   * 渐现方式查看大图（支持缩放）
   * 多图加载
   */
  static void openLargeImages(BuildContext context,List<String> imageUrls,String type,int startIndex) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new TouchImagesViewer(imageUrls,type,startIndex);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget widget) {
          return new FadeTransition(
              opacity: animation,
              child: new AnimatedOpacity(
                opacity: 1.0, //1.0不透明，0.0透明
                duration: new Duration(seconds: 10),
                child: widget,
              )
          );
        }));
  }
}