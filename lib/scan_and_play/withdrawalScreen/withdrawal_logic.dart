import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/scan_and_play/withdrawalScreen/model/Pending_withdrawal_response.dart';
import 'package:longalottoretail/scan_and_play/withdrawalScreen/repository/withdrawal_repository.dart';

import '../../utility/result.dart';
import '../../utility/user_info.dart';
import 'model/update_qr_withdrawal_response.dart';


class WithdrawalLogic {
  static Future<Result<dynamic>> pendingWithdrawal(
      BuildContext context, Map<String, String> param) async {
    Map<String, String> header = {
      "Authorization": "Bearer ${UserInfo.userToken}",
      "userId": UserInfo.userId,
      "merchantId": "1",
    };
    dynamic jsonMap =
        await WithdrawalRepository.checkPendingQrCode(context, param, header);

    try {
      var respObj = PendingWithdrawalResponse.fromJson(jsonMap);
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


  static Future<Result<dynamic>> updatePendingWithdrawal(
      BuildContext context, Map<String, dynamic>? requestBody) async {
    Map<String, String> header = {
      "Authorization": "Bearer ${UserInfo.userToken}",
      "userId": UserInfo.userId,
      "merchantId": "1",
    };

    dynamic jsonMap =
    await WithdrawalRepository.updatePendingQrCode(context, header,requestBody);

    try {
      var respObj = UpdateQRWithdrawalResponse.fromJson(jsonMap);
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
