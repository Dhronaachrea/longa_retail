class PackOrderRequest {
  List<GameOrderList>? gameOrderList;
  String? userName;
  String? userSessionId;

  PackOrderRequest({this.gameOrderList, this.userName, this.userSessionId});

  PackOrderRequest.fromJson(Map<String, dynamic> json) {
    if (json['gameOrderList'] != null) {
      gameOrderList = <GameOrderList>[];
      json['gameOrderList'].forEach((v) {
        gameOrderList!.add(new GameOrderList.fromJson(v));
      });
    }
    userName = json['userName'];
    userSessionId = json['userSessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gameOrderList != null) {
      data['gameOrderList'] =
          this.gameOrderList!.map((v) => v.toJson()).toList();
    }
    data['userName'] = this.userName;
    data['userSessionId'] = this.userSessionId;
    return data;
  }
}

class GameOrderList {
  int? booksQuantity;
  int? gameId;

  GameOrderList({this.booksQuantity, this.gameId});

  GameOrderList.fromJson(Map<String, dynamic> json) {
    booksQuantity = json['booksQuantity'];
    gameId = json['gameId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booksQuantity'] = this.booksQuantity;
    data['gameId'] = this.gameId;
    return data;
  }
}