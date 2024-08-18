import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/network/api_base_url.dart';
import 'package:longalottoretail/network/api_call.dart';
import 'package:longalottoretail/network/api_relative_urls.dart';
import 'package:longalottoretail/network/network_utils.dart';


class DepositRepository {
  static dynamic depositAmount(BuildContext context, Map<String, String> header,
          String url, Map<String, dynamic>? requestBody) async =>
      await CallApi.callApi(rmsBackendUrl, MethodType.post, depositAmountApi,
          headers: header, requestBody: requestBody);

  static dynamic couponReversalApi(BuildContext context, Map<String, String> header,
      String url, Map<String, dynamic>? requestBody) async => await CallApi.callApi(rmsBackendUrl, MethodType.post, couponReversal, headers: header, requestBody: requestBody);
}
