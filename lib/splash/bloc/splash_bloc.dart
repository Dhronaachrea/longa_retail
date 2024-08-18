import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/home/home_logic.dart';
import 'package:longalottoretail/home/models/response/get_config_response.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/login/models/response/GetLoginDataResponse.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/splash/bloc/splash_event.dart';
import 'package:longalottoretail/splash/bloc/splash_state.dart';
import 'package:longalottoretail/splash/model/model/request/VersionControlRequest.dart';
import 'package:longalottoretail/splash/model/model/response/DefaultConfigData.dart';
import 'package:longalottoretail/splash/model/model/response/VersionControlResponse.dart';
import 'package:longalottoretail/splash/splash_logic.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:package_info_plus/package_info_plus.dart';


class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<VersionControlApi>(_onVersionControlApi);
    on<GetConfigData>(_onConfigEvent);
  }

  FutureOr<void> _onVersionControlApi(VersionControlApi event, Emitter<SplashState> emit) async {
    emit(VersionControlLoading());
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    BuildContext context = event.context;

    var request = VersionControlRequest(
      appType: "Cash",
      currAppVer: packageInfo.version,
      domainName: aliasName,
      os: "ANDROID",
      playerToken: UserInfo.userToken,
      playerId: (UserInfo.userId.toString())
    ).toJson();

    var response = await SplashLogic.callVersionControlApi(event.context, request);

    try {
      response.when(
          responseSuccess: (value) {
            print("bloc success");
            VersionControlResponse statusResponseModel = value as VersionControlResponse;
            print("bloc success: VersionControlSuccess");
            emit(VersionControlSuccess(response: statusResponseModel));
          },
          idle: () {},
          networkFault: (value) {
            emit(VersionControlError(errorMsg: context.l10n.no_internet));
          },
          responseFailure: (value) {
            print("======================>$value");
            VersionControlResponse errorResponse = value as VersionControlResponse;
            emit(VersionControlError(errorMsg: errorResponse.responseMessage ?? "Something went wrong "));

          },
          failure: (value) {
            print("splash bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
              emit(VersionControlError(errorMsg: context.l10n.no_internet,));
            } else {
              emit(VersionControlError(errorMsg: "Something went wrong "));
            }

          });
    } catch (e) {
      emit(VersionControlError(errorMsg: "Technical issue, Please try again."));
    }
  }

  _onConfigEvent(GetConfigData event, Emitter<SplashState> emit) async {
    emit(DefaultConfigLoading());

    BuildContext context = event.context;

    var response = await SplashLogic.getDefaultConfigApi(context);

    response.when(
        idle: () {},
        networkFault: (value) {
          emit(DefaultConfigError(
              errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          DefaultDomainConfigData successResponse = value as DefaultDomainConfigData;
          emit(DefaultConfigSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          DefaultDomainConfigData errorResponse = value as DefaultDomainConfigData;
          emit(DefaultConfigError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode)  ?? errorResponse.responseMessage ?? ""));
        },
        failure: (value) {
          print("=======>${value}");
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(DefaultConfigError(
              errorMessage: value["occurredErrorDescriptionMsg"]));
        });

    try {

    } catch (e) {
      print("error=========> $e");
    }
  }


}
