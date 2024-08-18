import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:longalottoretail/network/api_call.dart';
import 'package:longalottoretail/network/network_utils.dart';
import 'package:longalottoretail/utility/user_info.dart';

import '../../utility/UrlDrawGameBean.dart';

class LotteryRepository {
  static dynamic callFetchGameData(BuildContext context, Map<String, dynamic> request, Map<String, String> header, UrlDrawGameBean? urlsDetails) async =>
      await CallApi.callApi(urlsDetails?.basePath ?? "", MethodType.put, urlsDetails?.url ?? "", requestBody: request, headers: header);

  static dynamic callRePrint(BuildContext context, Map<String, dynamic> request, Map<String, String> header, String baseUrl, String relativeUrl, UrlDrawGameBean? urlsDetails) async =>
      await CallApi.callApi(urlsDetails?.basePath ?? "", MethodType.post, relativeUrl, requestBody: request, headers: header);

  static dynamic callResult(BuildContext context, Map<String, dynamic> request, Map<String, String> header, String baseUrl, String relativeUrl, UrlDrawGameBean? urlsDetails) async =>
      await CallApi.callApi(urlsDetails?.basePath ?? "", MethodType.post, relativeUrl, requestBody: request, headers: header);

  static dynamic callLotterySaleApi(BuildContext context, Map<String, dynamic> request, Map<String, String> header, UrlDrawGameBean? urlsDetails) async =>
      await CallApi.callApi(urlsDetails?.basePath ?? "", MethodType.post, urlsDetails?.url ?? "", requestBody: request, headers: header);

  static dynamic callCancelTicket(BuildContext context, Map<String, dynamic> request, Map<String, String> header, String baseUrl, String relativeUrl, UrlDrawGameBean? urlsDetails) async =>
      await CallApi.callApi(urlsDetails?.basePath ?? "", MethodType.post, relativeUrl, requestBody: request, headers: header);

}