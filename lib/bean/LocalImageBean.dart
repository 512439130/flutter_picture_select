class LocalImageBean {
  String id;
  String url;

  LocalImageBean({this.id, this.url});

  LocalImageBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['path'] = this.url;
    return data;
  }

  @override
  String toString() {
    return 'LocalImageBean{id: $id, path: $url}\n';
  }

}