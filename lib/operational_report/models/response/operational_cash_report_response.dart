class OperationalCashReportResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  OperationalCashReportResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  OperationalCashReportResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    responseData = json['responseData'] != null
        ? new ResponseData.fromJson(json['responseData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    if (this.responseData != null) {
      data['responseData'] = this.responseData!.toJson();
    }
    return data;
  }
}

class ResponseData {
  String? message;
  int? statusCode;
  Data? data;

  ResponseData({this.message, this.statusCode, this.data});

  ResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? totalCashOnHand;
  List<GameWiseData>? gameWiseData;
  String? salesCommision;
  String? totalClaimTax;
  String? totalCommision;
  String? winningsCommision;
  String? totalSale;
  String? totalClaim;

  Data(
      {this.totalCashOnHand,
        this.gameWiseData,
        this.salesCommision,
        this.totalClaimTax,
        this.totalCommision,
        this.winningsCommision,
        this.totalSale,
        this.totalClaim});

  Data.fromJson(Map<String, dynamic> json) {
    totalCashOnHand = json['totalCashOnHand'];
    if (json['gameWiseData'] != null) {
      gameWiseData = <GameWiseData>[];
      json['gameWiseData'].forEach((v) {
        gameWiseData!.add(new GameWiseData.fromJson(v));
      });
    }
    salesCommision = json['salesCommision'];
    totalClaimTax = json['totalClaimTax'];
    totalCommision = json['totalCommision'];
    winningsCommision = json['winningsCommision'];
    totalSale = json['totalSale'];
    totalClaim = json['totalClaim'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCashOnHand'] = this.totalCashOnHand;
    if (this.gameWiseData != null) {
      data['gameWiseData'] = this.gameWiseData!.map((v) => v.toJson()).toList();
    }
    data['salesCommision'] = this.salesCommision;
    data['totalClaimTax'] = this.totalClaimTax;
    data['totalCommision'] = this.totalCommision;
    data['winningsCommision'] = this.winningsCommision;
    data['totalSale'] = this.totalSale;
    data['totalClaim'] = this.totalClaim;
    return data;
  }
}

class GameWiseData {
  String? gameName;
  String? claims;
  String? claimTax;
  double? salesKeyForInternalUse;
  String? sales;

  GameWiseData(
      {this.gameName,
        this.claims,
        this.claimTax,
        this.salesKeyForInternalUse,
        this.sales});

  GameWiseData.fromJson(Map<String, dynamic> json) {
    gameName = json['gameName'];
    claims = json['claims'];
    claimTax = json['claimTax'];
    salesKeyForInternalUse = json['salesKeyForInternalUse'];
    sales = json['sales'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameName'] = this.gameName;
    data['claims'] = this.claims;
    data['claimTax'] = this.claimTax;
    data['salesKeyForInternalUse'] = this.salesKeyForInternalUse;
    data['sales'] = this.sales;
    return data;
  }
}
