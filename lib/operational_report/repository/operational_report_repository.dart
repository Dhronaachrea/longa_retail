import 'package:flutter/material.dart';

import '../../network/api_base_url.dart';
import '../../network/api_call.dart';
import '../../network/api_relative_urls.dart';
import '../../network/network_utils.dart';

class OperationalReportRepository {
  static dynamic callOperationalReportList(BuildContext context, Map<String, String> param, Map<String, String> header) async =>
      await CallApi.callApi(rmsBaseUrl, MethodType.get, getOperationalCashReportDataApi, params: param, headers: header);

  static dynamic getSaleList(
      BuildContext context, Map<String, String> header, String url) async =>
      await CallApi.callApi(rmsBaseUrl, MethodType.get, serviceList, headers: header);

}