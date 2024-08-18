class UrlDrawGameBean {
  String? url;
  String? username;
  String? password;
  String? contentType;

  UrlDrawGameBean({this.url, this.username, this.password, this.contentType});

  UrlDrawGameBean.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    username = json['username'];
    password = json['password'];
    contentType = json['contentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['username'] = this.username;
    data['password'] = this.password;
    data['contentType'] = this.contentType;
    return data;
  }
}
