import 'package:flutter/cupertino.dart';

import '../../network/api_base_url.dart';
import '../../network/api_call.dart';
import '../../network/api_relative_urls.dart';
import '../../network/network_utils.dart';

class SummarizeLedgerRepository {
  static dynamic getSummarizeLedgerReport(
          BuildContext context,
          Map<String, String> header,
          String url,
          Map<String, dynamic>? params) async =>
      await CallApi.callApi(rmsBaseUrl, MethodType.get, summarizeReport,
          params: params, headers: header);
}
