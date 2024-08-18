class VerifyPosRequest {
  String? latitudes;
  String? longitudes;
  String? modelCode;
  String? simType;
  String? terminalId;
  String? version;

  VerifyPosRequest(
      {this.latitudes,
        this.longitudes,
        this.modelCode,
        this.simType,
        this.terminalId,
        this.version});

  VerifyPosRequest.fromJson(Map<String, dynamic> json) {
    latitudes = json['latitudes'];
    longitudes = json['longitudes'];
    modelCode = json['modelCode'];
    simType = json['simType'];
    terminalId = json['terminalId'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitudes'] = this.latitudes;
    data['longitudes'] = this.longitudes;
    data['modelCode'] = this.modelCode;
    data['simType'] = this.simType;
    data['terminalId'] = this.terminalId;
    data['version'] = this.version;
    return data;
  }
}
