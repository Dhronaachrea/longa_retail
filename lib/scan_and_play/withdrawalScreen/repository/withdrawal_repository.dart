import 'package:flutter/cupertino.dart';

import '../../../network/api_base_url.dart';
import '../../../network/api_call.dart';
import '../../../network/api_relative_urls.dart';
import '../../../network/network_utils.dart';

class WithdrawalRepository {

  static dynamic checkPendingQrCode(BuildContext context,
          Map<String, String> param, Map<String, String> header) async =>
      await CallApi.callApi(
          rmsCashierUrl, MethodType.get, pendingWithdrawalByQrcode,
          params: param, headers: header);



  static dynamic updatePendingQrCode(BuildContext context,
          Map<String, String> header, Map<String, dynamic>? requestBody) async =>
      await CallApi.callApi(
          rmsCashierUrl, MethodType.post, updateQrWithdrawalRequest,
          headers: header, requestBody: requestBody);



}
