class TicketVerifyRequest {
  String? merchantCode;
  String? userName;
  String? ticketNumber;
  String? sessionId;
  int? lastPWTTicket;

  TicketVerifyRequest(
      {this.merchantCode,
        this.userName,
        this.ticketNumber,
        this.sessionId,
        this.lastPWTTicket});

  TicketVerifyRequest.fromJson(Map<String, dynamic> json) {
    merchantCode = json['merchantCode'];
    userName = json['userName'];
    ticketNumber = json['ticketNumber'];
    sessionId = json['sessionId'];
    lastPWTTicket = json['lastPWTTicket'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchantCode'] = this.merchantCode;
    data['userName'] = this.userName;
    data['ticketNumber'] = this.ticketNumber;
    data['sessionId'] = this.sessionId;
    data['lastPWTTicket'] = this.lastPWTTicket;
    return data;
  }
}
