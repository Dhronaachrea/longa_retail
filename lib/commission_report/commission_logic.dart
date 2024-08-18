import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/commission_report/commission_repository.dart';
import 'package:longalottoretail/commission_report/model/response/CommissionDetailedDataResponse.dart';
import 'package:longalottoretail/utility/result.dart';
import 'package:longalottoretail/utility/user_info.dart';

import 'model/response/FetchOrgCommissionResponse.dart';

class CommissionLogic {
  static Future<Result<dynamic>> callFetchOrgCommissionApi(BuildContext context, Map<String, String> commissionInfo) async {

    Map<String, String> header = {
      "Authorization"  : "Bearer ${UserInfo.userToken}",
    };

    //Map<String, dynamic> request = {"responseCode":0,"responseMessage":"Success","responseData":{"message":"Success","statusCode":0,"data":[{"commissionDate":"2023-06-08","directWagerComm":90,"directSaleReturnComm":0,"directWinningComm":0,"totalComm":90},{"commissionDate":"2023-06-09","directWagerComm":10,"directSaleReturnComm":0,"directWinningComm":0,"totalComm":10},{"commissionDate":"2023-06-10","directWagerComm":15,"directSaleReturnComm":0,"directWinningComm":0,"totalComm":15},{"commissionDate":"2023-06-11","directWagerComm":30,"directSaleReturnComm":5,"directWinningComm":0,"totalComm":25}]}};
    //Map<String, dynamic> request = {"responseCode":0,"responseMessage":"Success","responseData":{"message":"Success","statusCode":0,"data":[{"commissionDate":"2023-06-14","setId":"30","tieredWagerComm":"5,00 ","tieredWinningComm":"5,00 ","setStartingDate":"2023-06-13","setEndingDate":"2023-06-13","totalComm":"10,00 ","wagerAmt":"40,00 ","winningAmt":"20,00 "},{"commissionDate":"2023-06-15","setId":"30","tieredWagerComm":"5,00 ","tieredWinningComm":"5,00 ","setStartingDate":"2023-06-14","setEndingDate":"2023-06-14","totalComm":"10,00 ","wagerAmt":"50,00 ","winningAmt":"0,00 "},{"commissionDate":"2023-06-16","setId":"30","tieredWagerComm":"10,00 ","tieredWinningComm":"5,00 ","setStartingDate":"2023-06-15","setEndingDate":"2023-06-15","totalComm":"15,00 ","wagerAmt":"30,00 ","winningAmt":"0,00 "},{"commissionDate":"2023-06-21","setId":"30","tieredWagerComm":"40,00 ","tieredWinningComm":"10,00 ","setStartingDate":"2023-06-16","setEndingDate":"2023-06-20","totalComm":"50,00 ","wagerAmt":"60,00 ","winningAmt":"0,00 "},{"commissionDate":"2023-06-22","setId":"30","tieredWagerComm":"15,00 ","tieredWinningComm":"10,00 ","setStartingDate":"2023-06-11","setEndingDate":"2023-06-12","totalComm":"25,00 ","wagerAmt":"80,00 ","winningAmt":"0,00 "}]}};
    Map<String, dynamic> request = {"responseCode":0,"responseMessage":"Success","responseData":{"message":"Success","statusCode":0,"data":[{"commissionDate":"2023-06-14","setId":"30","tieredWagerComm":"5,00 ","tieredWinningComm":"5,00 ","setStartingDate":"2023-06-13","setEndingDate":"2023-06-13","totalComm":"10,00 ","wagerAmt":"40,00 ","winningAmt":"20,00 "},{"commissionDate":"2023-06-15","setId":"30","tieredWagerComm":"5,00 ","tieredWinningComm":"5,00 ","setStartingDate":"2023-06-14","setEndingDate":"2023-06-14","totalComm":"10,00 ","wagerAmt":"150,00 ","winningAmt":"0,00 "},{"commissionDate":"2023-06-16","setId":"30","tieredWagerComm":"10,00 ","tieredWinningComm":"5,00 ","setStartingDate":"2023-06-15","setEndingDate":"2023-06-15","totalComm":"15,00 ","wagerAmt":"200,00 ","winningAmt":"400,00 "},{"commissionDate":"2023-06-21","setId":"30","tieredWagerComm":"40,00 ","tieredWinningComm":"10,00 ","setStartingDate":"2023-06-16","setEndingDate":"2023-06-20","totalComm":"50,00 ","wagerAmt":"60,00 ","winningAmt":"0,00 "},{"commissionDate":"2023-06-22","setId":"30","tieredWagerComm":"15,00 ","tieredWinningComm":"10,00 ","setStartingDate":"2023-06-11","setEndingDate":"2023-06-12","totalComm":"25,00 ","wagerAmt":"80,00 ","winningAmt":"0,00 "}]}};

    //dynamic jsonMap = await CommissionRepository.callFetchOrgCommissionApi(context, header, commissionInfo);
    dynamic jsonMap = await CommissionRepository.callFetchOrgCommissionApi(context, request, header);

    try {
      dynamic respObj =  FetchOrgCommissionResponse.fromJson(jsonMap);
      if (respObj.responseData?.statusCode == 0) {
        return Result.responseSuccess(data: respObj);

      } else {

        return jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap["occurredErrorDescriptionMsg"] == "No connection" ? Result.networkFault(data: jsonMap) : Result.failure(data: jsonMap) : Result.responseFailure(data: respObj);
      }

    } catch(e) {
      if(jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);

      } else {
        return Result.failure(data: jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap : {"occurredErrorDescriptionMsg": e});
      }
    }
  }

  static Future<Result<dynamic>> callCommissionDetailedDataApi(BuildContext context, Map<String, String> commissionInfo) async {

    Map<String, String> header = {
      "Authorization"  : "Bearer ${UserInfo.userToken}",
    };

    //Map<String, dynamic> request = {"responseCode":0,"responseMessage":"Success","responseData":{"message":"Success","statusCode":0,"data":[{"commissionDate":"2023-06-08","directWagerComm":90,"directSaleReturnComm":0,"directWinningComm":0,"totalComm":90},{"commissionDate":"2023-06-09","directWagerComm":10,"directSaleReturnComm":0,"directWinningComm":0,"totalComm":10},{"commissionDate":"2023-06-10","directWagerComm":15,"directSaleReturnComm":0,"directWinningComm":0,"totalComm":15},{"commissionDate":"2023-06-11","directWagerComm":30,"directSaleReturnComm":5,"directWinningComm":0,"totalComm":25}]}};
    //Map<String, dynamic> request = {"responseCode":0,"responseMessage":"Success","responseData":{"message":"Success","statusCode":0,"wagerAmt":0,"winningAmt":0,"commOn":"","setStartingDate":"","setEndingDate":"","data":[{"setName":"SET1","setId":66,"isMergedSlab":"NO","chainType":"Direct Retailer","slabsInfo":[{"orgTypeCode":"Retailer","slabs":[{"rangeTo":"100","commRate":"2,0","rangeFrom":"1"},{"rangeTo":"500","commRate":"5,0","rangeFrom":"101"},{"rangeTo":"1000","commRate":"10,0","rangeFrom":"501"}]}],"config":"Commission Credited Daily"}]}};
    Map<String, dynamic> request = {"responseCode":0,"responseMessage":"Success","responseData":{"message":"Success","statusCode":0,"data":[{"setName":"SET1","setId":66,"isMergedSlab":"NO","chainType":"Direct Retailer","slabsInfo":[{"orgTypeCode":"Retailer","slabs":[{"rangeTo":"100","commRate":"2,0","rangeFrom":"0"},{"rangeTo":"500","commRate":"5,0","rangeFrom":"101"},{"rangeTo":"1000","commRate":"10,0","rangeFrom":"501"}]}],"config":"Commission Credited Daily"}]}};

    //dynamic jsonMap = await CommissionRepository.callFetchOrgCommissionApi(context, header, commissionInfo);
    dynamic jsonMap = await CommissionRepository.callFetchOrgCommissionApi(context, request, header);

    try {
      dynamic respObj =  CommissionDetailedDataResponse.fromJson(jsonMap);
      if (respObj.responseData?.statusCode == 0) {
        return Result.responseSuccess(data: respObj);

      } else {

        return jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap["occurredErrorDescriptionMsg"] == "No connection" ? Result.networkFault(data: jsonMap) : Result.failure(data: jsonMap) : Result.responseFailure(data: respObj);
      }

    } catch(e) {
      if(jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);

      } else {
        return Result.failure(data: jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap : {"occurredErrorDescriptionMsg": e});
      }
    }
  }
}