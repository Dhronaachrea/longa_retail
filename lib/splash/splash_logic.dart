import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:longalottoretail/splash/model/model/response/VersionControlResponse.dart';
import 'package:longalottoretail/splash/repository/repository/splash_repository.dart';
import 'package:longalottoretail/utility/result.dart';

import 'model/model/response/DefaultConfigData.dart';

class SplashLogic{
  static Future<Result<dynamic>> callVersionControlApi(
      BuildContext context, Map<String, dynamic> request) async {

    dynamic jsonMap = await SplashRepository.callVersionControlApi(context, request);
    print("jsonMap: $jsonMap");
    //dynamic jsonMapDummy = '{"responseCode":0,"responseMessage":"Success","responseData":{"message":"Success","statusCode":0,"data":{"id":16,"appTypeId":4,"appId":1,"version":"1.0.1","isMandatory":"YES","fileSize":"34 MB","downloadStatus":"ACTIVE","versionStatus":"ACTIVE","downloadUrl":"https://smartelist4u.pythonanywhere.com/media/Longalottoretail_v100.apk","createdBy":1,"appRemark":"This is a new version 1.1.4","createdAt":1683752400000,"isLatest":"YES","updatedAt":1683752400000}}}';
    try {
      VersionControlResponse respObj = VersionControlResponse.fromJson(jsonMap);
      if (respObj.responseCode == 0) {
        return Result.responseSuccess(data: respObj);
      } else {
        if (jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
          return Result.networkFault(data: jsonMap);
        }
        return Result.responseFailure(data: respObj);
      }
    } catch (e) {
      print("----------->");
      if (jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);
      } else {
        return Result.failure(
            data: jsonMap["occurredErrorDescriptionMsg"] != null
                ? jsonMap
                : {"occurredErrorDescriptionMsg": e});
      }
    }
  }

  static Future<Result<dynamic>> getDefaultConfigApi(
      BuildContext context) async {

    dynamic jsonMap = await SplashRepository.getDefaultConfigApi(context);
    //dynamic jsonDummy = '{"responseCode":0,"responseMessage":"Success","responseData":{"message":"Success","statusCode":0,"data":{"COUNTRY_CODES":"+243","SYSTEM_ALLOWED_LANGUAGES":"en,fr","MOBILE_REGEX":"","OTP_LENGTH":"5","IS_B2B_AND_B2C":"YES","PASSWORD_REGEX":""}}}';
    //dynamic jsonDummy =   '{"responseCode":0,"responseMessage":"Success","responseData":{"message":"Success","statusCode":0,"data":{"COUNTRY_CODES":"+243","MOBILE_CODE_MIN_MAX_LENGTH":{},"SYSTEM_ALLOWED_LANGUAGES":"en","MOBILE_REGEX":"","OTP_LENGTH":"5","IS_B2B_AND_B2C":"YES","PASSWORD_REGEX":""}}}';
    try {
      var respObj = DefaultDomainConfigData.fromJson(jsonMap);
      if (respObj.responseCode == 0) {
        return Result.responseSuccess(data: respObj);
      } else {
        return jsonMap["occurredErrorDescriptionMsg"] != null
            ? jsonMap["occurredErrorDescriptionMsg"] == "No connection"
            ? Result.networkFault(data: jsonMap)
            : Result.failure(data: jsonMap)
            : Result.responseFailure(data: respObj);
      }
    } catch (e) {
      if (jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);
      } else {
        return Result.failure(
            data: jsonMap["occurredErrorDescriptionMsg"] != null
                ? jsonMap
                : {"occurredErrorDescriptionMsg": e});
      }
    }
  }
}