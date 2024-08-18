import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:longalottoretail/lottery/lottery_bottom_nav/winning_claim/repository/winning_claim_repository.dart';
import 'package:longalottoretail/lottery/repository/lottery_repository.dart';
import 'package:longalottoretail/utility/result.dart';

import '../../../home/models/response/UserMenuApiResponse.dart';
import '../../../utility/UrlDrawGameBean.dart';
import '../../../utility/user_info.dart';
import '../../../utility/utils.dart';
import '../../models/response/RePrintResponse.dart';
import 'models/response/ClaimWinResponse.dart';
import 'models/response/TicketVerifyResponse.dart';

class WinningClaimLogic {
  static Future<Result<dynamic>> callTicketVerify(BuildContext context, String baseUrl, String relativePath, Map<String, dynamic> header, Map<String, dynamic> request) async {
    /*Map<String, String> header = {
    "username": "LotteryRMS",
    "password": "password"
    };*/

    dynamic jsonMap = await WinningClaimRepository.callTicketVerify(context, baseUrl, relativePath, request, header);

    //var dummyJson = '{"responseCode":0,"responseMessage":"Success","responseData":{"ticketNumber":"30030700006735495952","doneByUserId":673,"status":"DONE","balance":12475.0,"gameName":"Lucky Number+ 5/90","gameCode":"FiveByNinety","drawData":[{"drawId":36499,"drawName":"5/90 First","drawDate":"2023-07-03","drawTime":"10:30:00","isPwtCurrent":false,"winStatus":"NON WIN!!","winningAmount":"10.00","panelWinList":[{"panelId":1,"status":"CLAIMED","playType":"Direct3","winningAmt":10.0,"winningItem":null,"valid":true}],"winCode":2001},{"drawId":36500,"drawName":"5/90 First","drawDate":"2023-07-04","drawTime":"12:00:00","isPwtCurrent":false,"winStatus":"WIN!!","winningAmount":"10.00","panelWinList":[{"panelId":1,"status":"RESULT AWAITED","playType":"Direct3","winningAmt":10.0,"winningItem":null,"valid":true}],"winCode":2001},{"drawId":36501,"drawName":"5/90 First","drawDate":"2023-07-05","drawTime":"19:00:00","isPwtCurrent":false,"winStatus":"RESULT AWAITED","winningAmount":"10.00","panelWinList":[{"panelId":1,"status":"CLAIMED","playType":"Direct3","winningAmt":10.0,"winningItem":null,"valid":true}],"winCode":2001}],"prizeAmount":"7500.0","totalPay":"7500.0","currencySymbol":"EUR","merchantCode":"LotteryRMS","orgName":"Bet2WinAsia","retailerName":"rajneesh","reprintCountPwt":"1","drawTransMap":{},"panelData":[{"betType":"Direct3","pickType":"Direct3","tpticketList":null,"pickConfig":"Number","betAmountMultiple":1,"quickPick":false,"pickedValues":"01,02,03","qpPreGenerated":false,"numberOfLines":1,"unitCost":1.0,"panelPrice":3.0,"playerPanelPrice":3.0,"betDisplayName":"Pick 3","pickDisplayName":"Manual","winningMultiplier":null}],"merchantTxnId":2804,"validationCode":"u------i-h-w----a---","isPwtReprint":true,"totalPurchaseAmount":3.0,"playerPurchaseAmount":3.0,"purchaseTime":"03-07-2023 10:07:16","claimTime":"03-07-2023 10:24:07","winClaimAmount":0.0,"drawClaimedCount":0,"success":true}}';
    //var dummyJson = '{"responseCode":0,"responseMessage":"Success","responseData":{"ticketNumber":"30030700006735495953","doneByUserId":673,"status":"DONE","balance":12475.0,"gameName":"Lucky Number+ 5/90","gameCode":"FiveByNinety","drawData":[{"drawId":36499,"drawName":"5/90 First","drawDate":"2023-07-03","drawTime":"10:30:00","isPwtCurrent":false,"winStatus":"UNCLAIMED","winningAmount":"10.00","panelWinList":[{"panelId":1,"status":"UNCLAIMED","playType":"Direct3","winningAmt":10.0,"winningItem":null,"valid":true}],"winCode":2001}],"prizeAmount":"7500.0","totalPay":"7500.0","currencySymbol":"EUR","merchantCode":"LotteryRMS","orgName":"Bet2WinAsia","retailerName":"rajneesh","reprintCountPwt":"1","drawTransMap":{},"panelData":[{"betType":"Direct3","pickType":"Direct3","tpticketList":null,"pickConfig":"Number","betAmountMultiple":1,"quickPick":false,"pickedValues":"01,02,03","qpPreGenerated":false,"numberOfLines":1,"unitCost":1.0,"panelPrice":3.0,"playerPanelPrice":3.0,"betDisplayName":"Pick 3","pickDisplayName":"Manual","winningMultiplier":null}],"merchantTxnId":2804,"validationCode":"u------i-h-w----a---","isPwtReprint":true,"totalPurchaseAmount":3.0,"playerPurchaseAmount":3.0,"purchaseTime":"03-07-2023 10:07:16","claimTime":"03-07-2023 10:24:07","winClaimAmount":7500.0,"drawClaimedCount":0,"success":true}}';
    //var dummyJson = '{"responseCode":0,"responseMessage":"Success","responseData":{"ticketNumber":"30170300008776558214","gameName":"Boule de feu","gameCode":"EightByTwentyFour","gameId":3,"drawData":[{"drawId":20144,"drawName":"EightByTwentyFour","drawDate":"2023-10-16","drawTime":"13:25:00","isPwtCurrent":false,"winStatus":"WIN!!","winningAmount":"1500.00","panelWinList":[{"panelId":1,"status":"CLAIMED","playType":"Direct8","winningAmt":1500.0,"winningItem":null,"valid":true}],"winCode":2006},{"drawId":20145,"drawName":"EightByTwentyFour","drawDate":"2023-10-17","drawTime":"13:30:00","isPwtCurrent":false,"winStatus":"RESULT AWAITED","winningAmount":"0.00","panelWinList":[{"panelId":1,"status":"UNCLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null,"valid":true}],"winCode":2001},{"drawId":20143,"drawName":"EightByTwentyFour","drawDate":"2023-10-17","drawTime":"13:20:00","isPwtCurrent":false,"winStatus":"NON WIN!!","winningAmount":"0.00","panelWinList":[{"panelId":1,"status":"UNCLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null,"valid":true}],"winCode":2007}],"prizeAmount":"1500.00","totalPay":"1500.00","currencySymbol":"CDF","merchantCode":"LotteryRMS","orgName":"Bet2WinAsia","retailerName":"retailerdge2","reprintCountPwt":"1","pwtTicketType":"DRAW","reference":"","winClaimAmount":0.0,"panelData":[{"betType":"Direct8","pickType":"Direct8","tpticketList":null,"pickConfig":"Number","betAmountMultiple":1,"quickPick":false,"pickedValues":"01,02,03,04,05,21,20,24","qpPreGenerated":false,"numberOfLines":1,"unitCost":500.0,"panelPrice":1500.0,"playerPanelPrice":1500.0,"betDisplayName":"Direct 8","pickDisplayName":"Manual","winningMultiplier":null}],"prizeType":"AMOUNT"}}';
    try {
      var respObj = TicketVerifyResponse.fromJson(jsonMap);
      //var respObj = TicketVerifyResponse.fromJson(jsonDecode(dummyJson));
      log("respObj --->> ${jsonEncode(respObj)}");
      if (respObj.responseCode == 0) {
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

  static Future<Result<dynamic>> callClaimWinPayPwt(BuildContext context, String baseUrl, String relativePath, Map<String, dynamic> header, Map<String, dynamic> request) async {
    /*Map<String, String> header = {
    "username": "LotteryRMS",
    "password": "password"
    };*/

    dynamic jsonMap = await WinningClaimRepository.callClaimWinPayPwt(context, baseUrl, relativePath, request, header);

    //var dummyJson = '{"responseCode":0,"responseMessage":"Success","responseData":{"ticketNumber":"30030700006735495951","doneByUserId":673,"status":"DONE","balance":12475.0,"gameName":"Lucky Number+ 5/90","gameCode":"FiveByNinety","drawData":[{"drawId":36499,"drawName":"5/90 First","drawDate":"2023-07-03","drawTime":"10:30:00","isPwtCurrent":false,"winStatus":"WIN!!","winningAmount":"10.00","panelWinList":[{"panelId":1,"status":"CLAIMED","playType":"Direct3","winningAmt":10.0,"winningItem":null,"valid":true}],"winCode":2001},{"drawId":36500,"drawName":"5/90 First","drawDate":"2023-07-03","drawTime":"10:30:00","isPwtCurrent":false,"winStatus":"RESULT AWAITED","winningAmount":"100.00","panelWinList":[{"panelId":1,"status":"UNCLAIMED","playType":"Direct3","winningAmt":100.0,"winningItem":null,"valid":true}],"winCode":2001}],"prizeAmount":"7500.0","totalPay":"7500.0","currencySymbol":"EUR","merchantCode":"LotteryRMS","orgName":"Bet2WinAsia","retailerName":"rajneesh","reprintCountPwt":"1","drawTransMap":{},"panelData":[{"betType":"Direct3","pickType":"Direct3","tpticketList":null,"pickConfig":"Number","betAmountMultiple":1,"quickPick":false,"pickedValues":"01,02,03","qpPreGenerated":false,"numberOfLines":1,"unitCost":1.0,"panelPrice":3.0,"playerPanelPrice":3.0,"betDisplayName":"Pick 3","pickDisplayName":"Manual","winningMultiplier":null}],"merchantTxnId":2804,"validationCode":"u------i-h-w----a---","isPwtReprint":true,"totalPurchaseAmount":3.0,"playerPurchaseAmount":3.0,"purchaseTime":"03-07-2023 10:07:16","claimTime":"03-07-2023 10:24:07","winClaimAmount":7500.0,"drawClaimedCount":0,"success":true}}';
    //var dummyJson = '{"responseCode":0,"responseMessage":"Success","responseData":{"ticketNumber":"30030700006735495951","doneByUserId":673,"status":"DONE","balance":12475.0,"gameName":"Lucky Number+ 5/90","gameCode":"FiveByNinety","drawData":[{"drawId":36499,"drawName":"5/90 First","drawDate":"2023-07-03","drawTime":"10:30:00","isPwtCurrent":false,"winStatus":"WIN!!","winningAmount":"10.00","panelWinList":[{"panelId":1,"status":"CLAIMED","playType":"Direct3","winningAmt":10.0,"winningItem":null,"valid":true}],"winCode":2001}],"prizeAmount":"7500.0","totalPay":"7500.0","currencySymbol":"EUR","merchantCode":"LotteryRMS","orgName":"Bet2WinAsia","retailerName":"rajneesh","reprintCountPwt":"1","drawTransMap":{},"panelData":[{"betType":"Direct3","pickType":"Direct3","tpticketList":null,"pickConfig":"Number","betAmountMultiple":1,"quickPick":false,"pickedValues":"01,02,03","qpPreGenerated":false,"numberOfLines":1,"unitCost":1.0,"panelPrice":3.0,"playerPanelPrice":3.0,"betDisplayName":"Pick 3","pickDisplayName":"Manual","winningMultiplier":null}],"merchantTxnId":2804,"validationCode":"u------i-h-w----a---","isPwtReprint":true,"totalPurchaseAmount":3.0,"playerPurchaseAmount":3.0,"purchaseTime":"03-07-2023 10:07:16","claimTime":"03-07-2023 10:24:07","winClaimAmount":7500.0,"drawClaimedCount":0,"success":true}}';
   // var dummyJson = '{"responseCode":0,"responseMessage":"Success","responseData":{"ticketNumber":"30020300008776578951","doneByUserId":877,"status":"DONE","balance":985000.0,"gameName":"Bouledefeu","gameCode":"EightByTwentyFour","drawData":[{"drawId":20649,"drawName":"EightByTwentyFour","drawDate":"2023-10-19","drawTime":"07:30:00","isPwtCurrent":true,"winStatus":"WIN!!","winningAmount":"1500.00","panelWinList":[{"isValid":true,"panelId":1,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":2,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":3,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":4,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":5,"status":"CLAIMED","playType":"Direct8","winningAmt":1500.0,"winningItem":null}],"winCode":2006,"drawId":20650,"drawName":"EightByTwentyFour","drawDate":"2023-10-19","drawTime":"07:35:00","isPwtCurrent":true,"winStatus":"WIN!!","winningAmount":"1000.00","panelWinList":[{"isValid":true,"panelId":1,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":2,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":3,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":4,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":5,"status":"CLAIMED","playType":"Direct8","winningAmt":1000.0,"winningItem":null}],"winCode":2006,"drawId":20651,"drawName":"EightByTwentyFour","drawDate":"2023-10-19","drawTime":"07: 40: 00","isPwtCurrent":false,"winStatus":"RESULT AWAITED","winningAmount":"0.00","panelWinList":[{"isValid":true,"panelId":1,"status":"UNCLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":2,"status":"UNCLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":3,"status":"UNCLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":4,"status":"UNCLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":5,"status":"UNCLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null}]}],"prizeAmount":"2500.0","totalPay":"2500.0","currencySymbol":"CDF","merchantCode":"LotteryRMS","orgName":"Bet2WinAsia","retailerName":"retailerdge2","reprintCountPwt":"1","panelData":[{"betType":"Direct8","pickType":"Direct8","pickConfig":"Number","betAmountMultiple":1,"quickPick":true,"pickedValues":"01,08,04,22,20,18,17,12","qpPreGenerated":true,"numberOfLines":1,"unitCost":500.0,"panelPrice":1500.0,"playerPanelPrice":1500.0,"pickDisplayName":"Manual","betDisplayName":"Direct8"},{"betType":"Direct8","pickType":"Direct8","pickConfig":"Number","betAmountMultiple":1,"quickPick":true,"pickedValues":"03,12,14,07,09,24,17,05","qpPreGenerated":true,"numberOfLines":1,"unitCost":500.0,"panelPrice":1500.0,"playerPanelPrice":1500.0,"pickDisplayName":"Manual","betDisplayName":"Direct8"},{"betType":"Direct8","pickType":"Direct8","pickConfig":"Number","betAmountMultiple":1,"quickPick":true,"pickedValues":"22,16,04,15,07,08,09,24","qpPreGenerated":true,"numberOfLines":1,"unitCost":500.0,"panelPrice":1500.0,"playerPanelPrice":1500.0,"pickDisplayName":"Manual","betDisplayName":"Direct8"},{"betType":"Direct8","pickType":"Direct8","pickConfig":"Number","betAmountMultiple":1,"quickPick":true,"pickedValues":"22,13,16,20,24,18,08,06","qpPreGenerated":true,"numberOfLines":1,"unitCost":500.0,"panelPrice":1500.0,"playerPanelPrice":1500.0,"pickDisplayName":"Manual","betDisplayName":"Direct8"},{"betType":"Direct8","pickType":"Direct8","pickConfig":"Number","betAmountMultiple":1,"quickPick":true,"pickedValues":"03,11,24,18,19,16,21,02","qpPreGenerated":true,"numberOfLines":1,"unitCost":500.0,"panelPrice":1500.0,"playerPanelPrice":1500.0,"pickDisplayName":"Manual","betDisplayName":"Direct8"}],"errorCode":null,"isSuccess":true,"merchantTxnId":4048,"pwtUpdateDrawDataList":null,"reference":null,"validationCode":"d------45---2-----k-","isPwtReprint":true,"totalPurchaseAmount":7500.0,"playerPurchaseAmount":7500.0,"purchaseTime":"19-10-2023 07:27:33","claimTime":"19-10-2023 07:36:13","claimAmount":2500.0,"drawClaimedCount":0,"advMessages":null}}';
    //var dummyJson = '{"responseCode":0,"responseMessage":"Success","responseData":{"ticketNumber":"30020300008776578951","doneByUserId":877,"status":"DONE","balance":985000.0,"gameName":"Bouledefeu","gameCode":"EightByTwentyFour","drawData":[{"drawId":20649,"drawName":"EightByTwentyFour","drawDate":"2023-10-19","drawTime":"07:30:00","isPwtCurrent":true,"winstatus":"WIN!!","winningAmount":"1500.00","panelWinList":[{"isValid":true,"panelId":1,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":2,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":3,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":4,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":5,"status":"CLAIMED","playType":"Direct8","winningAmt":1500.0,"winningItem":null}],"winCode":2006,"drawId":20650,"drawName":"EightByTwentyFour","drawDate":"2023-10-19","drawTime":"07:35:00","isPwtCurrent":true,"winstatus":"WIN!!","winningAmount":"1000.00","panelWinList":[{"isValid":true,"panelId":1,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":2,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":3,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":4,"status":"CLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":5,"status":"CLAIMED","playType":"Direct8","winningAmt":1000.0,"winningItem":null}],"winCode":2006,"drawId":20651,"drawName":"EightByTwentyFour","drawDate":"2023-10-19","drawTime":"07: 40: 00","isPwtCurrent":false,"winstatus":"RESULT AWAITED","winningAmount":"0.00","panelWinList":[{"isValid":true,"panelId":1,"status":"UNCLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":2,"status":"UNCLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":3,"status":"UNCLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":4,"status":"UNCLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null},{"isValid":true,"panelId":5,"status":"UNCLAIMED","playType":"Direct8","winningAmt":0.0,"winningItem":null}]}]}}';
    try {
      var respObj = ClaimWinResponse.fromJson(jsonMap);
      //var respObj = ClaimWinResponse.fromJson(jsonDecode(dummyJson));
      if (respObj.responseCode == 0) {
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

  static Future<Result<dynamic>> callRePrint(BuildContext context, String baseUrl, String relativeUrl, Map<String, dynamic> request) async {
    ModuleBeanLst? mModuleBeanList = ModuleBeanLst.fromJson(jsonDecode(UserInfo.getDrawGameBeanList));
    MenuBeanList? apiDetails = mModuleBeanList.menuBeanList?.where((element) => element.menuCode == "DGE_REPRINT").toList()[0];
    UrlDrawGameBean? rePrintGameUrlsDetails = getDrawGameUrlDetails(apiDetails!, context, "reprintTicket");

    Map<String, String> header = {
      "username": rePrintGameUrlsDetails?.username ?? "",
      "password": rePrintGameUrlsDetails?.password ?? "",
    };

    dynamic jsonMap = await LotteryRepository.callRePrint(context, request, header, baseUrl, relativeUrl, rePrintGameUrlsDetails);

    try {
      var respObj = RePrintResponse.fromJson(jsonMap);
      if (respObj.responseCode == 0) {
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