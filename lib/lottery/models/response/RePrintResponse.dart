class RePrintResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  RePrintResponse({this.responseCode, this.responseMessage, this.responseData});

  RePrintResponse.fromJson(Map<String, dynamic> json) {
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
}

class ResponseData {
  int? gameId;
  String? gameName;
  String? gameCode;
  double? totalPurchaseAmount;
  double? playerPurchaseAmount;
  String? purchaseTime;
  String? ticketNumber;
  List<PanelData>? panelData;
  List<DrawData>? drawData;
  String? merchantCode;
  String? currencyCode;
  String? partyType;
  String? channel;
  String? validationCode;
  String? ticketExpiry;
  int? noOfDraws;

  ResponseData(
      {this.gameId,
        this.gameName,
        this.gameCode,
        this.totalPurchaseAmount,
        this.playerPurchaseAmount,
        this.purchaseTime,
        this.ticketNumber,
        this.panelData,
        this.drawData,
        this.merchantCode,
        this.currencyCode,
        this.partyType,
        this.channel,
        this.validationCode,
        this.ticketExpiry,
        this.noOfDraws});

  ResponseData.fromJson(Map<String, dynamic> json) {
    gameId = json['gameId'];
    gameName = json['gameName'];
    gameCode = json['gameCode'];
    totalPurchaseAmount = json['totalPurchaseAmount'];
    playerPurchaseAmount = json['playerPurchaseAmount'];
    purchaseTime = json['purchaseTime'];
    ticketNumber = json['ticketNumber'];
    if (json['panelData'] != null) {
      panelData = <PanelData>[];
      json['panelData'].forEach((v) {
        panelData!.add(new PanelData.fromJson(v));
      });
    }
    if (json['drawData'] != null) {
      drawData = <DrawData>[];
      json['drawData'].forEach((v) {
        drawData!.add(new DrawData.fromJson(v));
      });
    }
    merchantCode = json['merchantCode'];
    currencyCode = json['currencyCode'];
    partyType = json['partyType'];
    channel = json['channel'];
    validationCode = json['validationCode'];
    ticketExpiry = json['ticketExpiry'];
    noOfDraws = json['noOfDraws'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameId'] = this.gameId;
    data['gameName'] = this.gameName;
    data['gameCode'] = this.gameCode;
    data['totalPurchaseAmount'] = this.totalPurchaseAmount;
    data['playerPurchaseAmount'] = this.playerPurchaseAmount;
    data['purchaseTime'] = this.purchaseTime;
    data['ticketNumber'] = this.ticketNumber;
    if (this.panelData != null) {
      data['panelData'] = this.panelData!.map((v) => v.toJson()).toList();
    }
    if (this.drawData != null) {
      data['drawData'] = this.drawData!.map((v) => v.toJson()).toList();
    }
    data['merchantCode'] = this.merchantCode;
    data['currencyCode'] = this.currencyCode;
    data['partyType'] = this.partyType;
    data['channel'] = this.channel;
    data['validationCode'] = this.validationCode;
    data['ticketExpiry'] = this.ticketExpiry;
    data['noOfDraws'] = this.noOfDraws;
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
  Null? winningMultiplier;

  PanelData(
      {this.betType,
        this.pickType,
        this.tpticketList,
        this.pickConfig,
        this.betAmountMultiple,
        this.quickPick,
        this.pickedValues,
        this.qpPreGenerated,
        this.numberOfLines,
        this.unitCost,
        this.panelPrice,
        this.playerPanelPrice,
        this.betDisplayName,
        this.pickDisplayName,
        this.winningMultiplier});

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

class DrawData {
  String? drawName;
  String? drawDate;
  String? drawTime;

  DrawData({this.drawName, this.drawDate, this.drawTime});

  DrawData.fromJson(Map<String, dynamic> json) {
    drawName = json['drawName'];
    drawDate = json['drawDate'];
    drawTime = json['drawTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['drawName'] = this.drawName;
    data['drawDate'] = this.drawDate;
    data['drawTime'] = this.drawTime;
    return data;
  }
}
