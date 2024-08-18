class UserMenuListRequest {
  String? userId;
  String? appType;
  String? engineCode;
  String? languageCode;

  UserMenuListRequest(
      {this.userId, this.appType, this.engineCode, this.languageCode});

  UserMenuListRequest.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    appType = json['appType'];
    engineCode = json['engineCode'];
    languageCode = json['languageCode'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['userId'] = userId ?? "";
    data['appType'] = appType ?? "";
    data['engineCode'] = engineCode ?? "";
    data['languageCode'] = languageCode ?? "";
    return data;
  }
}
