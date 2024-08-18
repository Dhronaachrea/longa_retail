import 'dart:collection';

class GetLoginDataResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  GetLoginDataResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  GetLoginDataResponse.fromJson(Map<String, dynamic> json) {
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
  String? lastName;
  String? userStatus;
  String? walletType;
  String? mobileNumber;
  String? isHead;
  int? orgId;
  String? accessSelfDomainOnly;
  String? balance;
  String? qrCode;
  String? orgCode;
  int? parentAgtOrgId;
  int? parentMagtOrgId;
  String? creditLimit;
  String? userBalance;
  String? distributableLimit;
  String? orgTypeCode;
  String? mobileCode;
  String? orgName;
  String? isScanNPlay;
  int? userId;
  String? isAffiliate;
  int? domainId;
  String? walletMode;
  String? orgStatus;
  String? firstName;
  String? regionBinding;
  double? rawUserBalance;
  int? parentSagtOrgId;
  String? username;
  String? displayCommision;

  Data(
      {this.lastName,
        this.userStatus,
        this.walletType,
        this.mobileNumber,
        this.isHead,
        this.orgId,
        this.accessSelfDomainOnly,
        this.balance,
        this.qrCode,
        this.orgCode,
        this.isScanNPlay,
        this.parentAgtOrgId,
        this.parentMagtOrgId,
        this.creditLimit,
        this.userBalance,
        this.distributableLimit,
        this.orgTypeCode,
        this.mobileCode,
        this.orgName,
        this.userId,
        this.isAffiliate,
        this.domainId,
        this.walletMode,
        this.orgStatus,
        this.firstName,
        this.regionBinding,
        this.rawUserBalance,
        this.parentSagtOrgId,
        this.username,
      this.displayCommision});

  Data.fromJson(Map<String, dynamic> json) {
    lastName = json['lastName'];
    userStatus = json['userStatus'];
    walletType = json['walletType'];
    mobileNumber = json['mobileNumber'];
    isHead = json['isHead'];
    orgId = json['orgId'];
    accessSelfDomainOnly = json['accessSelfDomainOnly'];
    balance = json['balance'];
    qrCode = json['qrCode'];
    orgCode = json['orgCode'];
    isScanNPlay = json['isScanNPlay'];
    parentAgtOrgId = json['parentAgtOrgId'];
    parentMagtOrgId = json['parentMagtOrgId'];
    creditLimit = json['creditLimit'];
    userBalance = json['userBalance'];
    distributableLimit = json['distributableLimit'];
    orgTypeCode = json['orgTypeCode'];
    mobileCode = json['mobileCode'];
    orgName = json['orgName'];
    userId = json['userId'];
    isAffiliate = json['isAffiliate'];
    domainId = json['domainId'];
    walletMode = json['walletMode'];
    orgStatus = json['orgStatus'];
    firstName = json['firstName'];
    regionBinding = json['regionBinding'];
    rawUserBalance = json['rawUserBalance'];
    parentSagtOrgId = json['parentSagtOrgId'];
    username = json['username'];
    displayCommision = json['displayCommision'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastName'] = this.lastName;
    data['userStatus'] = this.userStatus;
    data['walletType'] = this.walletType;
    data['mobileNumber'] = this.mobileNumber;
    data['isHead'] = this.isHead;
    data['orgId'] = this.orgId;
    data['accessSelfDomainOnly'] = this.accessSelfDomainOnly;
    data['balance'] = this.balance;
    data['qrCode'] = this.qrCode;
    data['orgCode'] = this.orgCode;
    data['isScanNPlay'] = this.isScanNPlay;
    data['parentAgtOrgId'] = this.parentAgtOrgId;
    data['parentMagtOrgId'] = this.parentMagtOrgId;
    data['creditLimit'] = this.creditLimit;
    data['userBalance'] = this.userBalance;
    data['distributableLimit'] = this.distributableLimit;
    data['orgTypeCode'] = this.orgTypeCode;
    data['mobileCode'] = this.mobileCode;
    data['orgName'] = this.orgName;
    data['userId'] = this.userId;
    data['isAffiliate'] = this.isAffiliate;
    data['domainId'] = this.domainId;
    data['walletMode'] = this.walletMode;
    data['orgStatus'] = this.orgStatus;
    data['firstName'] = this.firstName;
    data['regionBinding'] = this.regionBinding;
    data['rawUserBalance'] = this.rawUserBalance;
    data['parentSagtOrgId'] = this.parentSagtOrgId;
    data['username'] = this.username;
    data['displayCommision'] = this.displayCommision;
    return data;
  }
}
