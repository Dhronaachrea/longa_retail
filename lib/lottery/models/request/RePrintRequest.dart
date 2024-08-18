class RePrintRequest {
  String? gameCode;
  String? purchaseChannel;
  String? ticketNumber;
  bool? isPwt;

  RePrintRequest(
      {this.gameCode, this.purchaseChannel, this.ticketNumber, this.isPwt});

  RePrintRequest.fromJson(Map<String, dynamic> json) {
    gameCode = json['gameCode'];
    purchaseChannel = json['purchaseChannel'];
    ticketNumber = json['ticketNumber'];
    isPwt = json['isPwt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameCode'] = this.gameCode;
    data['purchaseChannel'] = this.purchaseChannel;
    data['ticketNumber'] = this.ticketNumber;
    data['isPwt'] = this.isPwt;
    return data;
  }
}
