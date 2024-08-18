import 'package:longalottoretail/lottery/models/response/fetch_game_data_response.dart';

class DrawBean {
  DrawRespVOs? drawRespVOs;
  bool? isSelected;

  DrawBean({this.drawRespVOs, this.isSelected});

  DrawBean.fromJson(Map<String, dynamic> json) {
    drawRespVOs = json['drawRespVOs'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['drawRespVOs'] = drawRespVOs;
    data['isSelected'] = isSelected;
    return data;
  }
}
