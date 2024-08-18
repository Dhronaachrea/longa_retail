import '../widget/CommissionFilterBotttomSheet.dart';

class CommPickedBean {
  String? commType;
  bool? isSelected;

  CommPickedBean({this.commType,  this.isSelected});

  CommPickedBean.fromJson(Map<String, dynamic> json) {
    commType = json['commType'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commType'] = commType;
    data['isSelected'] = isSelected;
    return data;
  }
}
