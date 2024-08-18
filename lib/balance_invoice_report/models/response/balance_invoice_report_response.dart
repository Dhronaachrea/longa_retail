class BalanceInvoiceReportResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  BalanceInvoiceReportResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  BalanceInvoiceReportResponse.fromJson(Map<String, dynamic> json) {
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
  String? winningsCommission;
  String? salesCommission;
  String? payments;
  String? claims;
  String? closingBalance;
  String? claimTax;
  String? commission;
  String? openingBalance;
  String? sales;
  String? creditDebitTxn;

  Data(
      {this.winningsCommission,
        this.salesCommission,
        this.payments,
        this.claims,
        this.closingBalance,
        this.claimTax,
        this.commission,
        this.openingBalance,
        this.sales,
        this.creditDebitTxn});

  Data.fromJson(Map<String, dynamic> json) {
    winningsCommission = json['winningsCommission'];
    salesCommission = json['salesCommission'];
    payments = json['payments'];
    claims = json['claims'];
    closingBalance = json['closingBalance'];
    claimTax = json['claimTax'];
    commission = json['commission'];
    openingBalance = json['openingBalance'];
    sales = json['sales'];
    creditDebitTxn = json['creditDebitTxn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['winningsCommission'] = this.winningsCommission;
    data['salesCommission'] = this.salesCommission;
    data['payments'] = this.payments;
    data['claims'] = this.claims;
    data['closingBalance'] = this.closingBalance;
    data['claimTax'] = this.claimTax;
    data['commission'] = this.commission;
    data['openingBalance'] = this.openingBalance;
    data['sales'] = this.sales;
    data['creditDebitTxn'] = this.creditDebitTxn;
    return data;
  }
}
