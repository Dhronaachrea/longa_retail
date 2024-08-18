class QuickPickBetAmountBean {
  int? number;
  bool? isSelected;

  QuickPickBetAmountBean({this.number,  this.isSelected});

  QuickPickBetAmountBean.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['isSelected'] = isSelected;
    return data;
  }
}
