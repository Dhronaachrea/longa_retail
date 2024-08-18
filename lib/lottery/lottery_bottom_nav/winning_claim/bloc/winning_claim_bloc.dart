import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/lottery/lottery_bottom_nav/winning_claim/bloc/winning_claim_event.dart';
import 'package:longalottoretail/lottery/lottery_bottom_nav/winning_claim/bloc/winning_claim_state.dart';
import 'package:longalottoretail/lottery/models/response/RePrintResponse.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/utility/UrlDrawGameBean.dart';
import 'package:longalottoretail/utility/user_info.dart';

import '../../../../utility/app_constant.dart';
import '../../../models/request/RePrintRequest.dart';
import '../models/request/ClaimWinPayPwtRequest.dart';
import '../models/request/TicketVerifyRequest.dart';
import '../models/response/ClaimWinResponse.dart';
import '../models/response/TicketVerifyResponse.dart';
import '../winning_claim_logic.dart';

class WinningClaimBloc extends Bloc<WinningClaimEvent, WinningClaimState> {
  WinningClaimBloc() : super(WinningClaimInitial()) {
    on<TicketVerifyApi>(_onTicketVerifyEvent);
    on<ClaimWinPayPwtApi>(_onClaimWinPayPwtEvent);
    on<RePrintApiClaim>(_onRePrintEvent);
  }
}

_onTicketVerifyEvent(TicketVerifyApi event, Emitter<WinningClaimState> emit) async{
  emit(TicketVerifyApiLoading());

  BuildContext context        = event.context;
  String ticketNumber         = event.ticketNumber;
  UrlDrawGameBean? apiDetails = event.apiDetails;
  String relativePath         = apiDetails?.url ?? "";
  String baseUrl              = apiDetails?.basePath ?? "";
  Map<String, dynamic> header = {
    "username" : apiDetails?.username,
    "password" : apiDetails?.password,
  };

  var response = await WinningClaimLogic.callTicketVerify(context, baseUrl, relativePath, header, TicketVerifyRequest(
      lastPWTTicket     : 0,
      merchantCode      : "LotteryRMS",
      sessionId         : UserInfo.userToken,
      ticketNumber      : ticketNumber,
      userName          : UserInfo.userName
  ).toJson());



  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(TicketVerifyError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          log("ticket response----------------->${jsonEncode(value)}");
          TicketVerifyResponse? response = value as TicketVerifyResponse?;
          emit(TicketVerifySuccess(response: response));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          TicketVerifyResponse? errorResponse = value as TicketVerifyResponse?;
          emit(TicketVerifyError(errorMessage: loadLocalizedData("DMS_${errorResponse?.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? "", errorCode: errorResponse?.responseCode));
        },
        failure: (value) {
          print("bloc failure: ${value}");
          emit(TicketVerifyError(errorMessage: value["occurredErrorDescriptionMsg"]));
        }
    );
  } catch(e) {
    print("error=========> $e");
    emit(TicketVerifyError(errorMessage: "Technical Issue !"));
  }

}

_onClaimWinPayPwtEvent(ClaimWinPayPwtApi event, Emitter<WinningClaimState> emit) async{
  emit(TicketVerifyApiLoading());

  BuildContext context          = event.context;
  ClaimWinPayPwtRequest request = event.request;
  String relativePath           = event.apiDetails?.url ?? "";
  String baseUrl                = event.apiDetails?.basePath ?? "";

  Map<String, dynamic> header = {
    "username": event.apiDetails?.username ?? "",
    "password": event.apiDetails?.password ?? ""
  };

  var response = await WinningClaimLogic.callClaimWinPayPwt(context, baseUrl, relativePath, header, request.toJson());
  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(ClaimWinPayPwtError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          print("ticket response----------------->$value");
          ClaimWinResponse? response = value as ClaimWinResponse?;
          emit(ClaimWinPayPwtSuccess(response: response));

        },
        responseFailure: (value) {
          print("bloc responseFailure: $value");
          ClaimWinResponse? errorResponse = value as ClaimWinResponse?;
          emit(ClaimWinPayPwtError(errorMessage: loadLocalizedData("DMS_${errorResponse?.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? "", errorCode: errorResponse?.responseCode));

        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(ClaimWinPayPwtError(errorMessage: value["occurredErrorDescriptionMsg"]));
        }
    );

  } catch(e) {
    print("error=========> $e");
    emit(ClaimWinPayPwtError(errorMessage: "Technical Issue !"));
  }

}


_onRePrintEvent(RePrintApiClaim event, Emitter<WinningClaimState> emit) async{
  emit(RePrintLoading());

  BuildContext context = event.context;
  UrlDrawGameBean? urlDetails = event.apiUrlDetails;
  String ticketNumber = "";
  String gameCode = "";
  if (event.claimTicketNumber != null) {
    ticketNumber = event.claimTicketNumber ?? "0";
    gameCode = event.gameCode ?? "0";

  } else {
    ticketNumber = UserInfo.getDgeLastSaleTicketNo.replaceAll('"', "");
    gameCode = UserInfo.getDgeLastSaleGameCode.replaceAll('"', "");
  }

  print("relative url -------> ${urlDetails?.url}");

  var response = await WinningClaimLogic.callRePrint(context,
      urlDetails?.basePath ?? "",
      urlDetails?.url ?? "",
      RePrintRequest(
          gameCode: gameCode,
          purchaseChannel: purchaseChannel,
          ticketNumber: ticketNumber,
          isPwt: false
      ).toJson());

  try {
    response.when(idle: () {

    }, networkFault: (value) {
      emit(RePrintError(errorMessage: value["occurredErrorDescriptionMsg"]));

    }, responseSuccess: (value) {
      RePrintResponse successResponse =  value as RePrintResponse;
      emit(RePrintSuccessClaim(response: successResponse));

    }, responseFailure: (value) {
      print("bloc responseFailure:");
      RePrintResponse errorResponse =  value as RePrintResponse;
      emit(RePrintError(errorMessage: errorResponse.responseMessage ?? "responseFailure"));

    }, failure: (value) {
      print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
      emit(RePrintError(errorMessage: value["occurredErrorDescriptionMsg"]));
    });

  } catch(e) {
    print("error=========> $e");
    emit(RePrintError(errorMessage: "Technical Issue !"));
  }

}

