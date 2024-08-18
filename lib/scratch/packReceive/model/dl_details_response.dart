class DlDetailsResponse {
  int? responseCode;
  String? responseMessage;
  String? dlNumber;
  String? mobileNumber;
  String? countryName;
  String? zipCode;
  String? orderId;
  String? orderDate;
  String? firstName;
  String? lastName;
  String? countryCode;
  String? dlDate;
  String? dlStatus;
  String? dlMode;
  String? challanType;
  String? fromOrg;
  String? fromOrgAddress;
  String? toOrg;
  String? toOrgAddress;
  String? fromWarehouse;
  String? fromWarehouseAddress;
  String? toWarehouse;
  String? toWarehouseAddress;
  String? generatedBy;
  List<GameWiseDetails>? gameWiseDetails;
  String? cancelMessage;

  DlDetailsResponse(
      {this.responseCode,
        this.responseMessage,
        this.dlNumber,
        this.mobileNumber,
        this.countryName,
        this.zipCode,
        this.orderId,
        this.orderDate,
        this.firstName,
        this.lastName,
        this.countryCode,
        this.dlDate,
        this.dlStatus,
        this.dlMode,
        this.challanType,
        this.fromOrg,
        this.fromOrgAddress,
        this.toOrg,
        this.toOrgAddress,
        this.fromWarehouse,
        this.fromWarehouseAddress,
        this.toWarehouse,
        this.toWarehouseAddress,
        this.generatedBy,
        this.gameWiseDetails,
        this.cancelMessage});

  DlDetailsResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    dlNumber = json['dlNumber'];
    mobileNumber = json['mobileNumber'];
    countryName = json['countryName'];
    zipCode = json['zipCode'];
    orderId = json['orderId'];
    orderDate = json['orderDate'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    countryCode = json['countryCode'];
    dlDate = json['dlDate'];
    dlStatus = json['dlStatus'];
    dlMode = json['dlMode'];
    challanType = json['challanType'];
    fromOrg = json['fromOrg'];
    fromOrgAddress = json['fromOrgAddress'];
    toOrg = json['toOrg'];
    toOrgAddress = json['toOrgAddress'];
    fromWarehouse = json['fromWarehouse'];
    fromWarehouseAddress = json['fromWarehouseAddress'];
    toWarehouse = json['toWarehouse'];
    toWarehouseAddress = json['toWarehouseAddress'];
    generatedBy = json['generatedBy'];
    if (json['gameWiseDetails'] != null && json['gameWiseDetails'].isNotEmpty) {
      gameWiseDetails = <GameWiseDetails>[];
      json['gameWiseDetails'].forEach((v) {
        gameWiseDetails!.add(new GameWiseDetails.fromJson(v));
      });
    }
    cancelMessage = json['cancelMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    data['dlNumber'] = this.dlNumber;
    data['mobileNumber'] = this.mobileNumber;
    data['countryName'] = this.countryName;
    data['zipCode'] = this.zipCode;
    data['orderId'] = this.orderId;
    data['orderDate'] = this.orderDate;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['countryCode'] = this.countryCode;
    data['dlDate'] = this.dlDate;
    data['dlStatus'] = this.dlStatus;
    data['dlMode'] = this.dlMode;
    data['challanType'] = this.challanType;
    data['fromOrg'] = this.fromOrg;
    data['fromOrgAddress'] = this.fromOrgAddress;
    data['toOrg'] = this.toOrg;
    data['toOrgAddress'] = this.toOrgAddress;
    data['fromWarehouse'] = this.fromWarehouse;
    data['fromWarehouseAddress'] = this.fromWarehouseAddress;
    data['toWarehouse'] = this.toWarehouse;
    data['toWarehouseAddress'] = this.toWarehouseAddress;
    data['generatedBy'] = this.generatedBy;
    if (this.gameWiseDetails != null) {
      data['gameWiseDetails'] =
          this.gameWiseDetails!.map((v) => v.toJson()).toList();
    }
    data['cancelMessage'] = this.cancelMessage;
    return data;
  }
}

class GameWiseDetails {
  dynamic gameId;
  dynamic gameNumber;
  String? gameName;
  dynamic booksPerPack;
  dynamic pricePerTicket;
  dynamic ticketList;
  List<BookList>? bookList;
  dynamic packList;

  GameWiseDetails(
      {this.gameId,
        this.gameNumber,
        this.gameName,
        this.booksPerPack,
        this.pricePerTicket,
        this.ticketList,
        this.bookList,
        this.packList});

  GameWiseDetails.fromJson(Map<String, dynamic> json) {
    gameId = json['gameId'];
    gameNumber = json['gameNumber'];
    gameName = json['gameName'];
    booksPerPack = json['booksPerPack'];
    pricePerTicket = json['pricePerTicket'];
    ticketList = json['ticketList'];
    if (json['bookList'] != null) {
      bookList = <BookList>[];
      json['bookList'].forEach((v) {
        bookList!.add(new BookList.fromJson(v));
      });
    }
    packList = json['packList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameId'] = this.gameId;
    data['gameNumber'] = this.gameNumber;
    data['gameName'] = this.gameName;
    data['booksPerPack'] = this.booksPerPack;
    data['pricePerTicket'] = this.pricePerTicket;
    data['ticketList'] = this.ticketList;
    if (this.bookList != null) {
      data['bookList'] = this.bookList!.map((v) => v.toJson()).toList();
    }
    data['packList'] = this.packList;
    return data;
  }
}

class BookList {
  String? bookNumber;
  String? status;

  BookList({this.bookNumber, this.status});

  BookList.fromJson(Map<String, dynamic> json) {
    bookNumber = json['bookNumber'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookNumber'] = this.bookNumber;
    data['status'] = this.status;
    return data;
  }
}