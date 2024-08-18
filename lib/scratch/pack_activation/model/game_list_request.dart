class GameListRequest {
  dynamic? request;

  GameListRequest({this.request });

  GameListRequest.fromJson(Map<String, dynamic> json) {
    request = json['request'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request'] = this.request;
    return data;
  }
}