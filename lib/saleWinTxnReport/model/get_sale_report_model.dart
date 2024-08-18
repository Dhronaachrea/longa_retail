class GetSaleReportModel {
  String? appType;
  String? endDate;
  String? languageCode;
  String? orgId;
  String? orgTypeCode;
  String? serviceCode;
  String? startDate;

  GetSaleReportModel(
      {this.appType,
        this.endDate,
        this.languageCode,
        this.orgId,
        this.orgTypeCode,
        this.serviceCode,
        this.startDate});

  GetSaleReportModel.fromJson(Map<String, dynamic> json) {
    appType = json['appType'];
    endDate = json['endDate'];
    languageCode = json['languageCode'];
    orgId = json['orgId'];
    orgTypeCode = json['orgTypeCode'];
    serviceCode = json['serviceCode'];
    startDate = json['startDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appType'] = this.appType;
    data['endDate'] = this.endDate;
    data['languageCode'] = this.languageCode;
    data['orgId'] = this.orgId;
    data['orgTypeCode'] = this.orgTypeCode;
    data['serviceCode'] = this.serviceCode;
    data['startDate'] = this.startDate;
    return data;
  }
}
