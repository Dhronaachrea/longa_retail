class ClaimWinResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  ClaimWinResponse({this.responseCode, this.responseMessage, this.responseData});

  ClaimWinResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    responseData = json['responseData'] != null ? new ResponseData.fromJson(json['responseData']) : null;
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
  String? ticketNumber;
  int? doneByUserId;
  String? status;
  double? balance;
  String? gameName;
  String? gameCode;
  List<DrawData>? drawData;
  String? prizeAmount;
  String? totalPay;
  String? currencySymbol;
  String? merchantCode;
  String? orgName;
  String? retailerName;
  String? reprintCountPwt;
  List<PanelData>? panelData;
  int? merchantTxnId;
  String? validationCode;
  bool? isPwtReprint;
  String? ticketExpiry;
  double? totalPurchaseAmount;
  double? playerPurchaseAmount;
  String? purchaseTime;
  String? claimTime;
  double? claimAmount;
  int? drawClaimedCount;
  bool? success;

  ResponseData({this.ticketNumber, this.doneByUserId, this.status, this.balance, this.gameName, this.gameCode, this.drawData, this.prizeAmount, this.totalPay, this.currencySymbol, this.merchantCode, this.orgName, this.retailerName, this.reprintCountPwt, this.panelData, this.merchantTxnId, this.validationCode, this.isPwtReprint, this.totalPurchaseAmount, this.playerPurchaseAmount, this.purchaseTime, this.claimTime, this.claimAmount, this.drawClaimedCount, this.success, this.ticketExpiry});

  ResponseData.fromJson(Map<String, dynamic> json) {
    ticketNumber = json['ticketNumber'];
    doneByUserId = json['doneByUserId'];
    status = json['status'];
    balance = json['balance'];
    gameName = json['gameName'];
    gameCode = json['gameCode'];
    if (json['drawData'] != null) {
      drawData = <DrawData>[];
      json['drawData'].forEach((v) { drawData!.add(new DrawData.fromJson(v)); });
    }
    prizeAmount = json['prizeAmount'];
    totalPay = json['totalPay'];
    currencySymbol = json['currencySymbol'];
    merchantCode = json['merchantCode'];
    orgName = json['orgName'];
    retailerName = json['retailerName'];
    reprintCountPwt = json['reprintCountPwt'];
    /*drawTransMap = json['drawTransMap'] != null ? new DrawTransMap.fromJson(json['drawTransMap']) : null;*/
    if (json['panelData'] != null) {
      panelData = <PanelData>[];
      json['panelData'].forEach((v) { panelData!.add(new PanelData.fromJson(v)); });
    }
    merchantTxnId = json['merchantTxnId'];
    validationCode = json['validationCode'];
    isPwtReprint = json['isPwtReprint'];
    totalPurchaseAmount = json['totalPurchaseAmount'];
    playerPurchaseAmount = json['playerPurchaseAmount'];
    purchaseTime = json['purchaseTime'];
    claimTime = json['claimTime'];
    claimAmount = json['claimAmount'];
    drawClaimedCount = json['drawClaimedCount'];
    success = json['success'];
    ticketExpiry = json['ticketExpiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticketNumber'] = this.ticketNumber;
    data['doneByUserId'] = this.doneByUserId;
    data['status'] = this.status;
    data['balance'] = this.balance;
    data['gameName'] = this.gameName;
    data['gameCode'] = this.gameCode;
    if (this.drawData != null) {
      data['drawData'] = this.drawData!.map((v) => v.toJson()).toList();
    }
    data['prizeAmount'] = this.prizeAmount;
    data['totalPay'] = this.totalPay;
    data['currencySymbol'] = this.currencySymbol;
    data['merchantCode'] = this.merchantCode;
    data['orgName'] = this.orgName;
    data['retailerName'] = this.retailerName;
    data['reprintCountPwt'] = this.reprintCountPwt;
    if (this.panelData != null) {
      data['panelData'] = this.panelData!.map((v) => v.toJson()).toList();
    }
    data['merchantTxnId'] = this.merchantTxnId;
    data['validationCode'] = this.validationCode;
    data['isPwtReprint'] = this.isPwtReprint;
    data['totalPurchaseAmount'] = this.totalPurchaseAmount;
    data['playerPurchaseAmount'] = this.playerPurchaseAmount;
    data['purchaseTime'] = this.purchaseTime;
    data['claimTime'] = this.claimTime;
    data['claimAmount'] = this.claimAmount;
    data['drawClaimedCount'] = this.drawClaimedCount;
    data['success'] = this.success;
    data['ticketExpiry'] = this.ticketExpiry;
    return data;
  }
}

class DrawData {
  int? drawId;
  String? drawName;
  String? drawDate;
  String? drawTime;
  bool? isPwtCurrent;
  String? winStatus;
  String? winningAmount;
  List<PanelWinList>? panelWinList;
  int? winCode;

  DrawData({this.drawId, this.drawName, this.drawDate, this.drawTime, this.isPwtCurrent, this.winStatus, this.winningAmount, this.panelWinList, this.winCode});

  DrawData.fromJson(Map<String, dynamic> json) {
    drawId = json['drawId'];
    drawName = json['drawName'];
    drawDate = json['drawDate'];
    drawTime = json['drawTime'];
    isPwtCurrent = json['isPwtCurrent'];
    winStatus = json['winStatus'];
    winningAmount = json['winningAmount'];
    if (json['panelWinList'] != null) {
      panelWinList = <PanelWinList>[];
      json['panelWinList'].forEach((v) { panelWinList!.add(new PanelWinList.fromJson(v)); });
    }
    winCode = json['winCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['drawId'] = this.drawId;
    data['drawName'] = this.drawName;
    data['drawDate'] = this.drawDate;
    data['drawTime'] = this.drawTime;
    data['isPwtCurrent'] = this.isPwtCurrent;
    data['winStatus'] = this.winStatus;
    data['winningAmount'] = this.winningAmount;
    if (this.panelWinList != null) {
      data['panelWinList'] = this.panelWinList!.map((v) => v.toJson()).toList();
    }
    data['winCode'] = this.winCode;
    return data;
  }
}

class PanelWinList {
  int? panelId;
  String? status;
  String? playType;
  double? winningAmt;
  String? winningItem;
  bool? valid;

  PanelWinList({this.panelId, this.status, this.playType, this.winningAmt, this.winningItem, this.valid});

  PanelWinList.fromJson(Map<String, dynamic> json) {
    panelId = json['panelId'];
    status = json['status'];
    playType = json['playType'];
    winningAmt = json['winningAmt'];
    winningItem = json['winningItem'];
    valid = json['valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['panelId'] = this.panelId;
    data['status'] = this.status;
    data['playType'] = this.playType;
    data['winningAmt'] = this.winningAmt;
    data['winningItem'] = this.winningItem;
    data['valid'] = this.valid;
    return data;
  }
}

/*class DrawTransMap {


  DrawTransMap({});

DrawTransMap.fromJson(Map<String, dynamic> json) {
}*/

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
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
