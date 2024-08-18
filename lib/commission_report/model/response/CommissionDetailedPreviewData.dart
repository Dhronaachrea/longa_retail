import 'package:longalottoretail/commission_report/model/response/CommissionDetailedDataResponse.dart' as commission_detailed_data;

class CommissionDetailedPreviewData {
  int? wagerAmt;
  int? winningAmt;
  String? commOn;
  String? setStartingDate;
  String? setEndingDate;
  List<int>? amountList;
  List<commission_detailed_data.Data>? data;

  CommissionDetailedPreviewData(
      {this.wagerAmt,
        this.winningAmt,
        this.commOn,
        this.setStartingDate,
        this.setEndingDate,
        this.amountList,
        this.data});

  CommissionDetailedPreviewData.fromJson(Map<String, dynamic> json) {
    wagerAmt = json['wagerAmt'];
    winningAmt = json['winningAmt'];
    commOn = json['commOn'];
    setStartingDate = json['setStartingDate'];
    setEndingDate = json['setEndingDate'];
    amountList = json['amountList'];
    if (json['data'] != null) {
      data = <commission_detailed_data.Data>[];
      json['data'].forEach((v) {
        data!.add(new commission_detailed_data.Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wagerAmt'] = this.wagerAmt;
    data['winningAmt'] = this.winningAmt;
    data['commOn'] = this.commOn;
    data['setStartingDate'] = this.setStartingDate;
    data['setEndingDate'] = this.setEndingDate;
    data['amountList'] = this.amountList;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}