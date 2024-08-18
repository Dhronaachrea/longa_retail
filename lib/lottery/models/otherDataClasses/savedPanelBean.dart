import 'package:longalottoretail/lottery/models/otherDataClasses/panelBean.dart';

class SavedPanelBean {
  List<PanelBean> panelData = [];

  SavedPanelBean({required this.panelData});

  SavedPanelBean.fromJson(Map<String, dynamic> json) {
    if (json['panelData'] != null) {
      panelData = <PanelBean>[];
      json['panelBean'].forEach((v) {
        panelData.add(PanelBean.fromJson(v));
      });
    }
  }
}
