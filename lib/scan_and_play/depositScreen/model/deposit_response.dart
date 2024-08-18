class DepositResponse {
  String? errorMessage;
  int? errorCode;
  Data? data;

  DepositResponse({this.errorMessage, this.errorCode, this.data});

  DepositResponse.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'];
    errorCode = json['errorCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorMessage'] = this.errorMessage;
    data['errorCode'] = this.errorCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? couponQRCodeUrl;
  List<CouponCode>? couponCode;

  Data({this.couponQRCodeUrl, this.couponCode});

  Data.fromJson(Map<String, dynamic> json) {
    couponQRCodeUrl = json['couponQRCodeUrl'];
    if (json['couponCode'] != null) {
      couponCode = <CouponCode>[];
      json['couponCode'].forEach((v) {
        couponCode!.add(new CouponCode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couponQRCodeUrl'] = this.couponQRCodeUrl;
    if (this.couponCode != null) {
      data['couponCode'] = this.couponCode!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CouponCode {
  String? expiryDate;
  String? couponCode;

  CouponCode({this.expiryDate, this.couponCode});

  CouponCode.fromJson(Map<String, dynamic> json) {
    expiryDate = json['expiryDate'];
    couponCode = json['couponCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expiryDate'] = this.expiryDate;
    data['couponCode'] = this.couponCode;
    return data;
  }
}
