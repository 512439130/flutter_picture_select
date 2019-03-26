import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class ToastUtil{
  static void toast(String value) {
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
}