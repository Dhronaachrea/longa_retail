class FetchGameDataRequest {
  String? playerCurrencyCode;
  String? retailerId;
  String? sessionId;
  String? lastTicketNumber;
  String? domainCode;
  List<String>? gameCodes;

  FetchGameDataRequest(
      {this.playerCurrencyCode,
        this.retailerId,
        this.sessionId,
        this.lastTicketNumber,
        this.domainCode,
        this.gameCodes});

  FetchGameDataRequest.fromJson(Map<String, dynamic> json) {
    playerCurrencyCode = json['playerCurrencyCode'];
    retailerId = json['retailerId'];
    sessionId = json['sessionId'];
    lastTicketNumber = json['lastTicketNumber'];
    domainCode = json['domainCode'];
    gameCodes = json['gameCodes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playerCurrencyCode'] = this.playerCurrencyCode;
    data['retailerId'] = this.retailerId;
    data['sessionId'] = this.sessionId;
    data['lastTicketNumber'] = this.lastTicketNumber;
    data['domainCode'] = this.domainCode;
    data['gameCodes'] = this.gameCodes;
    return data;
  }
}
