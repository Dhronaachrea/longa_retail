class ResultResponse {
  int? responseCode;
  String? responseMessage;
  List<ResponseData>? responseData;

  ResultResponse({this.responseCode, this.responseMessage, this.responseData});

  ResultResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    if (json['responseData'] != null) {
      responseData = <ResponseData>[];
      json['responseData'].forEach((v) {
        responseData!.add(new ResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    if (this.responseData != null) {
      data['responseData'] = this.responseData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseData {
  String? gameCode;
  String? gameName;
  int? lastDrawId;
  List<ResultData>? resultData;

  ResponseData(
      {this.gameCode, this.gameName, this.lastDrawId, this.resultData});

  ResponseData.fromJson(Map<String, dynamic> json) {
    gameCode = json['gameCode'];
    gameName = json['gameName'];
    lastDrawId = json['lastDrawId'];
    if (json['resultData'] != null) {
      resultData = <ResultData>[];
      json['resultData'].forEach((v) {
        resultData!.add(new ResultData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameCode'] = this.gameCode;
    data['gameName'] = this.gameName;
    data['lastDrawId'] = this.lastDrawId;
    if (this.resultData != null) {
      data['resultData'] = this.resultData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResultData {
  String? resultDate;
  List<ResultInfo>? resultInfo;

  ResultData({this.resultDate, this.resultInfo});

  ResultData.fromJson(Map<String, dynamic> json) {
    resultDate = json['resultDate'];
    if (json['resultInfo'] != null) {
      resultInfo = <ResultInfo>[];
      json['resultInfo'].forEach((v) {
        resultInfo!.add(new ResultInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resultDate'] = this.resultDate;
    if (this.resultInfo != null) {
      data['resultInfo'] = this.resultInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResultInfo {
  String? drawName;
  String? drawTime;
  int? drawId;
  String? winningNo;
  WinningMultiplierInfo? winningMultiplierInfo;
  dynamic runTimeFlagInfo;
  List<MatchInfo>? matchInfo;
  List<SideBetMatchInfo>? sideBetMatchInfo;

  ResultInfo(
      {this.drawName,
        this.drawTime,
        this.drawId,
        this.winningNo,
        this.winningMultiplierInfo,
        this.runTimeFlagInfo,
        this.matchInfo,
        this.sideBetMatchInfo});

  ResultInfo.fromJson(Map<String, dynamic> json) {
    drawName = json['drawName'];
    drawTime = json['drawTime'];
    drawId = json['drawId'];
    winningNo = json['winningNo'];
    winningMultiplierInfo = json['winningMultiplierInfo'] != null
        ? new WinningMultiplierInfo.fromJson(json['winningMultiplierInfo'])
        : null;
    runTimeFlagInfo = json['runTimeFlagInfo'];
    if (json['matchInfo'] != null) {
      matchInfo = <MatchInfo>[];
      json['matchInfo'].forEach((v) {
        matchInfo!.add(new MatchInfo.fromJson(v));
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
    data['drawName'] = this.drawName;
    data['drawTime'] = this.drawTime;
    data['drawId'] = this.drawId;
    data['winningNo'] = this.winningNo;
    if (this.winningMultiplierInfo != null) {
      data['winningMultiplierInfo'] = this.winningMultiplierInfo!.toJson();
    }
    data['runTimeFlagInfo'] = this.runTimeFlagInfo;
    if (this.matchInfo != null) {
      data['matchInfo'] = this.matchInfo!.map((v) => v.toJson()).toList();
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

class MatchInfo {
  String? match;
  String? noOfWinners;
  String? amount;
  int? prizeRank;
  String? mode;

  MatchInfo(
      {this.match, this.noOfWinners, this.amount, this.prizeRank, this.mode});

  MatchInfo.fromJson(Map<String, dynamic> json) {
    match = json['match'];
    noOfWinners = json['noOfWinners'];
    amount = json['amount'];
    prizeRank = json['prizeRank'];
    mode = json['mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['match'] = this.match;
    data['noOfWinners'] = this.noOfWinners;
    data['amount'] = this.amount;
    data['prizeRank'] = this.prizeRank;
    data['mode'] = this.mode;
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
