class SaleTicketResponse {
  List<String>? invalidBooks;
  List<String>? invalidTickets;
  String? orgName;
  int? responseCode;
  String? responseMessage;
  List<SaleTicketDetails>? saleTicketDetails;
  List<String>? soldBooks;
  List<String>? soldTickets;

  SaleTicketResponse(
      {this.invalidBooks,
        this.invalidTickets,
        this.orgName,
        this.responseCode,
        this.responseMessage,
        this.saleTicketDetails,
        this.soldBooks,
        this.soldTickets});

  SaleTicketResponse.fromJson(Map<String, dynamic> json) {
    invalidBooks = json['invalidBooks']?.cast<String>();
    invalidTickets = json['invalidTickets']?.cast<String>();
    orgName = json['orgName'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    if (json['saleTicketDetails'] != null) {
      saleTicketDetails = <SaleTicketDetails>[];
      json['saleTicketDetails'].forEach((v) {
        saleTicketDetails!.add(new SaleTicketDetails.fromJson(v));
      });
    }
    soldBooks = json['soldBooks']?.cast<String>();
    soldTickets = json['soldTickets']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invalidBooks'] = this.invalidBooks;
    data['invalidTickets'] = this.invalidTickets;
    data['orgName'] = this.orgName;
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    if (this.saleTicketDetails != null) {
      data['saleTicketDetails'] =
          this.saleTicketDetails!.map((v) => v.toJson()).toList();
    }
    data['soldBooks'] = this.soldBooks;
    data['soldTickets'] = this.soldTickets;
    return data;
  }
}

class SaleTicketDetails {
  String? gameName;
  List<String>? ticketNumbers;
  double? ticketPrice;

  SaleTicketDetails({this.gameName, this.ticketNumbers, this.ticketPrice});

  SaleTicketDetails.fromJson(Map<String, dynamic> json) {
    gameName = json['gameName'];
    ticketNumbers = json['ticketNumbers']?.cast<String>();
    ticketPrice = json['ticketPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameName'] = this.gameName;
    data['ticketNumbers'] = this.ticketNumbers;
    data['ticketPrice'] = this.ticketPrice;
    return data;
  }
}