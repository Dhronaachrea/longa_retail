import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/balance_invoice_report/models/response/balance_invoice_report_response.dart';
import 'package:longalottoretail/balance_invoice_report/repository/balance_invoice_report_repository.dart';

import '../utility/result.dart';
import '../utility/user_info.dart';

class BalanceInvoiceReportLogic {
  static Future<Result<dynamic>> callBalanceInvoiceReportApi(
      BuildContext context, Map<String, String> param) async {
    Map<String, String> header = {
       "Authorization" : "Bearer ${UserInfo.userToken}"
    };

    dynamic jsonMap = await BalanceInvoiceReportRepository.callBalanceInvoiceReportApi(
        context, param, header);

    try {
      var respObj = BalanceInvoiceReportResponse.fromJson(jsonMap);
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
