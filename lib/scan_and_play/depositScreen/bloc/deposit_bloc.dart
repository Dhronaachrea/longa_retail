import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/scan_and_play/depositScreen/bloc/deposit_event.dart';
import 'package:longalottoretail/scan_and_play/depositScreen/bloc/deposit_state.dart';
import 'package:longalottoretail/scan_and_play/depositScreen/model/deposit_coupon_reversal/coupon_reversal_request.dart';
import 'package:longalottoretail/scan_and_play/depositScreen/model/deposit_coupon_reversal/coupon_reversal_response.dart';
import 'package:longalottoretail/scan_and_play/depositScreen/model/deposit_request.dart';
import 'package:longalottoretail/utility/user_info.dart';

import '../../../main.dart';
import '../../../utility/app_constant.dart';
import '../../../utility/longa_lotto_pos_color.dart';
import '../../../utility/longa_lotto_pos_screens.dart';
import '../../../utility/shared_pref.dart';
import '../../../utility/utils.dart';
import '../deposit_logic.dart';
import '../model/deposit_response.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  DepositBloc() : super(DepositInitial()) {
    on<DepositApiData>(_getDepositResponse);
    on<CouponReversalApi>(_getCouponReversal);
  }

  _getDepositResponse(
      DepositApiData event, Emitter<DepositState> emitter) async {
    emit(DepositLoading());

    BuildContext context = event.context;

    DepositRequest model = DepositRequest(
        aliasName: SharedPrefUtils.getAliasName,
        deviceType: terminal,
        appType: appType,
        couponCount: 1,
        responseType: responseType,
        retailerName: UserInfo.userName,
        amount: event.amount,
        gameCode: gameCode,
        serviceCode: serviceCode,
        providerCode: serviceCode);

    Map<String, dynamic>? _model = model.toJson();

    var response = await DepositLogic.depositData(context, _model);
    try {
      response.when(
          idle: () {},
          networkFault: (value) {
            emit(DepositError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          },
          responseSuccess: (value) {
            DepositResponse _response = value as DepositResponse;

            emit(DepositSuccess(response: _response));
          },
          responseFailure: (value) {
            DepositResponse errorResponse = value as DepositResponse;
            print(
                "bloc responseFailure: ${errorResponse.errorMessage} =======> ");

            if (errorResponse.errorCode == 12429) {
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
            }
            else {
              emit(DepositError(
                  errorMessage:loadLocalizedData("BONUS_${errorResponse.errorCode ?? ""}",SharedPrefUtils.getLocaleConfig) ?? errorResponse.errorMessage ?? ""));

            //  emit(DepositError(errorMessage:  errorResponse.errorMessage.toString() ));
            }
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            emit(DepositError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          });
    } catch (e) {
      print("error=========> $e");
    }
  }

  _getCouponReversal(CouponReversalApi event, Emitter<DepositState> emitter) async {
    emit(CouponReversalLoading());

    BuildContext context = event.context;

    CouponReversalRequest model = CouponReversalRequest(
        aliasName: SharedPrefUtils.getAliasName,
        deviceType: terminal,
        couponCode: event.couponCode,
        gameCode: gameCode,
        serviceCode: serviceCode,
        providerCode: serviceCode);

    Map<String, dynamic>? _model = model.toJson();

    var response = await DepositLogic.couponReversalApi(context, _model);
    try {
      response.when(
          idle: () {},
          networkFault: (value) {
            emit(CouponReversalError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          },
          responseSuccess: (value) {
            CouponReversalResponse _response = value as CouponReversalResponse;

            emit(CouponReversalSuccess(response: _response));
          },
          responseFailure: (value) {
            CouponReversalResponse errorResponse = value as CouponReversalResponse;
            print(
                "bloc responseFailure: ${errorResponse.errorMessage} =======> ");

            emit(CouponReversalError(
                errorMessage:loadLocalizedData("BONUS_${errorResponse.errorCode ?? ""}", SharedPrefUtils.getLocaleConfig) ?? errorResponse.errorMessage ?? ""));
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            emit(CouponReversalError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          });
    } catch (e) {
      print("error=========> $e");
    }
  }
}
