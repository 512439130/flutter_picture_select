import 'package:flutter_picture_select/demo/bean/LocalImageBean.dart';

class ImageBean {
  List<LocalImageBean> localImageBeanList;
  ResMsg resMsg;

  ImageBean({this.localImageBeanList, this.resMsg});

  ImageBean.fromJson(Map<String, dynamic> json) {
    if (json['datas'] != null) {
      localImageBeanList = new List<LocalImageBean>();
      json['datas'].forEach((v) {
        localImageBeanList.add(new LocalImageBean.fromJson(v));
      });
    }
    resMsg =
    json['resMsg'] != null ? new ResMsg.fromJson(json['resMsg']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.localImageBeanList != null) {
      data['datas'] = this.localImageBeanList.map((v) => v.toJson()).toList();
    }
    if (this.resMsg != null) {
      data['resMsg'] = this.resMsg.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'ImageBean{localImageBeanList: $localImageBeanList}';
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

  @override
  String toString() {
    return 'ResMsg{message: $message, method: $method, code: $code}';
  }

}



