class GetServiceListResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  GetServiceListResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  GetServiceListResponse.fromJson(Map<String, dynamic> json) {
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
  String? engineServiceId;
  int? scheduledCommApplicable;
  String? serviceCode;
  String? commDefinationLevel;
  String? serviceDisplayName;
  int? serviceId;
  String? serviceName;
  String? combinedTierTxn;

  Data(
      {this.engineServiceId,
        this.scheduledCommApplicable,
        this.serviceCode,
        this.commDefinationLevel,
        this.serviceDisplayName,
        this.serviceId,
        this.serviceName,
        this.combinedTierTxn});

  Data.fromJson(Map<String, dynamic> json) {
    engineServiceId = json['engineServiceId'];
    scheduledCommApplicable = json['scheduledCommApplicable'];
    serviceCode = json['serviceCode'];
    commDefinationLevel = json['commDefinationLevel'];
    serviceDisplayName = json['serviceDisplayName'];
    serviceId = json['serviceId'];
    serviceName = json['serviceName'];
    combinedTierTxn = json['combinedTierTxn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['engineServiceId'] = this.engineServiceId;
    data['scheduledCommApplicable'] = this.scheduledCommApplicable;
    data['serviceCode'] = this.serviceCode;
    data['commDefinationLevel'] = this.commDefinationLevel;
    data['serviceDisplayName'] = this.serviceDisplayName;
    data['serviceId'] = this.serviceId;
    data['serviceName'] = this.serviceName;
    data['combinedTierTxn'] = this.combinedTierTxn;
    return data;
  }
}
