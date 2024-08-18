class CancelTicketRequest {
  String? autoCancel;
  String? cancelChannel;
  String? gameCode;
  bool? isAutoCancel;
  String? modelCode;
  String? sessionId;
  String? terminalId;
  String? ticketNumber;
  String? userId;

  CancelTicketRequest(
      {this.autoCancel,
        this.cancelChannel,
        this.gameCode,
        this.isAutoCancel,
        this.modelCode,
        this.sessionId,
        this.terminalId,
        this.ticketNumber,
        this.userId});

  CancelTicketRequest.fromJson(Map<String, dynamic> json) {
    autoCancel = json['autoCancel'];
    cancelChannel = json['cancelChannel'];
    gameCode = json['gameCode'];
    isAutoCancel = json['isAutoCancel'];
    modelCode = json['modelCode'];
    sessionId = json['sessionId'];
    terminalId = json['terminalId'];
    ticketNumber = json['ticketNumber'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['autoCancel'] = this.autoCancel;
    data['cancelChannel'] = this.cancelChannel;
    data['gameCode'] = this.gameCode;
    data['isAutoCancel'] = this.isAutoCancel;
    data['modelCode'] = this.modelCode;
    data['sessionId'] = this.sessionId;
    data['terminalId'] = this.terminalId;
    data['ticketNumber'] = this.ticketNumber;
    data['userId'] = this.userId;
    return data;
  }
}
