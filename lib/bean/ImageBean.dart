class ImageBean {
  List<Datas> datas;
  ResMsg resMsg;

  ImageBean({this.datas, this.resMsg});

  ImageBean.fromJson(Map<String, dynamic> json) {
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
class Datas {
  String id;
  String url;

  Datas({this.id, this.url});

  Datas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
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



