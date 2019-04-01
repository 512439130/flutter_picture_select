import 'package:flutter_picture_select/bean/LocalFileBean.dart';

class FileBean {
  List<LocalFileBean> datas;
  ResMsg resMsg;

  FileBean({this.datas, this.resMsg});

  FileBean.fromJson(Map<String, dynamic> json) {
    if (json['datas'] != null) {
      datas = new List<LocalFileBean>();
      json['datas'].forEach((v) {
        datas.add(new LocalFileBean.fromJson(v));
      });
    }
    resMsg =
    json['resMsg'] != null ? new ResMsg.fromJson(json['resMsg']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datas != null) {
      data['datas'] = this.datas.map((v) => v.toJson()).toList();
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