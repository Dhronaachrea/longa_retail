class FetchGameDataResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  FetchGameDataResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  FetchGameDataResponse.fromJson(Map<String, dynamic> json) {
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
  List<GameRespVOs>? gameRespVOs;
  String? currentDate;
  bool? isTicketAutoCancelled;

  ResponseData({this.gameRespVOs, this.currentDate, this.isTicketAutoCancelled});

  ResponseData.fromJson(Map<String, dynamic> json) {
    if (json['gameRespVOs'] != null) {
      gameRespVOs = <GameRespVOs>[];
      json['gameRespVOs'].forEach((v) {
        gameRespVOs!.add(new GameRespVOs.fromJson(v));
      });
    }
    currentDate = json['currentDate'];
    isTicketAutoCancelled = json['isTicketAutoCancelled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gameRespVOs != null) {
      data['gameRespVOs'] = this.gameRespVOs!.map((v) => v.toJson()).toList();
    }
    data['currentDate'] = this.currentDate;
    data['isTicketAutoCancelled'] = this.isTicketAutoCancelled;
    return data;
  }
}

class GameRespVOs {
  int? id;
  int? gameNumber;
  String? gameName;
  String? gameCode;
  String? familyCode;
  String? lastDrawResult;
  String? displayOrder;
  String? drawFrequencyType;
  String? timeToFetchUpdatedGameInfo;
  NumberConfig? numberConfig;
  RunTimeFlag? runTimeFlag;
  List<BetRespVOs>? betRespVOs;
  List<DrawRespVOs>? drawRespVOs;
  String? nativeCurrency;
  String? drawEvent;
  String? gameStatus;
  String? gameOrder;
  String? consecutiveDraw;
  int? maxAdvanceDraws;
  DrawPrizeMultiplier? drawPrizeMultiplier;
  String? lastDrawFreezeTime;
  String? lastDrawDateTime;
  String? lastDrawSaleStopTime;
  String? lastDrawTime;
  int? ticketExpiry;
  List<CurrencyRespVOs>? currencyRespVOs;
  List<LastDrawWinningResultVOs>? lastDrawWinningResultVOs;
  String? hotNumbers;
  String? coldNumbers;
  int? maxPanelAllowed;
  bool? duplicateBallInSecondPanel;
  GameSchemas? gameSchemas;
  List<UnitCost>? unitCost;

  GameRespVOs(
      {this.id,
        this.gameNumber,
        this.gameName,
        this.gameCode,
        this.familyCode,
        this.lastDrawResult,
        this.displayOrder,
        this.drawFrequencyType,
        this.timeToFetchUpdatedGameInfo,
        this.numberConfig,
        this.runTimeFlag,
        this.betRespVOs,
        this.drawRespVOs,
        this.nativeCurrency,
        this.drawEvent,
        this.gameStatus,
        this.gameOrder,
        this.consecutiveDraw,
        this.maxAdvanceDraws,
        this.drawPrizeMultiplier,
        this.lastDrawFreezeTime,
        this.lastDrawDateTime,
        this.lastDrawSaleStopTime,
        this.lastDrawTime,
        this.ticketExpiry,
        this.currencyRespVOs,
        this.lastDrawWinningResultVOs,
        this.hotNumbers,
        this.coldNumbers,
        this.maxPanelAllowed,
        this.duplicateBallInSecondPanel,
        this.gameSchemas,
        this.unitCost,
       });

  GameRespVOs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gameNumber = json['gameNumber'];
    gameName = json['gameName'];
    gameCode = json['gameCode'];
    familyCode = json['familyCode'];
    lastDrawResult = json['lastDrawResult'];
    displayOrder = json['displayOrder'];
    drawFrequencyType = json['drawFrequencyType'];
    timeToFetchUpdatedGameInfo = json['timeToFetchUpdatedGameInfo'];
    numberConfig = json['numberConfig'] != null
        ? new NumberConfig.fromJson(json['numberConfig'])
        : null;
    runTimeFlag = json['runTimeFlag'] != null
        ? new RunTimeFlag.fromJson(json['runTimeFlag'])
        : null;
    if (json['betRespVOs'] != null) {
      betRespVOs = <BetRespVOs>[];
      json['betRespVOs'].forEach((v) {
        betRespVOs!.add(new BetRespVOs.fromJson(v));
      });
    }
    if (json['drawRespVOs'] != null) {
      drawRespVOs = <DrawRespVOs>[];
      json['drawRespVOs'].forEach((v) {
        drawRespVOs!.add(new DrawRespVOs.fromJson(v));
      });
    }
    nativeCurrency = json['nativeCurrency'];
    drawEvent = json['drawEvent'];
    gameStatus = json['gameStatus'];
    gameOrder = json['gameOrder'];
    consecutiveDraw = json['consecutiveDraw'];
    maxAdvanceDraws = json['maxAdvanceDraws'];
    drawPrizeMultiplier = json['drawPrizeMultiplier'] != null
        ? new DrawPrizeMultiplier.fromJson(json['drawPrizeMultiplier'])
        : null;
    lastDrawFreezeTime = json['lastDrawFreezeTime'];
    lastDrawDateTime = json['lastDrawDateTime'];
    lastDrawSaleStopTime = json['lastDrawSaleStopTime'];
    lastDrawTime = json['lastDrawTime'];
    ticketExpiry = json['ticket_expiry'];
    if (json['currencyRespVOs'] != null) {
      currencyRespVOs = <CurrencyRespVOs>[];
      json['currencyRespVOs'].forEach((v) {
        currencyRespVOs!.add(new CurrencyRespVOs.fromJson(v));
      });
    }
    if (json['lastDrawWinningResultVOs'] != null) {
      lastDrawWinningResultVOs = <LastDrawWinningResultVOs>[];
      json['lastDrawWinningResultVOs'].forEach((v) {
        lastDrawWinningResultVOs!.add(new LastDrawWinningResultVOs.fromJson(v));
      });
    }
    hotNumbers = json['hotNumbers'];
    coldNumbers = json['coldNumbers'];
    maxPanelAllowed = json['maxPanelAllowed'];
    duplicateBallInSecondPanel = json['duplicateBallInSecondPanel'];
    gameSchemas = json['gameSchemas'] != null
        ? new GameSchemas.fromJson(json['gameSchemas'])
        : null;
    if (json['unitCost'] != null) {
      unitCost = <UnitCost>[];
      json['unitCost'].forEach((v) {
        unitCost!.add(new UnitCost.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['gameNumber'] = this.gameNumber;
    data['gameName'] = this.gameName;
    data['gameCode'] = this.gameCode;
    data['familyCode'] = this.familyCode;
    data['lastDrawResult'] = this.lastDrawResult;
    data['displayOrder'] = this.displayOrder;
    data['drawFrequencyType'] = this.drawFrequencyType;
    data['timeToFetchUpdatedGameInfo'] = this.timeToFetchUpdatedGameInfo;
    if (this.numberConfig != null) {
      data['numberConfig'] = this.numberConfig!.toJson();
    }
    if (this.runTimeFlag != null) {
      data['runTimeFlag'] = this.runTimeFlag!.toJson();
    }
    if (this.betRespVOs != null) {
      data['betRespVOs'] = this.betRespVOs!.map((v) => v.toJson()).toList();
    }
    if (this.drawRespVOs != null) {
      data['drawRespVOs'] = this.drawRespVOs!.map((v) => v.toJson()).toList();
    }
    data['nativeCurrency'] = this.nativeCurrency;
    data['drawEvent'] = this.drawEvent;
    data['gameStatus'] = this.gameStatus;
    data['gameOrder'] = this.gameOrder;
    data['consecutiveDraw'] = this.consecutiveDraw;
    data['maxAdvanceDraws'] = this.maxAdvanceDraws;
    if (this.drawPrizeMultiplier != null) {
      data['drawPrizeMultiplier'] = this.drawPrizeMultiplier!.toJson();
    }
    data['lastDrawFreezeTime'] = this.lastDrawFreezeTime;
    data['lastDrawDateTime'] = this.lastDrawDateTime;
    data['lastDrawSaleStopTime'] = this.lastDrawSaleStopTime;
    data['lastDrawTime'] = this.lastDrawTime;
    data['ticket_expiry'] = this.ticketExpiry;
    if (this.currencyRespVOs != null) {
      data['currencyRespVOs'] =
          this.currencyRespVOs!.map((v) => v.toJson()).toList();
    }
    if (this.lastDrawWinningResultVOs != null) {
      data['lastDrawWinningResultVOs'] =
          this.lastDrawWinningResultVOs!.map((v) => v.toJson()).toList();
    }
    data['hotNumbers'] = this.hotNumbers;
    data['coldNumbers'] = this.coldNumbers;
    data['maxPanelAllowed'] = this.maxPanelAllowed;
    data['duplicateBallInSecondPanel'] = this.duplicateBallInSecondPanel;
    if (this.gameSchemas != null) {
      data['gameSchemas'] = this.gameSchemas!.toJson();
    }
    if (this.unitCost != null) {
      data['unitCost'] = this.unitCost!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NumberConfig {
  List<Range>? range;

  NumberConfig({this.range});

  NumberConfig.fromJson(Map<String, dynamic> json) {
    if (json['range'] != null) {
      range = <Range>[];
      json['range'].forEach((v) {
        range!.add(new Range.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.range != null) {
      data['range'] = this.range!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Range {
  List<Ball>? ball;

  Range({this.ball});

  Range.fromJson(Map<String, dynamic> json) {
    if (json['ball'] != null) {
      ball = <Ball>[];
      json['ball'].forEach((v) {
        ball!.add(new Ball.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ball != null) {
      data['ball'] = this.ball!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ball {
  String? color;
  String? label;
  String? number;

  Ball({this.color, this.label, this.number});

  Ball.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    label = json['label'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = this.color;
    data['label'] = this.label;
    data['number'] = this.number;
    return data;
  }
}

class RunTimeFlag {
  String? createEvent;
  List<FalgList>? falgList;

  RunTimeFlag({this.createEvent, this.falgList});

  RunTimeFlag.fromJson(Map<String, dynamic> json) {
    createEvent = json['createEvent'];
    if (json['falgList'] != null) {
      falgList = <FalgList>[];
      json['falgList'].forEach((v) {
        falgList!.add(new FalgList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createEvent'] = this.createEvent;
    if (this.falgList != null) {
      data['falgList'] = this.falgList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FalgList {
  String? name;
  double? multiplier;
  String? range;
  String? code;

  FalgList({this.name, this.multiplier, this.range, this.code});

  FalgList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    multiplier = json['multiplier'];
    range = json['range'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['multiplier'] = this.multiplier;
    data['range'] = this.range;
    data['code'] = this.code;
    return data;
  }
}

class BetRespVOs {
  double? unitPrice;
  int? maxBetAmtMul;
  String? betDispName;
  String? betCode;
  String? betName;
  String? betGroup;
  PickTypeData? pickTypeData;
  String? inputCount;
  String? winMode;
  int? betOrder;

  BetRespVOs(
      {this.unitPrice,
        this.maxBetAmtMul,
        this.betDispName,
        this.betCode,
        this.betName,
        this.betGroup,
        this.pickTypeData,
        this.inputCount,
        this.winMode,
        this.betOrder});

  BetRespVOs.fromJson(Map<String, dynamic> json) {
    unitPrice = json['unitPrice'];
    maxBetAmtMul = json['maxBetAmtMul'];
    betDispName = json['betDispName'];
    betCode = json['betCode'];
    betName = json['betName'];
    betGroup = json['betGroup'];
    pickTypeData = json['pickTypeData'] != null
        ? new PickTypeData.fromJson(json['pickTypeData'])
        : null;
    inputCount = json['inputCount'];
    winMode = json['winMode'];
    betOrder = json['betOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitPrice'] = this.unitPrice;
    data['maxBetAmtMul'] = this.maxBetAmtMul;
    data['betDispName'] = this.betDispName;
    data['betCode'] = this.betCode;
    data['betName'] = this.betName;
    data['betGroup'] = this.betGroup;
    if (this.pickTypeData != null) {
      data['pickTypeData'] = this.pickTypeData!.toJson();
    }
    data['inputCount'] = this.inputCount;
    data['winMode'] = this.winMode;
    data['betOrder'] = this.betOrder;
    return data;
  }
}

class PickTypeData {
  List<PickType>? pickType;

  PickTypeData({this.pickType});

  PickTypeData.fromJson(Map<String, dynamic> json) {
    if (json['pickType'] != null) {
      pickType = <PickType>[];
      json['pickType'].forEach((v) {
        pickType!.add(new PickType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pickType != null) {
      data['pickType'] = this.pickType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PickType {
  String? name;
  String? code;
  List<Range1>? range;
  String? coordinate;
  String? description;

  PickType(
      {this.name, this.code, this.range, this.coordinate, this.description});

  PickType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    if (json['range'] != null) {
      range = <Range1>[];
      json['range'].forEach((v) {
        range!.add(new Range1.fromJson(v));
      });
    }
    coordinate = json['coordinate'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    if (this.range != null) {
      data['range'] = this.range!.map((v) => v.toJson()).toList();
    }
    data['coordinate'] = this.coordinate;
    data['description'] = this.description;
    return data;
  }
}

class Range1 {
  String? pickMode;
  String? pickCount;
  String? pickValue;
  String? pickConfig;
  String? qpAllowed;

  Range1(
      {this.pickMode,
        this.pickCount,
        this.pickValue,
        this.pickConfig,
        this.qpAllowed});

  Range1.fromJson(Map<String, dynamic> json) {
    pickMode = json['pickMode'];
    pickCount = json['pickCount'];
    pickValue = json['pickValue'];
    pickConfig = json['pickConfig'];
    qpAllowed = json['qpAllowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pickMode'] = this.pickMode;
    data['pickCount'] = this.pickCount;
    data['pickValue'] = this.pickValue;
    data['pickConfig'] = this.pickConfig;
    data['qpAllowed'] = this.qpAllowed;
    return data;
  }
}

class DrawRespVOs {
  int? drawId;
  String? drawName;
  String? drawDay;
  String? drawDateTime;
  String? drawFreezeTime;
  String? drawSaleStopTime;
  String? drawStatus;

  DrawRespVOs(
      {this.drawId,
        this.drawName,
        this.drawDay,
        this.drawDateTime,
        this.drawFreezeTime,
        this.drawSaleStopTime,
        this.drawStatus});

  DrawRespVOs.fromJson(Map<String, dynamic> json) {
    drawId = json['drawId'];
    drawName = json['drawName'];
    drawDay = json['drawDay'];
    drawDateTime = json['drawDateTime'];
    drawFreezeTime = json['drawFreezeTime'];
    drawSaleStopTime = json['drawSaleStopTime'];
    drawStatus = json['drawStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['drawId'] = this.drawId;
    data['drawName'] = this.drawName;
    data['drawDay'] = this.drawDay;
    data['drawDateTime'] = this.drawDateTime;
    data['drawFreezeTime'] = this.drawFreezeTime;
    data['drawSaleStopTime'] = this.drawSaleStopTime;
    data['drawStatus'] = this.drawStatus;
    return data;
  }
}

class DrawPrizeMultiplier {
  String? createEvent;
  String? applyOnBet;
  List<Multiplier>? multiplier;

  DrawPrizeMultiplier({this.createEvent, this.applyOnBet, this.multiplier});

  DrawPrizeMultiplier.fromJson(Map<String, dynamic> json) {
    createEvent = json['createEvent'];
    applyOnBet = json['applyOnBet'];
    if (json['multiplier'] != null) {
      multiplier = <Multiplier>[];
      json['multiplier'].forEach((v) {
        multiplier!.add(new Multiplier.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createEvent'] = this.createEvent;
    data['applyOnBet'] = this.applyOnBet;
    if (this.multiplier != null) {
      data['multiplier'] = this.multiplier!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Multiplier {
  String? name;
  int? odds;
  double? value;
  String? code;

  Multiplier({this.name, this.odds, this.value, this.code});

  Multiplier.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    odds = json['odds'];
    value = json['value'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['odds'] = this.odds;
    data['value'] = this.value;
    data['code'] = this.code;
    return data;
  }
}

class CurrencyRespVOs {
  String? currencyCode;
  double? value;

  CurrencyRespVOs({this.currencyCode, this.value});

  CurrencyRespVOs.fromJson(Map<String, dynamic> json) {
    currencyCode = json['currencyCode'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currencyCode'] = this.currencyCode;
    data['value'] = this.value;
    return data;
  }
}

class LastDrawWinningResultVOs {
  String? lastDrawDateTime;
  String? winningNumber;
  WinningMultiplierInfo? winningMultiplierInfo;
  List<RunTimeFlagInfo>? runTimeFlagInfo;
  List<SideBetMatchInfo>? sideBetMatchInfo;

  LastDrawWinningResultVOs(
      {this.lastDrawDateTime,
        this.winningNumber,
        this.winningMultiplierInfo,
        this.runTimeFlagInfo,
        this.sideBetMatchInfo});

  LastDrawWinningResultVOs.fromJson(Map<String, dynamic> json) {
    lastDrawDateTime = json['lastDrawDateTime'];
    winningNumber = json['winningNumber'];
    winningMultiplierInfo = json['winningMultiplierInfo'] != null
        ? new WinningMultiplierInfo.fromJson(json['winningMultiplierInfo'])
        : null;
    if (json['runTimeFlagInfo'] != null) {
      runTimeFlagInfo = <RunTimeFlagInfo>[];
      json['runTimeFlagInfo'].forEach((v) {
        runTimeFlagInfo!.add(new RunTimeFlagInfo.fromJson(v));
      });
    }
    if (json['sideBetMatchInfo'] != null) {
      sideBetMatchInfo = <SideBetMatchInfo>[];
      json['sideBetMatchInfo'].forEach((v) {
        sideBetMatchInfo!.add(new SideBetMatchInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastDrawDateTime'] = this.lastDrawDateTime;
    data['winningNumber'] = this.winningNumber;
    if (this.winningMultiplierInfo != null) {
      data['winningMultiplierInfo'] = this.winningMultiplierInfo!.toJson();
    }
    if (this.runTimeFlagInfo != null) {
      data['runTimeFlagInfo'] =
          this.runTimeFlagInfo!.map((v) => v.toJson()).toList();
    }
    if (this.sideBetMatchInfo != null) {
      data['sideBetMatchInfo'] =
          this.sideBetMatchInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WinningMultiplierInfo {
  String? multiplierCode;
  double? value;

  WinningMultiplierInfo({this.multiplierCode, this.value});

  WinningMultiplierInfo.fromJson(Map<String, dynamic> json) {
    multiplierCode = json['multiplierCode'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['multiplierCode'] = this.multiplierCode;
    data['value'] = this.value;
    return data;
  }
}

class RunTimeFlagInfo {
  String? betDisplayName1;

  RunTimeFlagInfo({this.betDisplayName1});

  RunTimeFlagInfo.fromJson(Map<String, dynamic> json) {
    betDisplayName1 = json['betDisplayName1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['betDisplayName1'] = this.betDisplayName1;
    return data;
  }
}

class SideBetMatchInfo {
  String? betDisplayName;
  String? betCode;
  String? result;
  int? rank;
  String? pickTypeName;
  String? pickTypeCode;

  SideBetMatchInfo(
      {this.betDisplayName,
        this.betCode,
        this.result,
        this.rank,
        this.pickTypeName,
        this.pickTypeCode});

  SideBetMatchInfo.fromJson(Map<String, dynamic> json) {
    betDisplayName = json['betDisplayName'];
    betCode = json['betCode'];
    result = json['result'];
    rank = json['rank'];
    pickTypeName = json['pickTypeName'];
    pickTypeCode = json['pickTypeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['betDisplayName'] = this.betDisplayName;
    data['betCode'] = this.betCode;
    data['result'] = this.result;
    data['rank'] = this.rank;
    data['pickTypeName'] = this.pickTypeName;
    data['pickTypeCode'] = this.pickTypeCode;
    return data;
  }
}

class GameSchemas {
  String? gameDevName;
  List<MatchDetail>? matchDetail;

  GameSchemas({this.gameDevName, this.matchDetail});

  GameSchemas.fromJson(Map<String, dynamic> json) {
    gameDevName = json['gameDevName'];
    if (json['matchDetail'] != null) {
      matchDetail = <MatchDetail>[];
      json['matchDetail'].forEach((v) {
        matchDetail!.add(new MatchDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameDevName'] = this.gameDevName;
    if (this.matchDetail != null) {
      data['matchDetail'] = this.matchDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MatchDetail {
  String? match;
  int? rank;
  String? type;
  String? prizeAmount;
  String? betType;

  MatchDetail(
      {this.match, this.rank, this.type, this.prizeAmount, this.betType});

  MatchDetail.fromJson(Map<String, dynamic> json) {
    match = json['match'];
    rank = json['rank'];
    type = json['type'];
    prizeAmount = json['prizeAmount'];
    betType = json['betType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['match'] = this.match;
    data['rank'] = this.rank;
    data['type'] = this.type;
    data['prizeAmount'] = this.prizeAmount;
    data['betType'] = this.betType;
    return data;
  }
}

class UnitCost {
  String? currency;
  double? price;

  UnitCost({this.currency, this.price});

  UnitCost.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency'] = this.currency;
    data['price'] = this.price;
    return data;
  }
}
