class HeaderBean {
  List<Datas> datas;
  ResMsg resMsg;

  HeaderBean({this.datas, this.resMsg});

  HeaderBean.fromJson(Map<String, dynamic> json) {
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
  String name;

  Datas({this.id, this.url, this.name});

  Datas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['name'] = this.name;
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