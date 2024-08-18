import 'package:flutter/material.dart';
import 'package:longalottoretail/network/api_base_url.dart';
import 'package:longalottoretail/network/api_call.dart';
import 'package:longalottoretail/network/api_relative_urls.dart';
import 'package:longalottoretail/network/network_utils.dart';

class LoginRepository {
  static dynamic callLoginTokenApi(BuildContext context, Map<String, String> param, Map<String, String> header) async =>
      await CallApi.callApi(rmsBaseUrl, MethodType.get, loginTokenApi, params: param, headers: header);

  static dynamic callGetLoginDataApi(BuildContext context, Map<String, String> header) async =>
      await CallApi.callApi(rmsBaseUrl, MethodType.get, getLoginDataApi, headers: header);

  static dynamic callVerifyPosApi(BuildContext context, Map<String, String> header, Map<String, dynamic> request) async =>
      await CallApi.callApi(rmsBaseUrl, MethodType.post, "RMS/v1.0/verifyPOS", headers: header, requestBody: request);
}