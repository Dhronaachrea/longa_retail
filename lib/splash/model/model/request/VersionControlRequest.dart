class VersionControlRequest {
  String? appType;
  String? currAppVer;
  String? domainName;
  String? os;
  String? playerToken;
  String? playerId;

  VersionControlRequest(
      {this.appType,
        this.currAppVer,
        this.domainName,
        this.os,
        this.playerToken,
        this.playerId});

  VersionControlRequest.fromJson(Map<String, dynamic> json) {
    appType = json['appType'];
    currAppVer = json['currAppVer'];
    domainName = json['domainName'];
    os = json['os'];
    playerToken = json['playerToken'];
    playerId = json['playerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appType'] = this.appType;
    data['currAppVer'] = this.currAppVer;
    data['domainName'] = this.domainName;
    data['os'] = this.os;
    data['playerToken'] = this.playerToken;
    data['playerId'] = this.playerId;
    return data;
  }
}
