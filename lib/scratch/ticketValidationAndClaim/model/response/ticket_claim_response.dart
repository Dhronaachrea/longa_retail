class TicketClaimResponse {
  AdvMessages? advMessages;
  String? claimedByOrg;
  String? claimedLocation;
  int? commissionAmount; // checked
  int? gameId;
  int? gameTxnId;
  double? netWinningAmount;
  String? requestId;
  int? responseCode;
  String? responseMessage;
  String? soldByOrg;
  double? taxAmount;
  int? tdsAmount; // checked
  String? ticketNumber;
  String? transactionDate;
  String? transactionId;
  String? transactionNumber;
  String? txnStatus;
  String? virnNumber;
  double? winningAmount;
  TicketClaimResponse(
      {this.advMessages,
        this.claimedByOrg,
        this.claimedLocation,
        this.commissionAmount,
        this.gameId,
        this.gameTxnId,
        this.netWinningAmount,
        this.requestId,
        this.responseCode,
        this.responseMessage,
        this.soldByOrg,
        this.taxAmount,
        this.tdsAmount,
        this.ticketNumber,
        this.transactionDate,
        this.transactionId,
        this.transactionNumber,
        this.txnStatus,
        this.virnNumber,
        this.winningAmount});

  TicketClaimResponse.fromJson(Map<String, dynamic> json) {
    advMessages = json['advMessages'] != null
        ? new AdvMessages.fromJson(json['advMessages'])
        : null;
    claimedByOrg = json['claimedByOrg'];
    claimedLocation = json['claimedLocation'];
    commissionAmount = json['commissionAmount'];
    gameId = json['gameId'];
    gameTxnId = json['gameTxnId'];
    netWinningAmount = json['netWinningAmount'];
    requestId = json['requestId'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    soldByOrg = json['soldByOrg'];
    taxAmount = json['taxAmount'];
    tdsAmount = json['tdsAmount'];
    ticketNumber = json['ticketNumber'];
    transactionDate = json['transactionDate'];
    transactionId = json['transactionId'];
    transactionNumber = json['transactionNumber'];
    txnStatus = json['txnStatus'];
    virnNumber = json['virnNumber'];
    winningAmount = json['winningAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.advMessages != null) {
      data['advMessages'] = this.advMessages!.toJson();
    }
    data['claimedByOrg'] = this.claimedByOrg;
    data['claimedLocation'] = this.claimedLocation;
    data['commissionAmount'] = this.commissionAmount;
    data['gameId'] = this.gameId;
    data['gameTxnId'] = this.gameTxnId;
    data['netWinningAmount'] = this.netWinningAmount;
    data['requestId'] = this.requestId;
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    data['soldByOrg'] = this.soldByOrg;
    data['taxAmount'] = this.taxAmount;
    data['tdsAmount'] = this.tdsAmount;
    data['ticketNumber'] = this.ticketNumber;
    data['transactionDate'] = this.transactionDate;
    data['transactionId'] = this.transactionId;
    data['transactionNumber'] = this.transactionNumber;
    data['txnStatus'] = this.txnStatus;
    data['virnNumber'] = this.virnNumber;
    data['winningAmount'] = this.winningAmount;
    return data;
  }
}

class AdvMessages {
  List<Bottom>? bottom;
  List<Bottom>? top;

  AdvMessages({this.bottom, this.top});

  AdvMessages.fromJson(Map<String, dynamic> json) {
    if (json['bottom'] != null) {
      bottom = <Bottom>[];
      json['bottom'].forEach((v) {
        bottom!.add(new Bottom.fromJson(v));
      });
    }
    if (json['top'] != null) {
      top = <Bottom>[];
      json['top'].forEach((v) {
        top!.add(new Bottom.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bottom != null) {
      data['bottom'] = this.bottom!.map((v) => v.toJson()).toList();
    }
    if (this.top != null) {
      data['top'] = this.top!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bottom {
  String? msgMode;
  String? msgText;
  String? msgType;

  Bottom({this.msgMode, this.msgText, this.msgType});

  Bottom.fromJson(Map<String, dynamic> json) {
    msgMode = json['msgMode'];
    msgText = json['msgText'];
    msgType = json['msgType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msgMode'] = this.msgMode;
    data['msgText'] = this.msgText;
    data['msgType'] = this.msgType;
    return data;
  }
}