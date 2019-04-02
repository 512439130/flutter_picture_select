import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_picture_select/demo/dialog/BottomPicker.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


class BottomPickerHandler {
  BottomPicker bottomPicker;
  AnimationController _controller;
  BottomPickerListener _listener;


  BottomPickerHandler(this._listener, this._controller);

  openCamera() async {
    bottomPicker.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if(image != null){
      cropImage(image);
    }else{
      print("未操作-openCamera");
    }
  }

  openGallery() async {
    bottomPicker.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    //相册裁剪关闭
    if(image != null){
//      cropImage(image);
      _listener.bottomSelectImage(image);
    }else{
      print("未操作-openCamera");
    }
  }

  void init() {
    bottomPicker = new BottomPicker(this, _controller);
    bottomPicker.initState();
  }

  Future cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    _listener.bottomSelectImage(croppedFile);
  }

  showDialog(BuildContext context) {
    bottomPicker.getImage(context);
  }
}

abstract class BottomPickerListener {
  bottomSelectImage(File _image);
}
