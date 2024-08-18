class InvRepResponse {
  int? responseCode;
  String? responseMessage;
  String? orgName;
  List<GameWiseBookDetailList>? gameWiseBookDetailList;

  InvRepResponse(
      {this.responseCode,
        this.responseMessage,
        this.orgName,
        this.gameWiseBookDetailList});

  InvRepResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    orgName = json['orgName'];
    if (json['gameWiseBookDetailList'] != null) {
      gameWiseBookDetailList = <GameWiseBookDetailList>[];
      json['gameWiseBookDetailList'].forEach((v) {
        gameWiseBookDetailList!.add(new GameWiseBookDetailList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    data['orgName'] = this.orgName;
    if (this.gameWiseBookDetailList != null) {
      data['gameWiseBookDetailList'] =
          this.gameWiseBookDetailList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GameWiseBookDetailList {
  int? gameId;
  String? gameName;
  int? gameNumber;
  List<String>? inTransitPacksList;
  List<String>? receivedPacksList;
  List<String>? activatedPacksList;
  List<String>? invoicedPacksList;

  GameWiseBookDetailList(
      {this.gameId,
        this.gameName,
        this.gameNumber,
        this.inTransitPacksList,
        this.receivedPacksList,
        this.activatedPacksList,
        this.invoicedPacksList});

  GameWiseBookDetailList.fromJson(Map<String, dynamic> json) {
    gameId = json['gameId'];
    gameName = json['gameName'];
    gameNumber = json['gameNumber'];
    inTransitPacksList = json['inTransitPacksList']?.cast<String>();
    receivedPacksList = json['receivedPacksList']?.cast<String>();
    activatedPacksList = json['activatedPacksList']?.cast<String>();
    invoicedPacksList = json['invoicedPacksList']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameId'] = this.gameId;
    data['gameName'] = this.gameName;
    data['gameNumber'] = this.gameNumber;
    data['inTransitPacksList'] = this.inTransitPacksList;
    data['receivedPacksList'] = this.receivedPacksList;
    data['activatedPacksList'] = this.activatedPacksList;
    data['invoicedPacksList'] = this.invoicedPacksList;
    return data;
  }
}