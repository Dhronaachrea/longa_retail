import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/ledger_report/repository/ledger_report_repository.dart';

import '../utility/result.dart';
import '../utility/user_info.dart';
import 'models/response/ledgerReportApiResponse.dart';

class LedgerReportLogic {
  static Future<Result<dynamic>> callLedgerReportList(
      BuildContext context, Map<String, String> param) async {
    Map<String, String> header = {
       "Authorization" : "Bearer ${UserInfo.userToken}"
    };

    dynamic jsonMap = await LedgerReportRepository.callLedgerReportList(
        context, param, header);

    try {
      var respObj = LedgerReportApiResponse.fromJson(jsonMap);
      if (respObj.responseCode == 0 &&
          respObj.responseData!.statusCode != 102) {
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
