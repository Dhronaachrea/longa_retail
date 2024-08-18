class GameViseInventoryRequest {
  String? userName;
  String? userSessionId;

  GameViseInventoryRequest({ this.userName, this.userSessionId });

  GameViseInventoryRequest.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    userSessionId = json['userSessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['userSessionId'] = this.userSessionId;
    return data;
  }
}