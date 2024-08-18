import 'package:flutter/material.dart';

import '../../network/api_base_url.dart';
import '../../network/api_call.dart';
import '../../network/api_relative_urls.dart';
import '../../network/network_utils.dart';

class ChangePinRepository {

  static dynamic callChangePinApi(BuildContext context,
      Map<String, dynamic> param, Map<String, String> header,
      Map<String, dynamic>? requestBody) async =>
      await CallApi.callApi(rmsBaseUrl, MethodType.post, changePin,
          params: param, headers: header, requestBody: requestBody);

}