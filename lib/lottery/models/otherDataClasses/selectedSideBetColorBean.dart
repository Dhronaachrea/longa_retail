
import 'package:longalottoretail/lottery/models/response/fetch_game_data_response.dart';

class SelectedSideBetColorBean {
  PickType? pickType;
  bool? isSelected;

  SelectedSideBetColorBean({this.pickType,  this.isSelected});

  SelectedSideBetColorBean.fromJson(Map<String, dynamic> json) {
    pickType = json['pickType'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pickType'] = pickType;
    data['isSelected'] = isSelected;
    return data;
  }
}
