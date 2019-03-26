class LocalImageBean {
  String id;
  String path;

  LocalImageBean({this.id, this.path});

  LocalImageBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['path'] = this.path;
    return data;
  }

  @override
  String toString() {
    return 'LocalImageBean{id: $id, path: $path}\n';
  }

}