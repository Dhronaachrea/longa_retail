class GetSaleReportResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  GetSaleReportResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  GetSaleReportResponse.fromJson(Map<String, dynamic> json) {
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
  DataValue? data;

  ResponseData({this.message, this.statusCode, this.data});

  ResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? new DataValue.fromJson(json['data']) : null;
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

class DataValue {
  String? orgTypeCode;
  Total? total;
  String? orgName;
  String? address;
  List<TransactionData>? transactionData;
  String? orgId;

  DataValue(
      {this.orgTypeCode,
        this.total,
        this.orgName,
        this.address,
        this.transactionData,
        this.orgId});

  DataValue.fromJson(Map<String, dynamic> json) {
    orgTypeCode = json['orgTypeCode'];
    total = json['total'] != null ? new Total.fromJson(json['total']) : null;
    orgName = json['orgName'];
    address = json['address'];
    if (json['transactionData'] != null) {
      transactionData = <TransactionData>[];
      json['transactionData'].forEach((v) {
        transactionData!.add(new TransactionData.fromJson(v));
      });
    }
    orgId = json['orgId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orgTypeCode'] = this.orgTypeCode;
    if (this.total != null) {
      data['total'] = this.total!.toJson();
    }
    data['orgName'] = this.orgName;
    data['address'] = this.address;
    if (this.transactionData != null) {
      data['transactionData'] =
          this.transactionData!.map((v) => v.toJson()).toList();
    }
    data['orgId'] = this.orgId;
    return data;
  }
}

class Total {
  String? sumOfWinReturn;
  String? netCommision;
  String? sumOfWinning;
  String? netSale;
  String? sumOfWinningTax;
  String? sumOfSaleReturn;
  String? rawNetCommission;
  String? sumOfSale;
  String? rawNetSale;

  Total(
      {this.sumOfWinReturn,
        this.netCommision,
        this.sumOfWinning,
        this.netSale,
        this.sumOfWinningTax,
        this.sumOfSaleReturn,
        this.rawNetCommission,
        this.sumOfSale,
        this.rawNetSale});

  Total.fromJson(Map<String, dynamic> json) {
    sumOfWinReturn = json['sumOfWinReturn'];
    netCommision = json['netCommision'];
    sumOfWinning = json['sumOfWinning'];
    netSale = json['netSale'];
    sumOfWinningTax = json['sumOfWinningTax'];
    sumOfSaleReturn = json['sumOfSaleReturn'];
    rawNetCommission = json['rawNetCommission'];
    sumOfSale = json['sumOfSale'];
    rawNetSale = json['rawNetSale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sumOfWinReturn'] = this.sumOfWinReturn;
    data['netCommision'] = this.netCommision;
    data['sumOfWinning'] = this.sumOfWinning;
    data['netSale'] = this.netSale;
    data['sumOfWinningTax'] = this.sumOfWinningTax;
    data['sumOfSaleReturn'] = this.sumOfSaleReturn;
    data['rawNetCommission'] = this.rawNetCommission;
    data['sumOfSale'] = this.sumOfSale;
    data['rawNetSale'] = this.rawNetSale;
    return data;
  }
}

class TransactionData {
  String? createdAt;
  String? gameName;
  String? txnValue;
  String? winningTax;
  String? orgCommValue;
  String? balancePostTxn;
  String? txnTypeCode;
  String? orgNetAmount;
  String? userName;
  String? userId;
  String? orgDueAmount;
  String? txnId;

  TransactionData(
      {this.createdAt,
        this.gameName,
        this.txnValue,
        this.winningTax,
        this.orgCommValue,
        this.balancePostTxn,
        this.txnTypeCode,
        this.orgNetAmount,
        this.userName,
        this.userId,
        this.orgDueAmount,
        this.txnId});

  TransactionData.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    gameName = json['gameName'];
    txnValue = json['txnValue'];
    winningTax = json['winningTax'];
    orgCommValue = json['orgCommValue'];
    balancePostTxn = json['balancePostTxn'];
    txnTypeCode = json['txnTypeCode'];
    orgNetAmount = json['orgNetAmount'];
    userName = json['userName'];
    userId = json['userId'];
    orgDueAmount = json['orgDueAmount'];
    txnId = json['txnId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['gameName'] = this.gameName;
    data['txnValue'] = this.txnValue;
    data['winningTax'] = this.winningTax;
    data['orgCommValue'] = this.orgCommValue;
    data['balancePostTxn'] = this.balancePostTxn;
    data['txnTypeCode'] = this.txnTypeCode;
    data['orgNetAmount'] = this.orgNetAmount;
    data['userName'] = this.userName;
    data['userId'] = this.userId;
    data['orgDueAmount'] = this.orgDueAmount;
    data['txnId'] = this.txnId;
    return data;
  }
}
