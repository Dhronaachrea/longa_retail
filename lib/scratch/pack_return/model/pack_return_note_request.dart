class PackReturnNoteRequest {
  String? dlChallanNumber;
  String? userName;
  String? userSessionId;

  PackReturnNoteRequest({this.dlChallanNumber, this.userName, this.userSessionId });

  PackReturnNoteRequest.fromJson(Map<String, dynamic> json) {
    dlChallanNumber = json['dlChallanNumber'];
    userName = json['userName'];
    userSessionId = json['userSessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dlChallanNumber'] = this.dlChallanNumber;
    data['userName'] = this.userName;
    data['userSessionId'] = this.userSessionId;
    return data;
  }
}