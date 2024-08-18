class LoginTokenResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  LoginTokenResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  LoginTokenResponse.fromJson(Map<String, dynamic> json) {
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
  String? authToken;
  String? timestamp;
  String? expiryTime;
  String? issueAt;
  int? userId;
  String? forcePasswordUpdate;

  ResponseData(
      {this.message,
        this.statusCode,
        this.authToken,
        this.timestamp,
        this.expiryTime,
        this.issueAt,
        this.userId,
        this.forcePasswordUpdate});

  ResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    authToken = json['authToken'];
    timestamp = json['timestamp'];
    expiryTime = json['expiryTime'];
    issueAt = json['issueAt'];
    userId = json['userId'];
    forcePasswordUpdate = json['forcePasswordUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    data['authToken'] = this.authToken;
    data['timestamp'] = this.timestamp;
    data['expiryTime'] = this.expiryTime;
    data['issueAt'] = this.issueAt;
    data['userId'] = this.userId;
    data['forcePasswordUpdate'] = this.forcePasswordUpdate;
    return data;
  }
}