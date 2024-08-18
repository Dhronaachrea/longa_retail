import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/scan_and_play/depositScreen/model/deposit_coupon_reversal/coupon_reversal_response.dart';
import 'package:longalottoretail/scan_and_play/depositScreen/repository/deposit_repository.dart';
import 'package:longalottoretail/utility/app_constant.dart';

import '../../utility/result.dart';
import '../../utility/user_info.dart';
import 'model/deposit_response.dart';

class DepositLogic {
  static Future<Result<dynamic>> depositData(
      BuildContext context, Map<String, dynamic> requestBody) async {
    Map<String, String> header = {
      "Authorization": "Bearer ${UserInfo.userToken}",
      "userId": UserInfo.userId,
      "merchantId": "1",
    };

    dynamic jsonMap =
        await DepositRepository.depositAmount(context, header, "", requestBody);

    try {
      var respObj = DepositResponse.fromJson(jsonMap);
      if (respObj.errorCode == 0) {
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

  static Future<Result<dynamic>> couponReversalApi(
      BuildContext context, Map<String, dynamic> requestBody) async {
    Map<String, String> header = {
      "Authorization" : "Bearer ${UserInfo.userToken}",
      "userId"        : UserInfo.userId,
      "merchantId"    : "1",
      "merchantPwd"   : merchantPwd
    };

    dynamic jsonMap = await DepositRepository.couponReversalApi(context, header, "", requestBody);

    try {
      var respObj = CouponReversalResponse.fromJson(jsonMap);
      if (respObj.errorCode == 0) {
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
