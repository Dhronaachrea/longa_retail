import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';
import 'package:longalottoretail/network/api_base_url.dart';
import 'package:longalottoretail/network/api_relative_urls.dart';
import 'package:longalottoretail/scratch/inventory/inventory_flow/model/response/inv_flow_response.dart';
import 'package:longalottoretail/scratch/inventory/inventory_flow/repository/inv_flow_repository.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:longalottoretail/utility/result.dart';

class InvFlowLogic {
  static Future<Result<dynamic>> callInvFlowReportAPI(BuildContext context,
      MenuBeanList? menuBeanList, Map<String, String> param) async {
    Map apiDetails = json.decode(menuBeanList?.apiDetails ?? "");
    String? endUrl = apiDetails[apiDetails.keys.first]['url'];
    Map headerValues = apiDetails[apiDetails.keys.first]['headers'];
    Map<String, String> header = {
      "clientId": scratchClientId /*headerValues['clientId']*/,
      "clientSecret": scratchClientSecret //merchantPwd ,  /*headerValues['clientSecret']*/
    };

    dynamic jsonMap = await InvFlowRepository.callInvFlowReportAPI(
        context,
        param,
        header,
        menuBeanList!.basePath ?? scratchUrl,
        inventoryFlowReportUrl, // endUrl ?? "/reports/inventoryFlowReport",
    );

    try {
      var respObj = InvFlowResponse.fromJson(jsonMap);
      if (respObj.responseCode == 1000) {
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
