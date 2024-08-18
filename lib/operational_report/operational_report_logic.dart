import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/operational_report/models/response/operational_cash_report_response.dart';
import 'package:longalottoretail/operational_report/repository/operational_report_repository.dart';
import 'package:longalottoretail/saleWinTxnReport/model/get_service_list_response.dart';

import '../utility/result.dart';
import '../utility/user_info.dart';

class OperationalReportLogic {

  static Future<Result<dynamic>> callLedgerReportList(BuildContext context, Map<String, String> param) async {
    Map<String, String> header = {
       "Authorization" : "Bearer ${UserInfo.userToken}"
    };

    dynamic jsonMap = await OperationalReportRepository.callOperationalReportList(
        context,
        param,
        header
    );

    try {

      var respObj = OperationalCashReportResponse.fromJson(jsonMap);
      if (respObj.responseCode == 0 && respObj.responseData!.statusCode != 102) {
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

  static Future<Result<dynamic>> getSaleList(BuildContext context) async {
    Map<String, String> header = {
      "Authorization": "Bearer ${UserInfo.userToken}"
    };

    dynamic jsonMap = await OperationalReportRepository.getSaleList(
        context, header, "");

    try {
      var respObj = GetServiceListResponse.fromJson(jsonMap);
      if (respObj.responseCode == 0 && respObj.responseData?.statusCode == 0) {
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
