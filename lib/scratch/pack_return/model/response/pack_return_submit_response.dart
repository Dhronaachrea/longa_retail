class PackReturnSubmitResponse {
  int? responseCode;
  String? responseMessage;
  String? dlChallanNumber;
  int? challanId;

  PackReturnSubmitResponse(
      {this.responseCode,
        this.responseMessage,
        this.dlChallanNumber,
        this.challanId});

  PackReturnSubmitResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    dlChallanNumber = json['dlChallanNumber'];
    challanId = json['challanId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    data['dlChallanNumber'] = this.dlChallanNumber;
    data['challanId'] = this.challanId;
    return data;
  }
}