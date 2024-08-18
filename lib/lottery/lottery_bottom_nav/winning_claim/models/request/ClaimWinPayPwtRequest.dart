class ClaimWinPayPwtRequest {
  String? interfaceType;
  String? merchantCode;
  String? saleMerCode;
  String? sessionId;
  String? ticketNumber;
  String? userName;
  String? verificationCode;
  String? termminalId;
  String? modelCode;

  ClaimWinPayPwtRequest(
      {this.interfaceType,
        this.merchantCode,
        this.saleMerCode,
        this.sessionId,
        this.ticketNumber,
        this.userName,
        this.verificationCode,
        this.termminalId,
        this.modelCode});

  ClaimWinPayPwtRequest.fromJson(Map<String, dynamic> json) {
    interfaceType = json['interfaceType'];
    merchantCode = json['merchantCode'];
    saleMerCode = json['saleMerCode'];
    sessionId = json['sessionId'];
    ticketNumber = json['ticketNumber'];
    userName = json['userName'];
    verificationCode = json['verificationCode'];
    termminalId = json['termminalId'];
    modelCode = json['modelCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['interfaceType'] = this.interfaceType;
    data['merchantCode'] = this.merchantCode;
    data['saleMerCode'] = this.saleMerCode;
    data['sessionId'] = this.sessionId;
    data['ticketNumber'] = this.ticketNumber;
    data['userName'] = this.userName;
    data['verificationCode'] = this.verificationCode;
    data['termminalId'] = this.termminalId;
    data['modelCode'] = this.modelCode;
    return data;
  }
}
