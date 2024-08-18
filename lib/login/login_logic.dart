import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/login/models/response/VerifyPosResponse.dart';
import 'package:longalottoretail/login/repository/login_repository.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:longalottoretail/utility/result.dart';
import 'package:longalottoretail/utility/user_info.dart';

import 'models/response/GetLoginDataResponse.dart';
import 'models/response/LoginTokenResponse.dart';

class LoginLogic {
  static Future<Result<dynamic>> callLoginTokenApi(BuildContext context, Map<String, String> loginInfo) async {

    Map<String, String> param = {
      "terminalId" : "NA",
      "modelCode"  : "NA"
    };

    Map<String, String> header = {
      "clientSecret"  : merchantPwd,
      "clientId"      : clientId,
      // "merchantCode"  : merchantCode,
      "username"      : loginInfo["userName"] ?? "NA",
      "password"      : loginInfo["password"] ?? "NA",
    };

    dynamic jsonMap = await LoginRepository.callLoginTokenApi(context, param, header);

    try {
      var respObj = LoginTokenResponse.fromJson(jsonMap);
      if (respObj.responseData?.statusCode == 0) {
        return Result.responseSuccess(data: respObj);

      } else {

        return jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap["occurredErrorDescriptionMsg"] == "No connection" ? Result.networkFault(data: jsonMap) : Result.failure(data: jsonMap) : Result.responseFailure(data: respObj);
      }

    } catch(e) {
      if(jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);

      } else {
        return Result.failure(data: jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap : {"occurredErrorDescriptionMsg": e});
      }
    }
  }

  static Future<Result<dynamic>> callGetLoginDataApi(BuildContext context) async {

    Map<String, String> header = {
      "Authorization"  : "Bearer ${UserInfo.userToken}",
    };

    dynamic jsonMap = await LoginRepository.callGetLoginDataApi(context, header);

    try {
      var respObj = GetLoginDataResponse.fromJson(jsonMap);
      if (respObj.responseData?.statusCode == 0) {
        return Result.responseSuccess(data: respObj);

      } else {
        return jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap["occurredErrorDescriptionMsg"] == "No connection" ? Result.networkFault(data: jsonMap) : Result.failure(data: jsonMap) : Result.responseFailure(data: respObj);
      }

    } catch(e) {
      if(jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);

      } else {
        return Result.failure(data: jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap : {"occurredErrorDescriptionMsg": e});
      }
    }
  }

  static Future<Result<dynamic>> callVerifyPosApi(BuildContext context, Map<String, dynamic> request) async {

    Map<String, String> header = {
      "Authorization"  : "Bearer ${UserInfo.userToken}",
    };

    dynamic jsonMap = await LoginRepository.callVerifyPosApi(context, header, request);

    try {
      var respObj = VerifyPosResponse.fromJson(jsonMap);
      if (respObj.responseData?.statusCode == 0) {
        return Result.responseSuccess(data: respObj);

      } else {
        return jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap["occurredErrorDescriptionMsg"] == "No connection" ? Result.networkFault(data: jsonMap) : Result.failure(data: jsonMap) : Result.responseFailure(data: respObj);
      }

    } catch(e) {
      if(jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);

      } else {
        return Result.failure(data: jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap : {"occurredErrorDescriptionMsg": e});
      }
    }
  }
}