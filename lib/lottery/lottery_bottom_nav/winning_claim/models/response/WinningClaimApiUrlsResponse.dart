class WinningClaimApiUrlsResponse {
  VerifyTicket? verifyTicket;
  VerifyTicket? claimWin;

  WinningClaimApiUrlsResponse({this.verifyTicket, this.claimWin});

  WinningClaimApiUrlsResponse.fromJson(Map<String, dynamic> json) {
    verifyTicket = json['verifyTicket'] != null
        ? new VerifyTicket.fromJson(json['verifyTicket'])
        : null;
    claimWin = json['claimWin'] != null
        ? new VerifyTicket.fromJson(json['claimWin'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.verifyTicket != null) {
      data['verifyTicket'] = this.verifyTicket!.toJson();
    }
    if (this.claimWin != null) {
      data['claimWin'] = this.claimWin!.toJson();
    }
    return data;
  }
}

class VerifyTicket {
  String? url;
  Headers? headers;

  VerifyTicket({this.url, this.headers});

  VerifyTicket.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    headers =
    json['headers'] != null ? new Headers.fromJson(json['headers']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    if (this.headers != null) {
      data['headers'] = this.headers!.toJson();
    }
    return data;
  }
}

class Headers {
  String? username;
  String? password;
  String? contentType;

  Headers({this.username, this.password, this.contentType});

  Headers.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    contentType = json['Content-Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['Content-Type'] = this.contentType;
    return data;
  }
}
