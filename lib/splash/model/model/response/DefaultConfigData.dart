class DefaultDomainConfigData {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  DefaultDomainConfigData(
      {this.responseCode, this.responseMessage, this.responseData});

  DefaultDomainConfigData.fromJson(Map<dynamic, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    responseData = json['responseData'] != null
        ? new ResponseData.fromJson(json['responseData'])
        : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
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

  ResponseData.fromJson(Map<dynamic, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? cOUNTRYCODES;
  String? sYSTEMALLOWEDLANGUAGES;
  String? oTPLENGTH;
  String? iSB2BANDB2C;

  Data(
      {this.cOUNTRYCODES,
        this.sYSTEMALLOWEDLANGUAGES,
        this.oTPLENGTH,
        this.iSB2BANDB2C});

  Data.fromJson(Map<dynamic, dynamic> json) {
    cOUNTRYCODES = json['COUNTRY_CODES'];
    sYSTEMALLOWEDLANGUAGES = json['SYSTEM_ALLOWED_LANGUAGES'];
    oTPLENGTH = json['OTP_LENGTH'];
    iSB2BANDB2C = json['IS_B2B_AND_B2C'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['COUNTRY_CODES'] = this.cOUNTRYCODES;
    data['SYSTEM_ALLOWED_LANGUAGES'] = this.sYSTEMALLOWEDLANGUAGES;
    data['OTP_LENGTH'] = this.oTPLENGTH;
    data['IS_B2B_AND_B2C'] = this.iSB2BANDB2C;
    return data;
  }
}
