import 'package:longalottoretail/network/api_call.dart';
import 'package:longalottoretail/network/network_utils.dart';
import 'package:flutter/material.dart';

class InvRepRepository {

  static dynamic callInvDetailsForRetailerAPI(BuildContext context, Map<String, String> param, Map<String, String> header,String basePath,
      String relativeUrl) async =>
      await CallApi.callApi(basePath, MethodType.get, relativeUrl, params: param, headers: header);
}