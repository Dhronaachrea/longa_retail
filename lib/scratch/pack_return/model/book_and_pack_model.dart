import 'package:longalottoretail/scratch/pack_return/model/bookSelectionDetailModel.dart';

class BookAndPackModel {
  int? gameId;
  List<String>? bookList;
  //List<String>? packList;

  BookAndPackModel(
      {
        this.gameId,
        this.bookList,
        //this.packList,
      });

  BookAndPackModel.fromJson(Map<String, dynamic> json) {
    gameId = json['gameId'];
    bookList = json['bookList'].cast<String>();
    //packList = json['packList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameId'] = this.gameId;
    data['bookList'] = this.bookList;
    //data['packList'] = this.packList;
    return data;
  }
}

class TotalBook {
  List<BookSelectionDetailModel>? bookDetailsData;
  int? gameId;
  int? bookQuantity;

  TotalBook({this.bookDetailsData, this.gameId, this.bookQuantity});

  TotalBook.fromJson(Map<String, dynamic> json) {
    bookDetailsData = json['bookDetailsData'];
    gameId = json['gameId'];
    bookQuantity = json['bookQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookDetailsData'] = this.bookDetailsData;
    data['gameId'] = this.gameId;
    data['bookQuantity'] = this.bookQuantity;
    return data;
  }
}
