class FetchOrgCommissionResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  FetchOrgCommissionResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  FetchOrgCommissionResponse.fromJson(Map<String, dynamic> json) {
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
  List<Data>? data;

  ResponseData({this.message, this.statusCode, this.data});

  ResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? commissionDate;
  String? tieredWagerComm;
  String? tieredWinningComm;
  String? totalComm;
  String? setId;
  String? setStartingDate;
  String? setEndingDate;
  String? wagerAmt;
  String? winningAmt;
  String? directWagerComm;
  String? directSaleReturnComm;
  String? directWinningComm;

  Data(
      {this.commissionDate,
        this.tieredWagerComm,
        this.tieredWinningComm,
        this.totalComm,
        this.setId,
        this.setStartingDate,
        this.setEndingDate,
        this.wagerAmt,
        this.winningAmt,
        this.directWagerComm,
        this.directWinningComm,
        this.directSaleReturnComm
      });

  Data.fromJson(Map<String, dynamic> json) {
    commissionDate = json['commissionDate'];
    tieredWagerComm = json['tieredWagerComm'];
    tieredWinningComm = json['tieredWinningComm'];
    totalComm = json['totalComm'];
    setId = json['setId'];
    setStartingDate = json['setStartingDate'];
    setEndingDate = json['setEndingDate'];
    wagerAmt = json['wagerAmt'];
    winningAmt = json['winningAmt'];
    directWagerComm = json['directWagerComm'];
    winningAmt = json['winningAmt'];
    winningAmt = json['winningAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commissionDate'] = this.commissionDate;
    data['tieredWagerComm'] = this.tieredWagerComm;
    data['tieredWinningComm'] = this.tieredWinningComm;
    data['totalComm'] = this.totalComm;
    data['setId'] = this.setId;
    data['setStartingDate'] = this.setStartingDate;
    data['setEndingDate'] = this.setEndingDate;
    data['wagerAmt'] = this.wagerAmt;
    data['winningAmt'] = this.winningAmt;
    return data;
  }
}
