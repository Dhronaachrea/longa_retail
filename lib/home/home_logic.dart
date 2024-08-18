import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/home/repository/home_repository.dart';
import 'package:longalottoretail/utility/result.dart';

import '../utility/user_info.dart';
import 'models/response/UserMenuApiResponse.dart';
import 'models/response/get_config_response.dart';

class HomeLogic {
  static Future<Result<dynamic>> callUserMenuList(
      BuildContext context, Map<String, String> param) async {
    Map<String, String> header = {
      "Authorization" : "Bearer ${UserInfo.userToken}"
    };

    dynamic jsonMap =
        await HomeRepository.callUserMenuList(context, param, header);

    try {
      var respObj = UserMenuApiResponse.fromJson(jsonMap);
      if (respObj.responseData?.statusCode == 0) {
        return Result.responseSuccess(data: respObj);
      } else {
        return jsonMap["occurredErrorDescriptionMsg"] != null
            ? jsonMap["occurredErrorDescriptionMsg"] == "No connection"
                ? Result.networkFault(data: jsonMap)
                : Result.failure(data: jsonMap)
            : Result.responseFailure(data: respObj);
      }
    } catch (e) {
      if (jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);
      } else {
        return Result.failure(
            data: jsonMap["occurredErrorDescriptionMsg"] != null
                ? jsonMap
                : {"occurredErrorDescriptionMsg": e});
      }
    }
  }


  static Future<Result<dynamic>> callConfigData(
      BuildContext context, Map<String, String> param) async {
    Map<String, String> header = {
      "Authorization" : "Bearer ${UserInfo.userToken}"
    };

    dynamic jsonMap =
        await HomeRepository.getConfigResponse(context, param, header);

    try {
      var respObj = GetConfigResponse.fromJson(jsonMap);
      if (respObj.responseCode == 0) {
        return Result.responseSuccess(data: respObj);
      } else {
        return jsonMap["occurredErrorDescriptionMsg"] != null
            ? jsonMap["occurredErrorDescriptionMsg"] == "No connection"
                ? Result.networkFault(data: jsonMap)
                : Result.failure(data: jsonMap)
            : Result.responseFailure(data: respObj);
      }
    } catch (e) {
      if (jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);
      } else {
        return Result.failure(
            data: jsonMap["occurredErrorDescriptionMsg"] != null
                ? jsonMap
                : {"occurredErrorDescriptionMsg": e});
      }
    }
  }
}
