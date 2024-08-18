import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

extension NetworkConnection on Dio {
  isNetworkConnected() async{
    var isConnected = await InternetConnectionChecker().hasConnection;
    return isConnected;
  }
}

enum BaseUrlEnum{cashierBaseUrl, ramBaseUrl, weaverBaseUrl, bonusBaseUrl, dgeBaseUrl, igeBaseUrl, profileImageBaseUrl}

enum MethodType{get, post, put, patch, delete}

enum ContentTypeLabel{json, multipart}
Map<ContentTypeLabel, String> contentTypeMap = {
  ContentTypeLabel.json      : "application/json",
  ContentTypeLabel.multipart : "multipart/form-data"
};