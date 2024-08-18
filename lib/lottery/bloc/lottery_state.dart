import 'package:longalottoretail/lottery/lottery_bottom_nav/winning_claim/models/response/TicketVerifyResponse.dart';
import 'package:longalottoretail/lottery/models/response/fetch_game_data_response.dart';
import 'package:longalottoretail/lottery/models/response/RePrintResponse.dart';
import 'package:longalottoretail/lottery/models/response/ResultResponse.dart';

import '../models/response/CancelTicketResponse.dart';
import '../models/response/saleResponseBean.dart';

abstract class LotteryState {}

class LotteryInitial extends LotteryState {}

class FetchGameLoading extends LotteryState{}

class FetchGameSuccess extends LotteryState{
  FetchGameDataResponse response;

  FetchGameSuccess({required this.response});

}
class FetchGameError extends LotteryState{
  String errorMessage;
  int? errorCode;

  FetchGameError({required this.errorMessage, this.errorCode});
}


//////////////////////// RePrint api ///////////////////////////////

class RePrintLoading extends LotteryState{}

class RePrintSuccess extends LotteryState{
  RePrintResponse response;

  RePrintSuccess({required this.response});
}
class RePrintError extends LotteryState{
  String errorMessage;
  int? errorCode;

  RePrintError({required this.errorMessage, this.errorCode});
}

//////////////////////// Result api ///////////////////////////////

class ResultLoading extends LotteryState{}

class ResultSuccess extends LotteryState{
  ResultResponse response;

  ResultSuccess({required this.response});

}
class ResultError extends LotteryState{
  String errorMessage;
  int? errorCode;

  ResultError({required this.errorMessage, this.errorCode});
}

class GameSaleApiLoading extends LotteryState{}

class GameSaleApiSuccess extends LotteryState{
  SaleResponseBean response;

  GameSaleApiSuccess({required this.response});
}

class GameSaleApiError extends LotteryState{
  String errorMessage;
  int? errorCode;

  GameSaleApiError({required this.errorMessage, this.errorCode});
}

class CancelTicketLoading extends LotteryState{}

class CancelTicketSuccess extends LotteryState{
  CancelTicketResponse response;

  CancelTicketSuccess({required this.response});
}
class CancelTicketError extends LotteryState{
  String errorMessage;
  int? errorCode;

  CancelTicketError({required this.errorMessage, this.errorCode});
}
