class DlDetailsRequest {
  dynamic? dlChallanId;
  String? dlChallanNumber;
  String? tag;
  String? userName;
  String? userSessionId;

  DlDetailsRequest({this.dlChallanId, this.dlChallanNumber, this.tag, this.userName, this.userSessionId});

  DlDetailsRequest.fromJson(Map<String, dynamic> json) {
    dlChallanId = json['dlChallanId'];
    dlChallanNumber = json['dlChallanNumber'];
    tag = json['tag'];
    userName = json['userName'];
    userSessionId = json['userSessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dlChallanId'] = this.dlChallanId;
    data['dlChallanNumber'] = this.dlChallanNumber;
    data['tag'] = this.tag;
    data['userName'] = this.userName;
    data['userSessionId'] = this.userSessionId;
    return data;
  }
}