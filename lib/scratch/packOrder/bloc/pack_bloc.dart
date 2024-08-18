import 'dart:developer';

import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/scratch/packOrder/bloc/pack_state.dart';
import 'package:longalottoretail/scratch/packOrder/game_details_logic.dart';
import 'package:longalottoretail/scratch/packOrder/model/PackOrderRequest.dart';
import 'package:longalottoretail/scratch/packOrder/model/game_details_response.dart';
import 'package:longalottoretail/scratch/packOrder/model/pack_order_response.dart';
import 'package:longalottoretail/scratch/packOrder/pack_order_logic.dart';
import 'package:longalottoretail/scratch/packReceive/book_receive_logic.dart';
import 'package:longalottoretail/scratch/packReceive/dl_details_logic.dart';
import 'package:longalottoretail/scratch/packReceive/model/book_receive_response.dart';
import 'package:longalottoretail/scratch/packReceive/model/dl_details_request.dart';
import 'package:longalottoretail/scratch/packReceive/model/dl_details_response.dart';
import 'package:longalottoretail/scratch/pack_activation/game_list_logic.dart';
import 'package:longalottoretail/scratch/pack_activation/model/game_list_request.dart';
import 'package:longalottoretail/scratch/pack_activation/model/game_list_response.dart';
import 'package:longalottoretail/scratch/pack_activation/model/pack_activation_response.dart';
import 'package:longalottoretail/scratch/pack_activation/pack_activation_logic.dart';
import 'package:longalottoretail/scratch/pack_return/model/pack_return_note_response.dart';
import 'package:longalottoretail/scratch/pack_return/model/response/game_vise_inventory_response.dart';
import 'package:longalottoretail/scratch/pack_return/model/response/pack_return_submit_response.dart';
import 'package:longalottoretail/scratch/pack_return/pack_return_note_logic.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pack_event.dart';


class PackBloc extends Bloc<PackEvent, PackState> {
  PackBloc() : super(PackInitial()) {
    on<PackApi>(_onPackOrderEvent);
    on<GameDetailsApi>(_onGameDetailsEvent);
    on<DlDetailsApi>(_onDiDetailsEvent);
    on<BookReceiveApi>(_onBookReceiveEvent);
    on<GameListApi>(_onGameListEvent);
    on<PackActivationApi>(_onPackActivationEvent);
    on<GameViseInventoryApi>(_onGameViseInventoryEvent);
    on<PackReturnNoteApi>(_onPackReturnNoteEvent);
    on<PackReturnSubmitApi>(_onPackReturnSubmitApi);
  }
}

_onPackOrderEvent(PackApi event, Emitter<PackState> emit) async {
  emit(PackLoading());

  BuildContext context  = event.context;
  var scratchList       = event.scratchList;
   var requestData     = event.requestData;

  /*{
    "barcodeNumber": "123456789000",
  "modelCode": "V2PRO",
  "terminalId": "NA",
  "userName": "demoret5",
  "userSessionId": "drxR2jMZvGO7MHKB-zZYCTJq529HVORqnh4qq6j0_x0"
  }*/

  var response = await PackOrderLogic.callPackOrderData(
      context,
      requestData.toJson(),
      scratchList
  );

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          PackOrderResponse successResponse = value as PackOrderResponse;
          emit(PackSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          PackOrderResponse errorResponse = value as PackOrderResponse;
          emit(PackError(errorMessage: loadLocalizedData("SCRATCH_${errorResponse.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
    emit(PackError(errorMessage: "Technical Issue !"));
  }
}

_onGameDetailsEvent(GameDetailsApi event, Emitter<PackState> emit) async {
  emit(PackLoading());

  BuildContext context  = event.context;
  var scratchList       = event.scratchList;

  var response = await GameDetailsLogic.callGameDetailsData(
      context,
      PackOrderRequest(
          userName: UserInfo.userName,
          userSessionId: UserInfo.userToken
      ).toJson(),
      scratchList);

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          GameDetailsResponse successResponse = value as GameDetailsResponse;

          emit(GameDetailsSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          GameDetailsResponse errorResponse = value as GameDetailsResponse;
          emit(PackError(errorMessage: loadLocalizedData("SCRATCH_${errorResponse.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
    emit(PackError(errorMessage: "Technical Issue !"));
  }
}

_onDiDetailsEvent(DlDetailsApi event, Emitter<PackState> emit) async {
  emit(PackLoading());

  BuildContext context  = event.context;
  var scratchList       = event.scratchList;
  String? barCodeText   = event.barCodeText;

  var response = await DlDetailsLogic.callDlDetailsData(
      context,
      DlDetailsRequest(
          dlChallanId: '',
          tag: '',
          dlChallanNumber: barCodeText,
          userName: UserInfo.userName,
          userSessionId: UserInfo.userToken
      ).toJson(),
      scratchList);

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          DlDetailsResponse successResponse = value as DlDetailsResponse;

          emit(DlDetailsSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          // GameDetailsResponse errorResponse = value as GameDetailsResponse;
          var errorResponse = value;
          emit(PackError(errorMessage: loadLocalizedData("SCRATCH_${errorResponse.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
    emit(PackError(errorMessage: "Technical Issue !"));
  }
}

_onBookReceiveEvent(BookReceiveApi event, Emitter<PackState> emit) async {
  emit(PackLoading());

  BuildContext context  = event.context;
  var scratchList       = event.scratchList;
  var requestData = event.requestData;

  var response = await BookReceiveLogic.callBookReceiveData(
      context,
      requestData.toJson(),
      scratchList);

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          BookReceiveResponse successResponse = value as BookReceiveResponse;

          emit(BookReceiveSuccess(response: successResponse));
        },
        responseFailure: (value) {
          log("bloc responseFailure: $value");
          BookReceiveResponse errorResponse = value as BookReceiveResponse;
          emit(PackError(errorMessage: loadLocalizedData("SCRATCH_${errorResponse.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));
        },
        failure: (value) {
          log("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    log("error=========> $e");
    emit(PackError(errorMessage: "Technical Issue !"));
  }
}

_onGameListEvent(GameListApi event, Emitter<PackState> emit) async {
  emit(PackLoading());

  BuildContext context  = event.context;
  var scratchList       = event.scratchList;

  var response = await GameListLogic.callGameListData(
      context,
      GameListRequest(
        request:  "{\"gameType\":\"SCRATCH\"}",
      ).toJson(),
      scratchList);

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          GameListResponse successResponse = value as GameListResponse;

          emit(GameListSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          GameListResponse errorResponse = value as GameListResponse;
          emit(PackError(errorMessage: loadLocalizedData("SCRATCH_${errorResponse.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
    emit(PackError(errorMessage: "Technical Issue !"));
  }
}

_onPackActivationEvent(PackActivationApi event, Emitter<PackState> emit) async {
  emit(PackLoading());

  BuildContext context  = event.context;
  var scratchList       = event.scratchList;
  var requestData = event.requestData;

  var response = await PackActivationLogic.callPackActivationData(
      context,
      requestData.toJson(),
      scratchList);

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          PackActivationResponse successResponse = value as PackActivationResponse;

          emit(PackActivationSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          PackActivationResponse errorResponse = value as PackActivationResponse;
          emit(PackError(errorMessage: loadLocalizedData("SCRATCH_${errorResponse.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
    emit(PackError(errorMessage: "Technical Issue !"));
  }
}

_onPackReturnNoteEvent(PackReturnNoteApi event, Emitter<PackState> emit) async {
  emit(PackLoading());

  BuildContext context  = event.context;
  var scratchList       = event.scratchList;
  var requestData       = event.requestData;

  var response = await PackReturnNoteLogic.callPackReturnNoteData(
      context,
      requestData.toJson(),
      scratchList);

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          PackReturnNoteResponse successResponse = value as PackReturnNoteResponse;

          emit(PackReturnNoteSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          var errorResponse = value;
          emit(PackError(errorMessage: loadLocalizedData("SCRATCH_${errorResponse.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
    emit(PackError(errorMessage: "Technical Issue !"));
  }
}

_onGameViseInventoryEvent(GameViseInventoryApi event, Emitter<PackState> emit) async {
  emit(PackLoading());

  BuildContext context  = event.context;
  var scratchList       = event.scratchList;
  var requestData       = event.requestData;

  var response = await PackReturnNoteLogic.callGameViseInventoryData(
      context,
      requestData.toJson(),
      scratchList);

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          GameViseInventoryResponse successResponse = value as GameViseInventoryResponse;

          emit(GameViseInventorySuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          var errorResponse = value;
          emit(PackError(errorMessage: loadLocalizedData("SCRATCH_${errorResponse.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
    emit(PackError(errorMessage: "Technical Issue !"));
  }
}

_onPackReturnSubmitApi(PackReturnSubmitApi event, Emitter<PackState> emit) async {
  emit(PackLoading());

  BuildContext context  = event.context;
  var scratchList       = event.scratchList;
  var requestData       = event.requestData;

  var response = await PackReturnNoteLogic.callPackReturnSubmitData(
      context,
      requestData.toJson(),
      scratchList);

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          PackReturnSubmitResponse successResponse = value as PackReturnSubmitResponse;

          emit(PackReturnSubmitSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          var errorResponse = value;
          emit(PackError(errorMessage: loadLocalizedData("SCRATCH_${errorResponse.responseCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(PackError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
    emit(PackError(errorMessage: "Technical Issue !"));
  }

}

