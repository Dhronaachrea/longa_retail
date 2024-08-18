class CouponReversalRequest {
  String? aliasName;
  String? deviceType;
  String? couponCode;
  String? gameCode;
  String? serviceCode;
  String? providerCode;

  CouponReversalRequest(
      {this.aliasName,
        this.deviceType,
        this.couponCode,
        this.gameCode,
        this.serviceCode,
        this.providerCode});

  CouponReversalRequest.fromJson(Map<String, dynamic> json) {
    aliasName = json['aliasName'];
    deviceType = json['deviceType'];
    couponCode = json['couponCode'];
    gameCode = json['gameCode'];
    serviceCode = json['serviceCode'];
    providerCode = json['providerCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aliasName'] = this.aliasName;
    data['deviceType'] = this.deviceType;
    data['couponCode'] = this.couponCode;
    data['gameCode'] = this.gameCode;
    data['serviceCode'] = this.serviceCode;
    data['providerCode'] = this.providerCode;
    return data;
  }
}
