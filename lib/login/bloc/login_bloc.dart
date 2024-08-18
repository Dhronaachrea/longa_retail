import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/login/login_logic.dart';
import 'package:longalottoretail/login/models/request/VerifyPosRequest.dart';
import 'package:longalottoretail/login/models/response/GetLoginDataResponse.dart';
import 'package:longalottoretail/login/models/response/LoginTokenResponse.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/splash/model/model/request/VersionControlRequest.dart';
import 'package:longalottoretail/splash/model/model/response/DefaultConfigData.dart';
import 'package:longalottoretail/splash/model/model/response/VersionControlResponse.dart';
import 'package:longalottoretail/splash/splash_logic.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:longalottoretail/utility/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/response/VerifyPosResponse.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginTokenApi>(_onLoginTokenApiEvent);
    on<GetLoginDataApi>(_onGetLoginDataEvent);
    on<VerifyPosApi>(_onVerifyPosEvent);
    on<VersionControlApi>(_onVersionControlApi);
    on<GetConfigData>(_onConfigEvent);
  }


  _onLoginTokenApiEvent(LoginTokenApi event, Emitter<LoginState> emit) async {
    emit(LoginTokenLoading());
    BuildContext context      = event.context;
    String userName           = event.userName;
    String encryptedPassword  = encryptMd5(event.password);

    Map<String, String> loginInfo = {
        "userName"    : userName,
        "password"    : encryptedPassword
    };

    var response = await LoginLogic.callLoginTokenApi(context, loginInfo);

    try {
      response.when(idle: () {

      },
          networkFault: (value) {
            emit(LoginTokenError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          },
          responseSuccess: (value) {
            LoginTokenResponse successResponse = value as LoginTokenResponse;
            String playerId = (successResponse.responseData?.userId != null) ? successResponse.responseData!.userId.toString() : "";
            UserInfo.setPlayerToken( successResponse.responseData?.authToken ?? "");
            UserInfo.setPlayerId(playerId);
            emit(LoginTokenSuccess(response: successResponse));
          },
          responseFailure: (value) {
            LoginTokenResponse errorResponse = value as LoginTokenResponse;
            print("bloc responseFailure: ${errorResponse.responseData?.message} =======> ");

            emit(LoginTokenError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            emit(LoginTokenError(errorMessage: value["occurredErrorDescriptionMsg"]));
          });
    } catch (e) {
      print("error=========> $e");
    }
  }

  _onGetLoginDataEvent(GetLoginDataApi event, Emitter<LoginState> emit) async {
    emit(GetLoginDataLoading());
    BuildContext context      = event.context;

    var response = await LoginLogic.callGetLoginDataApi(context);
    response.when(idle: () {

    },
        networkFault: (value) {
          emit(GetLoginDataError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          print("-------------------------------------------------------------------------------------------------------------------->");
          GetLoginDataResponse successResponse = value as GetLoginDataResponse;
          String orgId = successResponse.responseData?.data?.orgId?.toString() ?? "";
          print("orgId: $orgId");
          print("UserInfo.organisationID: ${UserInfo.organisationID}");
          if(UserInfo.organisationID != orgId) {
            UserInfo.setLastSaleTicketNo("0");

          }

          UserInfo.setTotalBalance(successResponse.responseData?.data?.balance?.toString() ?? "");
          UserInfo.setOrganisation(successResponse.responseData?.data?.orgCode?.toString() ?? "");
          UserInfo.setDisplayCommission(successResponse.responseData?.data?.displayCommision ?? "");
          UserInfo.setOrganisationId(successResponse.responseData?.data?.orgId?.toString() ?? "");
          UserInfo.setDomainId(successResponse.responseData?.data?.domainId?.toString() ?? "");
          UserInfo.setUserName(successResponse.responseData?.data?.username?.toString() ?? "");
          UserInfo.setUserInfoData(jsonEncode(successResponse));
          GetLoginDataResponse loginResponse        = GetLoginDataResponse.fromJson(jsonDecode(UserInfo.getUserInfo));
          print("loginResponse.responseData?.data?.orgName: ${loginResponse.responseData?.data?.orgName}");
          emit(GetLoginDataSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          GetLoginDataResponse errorResponse = value as GetLoginDataResponse;
          emit(GetLoginDataError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode)?? errorResponse.responseData?.message ?? ""));
        },
        failure: (value) {

          print("bloc failure: ${value}");
          print("bloc failure: ${value["OS Error:"]}");
          emit(GetLoginDataError(errorMessage: "Something Went Wrong!"));
        });
    try {

    } catch (e) {
      print("error=========> $e");
    }
  }

  _onVerifyPosEvent(VerifyPosApi event, Emitter<LoginState> emit) async {
    emit(VerifyPosLoading());
    BuildContext context      = event.context;
    String latitude = event.latitude;
    String longitudes = event.longitude;

    var response = await LoginLogic.callVerifyPosApi(context, VerifyPosRequest(
      latitudes: latitude ?? "0",
      longitudes: longitudes ?? "0",
      modelCode: "telpoM1",
      simType: "MTN",
      terminalId: "A24M001000500314",
      version: "1.0.0"
    ).toJson());
    response.when(idle: () {

    },
    networkFault: (value) {
      emit(VerifyPosError(errorMessage: value["occurredErrorDescriptionMsg"]));
    },
    responseSuccess: (value) {
      VerifyPosResponse successResponse = value as VerifyPosResponse;
      emit(VerifyPosSuccess(response: successResponse));
    },
    responseFailure: (value) {
      VerifyPosResponse errorResponse = value as VerifyPosResponse;
      print("bloc responseFailure:");
      emit(VerifyPosError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
    },
    failure: (value) {
      print("bloc failure: ${value}");
      emit(VerifyPosError(errorMessage: "Something Went Wrong!"));
    });
    try {

    } catch (e) {
      print("error=========> $e");
    }
  }

  FutureOr<void> _onVersionControlApi(VersionControlApi event, Emitter<LoginState> emit) async {
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
            emit(DefaultConfigError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));

          },
          failure: (value) {
            print("splash bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
              emit(VersionControlError(errorMsg: context.l10n.no_internet,));
            } else {
              emit(VersionControlError(errorMsg: value["occurredErrorDescriptionMsg"] ?? "Something went wrong "));
            }

          });
    } catch (e) {
      emit(VersionControlError(errorMsg: "Technical issue, Please try again. $e"));
    }
  }

  _onConfigEvent(GetConfigData event, Emitter<LoginState> emit) async {
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
