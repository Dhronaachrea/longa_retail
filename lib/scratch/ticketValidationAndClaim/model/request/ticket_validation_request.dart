class TicketValidationRequest {
  String? barcodeNumber;
  String? userName;
  String? userSessionId;

  TicketValidationRequest(
      {this.barcodeNumber, this.userName, this.userSessionId});

  TicketValidationRequest.fromJson(Map<String, dynamic> json) {
    barcodeNumber = json['barcodeNumber'];
    userName = json['userName'];
    userSessionId = json['userSessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['barcodeNumber'] = this.barcodeNumber;
    data['userName'] = this.userName;
    data['userSessionId'] = this.userSessionId;
    return data;
  }
}