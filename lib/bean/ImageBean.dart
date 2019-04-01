import 'package:flutter_picture_select/bean/LocalImageBean.dart';

class ImageBean {
  List<LocalImageBean> localImageBean;
  ResMsg resMsg;

  ImageBean({this.localImageBean, this.resMsg});

  ImageBean.fromJson(Map<String, dynamic> json) {
    if (json['datas'] != null) {
      localImageBean = new List<LocalImageBean>();
      json['datas'].forEach((v) {
        localImageBean.add(new LocalImageBean.fromJson(v));
      });
    }
    resMsg =
    json['resMsg'] != null ? new ResMsg.fromJson(json['resMsg']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.localImageBean != null) {
      data['datas'] = this.localImageBean.map((v) => v.toJson()).toList();
    }
    if (this.resMsg != null) {
      data['resMsg'] = this.resMsg.toJson();
    }
    return data;
  }
}

class ResMsg {
  String message;
  Null method;
  String code;

  ResMsg({this.message, this.method, this.code});

  ResMsg.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    method = json['method'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['method'] = this.method;
    data['code'] = this.code;
    return data;
  }
}



