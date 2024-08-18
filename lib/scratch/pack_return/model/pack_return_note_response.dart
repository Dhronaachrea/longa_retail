class PackReturnNoteResponse {
  int? responseCode;
  String? responseMessage;
  int? dlChallanId;
  String? dlChallanNumber;
  String? dateTime;
  List<Games>? games;

  PackReturnNoteResponse(
      {this.responseCode,
        this.responseMessage,
        this.dlChallanId,
        this.dlChallanNumber,
        this.dateTime,
        this.games});

  PackReturnNoteResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    dlChallanId = json['dlChallanId'];
    dlChallanNumber = json['dlChallanNumber'];
    dateTime = json['dateTime'];
    if (json['games'] != null) {
      games = <Games>[];
      json['games'].forEach((v) {
        games!.add(new Games.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    data['dlChallanId'] = this.dlChallanId;
    data['dlChallanNumber'] = this.dlChallanNumber;
    data['dateTime'] = this.dateTime;
    if (this.games != null) {
      data['games'] = this.games!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Games {
  int? gameId;
  int? gameNumber;
  int? booksQuantity;
  String? gameName;
  int? ticketsQuantity;
  int? ticketsPerBooks;

  Games(
      {this.gameId,
        this.gameNumber,
        this.booksQuantity,
        this.gameName,
        this.ticketsQuantity,
        this.ticketsPerBooks});

  Games.fromJson(Map<String, dynamic> json) {
    gameId = json['gameId'];
    gameNumber = json['gameNumber'];
    booksQuantity = json['booksQuantity'];
    gameName = json['gameName'];
    ticketsQuantity = json['ticketsQuantity'];
    ticketsPerBooks = json['ticketsPerBooks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameId'] = this.gameId;
    data['gameNumber'] = this.gameNumber;
    data['booksQuantity'] = this.booksQuantity;
    data['gameName'] = this.gameName;
    data['ticketsQuantity'] = this.ticketsQuantity;
    data['ticketsPerBooks'] = this.ticketsPerBooks;
    return data;
  }
}