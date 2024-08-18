// // To parse this JSON data, do
// //
// //     final dgeGameResponse = dgeGameResponseFromJson(jsonString);
//
// import 'dart:convert';
//
// DgeGameResponse dgeGameResponseFromJson(String str) => DgeGameResponse.fromJson(json.decode(str));
//
// String dgeGameResponseToJson(DgeGameResponse data) => json.encode(data.toJson());
//
// class DgeGameResponse {
//   DgeGameResponse({
//     this.errorCode,
//     this.message,
//     this.data,
//   });
//
//   int? errorCode;
//   String? message;
//   Data? data;
//
//   factory DgeGameResponse.fromJson(Map<String, dynamic> json) => DgeGameResponse(
//     errorCode: json["errorCode"],
//     message: json["message"],
//     data: json["data"] == null ? null : Data.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "errorCode": errorCode,
//     "message": message,
//     "data": data?.toJson(),
//   };
// }
//
// class Data {
//   Data({
//     this.games,
//     this.currentTime,
//   });
//
//   Games? games;
//   CurrentTime? currentTime;
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     games: json["games"] == null ? null : Games.fromJson(json["games"]),
//     currentTime: json["currentTime"] == null ? null : CurrentTime.fromJson(json["currentTime"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "games": games?.toJson(),
//     "currentTime": currentTime?.toJson(),
//   };
// }
//
// class CurrentTime {
//   CurrentTime({
//     this.date,
//     this.timezoneType,
//     this.timezone,
//   });
//
//   DateTime? date;
//   int? timezoneType;
//   String? timezone;
//
//   factory CurrentTime.fromJson(Map<String, dynamic> json) => CurrentTime(
//     date: json["date"] == null ? null : DateTime.parse(json["date"]),
//     timezoneType: json["timezone_type"],
//     timezone: json["timezone"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "date": date?.toIso8601String(),
//     "timezone_type": timezoneType,
//     "timezone": timezone,
//   };
// }
//
// class Games {
//   Games({
//     this.twelvebytwentyfour,
//     this.powerball,
//     this.superkeno,
//     this.luckysix,
//     this.thailotteryhighfrequency,
//     this.fivebyninety,
//     this.baloto,
//     this.revencha,
//   });
//
//   Baloto? twelvebytwentyfour;
//   Baloto? powerball;
//   Baloto? superkeno;
//   Baloto? luckysix;
//   Baloto? thailotteryhighfrequency;
//   Baloto? fivebyninety;
//   Baloto? baloto;
//   Baloto? revencha;
//
//   factory Games.fromJson(Map<String, dynamic> json) => Games(
//     twelvebytwentyfour: json["TWELVEBYTWENTYFOUR"] == null ? null : Baloto.fromJson(json["TWELVEBYTWENTYFOUR"]),
//     powerball: json["POWERBALL"] == null ? null : Baloto.fromJson(json["POWERBALL"]),
//     superkeno: json["SUPERKENO"] == null ? null : Baloto.fromJson(json["SUPERKENO"]),
//     luckysix: json["LUCKYSIX"] == null ? null : Baloto.fromJson(json["LUCKYSIX"]),
//     thailotteryhighfrequency: json["THAILOTTERYHIGHFREQUENCY"] == null ? null : Baloto.fromJson(json["THAILOTTERYHIGHFREQUENCY"]),
//     fivebyninety: json["FIVEBYNINETY"] == null ? null : Baloto.fromJson(json["FIVEBYNINETY"]),
//     baloto: json["BALOTO"] == null ? null : Baloto.fromJson(json["BALOTO"]),
//     revencha: json["REVENCHA"] == null ? null : Baloto.fromJson(json["REVENCHA"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "TWELVEBYTWENTYFOUR": twelvebytwentyfour?.toJson(),
//     "POWERBALL": powerball?.toJson(),
//     "SUPERKENO": superkeno?.toJson(),
//     "LUCKYSIX": luckysix?.toJson(),
//     "THAILOTTERYHIGHFREQUENCY": thailotteryhighfrequency?.toJson(),
//     "FIVEBYNINETY": fivebyninety?.toJson(),
//     "BALOTO": baloto?.toJson(),
//     "REVENCHA": revencha?.toJson(),
//   };
// }
//
// class Baloto {
//   Baloto({
//     this.gameCode,
//     this.datetime,
//     this.estimatedJackpot,
//     this.guaranteedJackpot,
//     this.jackpotTitle,
//     this.jackpotAmount,
//     this.drawDate,
//     this.extra,
//     this.nextDrawDate,
//     this.active,
//   });
//
//   String? gameCode;
//   DateTime? datetime;
//   String? estimatedJackpot;
//   String? guaranteedJackpot;
//   String? jackpotTitle;
//   String? jackpotAmount;
//   DateTime? drawDate;
//   Extra? extra;
//   DateTime? nextDrawDate;
//   String? active;
//
//   factory Baloto.fromJson(Map<String, dynamic> json) => Baloto(
//     gameCode: json["game_code"],
//     datetime: json["datetime"] == null ? null : DateTime.parse(json["datetime"]),
//     estimatedJackpot: json["estimated_jackpot"],
//     guaranteedJackpot: json["guaranteed_jackpot"],
//     jackpotTitle: json["jackpot_title"],
//     jackpotAmount: json["jackpot_amount"],
//     drawDate: json["draw_date"] == null ? null : DateTime.parse(json["draw_date"]),
//     extra: json["extra"] == null ? null : Extra.fromJson(json["extra"]),
//     nextDrawDate: json["next_draw_date"] == null ? null : DateTime.parse(json["next_draw_date"]),
//     active: json["active"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "game_code": gameCode,
//     "datetime": datetime?.toIso8601String(),
//     "estimated_jackpot": estimatedJackpot,
//     "guaranteed_jackpot": guaranteedJackpot,
//     "jackpot_title": jackpotTitle,
//     "jackpot_amount": jackpotAmount,
//     "draw_date": drawDate?.toIso8601String(),
//     "extra": extra?.toJson(),
//     "next_draw_date": nextDrawDate?.toIso8601String(),
//     "active": active,
//   };
// }
//
// class Extra {
//   Extra({
//     this.currentDrawNumber,
//     this.currentDrawFreezeDate,
//     this.currentDrawStopTime,
//     this.jackpotAmount,
//     this.unitCostJson,
//   });
//
//   int? currentDrawNumber;
//   DateTime? currentDrawFreezeDate;
//   DateTime? currentDrawStopTime;
//   double? jackpotAmount;
//   List<UnitCostJson>? unitCostJson;
//
//   factory Extra.fromJson(Map<String, dynamic> json) => Extra(
//     currentDrawNumber: json["currentDrawNumber"],
//     currentDrawFreezeDate: json["currentDrawFreezeDate"] == null ? null : DateTime.parse(json["currentDrawFreezeDate"]),
//     currentDrawStopTime: json["currentDrawStopTime"] == null ? null : DateTime.parse(json["currentDrawStopTime"]),
//     jackpotAmount: json["jackpotAmount"]?.toDouble(),
//     unitCostJson: json["unitCostJson"] == null ? [] : List<UnitCostJson>.from(json["unitCostJson"]!.map((x) => UnitCostJson.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "currentDrawNumber": currentDrawNumber,
//     "currentDrawFreezeDate": currentDrawFreezeDate?.toIso8601String(),
//     "currentDrawStopTime": currentDrawStopTime?.toIso8601String(),
//     "jackpotAmount": jackpotAmount,
//     "unitCostJson": unitCostJson == null ? [] : List<dynamic>.from(unitCostJson!.map((x) => x.toJson())),
//   };
// }
//
// class UnitCostJson {
//   UnitCostJson({
//     this.currency,
//     this.price,
//   });
//
//   String? currency;
//   int? price;
//
//   factory UnitCostJson.fromJson(Map<String, dynamic> json) => UnitCostJson(
//     currency: json["currency"],
//     price: json["price"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "currency": currency,
//     "price": price,
//   };
// }
// To parse this JSON data, do
//
//     final dgeGameResponse = dgeGameResponseFromJson(jsonString);
// To parse this JSON data, do
//
//     final dgeGameResponse = dgeGameResponseFromJson(jsonString);

// To parse this JSON data, do
//
//     final dgeGameResponse = dgeGameResponseFromJson(jsonString);
/*import 'dart:convert';

DgeGameResponse dgeGameResponseFromJson(String str) =>
    DgeGameResponse.fromJson(json.decode(str));

String dgeGameResponseToJson(DgeGameResponse data) =>
    json.encode(data.toJson());

class DgeGameResponse {
  DgeGameResponse({
    this.responseCode,
    this.responseMessage,
    this.responseData,
  });

  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  factory DgeGameResponse.fromJson(Map<String, dynamic> json) =>
      DgeGameResponse(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        responseData: json["responseData"] == null
            ? null
            : ResponseData.fromJson(json["responseData"]),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "responseData": responseData?.toJson(),
      };
}

class ResponseData {
  ResponseData({
    this.gameRespVOs,
    this.currentDate,
  });

  List<GameRespVo>? gameRespVOs;
  DateTime? currentDate;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        gameRespVOs: json["gameRespVOs"] == null
            ? []
            : List<GameRespVo>.from(
                json["gameRespVOs"]!.map((x) => GameRespVo.fromJson(x))),
        currentDate: json["currentDate"] == null
            ? null
            : DateTime.parse(json["currentDate"]),
      );

  Map<String, dynamic> toJson() => {
        "gameRespVOs": gameRespVOs == null
            ? []
            : List<dynamic>.from(gameRespVOs!.map((x) => x.toJson())),
        "currentDate": currentDate?.toIso8601String(),
      };
}

class GameRespVo {
  GameRespVo({
    this.id,
    this.gameNumber,
    this.gameName,
    this.gameCode,
    this.betLimitEnabled,
    this.familyCode,
    this.lastDrawResult,
    this.displayOrder,
    this.drawFrequencyType,
    this.timeToFetchUpdatedGameInfo,
    this.betRespVOs,
    this.drawRespVOs,
    this.additionalDrawRespVOs,
    this.drawEvent,
    this.gameStatus,
    this.gameOrder,
    this.consecutiveDraw,
    this.maxAdvanceDraws,
    this.lastDrawFreezeTime,
    this.lastDrawDateTime,
    this.lastDrawSaleStopTime,
    this.lastDrawTime,
    this.ticketExpiry,
    this.lastDrawWinningResultVOs,
    this.maxPanelAllowed,
    this.resultConfigData,
    this.jackpotAmount,
    this.unitCost,
  });

  int? id;
  int? gameNumber;
  String? gameName;
  String? gameCode;
  String? betLimitEnabled;
  String? familyCode;
  String? lastDrawResult;
  String? displayOrder;
  String? drawFrequencyType;
  String? timeToFetchUpdatedGameInfo;
  List<BetRespVo>? betRespVOs;
  List<dynamic>? drawRespVOs;
  List<dynamic>? additionalDrawRespVOs;
  String? drawEvent;
  String? gameStatus;
  String? gameOrder;
  String? consecutiveDraw;
  int? maxAdvanceDraws;
  String? lastDrawFreezeTime;
  String? lastDrawDateTime;
  String? lastDrawSaleStopTime;
  String? lastDrawTime;
  int? ticketExpiry;
  List<dynamic>? lastDrawWinningResultVOs;
  int? maxPanelAllowed;
  ResultConfigData? resultConfigData;
  double? jackpotAmount;
  List<UnitCost>? unitCost;

  factory GameRespVo.fromJson(Map<String, dynamic> json) => GameRespVo(
        id: json["id"],
        gameNumber: json["gameNumber"],
        gameName: json["gameName"],
        gameCode: json["gameCode"],
        betLimitEnabled: json["betLimitEnabled"],
        familyCode: json["familyCode"],
        lastDrawResult: json["lastDrawResult"],
        displayOrder: json["displayOrder"],
        drawFrequencyType: json["drawFrequencyType"],
        timeToFetchUpdatedGameInfo: json["timeToFetchUpdatedGameInfo"],
        betRespVOs: json["betRespVOs"] == null
            ? []
            : List<BetRespVo>.from(
                json["betRespVOs"]!.map((x) => BetRespVo.fromJson(x))),
        drawRespVOs: json["drawRespVOs"] == null
            ? []
            : List<dynamic>.from(json["drawRespVOs"]!.map((x) => x)),
        additionalDrawRespVOs: json["additionalDrawRespVOs"] == null
            ? []
            : List<dynamic>.from(json["additionalDrawRespVOs"]!.map((x) => x)),
        drawEvent: json["drawEvent"],
        gameStatus: json["gameStatus"],
        gameOrder: json["gameOrder"],
        consecutiveDraw: json["consecutiveDraw"],
        maxAdvanceDraws: json["maxAdvanceDraws"],
        lastDrawFreezeTime: json["lastDrawFreezeTime"],
        lastDrawDateTime: json["lastDrawDateTime"],
        lastDrawSaleStopTime: json["lastDrawSaleStopTime"],
        lastDrawTime: json["lastDrawTime"],
        ticketExpiry: json["ticket_expiry"],
        lastDrawWinningResultVOs: json["lastDrawWinningResultVOs"] == null
            ? []
            : List<dynamic>.from(
                json["lastDrawWinningResultVOs"]!.map((x) => x)),
        maxPanelAllowed: json["maxPanelAllowed"],
        resultConfigData: json["resultConfigData"] == null
            ? null
            : ResultConfigData.fromJson(json["resultConfigData"]),
        jackpotAmount: json["jackpotAmount"],
        unitCost: json["unitCost"] == null
            ? []
            : List<UnitCost>.from(
                json["unitCost"]!.map((x) => UnitCost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gameNumber": gameNumber,
        "gameName": gameName,
        "gameCode": gameCode,
        "betLimitEnabled": betLimitEnabled,
        "familyCode": familyCode,
        "lastDrawResult": lastDrawResult,
        "displayOrder": displayOrder,
        "drawFrequencyType": drawFrequencyType,
        "timeToFetchUpdatedGameInfo": timeToFetchUpdatedGameInfo,
        "betRespVOs": betRespVOs == null
            ? []
            : List<dynamic>.from(betRespVOs!.map((x) => x.toJson())),
        "drawRespVOs": drawRespVOs == null
            ? []
            : List<dynamic>.from(drawRespVOs!.map((x) => x)),
        "additionalDrawRespVOs": additionalDrawRespVOs == null
            ? []
            : List<dynamic>.from(additionalDrawRespVOs!.map((x) => x)),
        "drawEvent": drawEvent,
        "gameStatus": gameStatus,
        "gameOrder": gameOrder,
        "consecutiveDraw": consecutiveDraw,
        "maxAdvanceDraws": maxAdvanceDraws,
        "lastDrawFreezeTime": lastDrawFreezeTime,
        "lastDrawDateTime": lastDrawDateTime,
        "lastDrawSaleStopTime": lastDrawSaleStopTime,
        "lastDrawTime": lastDrawTime,
        "ticket_expiry": ticketExpiry,
        "lastDrawWinningResultVOs": lastDrawWinningResultVOs == null
            ? []
            : List<dynamic>.from(lastDrawWinningResultVOs!.map((x) => x)),
        "maxPanelAllowed": maxPanelAllowed,
        "resultConfigData": resultConfigData?.toJson(),
        "jackpotAmount": jackpotAmount,
        "unitCost": unitCost == null
            ? []
            : List<dynamic>.from(unitCost!.map((x) => x.toJson())),
      };
}

class BetRespVo {
  BetRespVo({
    this.unitPrice,
    this.maxBetAmtMul,
    this.betDispName,
    this.betCode,
    this.betName,
    this.betGroup,
    this.pickTypeData,
    this.inputCount,
    this.winMode,
    this.betOrder,
  });

  double? unitPrice;
  int? maxBetAmtMul;
  String? betDispName;
  String? betCode;
  String? betName;
  dynamic betGroup;
  PickTypeData? pickTypeData;
  String? inputCount;
  String? winMode;
  int? betOrder;

  factory BetRespVo.fromJson(Map<String, dynamic> json) => BetRespVo(
        unitPrice: json["unitPrice"],
        maxBetAmtMul: json["maxBetAmtMul"],
        betDispName: json["betDispName"],
        betCode: json["betCode"],
        betName: json["betName"],
        betGroup: json["betGroup"],
        pickTypeData: json["pickTypeData"] == null
            ? null
            : PickTypeData.fromJson(json["pickTypeData"]),
        inputCount: json["inputCount"],
        winMode: json["winMode"],
        betOrder: json["betOrder"],
      );

  Map<String, dynamic> toJson() => {
        "unitPrice": unitPrice,
        "maxBetAmtMul": maxBetAmtMul,
        "betDispName": betDispName,
        "betCode": betCode,
        "betName": betName,
        "betGroup": betGroup,
        "pickTypeData": pickTypeData?.toJson(),
        "inputCount": inputCount,
        "winMode": winMode,
        "betOrder": betOrder,
      };
}

class PickTypeData {
  PickTypeData({
    this.pickType,
  });

  List<PickType>? pickType;

  factory PickTypeData.fromJson(Map<String, dynamic> json) => PickTypeData(
        pickType: json["pickType"] == null
            ? []
            : List<PickType>.from(
                json["pickType"]!.map((x) => PickType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pickType": pickType == null
            ? []
            : List<dynamic>.from(pickType!.map((x) => x.toJson())),
      };
}

class PickType {
  PickType({
    this.name,
    this.code,
    this.range,
    this.coordinate,
    this.description,
  });

  String? name;
  String? code;
  List<Range>? range;
  dynamic coordinate;
  String? description;

  factory PickType.fromJson(Map<String, dynamic> json) => PickType(
        name: json["name"],
        code: json["code"],
        range: json["range"] == null
            ? []
            : List<Range>.from(json["range"]!.map((x) => Range.fromJson(x))),
        coordinate: json["coordinate"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "range": range == null
            ? []
            : List<dynamic>.from(range!.map((x) => x.toJson())),
        "coordinate": coordinate,
        "description": description,
      };
}

class Range {
  Range({
    this.pickMode,
    this.pickCount,
    this.pickValue,
    this.pickConfig,
    this.qpAllowed,
  });

  String? pickMode;
  String? pickCount;
  String? pickValue;
  String? pickConfig;
  String? qpAllowed;

  factory Range.fromJson(Map<String, dynamic> json) => Range(
        pickMode: json["pickMode"],
        pickCount: json["pickCount"],
        pickValue: json["pickValue"],
        pickConfig: json["pickConfig"],
        qpAllowed: json["qpAllowed"],
      );

  Map<String, dynamic> toJson() => {
        "pickMode": pickMode,
        "pickCount": pickCount,
        "pickValue": pickValue,
        "pickConfig": pickConfig,
        "qpAllowed": qpAllowed,
      };
}

class ResultConfigData {
  ResultConfigData({
    this.type,
    this.balls,
    this.ballsPerCall,
    this.interval,
    this.duplicateAllowed,
  });

  String? type;
  String? balls;
  int? ballsPerCall;
  int? interval;
  bool? duplicateAllowed;

  factory ResultConfigData.fromJson(Map<String, dynamic> json) =>
      ResultConfigData(
        type: json["type"],
        balls: json["balls"],
        ballsPerCall: json["ballsPerCall"],
        interval: json["interval"],
        duplicateAllowed: json["duplicateAllowed"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "balls": balls,
        "ballsPerCall": ballsPerCall,
        "interval": interval,
        "duplicateAllowed": duplicateAllowed,
      };
}

class UnitCost {
  UnitCost({
    this.currency,
    this.price,
  });

  String? currency;
  double? price;

  factory UnitCost.fromJson(Map<String, dynamic> json) => UnitCost(
        currency: json["currency"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "price": price,
      };
}
 */

// To parse this JSON data, do
//
//     final dgeGameResponse = dgeGameResponseFromJson(jsonString);

import 'dart:convert';

DgeGameResponse dgeGameResponseFromJson(String str) =>
    DgeGameResponse.fromJson(json.decode(str));

String dgeGameResponseToJson(DgeGameResponse data) =>
    json.encode(data.toJson());

class DgeGameResponse {
  DgeGameResponse({
    this.responseCode,
    this.responseMessage,
    this.responseData,
  });

  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  factory DgeGameResponse.fromJson(Map<String, dynamic> json) =>
      DgeGameResponse(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        responseData: json["responseData"] == null
            ? null
            : ResponseData.fromJson(json["responseData"]),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "responseData": responseData?.toJson(),
      };
}

class ResponseData {
  ResponseData({
    this.gameRespVOs,
    this.currentDate,
  });

  List<GameRespVo>? gameRespVOs;
  DateTime? currentDate;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        gameRespVOs: json["gameRespVOs"] == null
            ? []
            : List<GameRespVo>.from(
                json["gameRespVOs"]!.map((x) => GameRespVo.fromJson(x))),
        currentDate: json["currentDate"] == null
            ? null
            : DateTime.parse(json["currentDate"]),
      );

  Map<String, dynamic> toJson() => {
        "gameRespVOs": gameRespVOs == null
            ? []
            : List<dynamic>.from(gameRespVOs!.map((x) => x.toJson())),
        "currentDate": currentDate?.toIso8601String(),
      };
}

class GameRespVo {
  GameRespVo({
    this.id,
    this.gameNumber,
    this.gameName,
    this.gameCode,
    this.betLimitEnabled,
    this.familyCode,
    this.lastDrawResult,
    this.displayOrder,
    this.drawFrequencyType,
    this.timeToFetchUpdatedGameInfo,
    this.betRespVOs,
    this.drawRespVOs,
    this.additionalDrawRespVOs,
    this.drawEvent,
    this.gameStatus,
    this.gameOrder,
    this.consecutiveDraw,
    this.maxAdvanceDraws,
    this.lastDrawFreezeTime,
    this.lastDrawDateTime,
    this.lastDrawSaleStopTime,
    this.lastDrawTime,
    this.ticketExpiry,
    this.lastDrawWinningResultVOs,
    this.maxPanelAllowed,
    this.resultConfigData,
    this.jackpotAmount,
    this.unitCost,
  });

  int? id;
  int? gameNumber;
  String? gameName;
  String? gameCode;
  String? betLimitEnabled;
  String? familyCode;
  String? lastDrawResult;
  String? displayOrder;
  String? drawFrequencyType;
  String? timeToFetchUpdatedGameInfo;
  List<BetRespVo>? betRespVOs;
  List<dynamic>? drawRespVOs;
  List<dynamic>? additionalDrawRespVOs;
  String? drawEvent;
  String? gameStatus;
  String? gameOrder;
  String? consecutiveDraw;
  int? maxAdvanceDraws;
  String? lastDrawFreezeTime;
  String? lastDrawDateTime;
  String? lastDrawSaleStopTime;
  String? lastDrawTime;
  int? ticketExpiry;
  List<dynamic>? lastDrawWinningResultVOs;
  int? maxPanelAllowed;
  ResultConfigData? resultConfigData;
  double? jackpotAmount;
  List<UnitCost>? unitCost;

  factory GameRespVo.fromJson(Map<String, dynamic> json) => GameRespVo(
        id: json["id"],
        gameNumber: json["gameNumber"],
        gameName: json["gameName"],
        gameCode: json["gameCode"],
        betLimitEnabled: json["betLimitEnabled"],
        familyCode: json["familyCode"],
        lastDrawResult: json["lastDrawResult"],
        displayOrder: json["displayOrder"],
        drawFrequencyType: json["drawFrequencyType"],
        timeToFetchUpdatedGameInfo: json["timeToFetchUpdatedGameInfo"],
        betRespVOs: json["betRespVOs"] == null
            ? []
            : List<BetRespVo>.from(
                json["betRespVOs"]!.map((x) => BetRespVo.fromJson(x))),
        drawRespVOs: json["drawRespVOs"] == null
            ? []
            : List<dynamic>.from(json["drawRespVOs"]!.map((x) => x)),
        additionalDrawRespVOs: json["additionalDrawRespVOs"] == null
            ? []
            : List<dynamic>.from(json["additionalDrawRespVOs"]!.map((x) => x)),
        drawEvent: json["drawEvent"],
        gameStatus: json["gameStatus"],
        gameOrder: json["gameOrder"],
        consecutiveDraw: json["consecutiveDraw"],
        maxAdvanceDraws: json["maxAdvanceDraws"],
        lastDrawFreezeTime: json["lastDrawFreezeTime"],
        lastDrawDateTime: json["lastDrawDateTime"],
        lastDrawSaleStopTime: json["lastDrawSaleStopTime"],
        lastDrawTime: json["lastDrawTime"],
        ticketExpiry: json["ticket_expiry"],
        lastDrawWinningResultVOs: json["lastDrawWinningResultVOs"] == null
            ? []
            : List<dynamic>.from(
                json["lastDrawWinningResultVOs"]!.map((x) => x)),
        maxPanelAllowed: json["maxPanelAllowed"],
        resultConfigData: json["resultConfigData"] == null
            ? null
            : ResultConfigData.fromJson(json["resultConfigData"]),
        jackpotAmount: json["jackpotAmount"],
        unitCost: json["unitCost"] == null
            ? []
            : List<UnitCost>.from(
                json["unitCost"]!.map((x) => UnitCost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gameNumber": gameNumber,
        "gameName": gameName,
        "gameCode": gameCode,
        "betLimitEnabled": betLimitEnabled,
        "familyCode": familyCode,
        "lastDrawResult": lastDrawResult,
        "displayOrder": displayOrder,
        "drawFrequencyType": drawFrequencyType,
        "timeToFetchUpdatedGameInfo": timeToFetchUpdatedGameInfo,
        "betRespVOs": betRespVOs == null
            ? []
            : List<dynamic>.from(betRespVOs!.map((x) => x.toJson())),
        "drawRespVOs": drawRespVOs == null
            ? []
            : List<dynamic>.from(drawRespVOs!.map((x) => x)),
        "additionalDrawRespVOs": additionalDrawRespVOs == null
            ? []
            : List<dynamic>.from(additionalDrawRespVOs!.map((x) => x)),
        "drawEvent": drawEvent,
        "gameStatus": gameStatus,
        "gameOrder": gameOrder,
        "consecutiveDraw": consecutiveDraw,
        "maxAdvanceDraws": maxAdvanceDraws,
        "lastDrawFreezeTime": lastDrawFreezeTime,
        "lastDrawDateTime": lastDrawDateTime,
        "lastDrawSaleStopTime": lastDrawSaleStopTime,
        "lastDrawTime": lastDrawTime,
        "ticket_expiry": ticketExpiry,
        "lastDrawWinningResultVOs": lastDrawWinningResultVOs == null
            ? []
            : List<dynamic>.from(lastDrawWinningResultVOs!.map((x) => x)),
        "maxPanelAllowed": maxPanelAllowed,
        "resultConfigData": resultConfigData?.toJson(),
        "jackpotAmount": jackpotAmount,
        "unitCost": unitCost == null
            ? []
            : List<dynamic>.from(unitCost!.map((x) => x.toJson())),
      };
}

class BetRespVo {
  BetRespVo({
    this.unitPrice,
    this.maxBetAmtMul,
    this.betDispName,
    this.betCode,
    this.betName,
    this.betGroup,
    this.pickTypeData,
    this.inputCount,
    this.winMode,
    this.betOrder,
  });

  double? unitPrice;
  int? maxBetAmtMul;
  String? betDispName;
  String? betCode;
  String? betName;
  dynamic betGroup;
  PickTypeData? pickTypeData;
  String? inputCount;
  String? winMode;
  int? betOrder;

  factory BetRespVo.fromJson(Map<String, dynamic> json) => BetRespVo(
        unitPrice: json["unitPrice"],
        maxBetAmtMul: json["maxBetAmtMul"],
        betDispName: json["betDispName"],
        betCode: json["betCode"],
        betName: json["betName"],
        betGroup: json["betGroup"],
        pickTypeData: json["pickTypeData"] == null
            ? null
            : PickTypeData.fromJson(json["pickTypeData"]),
        inputCount: json["inputCount"],
        winMode: json["winMode"],
        betOrder: json["betOrder"],
      );

  Map<String, dynamic> toJson() => {
        "unitPrice": unitPrice,
        "maxBetAmtMul": maxBetAmtMul,
        "betDispName": betDispName,
        "betCode": betCode,
        "betName": betName,
        "betGroup": betGroup,
        "pickTypeData": pickTypeData?.toJson(),
        "inputCount": inputCount,
        "winMode": winMode,
        "betOrder": betOrder,
      };
}

class PickTypeData {
  PickTypeData({
    this.pickType,
  });

  List<PickType>? pickType;

  factory PickTypeData.fromJson(Map<String, dynamic> json) => PickTypeData(
        pickType: json["pickType"] == null
            ? []
            : List<PickType>.from(
                json["pickType"]!.map((x) => PickType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pickType": pickType == null
            ? []
            : List<dynamic>.from(pickType!.map((x) => x.toJson())),
      };
}

class PickType {
  PickType({
    this.name,
    this.code,
    this.range,
    this.coordinate,
    this.description,
  });

  String? name;
  String? code;
  List<Range>? range;
  dynamic coordinate;
  String? description;

  factory PickType.fromJson(Map<String, dynamic> json) => PickType(
        name: json["name"],
        code: json["code"],
        range: json["range"] == null
            ? []
            : List<Range>.from(json["range"]!.map((x) => Range.fromJson(x))),
        coordinate: json["coordinate"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "range": range == null
            ? []
            : List<dynamic>.from(range!.map((x) => x.toJson())),
        "coordinate": coordinate,
        "description": description,
      };
}

class Range {
  Range({
    this.pickMode,
    this.pickCount,
    this.pickValue,
    this.pickConfig,
    this.qpAllowed,
  });

  String? pickMode;
  String? pickCount;
  String? pickValue;
  String? pickConfig;
  String? qpAllowed;

  factory Range.fromJson(Map<String, dynamic> json) => Range(
        pickMode: json["pickMode"],
        pickCount: json["pickCount"],
        pickValue: json["pickValue"],
        pickConfig: json["pickConfig"],
        qpAllowed: json["qpAllowed"],
      );

  Map<String, dynamic> toJson() => {
        "pickMode": pickMode,
        "pickCount": pickCount,
        "pickValue": pickValue,
        "pickConfig": pickConfig,
        "qpAllowed": qpAllowed,
      };
}

class ResultConfigData {
  ResultConfigData({
    this.type,
    this.balls,
    this.ballsPerCall,
    this.interval,
    this.duplicateAllowed,
  });

  String? type;
  String? balls;
  int? ballsPerCall;
  int? interval;
  bool? duplicateAllowed;

  factory ResultConfigData.fromJson(Map<String, dynamic> json) =>
      ResultConfigData(
        type: json["type"],
        balls: json["balls"],
        ballsPerCall: json["ballsPerCall"],
        interval: json["interval"],
        duplicateAllowed: json["duplicateAllowed"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "balls": balls,
        "ballsPerCall": ballsPerCall,
        "interval": interval,
        "duplicateAllowed": duplicateAllowed,
      };
}

class UnitCost {
  UnitCost({
    this.currency,
    this.price,
  });

  String? currency;
  double? price;

  factory UnitCost.fromJson(Map<String, dynamic> json) => UnitCost(
        currency: json["currency"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "price": price,
      };
}
