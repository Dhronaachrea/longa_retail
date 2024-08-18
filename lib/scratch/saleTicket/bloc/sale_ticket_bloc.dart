import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/scratch/saleTicket/model/request/remaining_ticket_count_request.dart';
import 'package:longalottoretail/scratch/saleTicket/model/response/remaining_ticket_count_response.dart';
import 'package:longalottoretail/scratch/saleTicket/model/response/sale_ticket_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/scratch/saleTicket/bloc/sale_ticket_event.dart';
import 'package:longalottoretail/scratch/saleTicket/bloc/sale_ticket_state.dart';
import 'package:longalottoretail/scratch/saleTicket/model/request/SaleTicketRequest.dart';
import 'package:longalottoretail/scratch/saleTicket/sale_ticket_logic.dart';
import 'package:longalottoretail/utility/user_info.dart';

class SaleTicketBloc extends Bloc<SaleTicketEvent, SaleTicketState> {
  SaleTicketBloc() : super(SaleTicketInitial()) {
    on<SaleTicketApi>(_onSaleTicketEvent);
    on<RemainingTicketCountApi>(_onRemainingTicketCountEvent);
  }
}

_onSaleTicketEvent(SaleTicketApi event, Emitter<SaleTicketState> emit) async {
  emit(SaleTicketLoading());

  BuildContext context  = event.context;
  var scratchList       = event.scratchList;

  /*{
    "barcodeNumber": "123456789000",
  "modelCode": "V2PRO",
  "terminalId": "NA",
  "userName": "demoret5",
  "userSessionId": "drxR2jMZvGO7MHKB-zZYCTJq529HVORqnh4qq6j0_x0"
  }*/

  var response = await SaleTicketLogic.callSaleTicketData(
      context,
      SaleTicketRequest(
        gameType: "Scratch", //required
        soldChannel: "WEB", //required "TERMINAL" - for pos
        ticketNumberList: event.ticketNumberList ,
        userName: UserInfo.userName, //required
        //modelCode: androidInfo?.model ?? "TelpoM1","V2PRO", - required only for pos
        terminalId: "NA",
        userSessionId: UserInfo.userToken,
          //retailerOrgId : UserInfo.organisationID
        fromTicket: event.fromTicket,
        toTicket: event.toTicket,
      ).toJson(),
      scratchList);

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(SaleTicketError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          SaleTicketResponse successResponse = value as SaleTicketResponse;

          emit(SaleTicketSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          SaleTicketResponse errorResponse = value as SaleTicketResponse;
          emit(SaleTicketError(errorMessage: loadLocalizedData("SCRATCH_${errorResponse.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(SaleTicketError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
    emit(SaleTicketError(errorMessage: "Technical Issue !"));
  }
}

_onRemainingTicketCountEvent(RemainingTicketCountApi event, Emitter<SaleTicketState> emit) async {
  emit(RemainingTicketCountLoading());

  BuildContext context  = event.context;
  var scratchList       = event.scratchList;

  var response = await SaleTicketLogic.callRemainingTicketCountData(
      context,
      RemainingTicketCountRequest(
        bookNumber: event.bookNumber,
        userName: UserInfo.userName,
        userSessionId: UserInfo.userToken,
      ).toJson(),
      scratchList);

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(RemainingTicketCountError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          RemainingTicketCountResponse successResponse = value as RemainingTicketCountResponse;

          emit(RemainingTicketCountSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          RemainingTicketCountResponse errorResponse = value as RemainingTicketCountResponse;
          emit(RemainingTicketCountError(errorMessage: loadLocalizedData("SCRATCH_${errorResponse.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(RemainingTicketCountError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
    emit(RemainingTicketCountError(errorMessage: "Technical Issue !"));
  }
}
