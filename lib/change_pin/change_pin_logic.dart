import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/change_pin/repository/change_pin_repository.dart';

import '../utility/result.dart';
import '../utility/user_info.dart';
import 'model/response/change_pin_response.dart';

class ChangePinLogic {
  static Future<Result<dynamic>> onChangePin(
      BuildContext context, Map<String, dynamic> requestBody,
      Map<String, String> param) async {
    Map<String, String> header = {
       "Authorization" : "Bearer ${UserInfo.userToken}"
    };


    dynamic jsonMap = await ChangePinRepository.callChangePinApi(
        context, param, header,requestBody);

    try {
      var respObj = ChangePinResponse.fromJson(jsonMap);
      if (respObj.responseCode == 0 &&
          respObj.responseData?.statusCode == 0) {
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
