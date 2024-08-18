import '../widget/CommissionFilterBotttomSheet.dart';

class DatePickedBean {
  String? dateType;
  bool? isSelected;

  DatePickedBean({this.dateType,  this.isSelected});

  DatePickedBean.fromJson(Map<String, dynamic> json) {
    dateType = json['commType'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commType'] = dateType;
    data['isSelected'] = isSelected;
    return data;
  }
}
