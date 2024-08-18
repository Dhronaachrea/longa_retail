import 'package:flutter/material.dart';
import 'package:longalottoretail/network/api_call.dart';
import 'package:longalottoretail/network/network_utils.dart';

class WinningClaimRepository {
  static dynamic callTicketVerify(BuildContext context, String baseUrl, String relativeUrl, Map<String, dynamic> request, Map<String, dynamic> header) async =>
      await CallApi.callApi(baseUrl, MethodType.post, relativeUrl, requestBody: request, headers: header);

  static dynamic callClaimWinPayPwt(BuildContext context, String baseUrl, String relativeUrl, Map<String, dynamic> request, Map<String, dynamic> header) async =>
      await CallApi.callApi(baseUrl, MethodType.post, relativeUrl, requestBody: request, headers: header);
}