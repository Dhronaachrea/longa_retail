class InvFlowResponse {
  int? booksClosingBalance;
  int? booksOpeningBalance;
  List<GameWiseClosingBalanceData>? gameWiseClosingBalanceData;
  List<GameWiseData>? gameWiseData;
  List<GameWiseClosingBalanceData>? gameWiseOpeningBalanceData;
  int? receivedBooks;
  int? receivedTickets;
  int? responseCode;
  String? responseMessage;
  int? returnedBooks;
  int? returnedTickets;
  int? soldBooks;
  int? soldTickets;
  int? ticketsClosingBalance;
  int? ticketsOpeningBalance;

  InvFlowResponse(
      {this.booksClosingBalance,
      this.booksOpeningBalance,
      this.gameWiseClosingBalanceData,
      this.gameWiseData,
      this.gameWiseOpeningBalanceData,
      this.receivedBooks,
      this.receivedTickets,
      this.responseCode,
      this.responseMessage,
      this.returnedBooks,
      this.returnedTickets,
      this.soldBooks,
      this.soldTickets,
      this.ticketsClosingBalance,
      this.ticketsOpeningBalance});

  InvFlowResponse.fromJson(Map<String, dynamic> json) {
    booksClosingBalance = json['booksClosingBalance'];
    booksOpeningBalance = json['booksOpeningBalance'];
    if (json['gameWiseClosingBalanceData'] != null) {
      gameWiseClosingBalanceData = <GameWiseClosingBalanceData>[];
      json['gameWiseClosingBalanceData'].forEach((v) {
        gameWiseClosingBalanceData!
            .add(new GameWiseClosingBalanceData.fromJson(v));
      });
    }
    if (json['gameWiseData'] != null) {
      gameWiseData = <GameWiseData>[];
      json['gameWiseData'].forEach((v) {
        gameWiseData!.add(new GameWiseData.fromJson(v));
      });
    }
    if (json['gameWiseOpeningBalanceData'] != null) {
      gameWiseOpeningBalanceData = <GameWiseClosingBalanceData>[];
      json['gameWiseOpeningBalanceData'].forEach((v) {
        gameWiseOpeningBalanceData!
            .add(new GameWiseClosingBalanceData.fromJson(v));
      });
    }
    receivedBooks = json['receivedBooks'];
    receivedTickets = json['receivedTickets'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    returnedBooks = json['returnedBooks'];
    returnedTickets = json['returnedTickets'];
    soldBooks = json['soldBooks'];
    soldTickets = json['soldTickets'];
    ticketsClosingBalance = json['ticketsClosingBalance'];
    ticketsOpeningBalance = json['ticketsOpeningBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booksClosingBalance'] = this.booksClosingBalance;
    data['booksOpeningBalance'] = this.booksOpeningBalance;
    if (this.gameWiseClosingBalanceData != null) {
      data['gameWiseClosingBalanceData'] =
          this.gameWiseClosingBalanceData!.map((v) => v.toJson()).toList();
    }
    if (this.gameWiseData != null) {
      data['gameWiseData'] = this.gameWiseData!.map((v) => v.toJson()).toList();
    }
    if (this.gameWiseOpeningBalanceData != null) {
      data['gameWiseOpeningBalanceData'] =
          this.gameWiseOpeningBalanceData!.map((v) => v.toJson()).toList();
    }
    data['receivedBooks'] = this.receivedBooks;
    data['receivedTickets'] = this.receivedTickets;
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    data['returnedBooks'] = this.returnedBooks;
    data['returnedTickets'] = this.returnedTickets;
    data['soldBooks'] = this.soldBooks;
    data['soldTickets'] = this.soldTickets;
    data['ticketsClosingBalance'] = this.ticketsClosingBalance;
    data['ticketsOpeningBalance'] = this.ticketsOpeningBalance;
    return data;
  }
}

class GameWiseClosingBalanceData {
  int? gameId;
  String? gameName;
  int? gameNumber;
  int? totalBooks;
  int? totalTickets;

  GameWiseClosingBalanceData(
      {this.gameId,
      this.gameName,
      this.gameNumber,
      this.totalBooks,
      this.totalTickets});

  GameWiseClosingBalanceData.fromJson(Map<String, dynamic> json) {
    gameId = json['gameId'];
    gameName = json['gameName'];
    gameNumber = json['gameNumber'];
    totalBooks = json['totalBooks'];
    totalTickets = json['totalTickets'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameId'] = this.gameId;
    data['gameName'] = this.gameName;
    data['gameNumber'] = this.gameNumber;
    data['totalBooks'] = this.totalBooks;
    data['totalTickets'] = this.totalTickets;
    return data;
  }
}

class GameWiseData {
  int? gameId;
  String? gameName;
  int? gameNumber;
  int? missingBooks;
  int? missingTickets;
  int? receivedBooks;
  int? receivedTickets;
  int? returnedBooks;
  int? returnedTickets;
  int? soldBooks;
  int? soldTickets;

  GameWiseData(
      {this.gameId,
      this.gameName,
      this.gameNumber,
      this.missingBooks,
      this.missingTickets,
      this.receivedBooks,
      this.receivedTickets,
      this.returnedBooks,
      this.returnedTickets,
      this.soldBooks,
      this.soldTickets});

  GameWiseData.fromJson(Map<String, dynamic> json) {
    gameId = json['gameId'];
    gameName = json['gameName'];
    gameNumber = json['gameNumber'];
    missingBooks = json['missingBooks'];
    missingTickets = json['missingTickets'];
    receivedBooks = json['receivedBooks'];
    receivedTickets = json['receivedTickets'];
    returnedBooks = json['returnedBooks'];
    returnedTickets = json['returnedTickets'];
    soldBooks = json['soldBooks'];
    soldTickets = json['soldTickets'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameId'] = this.gameId;
    data['gameName'] = this.gameName;
    data['gameNumber'] = this.gameNumber;
    data['missingBooks'] = this.missingBooks;
    data['missingTickets'] = this.missingTickets;
    data['receivedBooks'] = this.receivedBooks;
    data['receivedTickets'] = this.receivedTickets;
    data['returnedBooks'] = this.returnedBooks;
    data['returnedTickets'] = this.returnedTickets;
    data['soldBooks'] = this.soldBooks;
    data['soldTickets'] = this.soldTickets;
    return data;
  }
}
