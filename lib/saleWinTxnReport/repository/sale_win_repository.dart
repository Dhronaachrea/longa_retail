import 'package:flutter/cupertino.dart';

import '../../network/api_base_url.dart';
import '../../network/api_call.dart';
import '../../network/api_relative_urls.dart';
import '../../network/network_utils.dart';

class SaleWinRepository {

  static dynamic getSaleList(
          BuildContext context, Map<String, String> header, String url) async =>
      await CallApi.callApi(rmsBaseUrl, MethodType.get, serviceList, headers: header);


  static dynamic getSaleWinTaxReport(BuildContext context,Map<String, String> header,
      Map<String, dynamic>? requestBody) async =>
      await CallApi.callApi(rmsBaseUrl, MethodType.post, serviceReportDetail
          , headers: header, requestBody: requestBody);
}
