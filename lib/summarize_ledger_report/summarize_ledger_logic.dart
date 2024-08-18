import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/summarize_ledger_report/repository/summarize_ledger_repository.dart';
import '../utility/result.dart';
import '../utility/user_info.dart';
import 'model/response/summarize_date_wise_response.dart';
import 'model/response/summarize_defalut_response.dart';

class SummarizeLedgerLogic {
  static Future<Result<dynamic>> getSummarizeDateWise(
      BuildContext context, Map<String, dynamic>? params, String type) async {
    Map<String, String> header = {
      "Authorization": "Bearer ${UserInfo.userToken}"
    };

    dynamic jsonMap = await SummarizeLedgerRepository.getSummarizeLedgerReport(
        context, header, "", params);
    /*dynamic jsonMap = {
      "responseCode": 0,
      "responseMessage": "Success",
      "responseData": {
        "message": "Success",
        "statusCode": 0,
        "data": {
          "ledgerData": [
            {
              "key1": "400,00 ",
              "key2": "0,00 ",
              "rawNetAmount": "400",
              "netAmount": "400,00 ",
              "serviceCode": "DGE",
              "key1Name": "Sale",
              "serviceName": "DGE",
              "key2Name": "Winning"
            },
            {
              "key1": "200,00 ",
              "key2": "200,00 ",
              "rawNetAmount": "0",
              "netAmount": "0,00 ",
              "serviceCode": "PAY",
              "key1Name": "Credit",
              "serviceName": "Retail Payments",
              "key2Name": "Debit"
            },
            {
              "key1": "5600,00 ",
              "key2": "0,00 ",
              "rawNetAmount": "53600",
              "netAmount": "53600,00 ",
              "serviceCode": "PPL",
              "key1Name": "Sale",
              "serviceName": "Scratch",
              "key2Name": "Winning"
            },{
              "key1": "400,00 ",
              "key2": "0,00 ",
              "rawNetAmount": "400",
              "netAmount": "400,00 ",
              "serviceCode": "DGE",
              "key1Name": "Sale",
              "serviceName": "DGE",
              "key2Name": "Winning"
            },
            {
          "key1": "200,00 ",
          "key2": "20,00 ",
          "rawNetAmount": "200",
          "netAmount": "200,00 ",
          "serviceCode": "DGE",
          "key1Name": "Sale",
          "serviceName": "DGE",
          "key2Name": "Winning"
        },
          ],
          "rawClosingBalance": 46400,
          "rawOpeningBalance": 0,
          "closingBalance": "4400,00 ",
          "openingBalance": "0,00 "
        }
      }
    };*/
    try {
      var respObj;

      if (type == "default") {
        respObj = SummarizeDefaultResponse.fromJson(jsonMap);
      } else {
        respObj = SummarizeDateWiseResponse.fromJson(jsonMap);
      }
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
