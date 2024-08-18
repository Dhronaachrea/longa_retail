class SaleTicketRequest {
  String? gameType;
  String? soldChannel;
  List<String>? ticketNumberList;
  //String? modelCode;
  String? terminalId;
  String? userName;
  String? userSessionId;
  //String? retailerOrgId;
  String? fromTicket;
  String? toTicket;

  SaleTicketRequest(
      {this.gameType,
        this.soldChannel,
        this.ticketNumberList,
        //this.modelCode,
        this.terminalId,
        this.userName,
        this.userSessionId,
        this.fromTicket,
        this.toTicket,
       // this.retailerOrgId,
      });

  SaleTicketRequest.fromJson(Map<String, dynamic> json) {
    gameType = json['gameType'];
    soldChannel = json['soldChannel'];
    ticketNumberList = json['ticketNumberList'].cast<String>();
    //modelCode = json['modelCode'];
    terminalId = json['terminalId'];
    userName = json['userName'];
    userSessionId = json['userSessionId'];
    //retailerOrgId = json['retailerOrgId'];
    fromTicket = json['fromTicket'];
    toTicket = json['toTicket'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameType'] = this.gameType;
    data['soldChannel'] = this.soldChannel;
    if(this.ticketNumberList != null){
      data['ticketNumberList'] = this.ticketNumberList;
    }
   // data['modelCode'] = this.modelCode;
    data['terminalId'] = this.terminalId;
    data['userName'] = this.userName;
    data['userSessionId'] = this.userSessionId;
    //data['retailerOrgId'] = this.retailerOrgId;
    if(this.fromTicket != null){
      data['fromTicket'] = this.fromTicket;
    }
    if(this.toTicket != null){
      data['toTicket'] = this.toTicket;
    }
    return data;
  }
}
