import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/scan_and_play/withdrawalScreen/bloc/withdrawal_event.dart';
import 'package:longalottoretail/scan_and_play/withdrawalScreen/bloc/withdrawal_state.dart';

import '../../../l10n/l10n.dart';
import '../../../utility/longa_lotto_pos_color.dart';
import '../../../utility/longa_lotto_pos_screens.dart';
import '../../../utility/shared_pref.dart';
import '../../../utility/user_info.dart';
import '../../../utility/utils.dart';
import '../model/Pending_withdrawal_response.dart';
import '../model/update_qr_withdrawal_response.dart';
import '../withdrawal_logic.dart';

class WithdrawalBloc extends Bloc<WithdrawalEvent, WithdrawalState> {
  WithdrawalBloc() : super(PendingWithdrawalInitial()) {
    on<PendingWithdrawalApiData>(_getPendingWithdrawalResponse);
    on<UpdateWithdrawalApiData>(_getUpdateWithdrawalQRResponse);
  }

  _getPendingWithdrawalResponse(
      PendingWithdrawalApiData event, Emitter<WithdrawalState> emitter) async {
    emit(PendingWithdrawalLoading());

    BuildContext context = event.context;
    Map<String, String> params = {"userName": event.id};

    var response = await WithdrawalLogic.pendingWithdrawal(context, params);
    try {
      response.when(
          idle: () {},
          networkFault: (value) {
            emit(PendingWithdrawalError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          },
          responseSuccess: (value) {
            PendingWithdrawalResponse _response =
                value as PendingWithdrawalResponse;

            emit(PendingWithdrawalSuccess(response: _response));
          },
          responseFailure: (value) {
            PendingWithdrawalResponse errorResponse =
                value as PendingWithdrawalResponse;
            print("bloc responseFailure: ${errorResponse.errorMsg} =======> ");
            if (errorResponse.errorCode == 2007) {
              // session expire
              BuildContext? context = navigatorKey.currentContext;
              UserInfo.logout();
              if (context != null) {
                Navigator.of(context).popUntil((route) => false);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: LongaLottoPosColor.tomato,
                  content: const Text("Session Expired, Please Login",
                      style: TextStyle(color: LongaLottoPosColor.white)),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height - 100,
                      right: 20,
                      left: 20),
                ));
                Navigator.of(context).pushNamed(LongaLottoPosScreen.loginScreen);
              }
            }else {
              emit(PendingWithdrawalError(
                  errorMessage:loadLocalizedData("CASHIER_${errorResponse.errorCode ?? ""}",SharedPrefUtils.getLocaleConfig) ?? errorResponse.errorMsg ?? ""));
            }
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            emit(PendingWithdrawalError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          });
    } catch (e) {
      print("error=========> $e");
    }
  }

  _getUpdateWithdrawalQRResponse(
      UpdateWithdrawalApiData event, Emitter<WithdrawalState> emitter) async {
    emit(UpdateWithdrawalLoading());

    BuildContext context = event.context;

     var data = event.updateQrWithdrawalRequest;

    Map<String, dynamic>? _model = data.toJson();

    var response = await WithdrawalLogic.updatePendingWithdrawal(context, _model);

    try {
      response.when(
          idle: () {},
          networkFault: (value) {
            emit(UpdateWithdrawalError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          },
          responseSuccess: (value) {
            UpdateQRWithdrawalResponse _response = value as UpdateQRWithdrawalResponse;
            log("UpdateWithdrawalSuccessUpdateWithdrawalSuccessUpdateWithdrawalSuccessUpdateWithdrawalSuccessUpdateWithdrawalSuccessUpdateWithdrawalSuccessUpdateWithdrawalSuccess");
            emit(UpdateWithdrawalSuccess(response: _response));
          },
          responseFailure: (value) {
            UpdateQRWithdrawalResponse errorResponse =
                value as UpdateQRWithdrawalResponse;
            print("bloc responseFailure: ${errorResponse.errorMsg} =======> ");
            if (errorResponse.errorCode == 2007) {
              // session expire
              BuildContext? context = navigatorKey.currentContext;
              UserInfo.logout();
              if (context != null) {
                Navigator.of(context).popUntil((route) => false);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: LongaLottoPosColor.tomato,
                  content: const Text("Session Expired, Please Login",
                      style: TextStyle(color: LongaLottoPosColor.white)),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height - 100,
                      right: 20,
                      left: 20),
                ));
                Navigator.of(context).pushNamed(LongaLottoPosScreen.loginScreen);
              }
            }else {
              emit(UpdateWithdrawalError(
                  errorMessage: loadLocalizedData("CASHIER_${errorResponse.errorCode ?? ""}", SharedPrefUtils.getLocaleConfig) ?? errorResponse.errorMsg ?? ""));
            }
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            emit(UpdateWithdrawalError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          });
    } catch (e) {
      print("error=========> $e");
    }
  }
}
