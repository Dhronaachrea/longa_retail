class FiveByNinetyBetAmountBean {
  int? amount;
  bool? isSelected;

  FiveByNinetyBetAmountBean({this.amount,  this.isSelected});

  FiveByNinetyBetAmountBean.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['isSelected'] = isSelected;
    return data;
  }
}
