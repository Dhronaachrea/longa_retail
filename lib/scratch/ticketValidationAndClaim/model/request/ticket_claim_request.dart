class TicketClaimRequest {
  String? barcodeNumber;
  String? modelCode;
  int? requestId;
  int? terminalId;
  String? userName;
  String? userSessionId;

  TicketClaimRequest(
      {this.barcodeNumber,
        this.modelCode,
        this.requestId,
        this.terminalId,
        this.userName,
        this.userSessionId});

  TicketClaimRequest.fromJson(Map<String, dynamic> json) {
    barcodeNumber = json['barcodeNumber'];
    modelCode = json['modelCode'];
    requestId = json['requestId'];
    terminalId = json['terminalId'];
    userName = json['userName'];
    userSessionId = json['userSessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['barcodeNumber'] = this.barcodeNumber;
    data['modelCode'] = this.modelCode;
    data['requestId'] = this.requestId;
    data['terminalId'] = this.terminalId;
    data['userName'] = this.userName;
    data['userSessionId'] = this.userSessionId;
    return data;
  }
}