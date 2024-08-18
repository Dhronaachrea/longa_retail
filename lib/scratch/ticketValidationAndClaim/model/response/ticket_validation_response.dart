class TicketValidationResponse {
  double? netWinningAmount;
  int? responseCode;
  String? responseMessage;
  String? soldByOrg;
  double? taxAmount;
  String? ticketNumber;
  String? virnNumber;
  double? winningAmount;


  TicketValidationResponse(
      {this.netWinningAmount,
        this.responseCode,
        this.responseMessage,
        this.soldByOrg,
        this.taxAmount,
        this.ticketNumber,
        this.virnNumber,
        this.winningAmount});

  TicketValidationResponse.fromJson(Map<String, dynamic> json) {
    netWinningAmount = json['netWinningAmount'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    soldByOrg = json['soldByOrg'];
    taxAmount = json['taxAmount'];
    ticketNumber = json['ticketNumber'];
    virnNumber = json['virnNumber'];
    winningAmount = json['winningAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['netWinningAmount'] = this.netWinningAmount;
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    data['soldByOrg'] = this.soldByOrg;
    data['taxAmount'] = this.taxAmount;
    data['ticketNumber'] = this.ticketNumber;
    data['virnNumber'] = this.virnNumber;
    data['winningAmount'] = this.winningAmount;
    return data;
  }
}