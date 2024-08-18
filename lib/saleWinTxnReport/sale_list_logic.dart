import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/saleWinTxnReport/repository/sale_win_repository.dart';

import '../utility/result.dart';
import '../utility/user_info.dart';
import 'model/get_sale_report_response.dart';
import 'model/get_service_list_response.dart';

class SaleListLogic {
  static Future<Result<dynamic>> getSaleList(BuildContext context) async {
    Map<String, String> header = {
      "Authorization": "Bearer ${UserInfo.userToken}"
    };

    dynamic jsonMap = await SaleWinRepository.getSaleList(
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



  static Future<Result<dynamic>> getSaleTxnReport(
      BuildContext context, Map<String, dynamic> requestBody) async {
    Map<String, String> header = {
      "Authorization" : "Bearer ${UserInfo.userToken}"
    };


    dynamic jsonMap = await SaleWinRepository.getSaleWinTaxReport(
        context, header,requestBody);

    try {
      var respObj = GetSaleReportResponse.fromJson(jsonMap);
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
