class CouponReversalResponse {
  String? errorMessage;
  int? errorCode;
  String? data;

  CouponReversalResponse({this.errorMessage, this.errorCode, this.data});

  CouponReversalResponse.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'];
    errorCode = json['errorCode'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorMessage'] = this.errorMessage;
    data['errorCode'] = this.errorCode;
    data['data'] = this.data;
    return data;
  }
}
