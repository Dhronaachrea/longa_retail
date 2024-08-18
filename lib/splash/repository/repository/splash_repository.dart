import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/network/api_base_url.dart';
import 'package:longalottoretail/network/api_call.dart';
import 'package:longalottoretail/network/api_relative_urls.dart';
import 'package:longalottoretail/network/network_utils.dart';

class SplashRepository {

  static dynamic callVersionControlApi(
          BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(
        rmsBaseUrl,
        MethodType.get,
        versionControlUrl,
        requestBody: request,
        headers: {
          "Content-Type": "application/json",
        }
      );

  static dynamic getDefaultConfigApi(BuildContext context) async =>
      await CallApi.callApi(rmsBaseUrl, MethodType.get, defaultConfigApi);

}
