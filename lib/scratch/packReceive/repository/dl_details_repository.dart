import 'package:flutter/material.dart';
import 'package:longalottoretail/network/api_call.dart';
import 'package:longalottoretail/network/network_utils.dart';

class DlDetailsRepository {
  static dynamic callDlDetails(
      BuildContext context,
      Map<String, dynamic> param,
      Map<String, String> header,
      String basePath,
      String relativeUrl
      ) async =>
      await CallApi.callApi(basePath, MethodType.get, relativeUrl, params: param, headers: header);
}
