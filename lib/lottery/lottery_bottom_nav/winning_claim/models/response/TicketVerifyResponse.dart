class TicketVerifyResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  TicketVerifyResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  TicketVerifyResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    responseData = json['responseData'] != null
        ? new ResponseData.fromJson(json['responseData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    if (this.responseData != null) {
      data['responseData'] = this.responseData!.toJson();
    }
    return data;
  }

  getResponseData() {}
}

class ResponseData {
  String? ticketNumber;
  String? gameName;
  String? gameCode;
  int? gameId;
  List<DrawData>? drawData;
  List<PanelData>? panelData;
  String? prizeAmount;
  String? totalPay;
  String? currencySymbol;
  String? merchantCode;
  String? orgName;
  String? retailerName;
  String? reprintCountPwt;
  String? pwtTicketType;
  String? reference;
  double? winClaimAmount;
  String? ticketExpiry;
  double? totalPurchaseAmount;

  ResponseData(
      {this.ticketNumber,
        this.gameName,
        this.gameCode,
        this.gameId,
        this.drawData,
        this.panelData,
        this.prizeAmount,
        this.totalPay,
        this.currencySymbol,
        this.merchantCode,
        this.orgName,
        this.retailerName,
        this.reprintCountPwt,
        this.pwtTicketType,
        this.reference,
        this.winClaimAmount,
        this.ticketExpiry,
        this.totalPurchaseAmount
      });

  ResponseData.fromJson(Map<String, dynamic> json) {
    ticketNumber = json['ticketNumber'];
    gameName = json['gameName'];
    gameCode = json['gameCode'];
    gameId = json['gameId'];
    if (json['drawData'] != null) {
      drawData = <DrawData>[];
      json['drawData'].forEach((v) {
        drawData!.add(new DrawData.fromJson(v));
      });
    }
    if (json['panelData'] != null) {
      panelData = <PanelData>[];
      json['panelData'].forEach((v) {
        panelData!.add(new PanelData.fromJson(v));
      });
    }
    prizeAmount = json['prizeAmount'];
    totalPay = json['totalPay'];
    currencySymbol = json['currencySymbol'];
    merchantCode = json['merchantCode'];
    orgName = json['orgName'];
    retailerName = json['retailerName'];
    reprintCountPwt = json['reprintCountPwt'];
    pwtTicketType = json['pwtTicketType'];
    reference = json['reference'];
    winClaimAmount = json['winClaimAmount'];
    ticketExpiry = json['ticketExpiry'];
    totalPurchaseAmount = json['totalPurchaseAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticketNumber'] = this.ticketNumber;
    data['gameName'] = this.gameName;
    data['gameCode'] = this.gameCode;
    data['gameId'] = this.gameId;
    if (this.drawData != null) {
      data['drawData'] = this.drawData!.map((v) => v.toJson()).toList();
    }
    if (this.panelData != null) {
      data['panelData'] = this.panelData!.map((v) => v.toJson()).toList();
    }
    data['prizeAmount'] = this.prizeAmount;
    data['totalPay'] = this.totalPay;
    data['currencySymbol'] = this.currencySymbol;
    data['merchantCode'] = this.merchantCode;
    data['orgName'] = this.orgName;
    data['retailerName'] = this.retailerName;
    data['reprintCountPwt'] = this.reprintCountPwt;
    data['pwtTicketType'] = this.pwtTicketType;
    data['reference'] = this.reference;
    data['winClaimAmount'] = this.winClaimAmount;
    data['ticketExpiry'] = this.ticketExpiry;
    data['totalPurchaseAmount'] = this.totalPurchaseAmount;
    return data;
  }
}

class DrawData {
  int? drawId;
  String? drawName;
  String? drawDate;
  String? drawTime;
  String? winStatus;
  String? winningAmount;
  List<PanelWinList>? panelWinList;
  int? winCode;

  DrawData(
      {this.drawId,
        this.drawName,
        this.drawDate,
        this.drawTime,
        this.winStatus,
        this.winningAmount,
        this.panelWinList,
        this.winCode});

  DrawData.fromJson(Map<String, dynamic> json) {
    drawId = json['drawId'];
    drawName = json['drawName'];
    drawDate = json['drawDate'];
    drawTime = json['drawTime'];
    winStatus = json['winStatus'];
    winningAmount = json['winningAmount'];
    if (json['panelWinList'] != null) {
      panelWinList = <PanelWinList>[];
      json['panelWinList'].forEach((v) {
        panelWinList!.add(new PanelWinList.fromJson(v));
      });
    }
    winCode = json['winCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['drawId'] = this.drawId;
    data['drawName'] = this.drawName;
    data['drawDate'] = this.drawDate;
    data['drawTime'] = this.drawTime;
    data['winStatus'] = this.winStatus;
    data['winningAmount'] = this.winningAmount;
    if (this.panelWinList != null) {
      data['panelWinList'] = this.panelWinList!.map((v) => v.toJson()).toList();
    }
    data['winCode'] = this.winCode;
    return data;
  }
}

class PanelData {
  String? betType;
  String? pickType;
  Null? tpticketList;
  String? pickConfig;
  int? betAmountMultiple;
  bool? quickPick;
  String? pickedValues;
  bool? qpPreGenerated;
  int? numberOfLines;
  double? unitCost;
  double? panelPrice;
  double? playerPanelPrice;
  String? betDisplayName;
  String? pickDisplayName;
  String? winningMultiplier;

  PanelData({this.betType, this.pickType, this.tpticketList, this.pickConfig, this.betAmountMultiple, this.quickPick, this.pickedValues, this.qpPreGenerated, this.numberOfLines, this.unitCost, this.panelPrice, this.playerPanelPrice, this.betDisplayName, this.pickDisplayName, this.winningMultiplier});

  PanelData.fromJson(Map<String, dynamic> json) {
    betType = json['betType'];
    pickType = json['pickType'];
    tpticketList = json['tpticketList'];
    pickConfig = json['pickConfig'];
    betAmountMultiple = json['betAmountMultiple'];
    quickPick = json['quickPick'];
    pickedValues = json['pickedValues'];
    qpPreGenerated = json['qpPreGenerated'];
    numberOfLines = json['numberOfLines'];
    unitCost = json['unitCost'];
    panelPrice = json['panelPrice'];
    playerPanelPrice = json['playerPanelPrice'];
    betDisplayName = json['betDisplayName'];
    pickDisplayName = json['pickDisplayName'];
    winningMultiplier = json['winningMultiplier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['betType'] = this.betType;
    data['pickType'] = this.pickType;
    data['tpticketList'] = this.tpticketList;
    data['pickConfig'] = this.pickConfig;
    data['betAmountMultiple'] = this.betAmountMultiple;
    data['quickPick'] = this.quickPick;
    data['pickedValues'] = this.pickedValues;
    data['qpPreGenerated'] = this.qpPreGenerated;
    data['numberOfLines'] = this.numberOfLines;
    data['unitCost'] = this.unitCost;
    data['panelPrice'] = this.panelPrice;
    data['playerPanelPrice'] = this.playerPanelPrice;
    data['betDisplayName'] = this.betDisplayName;
    data['pickDisplayName'] = this.pickDisplayName;
    data['winningMultiplier'] = this.winningMultiplier;
    return data;
  }
}

class PanelWinList {
  int? panelId;
  String? status;
  String? playType;
  double? winningAmt;
  bool? valid;

  PanelWinList(
      {this.panelId, this.status, this.playType, this.winningAmt, this.valid});

  PanelWinList.fromJson(Map<String, dynamic> json) {
    panelId = json['panelId'];
    status = json['status'];
    playType = json['playType'];
    winningAmt = json['winningAmt'];
    valid = json['valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['panelId'] = this.panelId;
    data['status'] = this.status;
    data['playType'] = this.playType;
    data['winningAmt'] = this.winningAmt;
    data['valid'] = this.valid;
    return data;
  }
}