class ClaimDialogDataBean {
  String? winAmount;
  String? drawDate;
  String? drawTime;

  ClaimDialogDataBean({this.winAmount, this.drawDate,  this.drawTime});

  ClaimDialogDataBean.fromJson(Map<String, dynamic> json) {
    winAmount = json['winAmount'];
    drawDate = json['drawDate'];
    drawTime = json['drawTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['winAmount'] = winAmount;
    data['drawDate'] = drawDate;
    data['drawTime'] = drawTime;
    return data;
  }
}
