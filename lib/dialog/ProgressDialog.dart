import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class ProgressDialog {
  bool _isShowing = false;

  BuildContext buildContext, _context;
  String message = "Loading...";
  double textSize = 16;
  Color textColor = Colors.black;

  ProgressDialog(this.buildContext);

  void setMessage(String mess) {
    this.message = mess;
  }
  void setTextSize(double size) {
    this.textSize = size;
  }
  void setTextColor(Color color) {
    this.textColor = color;
  }
  void show() {
    _showDialog();
    _isShowing = true;
  }

  bool isShowing() {
    return _isShowing;
  }

  void hide() {
    _isShowing = false;
    Navigator.of(_context).pop();
  }

  Future _showDialog() {
    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _context = context;

        return CupertinoAlertDialog(
          content: SizedBox(
            height: 40.0,
            child: Center(
              child: Row(
                children: <Widget>[
                  SizedBox(width: 10.0),
                  CircularProgressIndicator(),
                  SizedBox(width: 40.0),
                  Text(
                    message,
                    style: TextStyle(color: textColor, fontSize: textSize),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
    return null;
  }
}