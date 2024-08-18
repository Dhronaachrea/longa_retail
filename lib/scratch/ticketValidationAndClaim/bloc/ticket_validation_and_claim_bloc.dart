import 'dart:async';

import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/scratch/ticketValidationAndClaim/model/request/ticket_claim_request.dart';
import 'package:longalottoretail/scratch/ticketValidationAndClaim/model/request/ticket_validation_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/scratch/ticketValidationAndClaim/bloc/ticket_validation_and_claim_event.dart';
import 'package:longalottoretail/scratch/ticketValidationAndClaim/bloc/ticket_validation_and_claim_state.dart';
import 'package:longalottoretail/scratch/ticketValidationAndClaim/ticket_validationa_and_claim_logic.dart';
import 'package:longalottoretail/utility/user_info.dart';

import '../model/response/ticket_claim_response.dart';
import '../model/response/ticket_validation_response.dart';

class TicketValidationAndClaimBloc extends Bloc<TicketValidationAndClaimEvent, TicketValidationAndClaimState> {
  TicketValidationAndClaimBloc() : super(TicketValidationAndClaimInitial()) {
    on<TicketValidationAndClaimApi>(_onTicketValidationAndClaimEvent);
    on<TicketClaimApi>(_onTicketClaimEvent);
  }

  FutureOr<void> _onTicketClaimEvent(TicketClaimApi event, Emitter<TicketValidationAndClaimState> emit) async  {
    emit(TicketClaimLoading());

    BuildContext context  = event.context;
    var scratchList       = event.scratchList;

    var response = await TicketValidationAndClaimLogic.callTicketClaimData(
        context,
        TicketClaimRequest(
            barcodeNumber: event.barCodeText.toString(),// double.parse(event.barCodeText.toString()??"0"),
            modelCode: "NA",
            requestId: 1234,
            terminalId: 12345678901,
            userName: UserInfo.userName,
            userSessionId:UserInfo.userToken
        ).toJson(),
        scratchList);

    try {
      response.when(
          idle: () {},
          networkFault: (value) {
            emit(TicketClaimError(errorMessage: value["occurredErrorDescriptionMsg"]));
          },
          responseSuccess: (value) {
            TicketClaimResponse successResponse = value as TicketClaimResponse;
            emit(TicketClaimSuccess(response: successResponse));
          },
          responseFailure: (value) {
            print("bloc responseFailure:");
            TicketClaimResponse errorResponse = value as TicketClaimResponse;
            emit(TicketClaimError(errorMessage: loadLocalizedData("SCRATCH_${errorResponse.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            emit(TicketClaimError(errorMessage: value["occurredErrorDescriptionMsg"]));
          });
    } catch (e) {
      print("error=========> $e");
      emit(TicketClaimError(errorMessage: "Technical Issue !"));
    }

  }
}

_onTicketValidationAndClaimEvent(TicketValidationAndClaimApi event, Emitter<TicketValidationAndClaimState> emit) async {
  emit(TicketValidationAndClaimLoading());

  BuildContext context  = event.context;
  var scratchList       = event.scratchList;

  /*{
    "barcodeNumber": "123456789000",
  "modelCode": "V2PRO",
  "terminalId": "NA",
  "userName": "demoret5",
  "userSessionId": "drxR2jMZvGO7MHKB-zZYCTJq529HVORqnh4qq6j0_x0"
  }*/

  var response = await TicketValidationAndClaimLogic.callTicketValidationAndClaimData(
      context,
      // SaleTicketRequest(
      //     gameType: "Scratch",
      //     soldChannel: "MOBILE",
      //     ticketNumberList: [
      //       event.barCodeText.toString(),
      //     ] ,
      //     userName: UserInfo.userName,
      //     modelCode: "V2PRO",
      //     terminalId: "NA",
      //     userSessionId: UserInfo.userToken
      // ).toJson(),
      TicketValidationRequest(
        barcodeNumber:  event.barCodeText.toString(),
          userName: UserInfo.userName,
          userSessionId:UserInfo.userToken
      ).toJson(),
      scratchList);

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(TicketValidationAndClaimError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          TicketValidationResponse successResponse = value as TicketValidationResponse;
          emit(TicketValidationAndClaimSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          TicketValidationResponse errorResponse = value as TicketValidationResponse;
          emit(TicketValidationAndClaimError(errorMessage: loadLocalizedData("SCRATCH_${errorResponse.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(TicketValidationAndClaimError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
    emit(TicketValidationAndClaimError(errorMessage: "Technical Issue !"));
  }
}
