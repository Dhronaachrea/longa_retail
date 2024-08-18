import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/utility/UrlDrawGameBean.dart';

import '../models/otherDataClasses/panelBean.dart';
import '../models/response/fetch_game_data_response.dart';

abstract class LotteryEvent {}

class FetchGameDataApi extends LotteryEvent {
  BuildContext context;

  FetchGameDataApi({required this.context});
}


class RePrintApi extends LotteryEvent {
  BuildContext context;
  UrlDrawGameBean? apiUrlDetails;

  RePrintApi({required this.context, required this.apiUrlDetails});
}

class ResultApi extends LotteryEvent {
  BuildContext context;
  UrlDrawGameBean? apiUrlDetails;
  String toDateTime;
  String fromDateTime;
  String gameCode;

  ResultApi({required this.context, required this.apiUrlDetails, required this.fromDateTime, required this.toDateTime, required this.gameCode});
}

class LotterySaleApi extends LotteryEvent {
  BuildContext context;
  bool? isAdvancePlay;
  int? noOfDraws;
  List<Map<String, String>>? listAdvanceDraws;
  List<PanelBean>? listPanel;
  GameRespVOs? gameObjectsList;

  LotterySaleApi({required this.context, this.isAdvancePlay, this.noOfDraws, this.listAdvanceDraws, this.listPanel, this.gameObjectsList});
}

class CancelTicketApi extends LotteryEvent {
  BuildContext context;
  UrlDrawGameBean? apiUrlDetails;

  CancelTicketApi({required this.context, required this.apiUrlDetails});
}

