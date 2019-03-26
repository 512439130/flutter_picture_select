import 'package:flutter_picture_select/bean/Datas.dart';
import 'package:flutter_picture_select/bean/ResMsg.dart';

class TestBean {
  List<Datas> datas;
  ResMsg resMsg;

  TestBean({this.datas, this.resMsg});

  TestBean.fromJson(Map<String, dynamic> json) {
    if (json['datas'] != null) {
      datas = new List<Datas>();
      json['datas'].forEach((v) {
        datas.add(new Datas.fromJson(v));
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



