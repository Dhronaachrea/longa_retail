class SummarizeDefaultResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  SummarizeDefaultResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  SummarizeDefaultResponse.fromJson(Map<String, dynamic> json) {
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
  List<LedgerData>? ledgerData;
  int? rawClosingBalance;
  int? rawOpeningBalance;
  String? closingBalance;
  String? openingBalance;
  String? totalCredit;
  String? totalDebit;

  Data(
      {this.ledgerData,
        this.rawClosingBalance,
        this.rawOpeningBalance,
        this.closingBalance,
        this.openingBalance,
        this.totalCredit,
        this.totalDebit
      });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['ledgerData'] != null) {
      ledgerData = <LedgerData>[];
      json['ledgerData'].forEach((v) {
        ledgerData!.add(new LedgerData.fromJson(v));
      });
    }
    rawClosingBalance = json['rawClosingBalance'];
    rawOpeningBalance = json['rawOpeningBalance'];
    closingBalance = json['closingBalance'];
    openingBalance = json['openingBalance'];
    totalDebit = json['totalDebit'];
    totalCredit = json['totalCredit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ledgerData != null) {
      data['ledgerData'] = this.ledgerData!.map((v) => v.toJson()).toList();
    }
    data['rawClosingBalance'] = this.rawClosingBalance;
    data['rawOpeningBalance'] = this.rawOpeningBalance;
    data['closingBalance'] = this.closingBalance;
    data['openingBalance'] = this.openingBalance;
    data['totalDebit'] = this.totalDebit;
    data['totalCredit'] = this.totalCredit;
    return data;
    return data;
  }
}

class LedgerData {
  String? key1;
  String? key2;
  String? rawNetAmount;
  String? netAmount;
  String? serviceCode;
  String? key1Name;
  String? serviceName;
  String? key2Name;

  LedgerData(
      {this.key1,
        this.key2,
        this.rawNetAmount,
        this.netAmount,
        this.serviceCode,
        this.key1Name,
        this.serviceName,
        this.key2Name});

  LedgerData.fromJson(Map<String, dynamic> json) {
    key1 = json['key1'];
    key2 = json['key2'];
    rawNetAmount = json['rawNetAmount'];
    netAmount = json['netAmount'];
    serviceCode = json['serviceCode'];
    key1Name = json['key1Name'];
    serviceName = json['serviceName'];
    key2Name = json['key2Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key1'] = this.key1;
    data['key2'] = this.key2;
    data['rawNetAmount'] = this.rawNetAmount;
    data['netAmount'] = this.netAmount;
    data['serviceCode'] = this.serviceCode;
    data['key1Name'] = this.key1Name;
    data['serviceName'] = this.serviceName;
    data['key2Name'] = this.key2Name;
    return data;
  }
}
