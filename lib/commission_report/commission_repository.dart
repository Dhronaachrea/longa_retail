import 'package:flutter/material.dart';
import 'package:longalottoretail/network/api_base_url.dart';
import 'package:longalottoretail/network/api_call.dart';
import 'package:longalottoretail/network/api_relative_urls.dart';
import 'package:longalottoretail/network/network_utils.dart';

class CommissionRepository {
  /*static dynamic callFetchOrgCommissionApi(BuildContext context, Map<String, String> param, Map<String, String> header) async =>
      await CallApi.callApi(rmsBaseUrl, MethodType.get, loginTokenApi, params: param, headers: header);*/

  static dynamic callFetchOrgCommissionApi(BuildContext context, Map<String, dynamic> request, Map<String, String> header) async =>
      await CallApi.callApi("/commissionData", MethodType.post, "", requestBody: request, headers: header);

  static dynamic callCommissionDetailedDataApi(BuildContext context, Map<String, dynamic> request, Map<String, String> header) async =>
      await CallApi.callApi("/commissionData", MethodType.post, "", requestBody: request, headers: header);
}