class GameViseInventoryResponse {
  int? responseCode;
  String? responseMessage;
  InventoryResponse? inventoryResponse;

  GameViseInventoryResponse(
      {this.responseCode, this.responseMessage, this.inventoryResponse});

  GameViseInventoryResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    inventoryResponse = json['response'] != null
        ? new InventoryResponse.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    if (this.inventoryResponse != null) {
      data['response'] = this.inventoryResponse!.toJson();
    }
    return data;
  }
}

class InventoryResponse {
  List<GameDetails>? gameDetails;

  InventoryResponse({this.gameDetails});

  InventoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['gameDetails'] != null) {
      gameDetails = <GameDetails>[];
      json['gameDetails'].forEach((v) {
        gameDetails!.add(new GameDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gameDetails != null) {
      data['gameDetails'] = this.gameDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GameDetails {
  int? gameId;
  List<String>? bookList;

  GameDetails({this.gameId, this.bookList});

  GameDetails.fromJson(Map<String, dynamic> json) {
    gameId = json['gameId'];
    bookList = json['bookList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameId'] = this.gameId;
    data['bookList'] = this.bookList;
    return data;
  }
}