class LedgerReportApiResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  LedgerReportApiResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  LedgerReportApiResponse.fromJson(Map<String, dynamic> json) {
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
  Balance? balance;
  List<Transaction>? transaction;

  Data({this.balance, this.transaction});

  Data.fromJson(Map<String, dynamic> json) {
    balance =
    json['balance'] != null ? new Balance.fromJson(json['balance']) : null;
    if (json['transaction'] != null) {
      transaction = <Transaction>[];
      json['transaction'].forEach((v) {
        transaction!.add(new Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.balance != null) {
      data['balance'] = this.balance!.toJson();
    }
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Balance {
  String? rawClosingBalance;
  String? rawOpeningBalance;
  String? closingBalance;
  String? openingBalance;
  String? totalCredit;
  String? totalDebit;
  String? creditDebitDiff;
  String? netBalanceMovement;

  Balance(
      {this.rawClosingBalance,
        this.rawOpeningBalance,
        this.closingBalance,
        this.openingBalance,
        this.totalCredit,
        this.totalDebit,
        this.creditDebitDiff,
        this.netBalanceMovement,
      });

  Balance.fromJson(Map<String, dynamic> json) {
    rawClosingBalance = json['rawClosingBalance'];
    rawOpeningBalance = json['rawOpeningBalance'];
    closingBalance = json['closingBalance'];
    openingBalance = json['openingBalance'];
    totalCredit = json['totalCredit'];
    totalDebit = json['totalDebit'];
    creditDebitDiff = json['creditDebitDiff'];
    netBalanceMovement = json['netBalanceMovement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rawClosingBalance'] = this.rawClosingBalance;
    data['rawOpeningBalance'] = this.rawOpeningBalance;
    data['closingBalance'] = this.closingBalance;
    data['openingBalance'] = this.openingBalance;
    data['totalCredit'] = this.totalCredit;
    data['totalDebit'] = this.totalDebit;
    data['creditDebitDiff'] = this.creditDebitDiff;
    data['netBalanceMovement'] = this.netBalanceMovement;
    return data;
  }
}

class Transaction {
  String? createdAt;
  String? amount;
  String? transactionMode;
  String? particular;
  String? serviceDisplayName;
  String? availableBalance;

  Transaction(
      {this.createdAt,
        this.amount,
        this.transactionMode,
        this.particular,
        this.serviceDisplayName,
        this.availableBalance});

  Transaction.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    amount = json['amount'];
    transactionMode = json['transactionMode'];
    particular = json['particular'];
    serviceDisplayName = json['serviceDisplayName'];
    availableBalance = json['availableBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['amount'] = this.amount;
    data['transactionMode'] = this.transactionMode;
    data['particular'] = this.particular;
    data['serviceDisplayName'] = this.serviceDisplayName;
    data['availableBalance'] = this.availableBalance;
    return data;
  }
}