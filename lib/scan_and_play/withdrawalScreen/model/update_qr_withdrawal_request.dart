class UpdateQrWithdrawalRequest {
  String? requestId;
  String? domainId;
  String? aliasId;
  String? userId;
  String? amount;
  String? device;
  String? appType;
  String? retailerId;

  UpdateQrWithdrawalRequest(
      {this.requestId, this.domainId, this.aliasId, this.userId, this.amount,this.device,this.appType,this.retailerId});

  UpdateQrWithdrawalRequest.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    domainId = json['domainId'];
    aliasId = json['aliasId'];
    userId = json['userId'];
    amount = json['amount'];
    device = json['device'];
    appType = json['appType'];
    retailerId = json['retailerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    data['domainId'] = this.domainId;
    data['aliasId'] = this.aliasId;
    data['userId'] = this.userId;
    data['amount'] = this.amount;
    data['device'] = this.device;
    data['appType'] = this.appType;
    data['retailerId'] = this.retailerId;
    return data;
  }
}
