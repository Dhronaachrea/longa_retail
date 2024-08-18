import 'dart:convert';

import 'package:longalottoretail/network/api_base_url.dart';
import 'package:longalottoretail/network/api_relative_urls.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/scratch/saleTicket/repository/sale_ticket_repository.dart';
import 'package:longalottoretail/utility/result.dart';

import 'model/response/remaining_ticket_count_response.dart';
import 'model/response/sale_ticket_response.dart';

class SaleTicketLogic {
  static Future<Result<dynamic>> callSaleTicketData(BuildContext context, Map<String, dynamic> param, var scratchList) async {
    // Map<dynamic, dynamic> apiDetails = json.decode(scratchList.apiDetails);
    Map apiDetails = json.decode(scratchList.apiDetails);
    String endUrl = soldTicketUrl ; //apiDetails[apiDetails.keys.first]['url'];
    Map headerValues = apiDetails[apiDetails.keys.first]['headers'];
    Map<String, String> header = {
      "clientId": scratchClientId,//"RMS1",
      "clientSecret": scratchClientSecret, // scratchClientSecret, ph2Nj5knd4IjWBVLc4mhmYHo1hQDEdS3FlIC2KskHpeHFhsqxD
      "Content-Type": headerValues['Content-Type']
    };

    dynamic jsonMap = await SaleTicketRepository.callSaleTicket(context, param, header,scratchList.basePath ?? scratchUrl, endUrl);

    try {
      var respObj = SaleTicketResponse.fromJson(jsonMap);
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
  static Future<Result<dynamic>> callRemainingTicketCountData(BuildContext context, Map<String, dynamic> param, var scratchList) async {
    Map apiDetails = json.decode(scratchList.apiDetails);
    String endUrl = remainingTicketCount ;
    Map headerValues = apiDetails[apiDetails.keys.first]['headers'];
    Map<String, String> header = {
      "clientId": scratchClientId,
      "clientSecret": scratchClientSecret,
      "Content-Type": headerValues['Content-Type']
    };

    dynamic jsonMap = await SaleTicketRepository.callRemainingTicketCount(context, param, header,scratchList.basePath, endUrl);

    try {
      var respObj = RemainingTicketCountResponse.fromJson(jsonMap);
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

