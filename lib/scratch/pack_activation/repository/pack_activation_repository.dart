import 'package:longalottoretail/network/api_call.dart';
import 'package:longalottoretail/network/network_utils.dart';
import 'package:flutter/material.dart';

class PackActivationRepository {
  static dynamic callPackActivation(
      BuildContext context,
      Map<String, dynamic> param,
      Map<String, String> header,
      String basePath,
      String relativeUrl,
      ) async =>
      await CallApi.callApi(basePath, MethodType.post, relativeUrl, requestBody: param, headers: header);
}
