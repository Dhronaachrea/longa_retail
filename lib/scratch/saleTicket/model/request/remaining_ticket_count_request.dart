class RemainingTicketCountRequest {
  String? bookNumber;
  String? userName;
  String? userSessionId;

  RemainingTicketCountRequest(
      {this.bookNumber,
        this.userName,
        this.userSessionId,
      });

  RemainingTicketCountRequest.fromJson(Map<String, dynamic> json) {
    bookNumber = json['BookNumber'];
    userName = json['userName'];
    userSessionId = json['userSessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BookNumber'] = this.bookNumber;
    data['userName'] = this.userName;
    data['userSessionId'] = this.userSessionId;
    return data;
  }
}
