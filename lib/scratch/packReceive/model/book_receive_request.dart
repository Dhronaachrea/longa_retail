class BookReceiveRequest {
  List<BookInfo>? bookInfo;
  // dynamic? dlChallanId;
  String? dlChallanNumber;
  String? receiveType;
  String? userName;
  String? userSessionId;

  BookReceiveRequest(
      {this.bookInfo,
        // this.dlChallanId,
        this.dlChallanNumber,
        this.receiveType,
        this.userName,
        this.userSessionId});

  BookReceiveRequest.fromJson(Map<String, dynamic> json) {
    if (json['bookInfo'] != null) {
      bookInfo = <BookInfo>[];
      json['bookInfo'].forEach((v) {
        bookInfo!.add(new BookInfo.fromJson(v));
      });
    }
    // dlChallanId = json['dlChallanId'];
    dlChallanNumber = json['dlChallanNumber'];
    receiveType = json['receiveType'];
    userName = json['userName'];
    userSessionId = json['userSessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bookInfo != null) {
      data['bookInfo'] = this.bookInfo!.map((v) => v.toJson()).toList();
    }
    // data['dlChallanId'] = this.dlChallanId;
    data['dlChallanNumber'] = this.dlChallanNumber;
    data['receiveType'] = this.receiveType;
    data['userName'] = this.userName;
    data['userSessionId'] = this.userSessionId;
    return data;
  }
}

class BookInfo {
  List<String>? bookList;
  int? gameId;
  String? gameType;
  List<String>? packList;

  BookInfo({this.bookList, this.gameId, this.gameType, this.packList});

  BookInfo.fromJson(Map<String, dynamic> json) {
    bookList = json['bookList'].cast<String>();
    gameId = json['gameId'];
    gameType = json['gameType'];
    packList = json['packList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookList'] = this.bookList;
    data['gameId'] = this.gameId;
    data['gameType'] = this.gameType;
    data['packList'] = this.packList;
    return data;
  }
}