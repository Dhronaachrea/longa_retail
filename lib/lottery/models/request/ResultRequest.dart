class ResultRequest {
  String? fromDate;
  String? toDate;
  String? gameCode;
  String? merchantCode;
  String? orderByOperator;
  String? orderByType;
  int? page;
  int? size;
  String? domainCode;
  int? drawId;

  ResultRequest(
      {this.fromDate,
        this.toDate,
        this.gameCode,
        this.merchantCode,
        this.orderByOperator,
        this.orderByType,
        this.page,
        this.size,
        this.domainCode,
        this.drawId});

  ResultRequest.fromJson(Map<String, dynamic> json) {
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    gameCode = json['gameCode'];
    merchantCode = json['merchantCode'];
    orderByOperator = json['orderByOperator'];
    orderByType = json['orderByType'];
    page = json['page'];
    size = json['size'];
    domainCode = json['domainCode'];
    drawId = json['drawId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['gameCode'] = this.gameCode;
    data['merchantCode'] = this.merchantCode;
    data['orderByOperator'] = this.orderByOperator;
    data['orderByType'] = this.orderByType;
    data['page'] = this.page;
    data['size'] = this.size;
    data['domainCode'] = this.domainCode;
    data['drawId'] = this.drawId;
    return data;
  }
}
