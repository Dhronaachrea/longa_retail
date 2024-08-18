class UrlDrawGameBean {
  String? url;
  String? basePath;
  String? username;
  String? password;
  String? contentType;

  UrlDrawGameBean({this.url, this.basePath, this.username, this.password, this.contentType});

  UrlDrawGameBean.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    basePath = json['basePath'];
    username = json['username'];
    password = json['password'];
    contentType = json['contentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['basePath'] = this.basePath;
    data['username'] = this.username;
    data['password'] = this.password;
    data['contentType'] = this.contentType;
    return data;
  }
}