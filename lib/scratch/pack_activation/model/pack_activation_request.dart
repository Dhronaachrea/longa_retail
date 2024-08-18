class PackActivationRequest {
  List<String>? bookNumbers;
  String? gameType;
  List<String>? packNumbers;
  String? userName;
  String? userSessionId;

  PackActivationRequest(
      {this.bookNumbers,
        this.gameType,
        this.packNumbers,
        this.userName,
        this.userSessionId});

  PackActivationRequest.fromJson(Map<String, dynamic> json) {
    bookNumbers = json['bookNumbers'].cast<String>();
    gameType = json['gameType'];
    packNumbers = json['packNumbers'].cast<String>();
    userName = json['userName'];
    userSessionId = json['userSessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookNumbers'] = this.bookNumbers;
    data['gameType'] = this.gameType;
    data['packNumbers'] = this.packNumbers;
    data['userName'] = this.userName;
    data['userSessionId'] = this.userSessionId;
    return data;
  }
}