import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:longalottoretail/drawer/longa_lotto_pos_drawer.dart';
import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/login/models/response/GetLoginDataResponse.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/widgets/longa_lotto_pos_scaffold.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:longalottoretail/lottery/models/response/ResultResponse.dart' as result_response;
import 'package:longalottoretail/lottery/widgets/printing_dialog.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:longalottoretail/utility/utils.dart';

import '../../models/response/ResultResponse.dart';

class ResultPreview extends StatefulWidget {
  final List<result_response.ResponseData>? resultList;
  const ResultPreview({Key? key, required this.resultList}) : super(key: key);

  @override
  State<ResultPreview> createState() => _ResultPreviewState();
}

class _ResultPreviewState extends State<ResultPreview> {
  List<ResultInfo>? resultInfo;

  @override
  void initState() {
    resultInfo = widget.resultList?[0].resultData?[0].resultInfo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LongaScaffold(showAppBar: true,
      drawer: LongaLottoPosDrawer(drawerModuleList: const []),
      appBarTitle: context.l10n.result,
      appBackGroundColor: LongaLottoPosColor.app_bg,
      body: ListView.builder(
          itemCount: resultInfo?.length ?? 0,
          itemBuilder: (BuildContext ctx, int mainIndex) {
            return Align(
              alignment: Alignment.topCenter,
              child: FittedBox(
                child: Container(
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 1),
                    color: LongaLottoPosColor.light_dark_white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                        offset: Offset(
                          1.0, // Move to right 5  horizontally
                          1.0, // Move to bottom 5 Vertically
                        ),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Colors.black),
                                  color: LongaLottoPosColor.white_two
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.draw_time,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        color: LongaLottoPosColor.warm_grey_seven,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Text(
                                    resultInfo?[mainIndex].drawTime ?? "NA",
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500
                                    ),
                                  )
                                ],
                              ).p(5),
                            ).pOnly(right: 10),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Colors.black),
                                  color: LongaLottoPosColor.white_two
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.draw_no,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        color: LongaLottoPosColor.warm_grey_seven,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Text(
                                    resultInfo?[mainIndex].drawId.toString() ?? "NA",
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500
                                    ),
                                  )
                                ],
                              ).p(5),
                            ).pOnly(right: 10),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                var gameName = widget.resultList?.isNotEmpty == true ? widget.resultList![0].gameName : "";
                                Map<String,dynamic> printingDataArgs = {};
                                printingDataArgs["resultData"]            = jsonEncode(resultInfo?[mainIndex] ?? []);
                                printingDataArgs["gameName"]              = gameName;
                                GetLoginDataResponse loginResponse        = GetLoginDataResponse.fromJson(jsonDecode(UserInfo.getUserInfo));
                                printingDataArgs["username"]              = loginResponse.responseData?.data?.orgName ?? "";
                                printingDataArgs["currencyCode"]          = getDefaultCurrency(getLanguage());
                                printingDataArgs["resultDate"]            = widget.resultList?[0].resultData?[0].resultDate?.split(" ")[0];
                                printingDataArgs["languageCode"]          = LongaLottoRetailApp.of(context).locale.languageCode;

                                PrintingDialog().show(context: context, title: context.l10n.printing_started, isRetryButtonAllowed: false, buttonText: 'Retry', printingDataArgs: printingDataArgs, isLastResult: true, onPrintingDone:(){
                                }, isPrintingForSale: false);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: Colors.black),
                                    color: LongaLottoPosColor.navy_blue
                                ),
                                child: const Icon(Icons.print, size: 45, color: Colors.white,),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                          color: LongaLottoPosColor.white_two,
                        ),
                        child: Text(
                          context.l10n.draw_result,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: LongaLottoPosColor.black),
                        ).p(5),
                      ).pOnly(top: 14),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                          color: LongaLottoPosColor.white_two,
                        ),
                        child: Text(
                          context.l10n.main_bet,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: LongaLottoPosColor.black),
                        ).p(5),
                      ).pOnly(top: 12),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                          color: LongaLottoPosColor.white_two,
                        ),
                        child: Text(
                          (resultInfo?[mainIndex].winningNo ?? "").replaceAll(",", "  "),
                          maxLines: 5,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: LongaLottoPosColor.black),
                        ).p(8),
                      ).pOnly(top: 6),
                      /*Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                          color: LongaLottoPosColor.white_two,
                        ),
                        child: const Text(
                          "Side Bet",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ).p(5),
                      ).pOnly(top: 12),
                      Container(
                        height: 170,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1)
                        ),
                        child: ListView.builder(
                            itemCount: resultInfo?.resultInfo?[mainIndex].sideBetMatchInfo?.length ?? 0,
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                children: [
                                  Text(resultInfo?.resultInfo?[mainIndex].sideBetMatchInfo?[index].betDisplayName ?? ""),
                                  Expanded(child: Container(),),
                                  Text(
                                    resultInfo?.resultInfo?[mainIndex].sideBetMatchInfo?[index].pickTypeName ?? "",
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  )
                                ],
                              ).pOnly(top: 4);
                            }
                        ).p(8),
                      ).pOnly(top: 6),*/
                      resultInfo?[mainIndex].winningMultiplierInfo != null
                          ? Row(
                        children: [
                          Text(context.l10n.winning_multiplier,style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16)),
                          Expanded(child: Container()),
                          Text("${resultInfo?[mainIndex].winningMultiplierInfo?.multiplierCode ?? ""} (${resultInfo?[mainIndex].winningMultiplierInfo?.value ?? ""})",style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16))
                        ],
                      ).pOnly(top: 7)
                          : Container()
                    ],
                  ).p(10),
                ).pOnly(top: 10),
              ),
            ).pOnly(top: 9, bottom: 9);
          }
      ),
    );
  }
}
