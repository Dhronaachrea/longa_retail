class LedgerReportApiRequest {
  String? orgId;
  String? startDate;
  String? endDate;
  String? languageCode;
  String? appType;

  LedgerReportApiRequest(
      {this.orgId, this.startDate, this.endDate, this.languageCode, this.appType});

  LedgerReportApiRequest.fromJson(Map<String, dynamic> json) {
    orgId = json['orgId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    languageCode = json['languageCode'];
    appType = json['appType'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['orgId'] = orgId ?? "";
    data['startDate'] = startDate ?? "";
    data['endDate'] = endDate ?? "";
    data['languageCode'] = languageCode ?? "";
    data['appType'] = appType ?? "";
    return data;
  }
}
