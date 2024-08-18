import 'dart:convert';

import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';
import 'package:longalottoretail/network/api_base_url.dart';
import 'package:longalottoretail/network/api_relative_urls.dart';
import 'package:longalottoretail/scratch/inventory/inventory_report/model/response/inv_rep_response.dart';
import 'package:longalottoretail/scratch/inventory/inventory_report/repository/inv_rep_repository.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:longalottoretail/utility/result.dart';
import 'package:flutter/material.dart';

class InvRepLogic {
  static Future<Result<dynamic>> callInvDetailsForRetailerAPI(
      BuildContext context,
      MenuBeanList? menuBeanList,
      Map<String, String> param) async {
    Map apiDetails = json.decode(menuBeanList?.apiDetails ?? "");
    String? endUrl = apiDetails[apiDetails.keys.first]['url'];
    Map headerValues = apiDetails[apiDetails.keys.first]['headers'];
    Map<String, String> header = {
      "clientId": scratchClientId,//headerValues['clientId'] /*"RMS"*/,
      "clientSecret": scratchClientSecret//headerValues['clientSecret'] /*"13f1JiFyWSZ0XI/3Plxr3mv7gbNObpU2" */
    };

    dynamic jsonMap = await InvRepRepository.callInvDetailsForRetailerAPI(
        context, param, header,menuBeanList!.basePath ?? scratchUrl, inventoryReportUrl /*endUrl ?? "/reports/getInventoryDetailsForRetailer"*/);

    try {
      var respObj = InvRepResponse.fromJson(jsonMap);
      if (respObj.responseCode == 1000) {
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
