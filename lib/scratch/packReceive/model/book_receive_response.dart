class BookReceiveResponse {
  int? responseCode;
  String? responseMessage;

  BookReceiveResponse({this.responseCode, this.responseMessage});

  BookReceiveResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    return data;
  }
}