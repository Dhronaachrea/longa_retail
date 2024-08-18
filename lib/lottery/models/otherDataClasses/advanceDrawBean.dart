import 'package:longalottoretail/lottery/models/response/fetch_game_data_response.dart';

class AdvanceDrawBean {
  DrawRespVOs? drawRespVOs;
  bool? isSelected;

  AdvanceDrawBean({this.drawRespVOs,  this.isSelected});

  AdvanceDrawBean.fromJson(Map<String, dynamic> json) {
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
