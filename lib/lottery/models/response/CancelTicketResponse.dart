class CancelTicketResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  CancelTicketResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  CancelTicketResponse.fromJson(Map<String, dynamic> json) {
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
  String? autoCancel;
  String? gameCode;
  String? cancelChannel;
  String? refundAmount;
  String? ticketNo;
  String? merchantreftxnid;
  String? retailerBalance;
  String? gameName;
  String? enginetxid;
  List<DrawData>? drawData;
  Null? isPartiallyCancelled;

  ResponseData(
      {this.autoCancel,
        this.gameCode,
        this.cancelChannel,
        this.refundAmount,
        this.ticketNo,
        this.merchantreftxnid,
        this.retailerBalance,
        this.gameName,
        this.enginetxid,
        this.drawData,
        this.isPartiallyCancelled});

  ResponseData.fromJson(Map<String, dynamic> json) {
    autoCancel = json['autoCancel'];
    gameCode = json['gameCode'];
    cancelChannel = json['cancelChannel'];
    refundAmount = json['refundAmount'];
    ticketNo = json['ticketNo'];
    merchantreftxnid = json['merchantreftxnid'];
    retailerBalance = json['retailerBalance'];
    gameName = json['gameName'];
    enginetxid = json['enginetxid'];
    if (json['drawData'] != null) {
      drawData = <DrawData>[];
      json['drawData'].forEach((v) {
        drawData!.add(new DrawData.fromJson(v));
      });
    }
    isPartiallyCancelled = json['isPartiallyCancelled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['autoCancel'] = this.autoCancel;
    data['gameCode'] = this.gameCode;
    data['cancelChannel'] = this.cancelChannel;
    data['refundAmount'] = this.refundAmount;
    data['ticketNo'] = this.ticketNo;
    data['merchantreftxnid'] = this.merchantreftxnid;
    data['retailerBalance'] = this.retailerBalance;
    data['gameName'] = this.gameName;
    data['enginetxid'] = this.enginetxid;
    if (this.drawData != null) {
      data['drawData'] = this.drawData!.map((v) => v.toJson()).toList();
    }
    data['isPartiallyCancelled'] = this.isPartiallyCancelled;
    return data;
  }
}

class DrawData {
  String? drawName;
  String? drawDate;
  String? drawTime;

  DrawData({this.drawName, this.drawDate, this.drawTime});

  DrawData.fromJson(Map<String, dynamic> json) {
    drawName = json['drawName'];
    drawDate = json['drawDate'];
    drawTime = json['drawTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['drawName'] = this.drawName;
    data['drawDate'] = this.drawDate;
    data['drawTime'] = this.drawTime;
    return data;
  }
}
