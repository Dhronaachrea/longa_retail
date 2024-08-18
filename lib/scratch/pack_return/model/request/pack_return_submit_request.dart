import 'package:longalottoretail/scratch/pack_return/model/book_and_pack_model.dart';

class PackReturnSubmitRequest {
  String? dlChallanNumber;
  List<BookAndPackModel>? packsToReturn;
  String? userName;
  String? userSessionId;

  PackReturnSubmitRequest(
      {this.dlChallanNumber,
        this.packsToReturn,
        this.userName,
        this.userSessionId});

  PackReturnSubmitRequest.fromJson(Map<String, dynamic> json) {
    dlChallanNumber = json['dlChallanNumber'];
    if (json['packsToReturn'] != null) {
      packsToReturn = <BookAndPackModel>[];
      json['packsToReturn'].forEach((v) {
        packsToReturn!.add(new BookAndPackModel.fromJson(v));
      });
    }
    userName = json['userName'];
    userSessionId = json['userSessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dlChallanNumber'] = this.dlChallanNumber;
    if (this.packsToReturn != null) {
      data['packsToReturn'] =
          this.packsToReturn!.map((v) => v.toJson()).toList();
    }
    data['userName'] = this.userName;
    data['userSessionId'] = this.userSessionId;
    return data;
  }
}

class PacksToReturn {
  List<String>? bookList;
  int? gameId;

  PacksToReturn({this.bookList, this.gameId});

  PacksToReturn.fromJson(Map<String, dynamic> json) {
    bookList = json['bookList'].cast<String>();
    gameId = json['gameId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookList'] = this.bookList;
    data['gameId'] = this.gameId;
    return data;
  }
}