import 'dart:convert';

import 'package:longalottoretail/network/api_base_url.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/scratch/ticketValidationAndClaim/repository/ticket_validation_and_claim_repository.dart';
import 'package:longalottoretail/utility/result.dart';

import '../../network/api_relative_urls.dart';
import 'model/response/ticket_claim_response.dart';
import 'model/response/ticket_validation_response.dart';

class TicketValidationAndClaimLogic {
  static Future<Result<dynamic>> callTicketValidationAndClaimData(BuildContext context, Map<String, dynamic> param, var scratchList) async {
    // Map<dynamic, dynamic> apiDetails = json.decode(scratchList.apiDetails);
    Map apiDetails = json.decode(scratchList.apiDetails);
    String endUrl =  ticketValidationUrl; //apiDetails[apiDetails.keys.first]['url'];
    Map headerValues = apiDetails[apiDetails.keys.first]['headers'];
    Map<String, String> header = {
      "clientId": scratchClientId,//"RMS1",
      "clientSecret": scratchClientSecret, //"13f1JiFyWSZ0XI/3Plxr3mv7gbNObpU1",
      "Content-Type": headerValues['Content-Type']
    };

    dynamic jsonMap = await TicketValidationAndClaimRepository.callTicketValidationAndClaim(context, param, header,scratchList.basePath ?? scratchUrl, endUrl);

    try {
      var respObj = TicketValidationResponse.fromJson(jsonMap);
      if (respObj.responseCode == scratchResponseCode || verifyWinSuccessErrorCodes.contains(respObj.responseCode)) {
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

  static Future<Result<dynamic>> callTicketClaimData(BuildContext context, Map<String, dynamic> param, var scratchList) async {
    // Map<dynamic, dynamic> apiDetails = json.decode(scratchList.apiDetails);
    Map apiDetails = json.decode(scratchList.apiDetails);
    String endUrl =  ticketClaimUrl; //apiDetails[apiDetails.keys.first]['url'];
    Map headerValues = apiDetails[apiDetails.keys.first]['headers'];
    Map<String, String> header = {
      "clientId": scratchClientId,//"RMS1",
      "clientSecret": scratchClientSecret, //"13f1JiFyWSZ0XI/3Plxr3mv7gbNObpU1",
      "Content-Type": headerValues['Content-Type']
    };

    dynamic jsonMap = await TicketValidationAndClaimRepository.callTicketClaim(context, param, header,scratchList.basePath, endUrl);

    try {
      var respObj = TicketClaimResponse.fromJson(jsonMap);
      if (respObj.responseCode == scratchResponseCode) {
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

