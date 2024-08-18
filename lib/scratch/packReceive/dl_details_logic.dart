import 'dart:convert';
import 'package:longalottoretail/network/api_base_url.dart';
import 'package:longalottoretail/network/api_relative_urls.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/scratch/packReceive/model/dl_details_response.dart';
import 'package:longalottoretail/scratch/packReceive/repository/dl_details_repository.dart';
import 'package:longalottoretail/utility/result.dart';

class DlDetailsLogic {
  static Future<Result<dynamic>> callDlDetailsData(BuildContext context, Map<String, dynamic> param, var scratchList) async {
    Map apiDetails = json.decode(scratchList.apiDetails);
    String endUrl = dlDetailsUrl ; //apiDetails['dlDetails']['url'];
    Map headerValues = apiDetails[apiDetails.keys.first]['headers'];
    Map<String, String> header = {
      "clientId": scratchClientId,
      "clientSecret": scratchClientSecret, //"13f1JiFyWSZ0XI/3Plxr3mv7gbNObpU1",
      "Content-Type": headerValues['Content-Type']
    };
    // Map<String, String> header = {
    //   "clientId": headerValues['clientId'],
    //   "clientSecret": headerValues['clientSecret'],
    //   "Content-Type": headerValues['Content-Type']
    // };

    dynamic jsonMap = await DlDetailsRepository.callDlDetails(context, param, header, scratchList.basePath ?? scratchUrl, endUrl);

    try {
      var respObj = DlDetailsResponse.fromJson(jsonMap);
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

