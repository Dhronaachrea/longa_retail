import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longalottoretail/network/network_exception.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_screens.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:longalottoretail/utility/utils.dart';

import 'network_utils.dart';

class CallApi {
  static Future<dynamic> callApi(String baseUrl, MethodType methodType, String relativeUrl, {String contentType = "application/json", Map<String, dynamic>? requestBody, Map<String, dynamic>?  params, Map<String, dynamic>? headers, int? pathId}) async {
    var dioObj = Dio();
    if (!await dioObj.isNetworkConnected()) {
      return {"occurredErrorDescriptionMsg": noConnection};
    }

    dioObj.options.baseUrl = baseUrl;
    dioObj.options.connectTimeout = 30000;
    dioObj.options.receiveTimeout = 30000;
    dioObj.interceptors.add(
        LogInterceptor(
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: true,
          logPrint: (object) {
            log(object.toString());
          },
        )
    );

    Response response;
    try {
      switch (methodType) {
        case MethodType.get:
          {
            params != null
                ? response = await dioObj.get(relativeUrl,
                    queryParameters: params,
                    options: Options(
                        validateStatus: (_) => true,
                        headers: headers,
                        contentType: contentType))
                : pathId != null
                    ? response = await dioObj.get("$relativeUrl/$pathId")
                    : headers != null
                        ? response = await dioObj.get(relativeUrl,
                            options: Options(
                                headers: headers, contentType: contentType))
                        : response = await dioObj.get(relativeUrl);

            break;
          }

        case MethodType.post:
          if (contentType == contentTypeMap[ContentTypeLabel.multipart]) {
            final formData = FormData.fromMap(requestBody ?? {});
            response = await dioObj.post(
              relativeUrl,
              options: Options(
                  validateStatus: (_) => true,
                  headers: headers,
                  contentType: contentType),
              data: formData,
            );
          } else {
            params != null
                ? response = await dioObj.post(
                    relativeUrl,
                    options: Options(
                        validateStatus: (_) => true,
                        headers: headers,
                        contentType: contentType),
                    queryParameters: params,
                    data: jsonEncode(requestBody),
                  )
                : response = await dioObj.post(
                    relativeUrl,
                    options:
                        Options(headers: headers, contentType: contentType),
                    data: jsonEncode(requestBody),
                  );
          }

          break;

        case MethodType.put:
          pathId != null
              ? response = await dioObj.put(
                  "$relativeUrl/$pathId",
                  options: Options(headers: headers, contentType: contentType),
                  data: jsonEncode(requestBody),
                )
              : response = await dioObj.put(
                  relativeUrl,
                  options: Options(headers: headers, contentType: contentType),
                  data: jsonEncode(requestBody),
                  queryParameters: params,
                );
          break;

        case MethodType.patch:
          pathId != null
              ? response = await dioObj.patch(
                  "$relativeUrl/$pathId",
                  options: Options(headers: headers, contentType: contentType),
                  data: jsonEncode(requestBody),
                )
              : response = await dioObj.patch(relativeUrl,
                  options: Options(headers: headers, contentType: contentType),
                  data: jsonEncode(requestBody),
                  queryParameters: params);
          break;

        case MethodType.delete:
          pathId != null
              ? response = await dioObj.delete("$relativeUrl/$pathId",
                  options: Options(headers: headers, contentType: contentType))
              : response = await dioObj.delete(relativeUrl,
                  options: Options(headers: headers, contentType: contentType),
                  data: jsonEncode(requestBody),
                  queryParameters: params);
          break;
      }
      if (response.statusCode == 200) {
        if (response.data["responseData"].toString().contains("statusCode")) {
          if (response.data["responseData"]["statusCode"] == 102) {
            // session expire
            BuildContext? context = navigatorKey.currentContext;
            UserInfo.logout();
            if (context != null) {
              Navigator.of(context).popUntil((route) => false);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: LongaLottoPosColor.tomato,
                content: const Text("Session Expired, Please Login",
                    style: TextStyle(color: LongaLottoPosColor.white)),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 100,
                    right: 20,
                    left: 20),
              ));
              Navigator.of(context).pushNamed(LongaLottoPosScreen.loginScreen);
            }
          }
          return response.data;
        }
        else if (response.toString().contains("responseCode")){
          if(response.data["responseCode"] == 1021){ // // session expire to check scratch side only
            BuildContext? context = navigatorKey.currentContext;
            UserInfo.logout();
            if (context != null) {
              Navigator.of(context).popUntil((route) => false);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: LongaLottoPosColor.tomato,
                content: const Text("Session Expired, Please Login",
                    style: TextStyle(color: LongaLottoPosColor.white)),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 100,
                    right: 20,
                    left: 20),
              ));
              Navigator.of(context).pushNamed(LongaLottoPosScreen.loginScreen);
            }
          }
          return response.data;
        }

        return response.data;
      } else if ((response.statusCode == 401 || response.statusCode == 400) &&
          response.data != null) {
        return response.data;
      } else {
        return {
          "occurredErrorDescriptionMsg":
              "Might be status code is not success or response data is null"
        };
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        log("------------ DioError Exception e: connectTimeout: ${e.message} --------------");
      }
      if (e.type == DioErrorType.receiveTimeout) {
        log("------------ DioError Exception e: receiveTimeout: ${e.message} --------------");
      }

      log("------------ DioError Exception e: ${e.message} --------------");
      log("------------ DioError Exception e:: response:  ${e.message} --------------");
      log("------------ DioError Exception e:: getDioException: msg:  ${NetworkExceptions.getErrorMessage(NetworkExceptions.getDioException(e))} --------------");

      return {"occurredErrorDescriptionMsg": NetworkExceptions.getErrorMessage(NetworkExceptions.getDioException(e))};
    }
  }
}
