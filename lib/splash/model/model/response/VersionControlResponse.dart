class VersionControlResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  VersionControlResponse({this.responseCode, this.responseMessage, this.responseData});

  VersionControlResponse.fromJson(Map<String, dynamic> json) {
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
  int? id;
  int? appTypeId;
  int? appId;
  String? version;
  String? isMandatory;
  String? fileSize;
  String? downloadStatus;
  String? versionStatus;
  String? downloadUrl;
  int? createdBy;
  String? appRemark;
  int? createdAt;
  String? isLatest;
  int? updatedAt;

  Data(
      {this.id,
        this.appTypeId,
        this.appId,
        this.version,
        this.isMandatory,
        this.fileSize,
        this.downloadStatus,
        this.versionStatus,
        this.downloadUrl,
        this.createdBy,
        this.appRemark,
        this.createdAt,
        this.isLatest,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appTypeId = json['appTypeId'];
    appId = json['appId'];
    version = json['version'];
    isMandatory = json['isMandatory'];
    fileSize = json['fileSize'];
    downloadStatus = json['downloadStatus'];
    versionStatus = json['versionStatus'];
    downloadUrl = json['downloadUrl'];
    createdBy = json['createdBy'];
    appRemark = json['appRemark'];
    createdAt = json['createdAt'];
    isLatest = json['isLatest'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appTypeId'] = this.appTypeId;
    data['appId'] = this.appId;
    data['version'] = this.version;
    data['isMandatory'] = this.isMandatory;
    data['fileSize'] = this.fileSize;
    data['downloadStatus'] = this.downloadStatus;
    data['versionStatus'] = this.versionStatus;
    data['downloadUrl'] = this.downloadUrl;
    data['createdBy'] = this.createdBy;
    data['appRemark'] = this.appRemark;
    data['createdAt'] = this.createdAt;
    data['isLatest'] = this.isLatest;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
