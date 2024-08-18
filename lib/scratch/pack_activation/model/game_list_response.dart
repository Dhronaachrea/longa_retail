class GameListResponse {
  int? responseCode;
  String? responseMessage;
  List<Games>? games;

  GameListResponse({this.responseCode, this.responseMessage, this.games});

  GameListResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
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
    if (this.games != null) {
      data['games'] = this.games!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Games {
  dynamic? gameId;
  dynamic? gameNumber;
  dynamic? packNumberDigits;
  dynamic? bookNumberDigits;
  dynamic? ticketNumberDigits;
  String? gameName;
  String? saleStartDate;
  String? saleEndDate;
  String? winningEndDate;
  String? addInventoryStatus;
  String? gameStatus;
  dynamic? ticketPrice;
  String? gameType;
  dynamic? booksPerPack;
  dynamic? ticketsPerBook;
  dynamic? packsPerGame;
  dynamic? commissionPercentage;
  dynamic? packDigitsInBook;
  dynamic? virnNumberDigits;
  dynamic? validationNumberDigits;
  dynamic? gameInfo;
  dynamic? gameIcon;
  dynamic? ticketFrontImage;
  dynamic? ticketBackImage;
  dynamic? ticketScratchImage;

  Games(
      {this.gameId,
        this.gameNumber,
        this.packNumberDigits,
        this.bookNumberDigits,
        this.ticketNumberDigits,
        this.gameName,
        this.saleStartDate,
        this.saleEndDate,
        this.winningEndDate,
        this.addInventoryStatus,
        this.gameStatus,
        this.ticketPrice,
        this.gameType,
        this.booksPerPack,
        this.ticketsPerBook,
        this.packsPerGame,
        this.commissionPercentage,
        this.packDigitsInBook,
        this.virnNumberDigits,
        this.validationNumberDigits,
        this.gameInfo,
        this.gameIcon,
        this.ticketFrontImage,
        this.ticketBackImage,
        this.ticketScratchImage});

  Games.fromJson(Map<String, dynamic> json) {
    gameId = json['gameId'];
    gameNumber = json['gameNumber'];
    packNumberDigits = json['packNumberDigits'];
    bookNumberDigits = json['bookNumberDigits'];
    ticketNumberDigits = json['ticketNumberDigits'];
    gameName = json['gameName'];
    saleStartDate = json['saleStartDate'];
    saleEndDate = json['saleEndDate'];
    winningEndDate = json['winningEndDate'];
    addInventoryStatus = json['addInventoryStatus'];
    gameStatus = json['gameStatus'];
    ticketPrice = json['ticketPrice'];
    gameType = json['gameType'];
    booksPerPack = json['booksPerPack'];
    ticketsPerBook = json['ticketsPerBook'];
    packsPerGame = json['packsPerGame'];
    commissionPercentage = json['commissionPercentage'];
    packDigitsInBook = json['packDigitsInBook'];
    virnNumberDigits = json['virnNumberDigits'];
    validationNumberDigits = json['validationNumberDigits'];
    gameInfo = json['gameInfo'];
    gameIcon = json['gameIcon'];
    ticketFrontImage = json['ticketFrontImage'];
    ticketBackImage = json['ticketBackImage'];
    ticketScratchImage = json['ticketScratchImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameId'] = this.gameId;
    data['gameNumber'] = this.gameNumber;
    data['packNumberDigits'] = this.packNumberDigits;
    data['bookNumberDigits'] = this.bookNumberDigits;
    data['ticketNumberDigits'] = this.ticketNumberDigits;
    data['gameName'] = this.gameName;
    data['saleStartDate'] = this.saleStartDate;
    data['saleEndDate'] = this.saleEndDate;
    data['winningEndDate'] = this.winningEndDate;
    data['addInventoryStatus'] = this.addInventoryStatus;
    data['gameStatus'] = this.gameStatus;
    data['ticketPrice'] = this.ticketPrice;
    data['gameType'] = this.gameType;
    data['booksPerPack'] = this.booksPerPack;
    data['ticketsPerBook'] = this.ticketsPerBook;
    data['packsPerGame'] = this.packsPerGame;
    data['commissionPercentage'] = this.commissionPercentage;
    data['packDigitsInBook'] = this.packDigitsInBook;
    data['virnNumberDigits'] = this.virnNumberDigits;
    data['validationNumberDigits'] = this.validationNumberDigits;
    data['gameInfo'] = this.gameInfo;
    data['gameIcon'] = this.gameIcon;
    data['ticketFrontImage'] = this.ticketFrontImage;
    data['ticketBackImage'] = this.ticketBackImage;
    data['ticketScratchImage'] = this.ticketScratchImage;
    return data;
  }
}