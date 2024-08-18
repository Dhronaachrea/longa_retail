import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/home/home_logic.dart';
import 'package:longalottoretail/home/models/request/UserMenuListRequest.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/login/models/response/GetLoginDataResponse.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:longalottoretail/utility/user_info.dart';

import '../models/response/UserMenuApiResponse.dart';
import '../models/response/get_config_response.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GetUserMenuListApiData>(_onHomeEvent);
    on<GetConfigData>(_onConfigEvent);
  }
}

_onHomeEvent(GetUserMenuListApiData event, Emitter<HomeState> emit) async {
  emit(UserMenuListLoading());

  BuildContext context = event.context;

  var response = await HomeLogic.callUserMenuList(
      context,
      UserMenuListRequest(
        userId: UserInfo.userId,
        appType: appType,
        engineCode: clientId, // RMS
        languageCode: LongaLottoRetailApp.of(context).locale.languageCode,
      ).toJson());

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(UserMenuListError(
              errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          UserMenuApiResponse successResponse = value as UserMenuApiResponse;

          List<ModuleBeanLst> fetchGameListModuleBean = successResponse.responseData?.moduleBeanLst?.where((element) => element.moduleCode == "DRAW_GAME").toList() ?? [];
          if (fetchGameListModuleBean.isNotEmpty == true) {
            var fetchGameListMenuBean = fetchGameListModuleBean[0].menuBeanList?.where((element) => element.menuCode == "DGE_GAME_LIST").toList();
            if (fetchGameListMenuBean?.isNotEmpty == true) {
              UserInfo.setLotteryMenuBeanList(jsonEncode(fetchGameListMenuBean?[0]));
              UserInfo.setDrawGameBeanListData(jsonEncode(fetchGameListModuleBean[0]));
            }
          }

          emit(UserMenuListSuccess(response: successResponse));
        },
        responseFailure: (value) {
          UserMenuApiResponse errorResponse = value as UserMenuApiResponse;
          print("bloc responseFailure:");
          emit(UserMenuListError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(UserMenuListError(
              errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
    emit(UserMenuListError(errorMessage: "Technical Issue !"));
  }
}

_onConfigEvent(GetConfigData event, Emitter<HomeState> emit) async {
  emit(UserMenuListLoading());

  BuildContext context = event.context;

  GetLoginDataResponse loginResponse        = GetLoginDataResponse.fromJson(jsonDecode(UserInfo.getUserInfo));

  log("savedLoginResponse: $loginResponse");
  Map<String, String> param = {
    'domainId': "${loginResponse.responseData?.data?.domainId}" ?? "1",
  };

  var response = await HomeLogic.callConfigData(context, param);

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(UserConfigError(
              errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          GetConfigResponse successResponse = value as GetConfigResponse;
          emit(UserConfigSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          GetConfigResponse errorResponse = value as GetConfigResponse;
          emit(UserConfigError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", LongaLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(UserConfigError(
              errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
  }
}
