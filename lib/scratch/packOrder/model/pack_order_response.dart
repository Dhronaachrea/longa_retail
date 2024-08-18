class PackOrderResponse {
  dynamic? responseCode;
  String? responseMessage;
  dynamic? orderId;
  String? orderDateTime;

  PackOrderResponse(
      {this.responseCode,
        this.responseMessage,
        this.orderId,
        this.orderDateTime});

  PackOrderResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    orderId = json['orderId'];
    orderDateTime = json['orderDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    data['orderId'] = this.orderId;
    data['orderDateTime'] = this.orderDateTime;
    return data;
  }
}