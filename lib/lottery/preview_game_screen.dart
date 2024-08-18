import 'dart:convert';
import 'dart:developer';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:longalottoretail/drawer/longa_lotto_pos_drawer.dart';
import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/login/bloc/login_bloc.dart';
import 'package:longalottoretail/login/bloc/login_event.dart';
import 'package:longalottoretail/login/bloc/login_state.dart';
import 'package:longalottoretail/login/models/response/GetLoginDataResponse.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_screens.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:longalottoretail/lottery/bloc/lottery_bloc.dart';
import 'package:longalottoretail/lottery/bloc/lottery_event.dart';
import 'package:longalottoretail/lottery/bloc/lottery_state.dart';
import 'package:longalottoretail/lottery/models/otherDataClasses/advanceDrawBean.dart';
import 'package:longalottoretail/lottery/models/otherDataClasses/bankerBean.dart';
import 'package:longalottoretail/lottery/models/response/fetch_game_data_response.dart';
import 'package:longalottoretail/lottery/models/otherDataClasses/panelBean.dart' as m_panel_bean;
import 'package:longalottoretail/lottery/widgets/advance_date_selection_dialog.dart';
import 'package:longalottoretail/lottery/widgets/bet_deletion_dialog.dart';
import 'package:longalottoretail/lottery/widgets/printing_dialog.dart';
import 'package:longalottoretail/utility/shared_pref.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:longalottoretail/utility/utils.dart';
import '../main.dart';
import '../utility/auth_bloc/auth_bloc.dart';
import '../utility/widgets/show_snackbar.dart';
import 'models/otherDataClasses/panelBean.dart';

/*
    created by Rajneesh Kr.Sharma on 7 May, 23
*/

class PreviewGameScreen extends StatefulWidget {
  List<m_panel_bean.PanelBean> gameSelectedDetails;
  GameRespVOs? gameObjectsList;
  final Function(String) onComingToPreviousScreen;
  final Function(List<m_panel_bean.PanelBean>) selectedGamesData;
  final Function(m_panel_bean.PanelBean)? selectedGamesDataForEdit;

  PreviewGameScreen(
      {Key? key,
      required this.gameSelectedDetails,
      this.gameObjectsList,
      required this.onComingToPreviousScreen,
      required this.selectedGamesData,
      this.selectedGamesDataForEdit})
      : super(key: key);

  @override
  State<PreviewGameScreen> createState() => _PreviewGameScreenState();
}

class _PreviewGameScreenState extends State<PreviewGameScreen> {
  int mNumberOfDraws = 1;
  int mIndexConsecutiveDrawsList = 0;
  late int drawRespLength;
  List<Map<String, String>> listAdvanceDraws = [];
  List<String> listConsecutiveDraws = [];
  List<m_panel_bean.PanelBean> listPanel = [];
  String drawCountAdvance = "0";
  bool minusDraw = false;
  bool plusDraw = false;
  bool isAdvancePlay = false;
  String betAmount = "";
  String noOfBet = "";
  bool addDrawNotAllowed = false;
  bool minusDrawNotAllowed = false;
  bool isPurchasing = false;
  bool isAdvanceDateSelectionOptionChosen = false;
  List<AdvanceDrawBean> mAdvanceDrawBean = [];
  List<Map<String, String>> listAdvanceMap = [];
  int noOfDrawsFromDrawBtn = 0;
  int drawsCount = 1;
  String lastTicketNumber = "";
  String lastGameCode = "";
  Map<String, dynamic> printingDataArgs = {};

  @override
  void initState() {
    super.initState();
    initializeInitialValues();

    log("listPanel: ${jsonEncode(listPanel)}");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is GetLoginDataSuccess) {
          if (state.response != null) {
            BlocProvider.of<AuthBloc>(context)
                .add(UpdateUserInfo(loginDataResponse: state.response!));
            setState(() {
              isPurchasing = false;
            });
            PrintingDialog().show(
                context: context,
                title: context.l10n.printing_started,
                isRetryButtonAllowed: false,
                buttonText: context.l10n.retry,
                printingDataArgs: printingDataArgs,
                onPrintingDone: () {
                  SharedPrefUtils.setDgeLastSaleTicketNo = lastTicketNumber;
                  SharedPrefUtils.setDgeLastSaleGameCode = lastGameCode;
                  SharedPrefUtils.setLastReprintTicketNo = lastTicketNumber;
                  widget.onComingToPreviousScreen("isBuyPerformed");
                  Navigator.of(context).pop(true);
                },
                onPrintingFailed: () {
                  if (SharedPrefUtils.getDgeLastSaleTicketNo == "" ||
                      SharedPrefUtils.getDgeLastSaleTicketNo == "0") {
                    SharedPrefUtils.setDgeLastSaleTicketNo = "-1";
                    SharedPrefUtils.setDgeLastSaleGameCode = lastGameCode;
                  }
                },
                isPrintingForSale: true);

            print(
                "SharedPrefUtils.getDgeLastSaleTicketNo: ${SharedPrefUtils.getDgeLastSaleTicketNo}");
          }
        } else if (state is GetLoginDataError) {
          PrintingDialog().show(
              context: context,
              title: context.l10n.printing_started,
              isRetryButtonAllowed: false,
              buttonText: context.l10n.retry,
              printingDataArgs: printingDataArgs,
              onPrintingDone: () {
                SharedPrefUtils.setDgeLastSaleTicketNo = lastTicketNumber;
                SharedPrefUtils.setDgeLastSaleGameCode = lastGameCode;
                SharedPrefUtils.setLastReprintTicketNo = lastTicketNumber;
                widget.onComingToPreviousScreen("isBuyPerformed");
                Navigator.of(context).pop(true);
              },
              onPrintingFailed: () {
                if (SharedPrefUtils.getDgeLastSaleTicketNo == "" ||
                    SharedPrefUtils.getDgeLastSaleTicketNo == "0") {
                  SharedPrefUtils.setDgeLastSaleTicketNo = "-1";
                  SharedPrefUtils.setDgeLastSaleGameCode = lastGameCode;
                }
              },
              isPrintingForSale: true);

        }
      },
      child: WillPopScope(
        onWillPop: () async {
          return !isPurchasing;
        },
        child: AbsorbPointer(
          absorbing: isPurchasing,
          child: LongaScaffold(
            showAppBar: true,
            backgroundColor: LongaLottoPosColor.white_five,
            appBackGroundColor: LongaLottoPosColor.app_bg,
            drawer: LongaLottoPosDrawer(drawerModuleList: const []),
            onBackButton: () {
              widget.selectedGamesData(listPanel);
              Navigator.of(context).pop();
            },
            appBarTitle: context.l10n.purchase_details,
            body: BlocListener<LotteryBloc, LotteryState>(
              listener: (context, state) {
                if (state is GameSaleApiLoading) {
                  setState(() {
                    isPurchasing = true;
                  });
                } else if (state is GameSaleApiSuccess) {
                  lastTicketNumber =
                      state.response.responseData?.ticketNumber.toString() ??
                          "";
                  lastGameCode =
                      state.response.responseData?.gameCode.toString() ?? "";

                  printingDataArgs["saleResponse"] = jsonEncode(state.response);
                  GetLoginDataResponse loginResponse =
                      GetLoginDataResponse.fromJson(
                          jsonDecode(UserInfo.getUserInfo));
                  print(
                      "loginResponse.responseData?.data?.orgName: ${loginResponse.responseData?.data?.orgName}");
                  printingDataArgs["username"] =
                      loginResponse.responseData?.data?.orgName ?? "";
                  printingDataArgs["currencyCode"] =
                      getDefaultCurrency(getLanguage());
                  log("before printing: ${jsonEncode(listPanel)}");
                  printingDataArgs["panelData"] = jsonEncode(listPanel);
                  printingDataArgs["languageCode"] =
                      LongaLottoRetailApp.of(context).locale.languageCode;

                  BlocProvider.of<LoginBloc>(context)
                      .add(GetLoginDataApi(context: context));
                }
                if (state is GameSaleApiError) {
                  setState(() {
                    isPurchasing = false;
                  });
                  ShowToast.showToast(context, state.errorMessage.toString(),
                      type: ToastType.ERROR);
                  Future.delayed(Duration(seconds: 1), () {
                    if (state.errorCode != null) {
                      if (state.errorCode == 102) {
                        Map<String, dynamic> panelDataToBeSave = {
                          "panelData": listPanel
                        };
                        SharedPrefUtils.setSelectedPanelData =
                            jsonEncode(panelDataToBeSave);
                        SharedPrefUtils.setSelectedGameObject =
                            jsonEncode(widget.gameObjectsList);

                        print(
                            "UserInfo.getSelectedPanelData: ${jsonDecode(UserInfo.getSelectedPanelData)}");
                        var jsonPanelData =
                            jsonDecode(UserInfo.getSelectedPanelData)
                                as Map<String, dynamic>;
                        print("jsonPanelData: $jsonPanelData");
                        print(
                            "jsonPanelData[panelData]: ${jsonPanelData["panelData"]}");
                        print(
                            "UserInfo.getSelectedGameObject: ${GameRespVOs.fromJson(jsonDecode(UserInfo.getSelectedGameObject))}");
                        Navigator.of(context).popUntil((route) => true);
                        Navigator.of(context)
                            .pushNamed(LongaLottoPosScreen.loginScreen);
                      }
                    }
                  });
                }
              },
              child: WillPopScope(
                onWillPop: () async {
                  widget.selectedGamesData(listPanel);
                  return true;
                },
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: LongaLottoPosColor.light_dark_white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6)),
                          boxShadow: [
                            BoxShadow(
                              color: LongaLottoPosColor.warm_grey_six,
                              blurRadius: .5,
                              offset: Offset(.5, 0),
                            ),
                            BoxShadow(
                              color: LongaLottoPosColor.warm_grey_six,
                              blurRadius: 1.0,
                              offset: Offset(-.5, -.5),
                            ),
                          ],
                        ),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(widget.gameObjectsList?.gameName ?? "",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: LongaLottoPosColor.black,
                                        fontWeight: FontWeight.bold))
                                .pOnly(top: 8, bottom: 8, left: 16)),
                      ).pOnly(top: 8, right: 8, left: 8),
                      Expanded(
                        flex: 8,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: widget.gameSelectedDetails.length,
                            itemBuilder:
                                (BuildContext context, int panelListItemIndex) {
                              int numberOfLines = widget
                                      .gameSelectedDetails[panelListItemIndex]
                                      .numberOfLines ??
                                  0;
                              var listOfUpperLowerLineLength = widget
                                      .gameSelectedDetails[panelListItemIndex]
                                      .listSelectedNumberUpperLowerLine
                                      ?.length ??
                                  0;
                              List<BankerBean> listOfUpperLine = [];
                              List<BankerBean> listOfLowerLine = [];
                              for (int i = 0;
                                  i < listOfUpperLowerLineLength;
                                  i++) {
                                List<BankerBean> tempUpperList = widget
                                        .gameSelectedDetails[panelListItemIndex]
                                        .listSelectedNumberUpperLowerLine?[0]
                                            ["$i"]
                                        ?.where((element) =>
                                            element.isSelectedInUpperLine ==
                                            true)
                                        .toList() ??
                                    [];
                                List<BankerBean> tempLowerList = widget
                                        .gameSelectedDetails[panelListItemIndex]
                                        .listSelectedNumberUpperLowerLine?[0]
                                            ["$i"]
                                        ?.where((element) =>
                                            element.isSelectedInUpperLine ==
                                            false)
                                        .toList() ??
                                    [];
                                if (tempUpperList.isNotEmpty) {
                                  listOfUpperLine.addAll(tempUpperList);
                                }
                                if (tempLowerList.isNotEmpty) {
                                  listOfLowerLine.addAll(tempLowerList);
                                }
                              }

                              int listOfUpperLineNosLength = widget
                                      .gameSelectedDetails[panelListItemIndex]
                                      .listSelectedNumberUpperLowerLine
                                      ?.length ??
                                  0;
                              int listOfLowerLineNosLength = widget
                                      .gameSelectedDetails[panelListItemIndex]
                                      .listSelectedNumberUpperLowerLine
                                      ?.length ??
                                  0;
                              var listOfOtherPickTypeNos = widget
                                      .gameSelectedDetails[panelListItemIndex]
                                      .listSelectedNumber?[0] ??
                                  0;
                              int lenSelectedNo = widget
                                      .gameSelectedDetails[panelListItemIndex]
                                      .listSelectedNumber?[0]["0"]
                                      ?.length ??
                                  0;
                              print(
                                  "listOfOtherPickTypeNos: $listOfOtherPickTypeNos");
                              var listOfSelectedNoPickType = widget
                                      .gameSelectedDetails[panelListItemIndex]
                                      .listSelectedNumber?[0]
                                      .length ??
                                  0;
                              return AnimationConfiguration.staggeredList(
                                duration: const Duration(milliseconds: 500),
                                position: panelListItemIndex,
                                child: FlipAnimation(
                                  flipAxis: FlipAxis.x,
                                  child: FadeInAnimation(
                                    child: Container(
                                      color: LongaLottoPosColor.white,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          listOfUpperLineNosLength > 0 &&
                                                  listOfLowerLineNosLength > 0
                                              ? Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("${context.l10n.ul} -",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: const TextStyle(
                                                                    color: LongaLottoPosColor
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))
                                                            .pOnly(
                                                                top: 8,
                                                                bottom: 8,
                                                                right: 8),
                                                        Container(
                                                            height: 40,
                                                            color:
                                                                LongaLottoPosColor
                                                                    .white,
                                                            child: Container(
                                                              width: 30,
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      LongaLottoPosColor
                                                                          .white,
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              6)),
                                                                  border: Border.all(
                                                                      color: LongaLottoPosColor
                                                                          .pale_lilac)),
                                                              child: Center(
                                                                  child: Text(
                                                                      listOfUpperLine[0]
                                                                              .number ??
                                                                          "?",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: const TextStyle(
                                                                          color: LongaLottoPosColor
                                                                              .black,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.bold))),
                                                            ).p(2)),
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Text("${context.l10n.ll} -",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: const TextStyle(
                                                                      color: LongaLottoPosColor
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                              .pOnly(
                                                                  top: 8,
                                                                  bottom: 8,
                                                                  left: 16,
                                                                  right: 8),
                                                          Expanded(
                                                            child: Container(
                                                              height: 40,
                                                              color:
                                                                  LongaLottoPosColor
                                                                      .white,
                                                              child: ListView
                                                                  .builder(
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          const BouncingScrollPhysics(),
                                                                      itemCount:
                                                                          listOfLowerLine
                                                                              .length,
                                                                      itemBuilder:
                                                                          (BuildContext context,
                                                                              int lowerLinesNoIndex) {
                                                                        return Container(
                                                                          width:
                                                                              30,
                                                                          decoration: BoxDecoration(
                                                                              color: LongaLottoPosColor.white,
                                                                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                                                                              border: Border.all(color: LongaLottoPosColor.pale_lilac)),
                                                                          child:
                                                                              Center(child: Text(listOfLowerLine[lowerLinesNoIndex].number ?? "?", textAlign: TextAlign.center, style: const TextStyle(color: LongaLottoPosColor.black, fontSize: 12, fontWeight: FontWeight.bold))),
                                                                        ).p(2);
                                                                      }),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text("${widget.gameSelectedDetails[panelListItemIndex].amount?.toInt()} ${getDefaultCurrency(getLanguage())}",
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: const TextStyle(
                                                                color:
                                                                    LongaLottoPosColor
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))
                                                        .pOnly(
                                                            top: 8,
                                                            bottom: 8,
                                                            left: 16)
                                                  ],
                                                )
                                              : widget
                                                          .gameSelectedDetails[
                                                              panelListItemIndex]
                                                          .isMainBet ==
                                                      true
                                                  ? Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                              color:
                                                                  LongaLottoPosColor
                                                                      .white,
                                                              child: Wrap(
                                                                  children: List
                                                                      .generate(
                                                                          lenSelectedNo,
                                                                          (otherPickTypeNosIndex) {
                                                                return Container(
                                                                  width: 30,
                                                                  height: 30,
                                                                  decoration: BoxDecoration(
                                                                      color: LongaLottoPosColor
                                                                          .white,
                                                                      borderRadius: const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              6)),
                                                                      border: Border.all(
                                                                          color:
                                                                              LongaLottoPosColor.pale_lilac)),
                                                                  child: Center(
                                                                      child: Text(
                                                                          widget.gameSelectedDetails[panelListItemIndex].listSelectedNumber?[0]["0"]?[otherPickTypeNosIndex] ??
                                                                              "?",
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style: const TextStyle(
                                                                              color: LongaLottoPosColor.black,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold))),
                                                                ).p(2);
                                                              }))),
                                                        ),
                                                        /*listOfSelectedNoPickType > 1
                                                  ? const Text("+", style: TextStyle(color: LongaLottoPosColor.black, fontSize: 12, fontWeight: FontWeight.bold)).pSymmetric(v:8, h:8)
                                                  : Container(),
                                              listOfSelectedNoPickType > 1
                                                  ? Expanded(
                                                child: Container(
                                                    height:40,
                                                    color: LongaLottoPosColor.white, ///////////////////////
                                                    child: ListView.builder(
                                                        scrollDirection: Axis.horizontal,
                                                        padding: EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        itemCount: widget.gameSelectedDetails[panelListItemIndex].listSelectedNumber?[0]["1"]?.length,
                                                        physics: const BouncingScrollPhysics(),
                                                        itemBuilder: (BuildContext context, int otherPickTypeNosIndex) {
                                                          return Container(
                                                            width: 30,
                                                            decoration: BoxDecoration(
                                                                color: LongaLottoPosColor.white,
                                                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                                                                border: Border.all(color: LongaLottoPosColor.pale_lilac)
                                                            ),
                                                            child: Center(child: Text(widget.gameSelectedDetails[panelListItemIndex].listSelectedNumber?[0]["1"]?[otherPickTypeNosIndex] ?? "?", textAlign: TextAlign.center, style: const TextStyle(color: LongaLottoPosColor.black, fontSize: 12,fontWeight: FontWeight.bold))),
                                                          );
                                                        }
                                                    )),
                                              )
                                                  : Container(),*/
                                                        Text("${widget.gameSelectedDetails[panelListItemIndex].amount?.toInt()} ${getDefaultCurrency(getLanguage())}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: const TextStyle(
                                                                    color: LongaLottoPosColor
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))
                                                            .pOnly(
                                                                top: 8,
                                                                bottom: 8,
                                                                left: 16)
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  LongaLottoPosColor
                                                                      .white,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          6)),
                                                              border: Border.all(
                                                                  color: LongaLottoPosColor
                                                                      .pale_lilac)),
                                                          child: Center(
                                                              child: Text(
                                                                      widget.gameSelectedDetails[panelListItemIndex].pickName ??
                                                                          "?",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: const TextStyle(
                                                                          color: LongaLottoPosColor
                                                                              .black,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.bold))
                                                                  .p(10)),
                                                        ).p(2),
                                                        Expanded(
                                                            child: Container()),
                                                        Text("${widget.gameSelectedDetails[panelListItemIndex].amount?.toInt()} ${getDefaultCurrency(getLanguage())}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: const TextStyle(
                                                                    color: LongaLottoPosColor
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))
                                                            .pOnly(
                                                                top: 8,
                                                                bottom: 8,
                                                                left: 16)
                                                      ],
                                                    ),
                                          Row(
                                            children: [
                                              Text(
                                                      /*widget.gameSelectedDetails[panelListItemIndex].isMainBet == true
                                                      ? numberOfLines > 2
                                                      ? "${context.l10n.main_bet} | ${widget.gameSelectedDetails[panelListItemIndex].pickName} | ${context.l10n.no_of_lines}: ${widget.gameSelectedDetails[panelListItemIndex].numberOfLines}"
                                                      : "${context.l10n.main_bet} | ${widget.gameSelectedDetails[panelListItemIndex].pickName} | ${context.l10n.no_of_line}: ${widget.gameSelectedDetails[panelListItemIndex].numberOfLines}"

                                                      : numberOfLines > 2
                                                      ? "${context.l10n.side_bet} | ${widget.gameSelectedDetails[panelListItemIndex].pickName} | ${context.l10n.no_of_lines}: ${widget.gameSelectedDetails[panelListItemIndex].numberOfLines}"
                                                      : "${context.l10n.side_bet} | ${widget.gameSelectedDetails[panelListItemIndex].pickName} | ${context.l10n.no_of_line}: ${widget.gameSelectedDetails[panelListItemIndex].numberOfLines}",*/
                                                      widget
                                                                  .gameSelectedDetails[
                                                                      panelListItemIndex]
                                                                  .isMainBet ==
                                                              true
                                                          ? numberOfLines > 2
                                                              ? "${widget.gameSelectedDetails[panelListItemIndex].betName}  | ${widget.gameSelectedDetails[panelListItemIndex].pickName?.toUpperCase() == "MANUAL" ? context.l10n.manual : context.l10n.qp}"
                                                              : "${widget.gameSelectedDetails[panelListItemIndex].betName} | ${widget.gameSelectedDetails[panelListItemIndex].pickName?.toUpperCase() == "MANUAL" ? context.l10n.manual : context.l10n.qp}"
                                                          : numberOfLines > 2
                                                              ? "${context.l10n.side_bet} | ${widget.gameSelectedDetails[panelListItemIndex].pickName} | ${context.l10n.no_of_lines}: ${widget.gameSelectedDetails[panelListItemIndex].numberOfLines}"
                                                              : "${context.l10n.side_bet} | ${widget.gameSelectedDetails[panelListItemIndex].pickName} | ${context.l10n.no_of_line}: ${widget.gameSelectedDetails[panelListItemIndex].numberOfLines}",
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor
                                                                  .black,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                  .pOnly(top: 8, bottom: 8),
                                              Expanded(child: Container()),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  widget.selectedGamesDataForEdit!(
                                                      widget.gameSelectedDetails[
                                                          panelListItemIndex]);
                                                },
                                                child: Ink(
                                                    child: const Icon(
                                                        Icons.edit,
                                                        size: 20,
                                                        color: LongaLottoPosColor
                                                            .game_color_blue)),
                                              ),
                                              const WidthBox(10),
                                              InkWell(
                                                onTap: () {
                                                  BetDeletionDialog().show(
                                                      context: context,
                                                      title: "",
                                                      buttonText:
                                                          context.l10n.ok_cap,
                                                      isCloseButton: true,
                                                      panelBeanDetails: listPanel[
                                                          panelListItemIndex],
                                                      onButtonClick: (PanelBean
                                                          panelBean) {
                                                        setState(() {
                                                          listPanel.remove(
                                                              panelBean);
                                                        });
                                                        recalculatePanelAmount();
                                                        if (listPanel.isEmpty) {
                                                          widget.onComingToPreviousScreen(
                                                              "isAllPreviewDataDeleted");
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        }
                                                      });
                                                },
                                                child: Ink(
                                                    child: SvgPicture.asset(
                                                        'assets/icons/delete.svg',
                                                        width: 20,
                                                        height: 20,
                                                        color: LongaLottoPosColor
                                                            .game_color_red)),
                                              ),
                                            ],
                                          ),
                                          panelListItemIndex !=
                                                  widget.gameSelectedDetails
                                                          .length -
                                                      1
                                              ? Container(
                                                  decoration: DottedDecoration(
                                                    color: LongaLottoPosColor
                                                        .ball_border_bg,
                                                    strokeWidth: 0.5,
                                                    linePosition:
                                                        LinePosition.bottom,
                                                  ),
                                                  height: 12,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                )
                                              : Container(),
                                        ],
                                      ).p(8),
                                    ),
                                  ),
                                ),
                              );
                            }).pOnly(right: 8, left: 8),
                      ),
                      Container(
                          height: 20, color: LongaLottoPosColor.white_five),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                    color: LongaLottoPosColor.marigold,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(context.l10n.no_of_draws,
                                            style: const TextStyle(
                                                color: LongaLottoPosColor.white,
                                                fontSize: 12)))),
                              ),
                              const VerticalDivider(width: 1),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Ink(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: LongaLottoPosColor.white,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          border: Border.all(
                                              color: LongaLottoPosColor
                                                  .game_color_grey,
                                              width: .5)),
                                      child: AbsorbPointer(
                                        absorbing: minusDrawNotAllowed,
                                        child: InkWell(
                                          onTap: () {
                                            resetAdvanceDraws();
                                            setState(() {
                                              noOfDrawsFromDrawBtn = 0;
                                              mAdvanceDrawBean.clear();
                                              listAdvanceMap.clear();
                                              isAdvancePlay = false;
                                              if (mIndexConsecutiveDrawsList >
                                                  0) {
                                                mNumberOfDraws = int.parse(
                                                    listConsecutiveDraws[
                                                        --mIndexConsecutiveDrawsList]);
                                              }
                                            });
                                            enableDisableDrawsButton();
                                            recalculatePanelAmount();
                                          },
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                              child: SvgPicture.asset(
                                                  'assets/icons/minus.svg',
                                                  width: 20,
                                                  height: 20,
                                                  color: mIndexConsecutiveDrawsList ==
                                                              -1 ||
                                                          mIndexConsecutiveDrawsList ==
                                                              0
                                                      ? LongaLottoPosColor
                                                          .game_color_grey
                                                      : LongaLottoPosColor
                                                          .black)),
                                        ),
                                      ),
                                    ).pOnly(right: 8),
                                    Align(
                                            alignment: Alignment.center,
                                            child: Text("$mNumberOfDraws",
                                                style: const TextStyle(
                                                    color: LongaLottoPosColor
                                                        .game_color_red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)))
                                        .pOnly(right: 8),
                                    Ink(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: LongaLottoPosColor.white,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          border: Border.all(
                                              color: LongaLottoPosColor
                                                  .game_color_grey,
                                              width: .5)),
                                      child: AbsorbPointer(
                                        absorbing: addDrawNotAllowed,
                                        child: InkWell(
                                          onTap: () {
                                            resetAdvanceDraws();
                                            setState(() {
                                              noOfDrawsFromDrawBtn = 0;
                                              mAdvanceDrawBean.clear();
                                              listAdvanceMap.clear();
                                              isAdvancePlay = false;
                                              drawRespLength = widget
                                                      .gameObjectsList
                                                      ?.drawRespVOs
                                                      ?.length ??
                                                  0;
                                              if (mIndexConsecutiveDrawsList <
                                                  drawRespLength) {
                                                mNumberOfDraws = int.parse(
                                                    listConsecutiveDraws[
                                                        ++mIndexConsecutiveDrawsList]);
                                              }
                                            });
                                            enableDisableDrawsButton();
                                            recalculatePanelAmount();
                                          },
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                              child: SvgPicture.asset(
                                                  'assets/icons/plus.svg',
                                                  width: 20,
                                                  height: 20,
                                                  color:
                                                      mIndexConsecutiveDrawsList ==
                                                              drawRespLength - 1
                                                          ? LongaLottoPosColor
                                                              .game_color_grey
                                                          : LongaLottoPosColor
                                                              .black)),
                                        ),
                                      ),
                                    ).pOnly(right: 8),
                                  ],
                                ),
                              ),
                              const VerticalDivider(width: 1, thickness: 1),
                              Expanded(
                                child: Material(
                                  child: InkWell(
                                    onTap: () {
                                      if (mAdvanceDrawBean.isEmpty) {
                                        List<DrawRespVOs> drawDateObjectsList =
                                            widget.gameObjectsList
                                                    ?.drawRespVOs ??
                                                [];
                                        for (DrawRespVOs drawResp
                                            in drawDateObjectsList) {
                                          if (mAdvanceDrawBean.length < 3) {
                                            mAdvanceDrawBean.add(
                                                AdvanceDrawBean(
                                                    drawRespVOs: drawResp,
                                                    isSelected: false));
                                          }
                                        }
                                      }
                                      if (mAdvanceDrawBean.isNotEmpty) {
                                        AdvanceDateSelectionDialog().show(
                                            context: context,
                                            title: context.l10n.select_draw,
                                            buttonText: context.l10n.select_cap,
                                            isCloseButton: true,
                                            listOfDraws: mAdvanceDrawBean,
                                            buttonClick: (List<AdvanceDrawBean>
                                                advanceDrawBean) {
                                              setState(() {
                                                if (advanceDrawBean.length >
                                                    1) {
                                                  if (advanceDrawBean
                                                      .where((element) =>
                                                          element.isSelected ==
                                                          true)
                                                      .toList()
                                                      .isNotEmpty) {
                                                    mAdvanceDrawBean =
                                                        advanceDrawBean;
                                                    noOfDrawsFromDrawBtn =
                                                        mAdvanceDrawBean
                                                            .where((element) =>
                                                                element
                                                                    .isSelected ==
                                                                true)
                                                            .toList()
                                                            .length;
                                                    mNumberOfDraws = 0;
                                                    mIndexConsecutiveDrawsList =
                                                        -1;
                                                    enableDisableDrawsButton();
                                                    recalculatePanelAmount();
                                                  } else {
                                                    resetAdvanceDraws();
                                                    setState(() {
                                                      noOfDrawsFromDrawBtn = 0;
                                                      mAdvanceDrawBean.clear();
                                                      listAdvanceMap.clear();
                                                      isAdvancePlay = false;
                                                      drawRespLength = widget
                                                              .gameObjectsList
                                                              ?.drawRespVOs
                                                              ?.length ??
                                                          0;
                                                      if (mIndexConsecutiveDrawsList <
                                                          drawRespLength) {
                                                        mNumberOfDraws = int.parse(
                                                            listConsecutiveDraws[
                                                                ++mIndexConsecutiveDrawsList]);
                                                      }
                                                    });
                                                    enableDisableDrawsButton();
                                                    recalculatePanelAmount();
                                                  }
                                                }
                                              });
                                            });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          duration: const Duration(seconds: 1),
                                          content: Text(context
                                              .l10n.no_advance_draw_available),
                                        ));
                                      }
                                    },
                                    child: Ink(
                                      color:
                                          LongaLottoPosColor.light_dark_white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: LongaLottoPosColor
                                                          .white,
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      border: Border.all(
                                                          color: LongaLottoPosColor
                                                              .game_color_grey,
                                                          width: .5)),
                                                  child: Center(
                                                      child: SvgPicture.asset(
                                                          'assets/icons/draw_list.svg',
                                                          width: 16,
                                                          height: 16,
                                                          color: LongaLottoPosColor
                                                              .game_color_grey)))
                                              .pOnly(right: 8),
                                          Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      context.l10n.draw_list,
                                                      style: const TextStyle(
                                                          color: LongaLottoPosColor
                                                              .game_color_grey,
                                                          fontSize: 10)))
                                              .pOnly(right: 8),
                                          Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      mAdvanceDrawBean
                                                                  .where(
                                                                      (element) =>
                                                                          element
                                                                              .isSelected ==
                                                                          true)
                                                                  .toList()
                                                                  .isNotEmpty ==
                                                              true
                                                          ? mAdvanceDrawBean
                                                              .where((element) =>
                                                                  element
                                                                      .isSelected ==
                                                                  true)
                                                              .toList()
                                                              .length
                                                              .toString()
                                                          : "0",
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor
                                                                  .game_color_red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16)))
                                              .pOnly(right: 8),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          color: LongaLottoPosColor.ball_border_light_bg,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text(noOfBet,
                                            style: const TextStyle(
                                                color: LongaLottoPosColor
                                                    .game_color_red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text(context.l10n.total_bets,
                                            style: const TextStyle(
                                                color: LongaLottoPosColor
                                                    .game_color_grey,
                                                fontSize: 12))),
                                  ],
                                ),
                              ),
                              const VerticalDivider(width: 1),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text(betAmount,
                                            style: const TextStyle(
                                                color: LongaLottoPosColor
                                                    .game_color_red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                            "${context.l10n.total_bet_value} (${getDefaultCurrency(getLanguage())})",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: LongaLottoPosColor
                                                    .game_color_grey,
                                                fontSize: 12))),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  child: InkWell(
                                    onTap: () {
                                      proceedToBuy();
                                    },
                                    child: Ink(
                                      color: LongaLottoPosColor.game_color_red,
                                      child: isPurchasing
                                          ? SizedBox(
                                              child: Lottie.asset(
                                                  'assets/lottie/buy_loader.json'))
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/icons/buy.svg',
                                                    width: 20,
                                                    height: 20,
                                                    color: LongaLottoPosColor
                                                        .white),
                                                Align(
                                                        alignment: Alignment
                                                            .center,
                                                        child: Text(
                                                            context
                                                                .l10n.buy_now,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: const TextStyle(
                                                                color:
                                                                    LongaLottoPosColor
                                                                        .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12)))
                                                    .pOnly(left: 4),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  proceedToBuy() {
    listAdvanceMap.clear();
    for (int i = 0; i < mAdvanceDrawBean.length; i++) {
      if (mAdvanceDrawBean[i].isSelected == true) {
        listAdvanceMap.add({
          "drawId": mAdvanceDrawBean[i].drawRespVOs?.drawId.toString() ?? ""
        });
      }
    }
    BlocProvider.of<LotteryBloc>(context).add(LotterySaleApi(
        context: context,
        isAdvancePlay: listAdvanceMap.isNotEmpty ? true : false,
        noOfDraws: drawsCount,
        listAdvanceDraws: listAdvanceMap,
        listPanel: widget.gameSelectedDetails,
        gameObjectsList: widget.gameObjectsList));
  }

  resetAdvanceDraws() {
    setState(() {
      listAdvanceDraws.clear();
      drawCountAdvance = "0";
    });
  }

  enableDisableDrawsButton() {
    setState(() {
      if (mIndexConsecutiveDrawsList == -1) {
        print("mIndexConsecutiveDrawsList: $mIndexConsecutiveDrawsList");
        addDrawNotAllowed = false;
        minusDrawNotAllowed = true;
      } else {
        if (mIndexConsecutiveDrawsList != drawRespLength - 1) {
          addDrawNotAllowed = false;
        } else {
          addDrawNotAllowed = true;
        }
        if (!addDrawNotAllowed) {
          if (mIndexConsecutiveDrawsList != 0) {
            minusDrawNotAllowed = false;
          } else {
            minusDrawNotAllowed = true;
          }
        }
      }
    });
  }

  void recalculatePanelAmount() {
    print("noOfDrawsFromDrawBtn:::::::::::::::::::::$noOfDrawsFromDrawBtn");
    int amt = 0;
    for (int index = 0; index < listPanel.length; index++) {
      if (noOfDrawsFromDrawBtn != 0) {
        setState(() {
          listPanel[index].numberOfDraws = noOfDrawsFromDrawBtn;
        });
      } else {
        setState(() {
          listPanel[index].numberOfDraws = mNumberOfDraws;
        });
      }
      print(
          "listPanel[index].numberOfDraws : ${listPanel[index].numberOfDraws}");
      int numberOfDraws = listPanel[index].numberOfDraws ?? 0;
      int numberOfLines = listPanel[index].numberOfLines ?? 0;

      var selectedAmt = listPanel[index].selectBetAmount ?? 0;

      amt += selectedAmt * numberOfDraws * numberOfLines;
      print("amt: $amt");
      /*setState(() {
        listPanel[index].amount = amt.toDouble();
      });*/
    }
    setState(() {
      betAmount = "$amt";
    });
    //calculateTotalAmount();
    calculateNumberOfBets();
  }

  calculateTotalAmount() {
    int amount = 0;

    for (m_panel_bean.PanelBean model in listPanel) {
      amount = amount + (model.amount != null ? model.amount!.toInt() : 0);
    }
    setState(() {
      betAmount = "${getDefaultCurrency(getLanguage())} $amount";
    });
    calculateNumberOfBets();
  }

  calculateNumberOfBets() {
    setState(() {
      noOfBet = "${listPanel.length}";
    });
  }

  Color? getColors(String colorName) {
    switch (colorName.toUpperCase()) {
      case "PINK":
        return LongaLottoPosColor.game_color_pink;
      case "RED":
        return LongaLottoPosColor.game_color_red;
      case "ORANGE":
        return LongaLottoPosColor.game_color_orange;
      case "BROWN":
        return LongaLottoPosColor.game_color_brown;
      case "GREEN":
        return LongaLottoPosColor.game_color_green;
      case "CYAN":
        return LongaLottoPosColor.game_color_cyan;
      case "BLUE":
        return LongaLottoPosColor.game_color_blue;
      case "MAGENTA":
        return LongaLottoPosColor.game_color_magenta;
      case "GREY":
        return LongaLottoPosColor.game_color_grey;
      case "BLACK":
        return LongaLottoPosColor.black;
    }

    return null;
  }

  createPanelData(List<dynamic> panelSavedDataList) {
    List<PanelBean> savedPanelBeanList = [];
    for (int i = 0; i < panelSavedDataList.length; i++) {
      PanelBean model = PanelBean();

      model.gameName = panelSavedDataList[i]["gameName"];
      model.amount = panelSavedDataList[i]["amount"];
      model.winMode = panelSavedDataList[i]["winMode"];
      model.betName = panelSavedDataList[i]["betName"];
      model.pickName = panelSavedDataList[i]["pickName"];
      model.betCode = panelSavedDataList[i]["betCode"];
      model.pickCode = panelSavedDataList[i]["pickCode"];
      model.pickConfig = panelSavedDataList[i]["pickConfig"];
      model.isPowerBallPlus = panelSavedDataList[i]["isPowerBallPlus"];
      model.selectBetAmount = panelSavedDataList[i]["selectBetAmount"];
      model.unitPrice = panelSavedDataList[i]["unitPrice"];
      model.numberOfDraws = panelSavedDataList[i]["numberOfDraws"];
      model.numberOfLines = panelSavedDataList[i]["numberOfLines"];
      model.isMainBet = panelSavedDataList[i]["isMainBet"];
      model.betAmountMultiple = panelSavedDataList[i]["betAmountMultiple"];
      model.isQuickPick = panelSavedDataList[i]["isQuickPick"];
      model.isQpPreGenerated = panelSavedDataList[i]["isQpPreGenerated"];

      List<Map<String, List<String>>> listOfSelectedNumber = [];
      if (panelSavedDataList[i]["listSelectedNumber"] != null) {
        Map<String, dynamic> mapOfSelectedNumbers = panelSavedDataList[i]
                ["listSelectedNumber"]
            [0]; // For Eg. {0: [40, 29, 26, 03, 31], 1: [03]}
        for (var i = 0; i < mapOfSelectedNumbers.length; i++) {
          List<String> numberList = List<String>.from(
              mapOfSelectedNumbers.values.toList()[i] as List);

          listOfSelectedNumber
              .add({mapOfSelectedNumbers.keys.toList()[i]: numberList});
        }
        print("listOfSelectedNumber --> $listOfSelectedNumber");
      }

      List<Map<String, List<BankerBean>>> listSelectedNumberUpperLowerLine = [];
      if (panelSavedDataList[i]["listSelectedNumberUpperLowerLine"] != 0) {
        Map<String, dynamic> mapOfBankerSelectedNumbers = panelSavedDataList[i]
                ["listSelectedNumberUpperLowerLine"]
            [0]; // For Eg. {0: [40, 29, 26, 03, 31], 1: [03]}
        for (var i = 0; i < mapOfBankerSelectedNumbers.length; i++) {
          List<BankerBean> bankerBeanList = [];
          for (var bankerDetails
              in mapOfBankerSelectedNumbers.values.toList()[i]) {
            bankerBeanList.add(BankerBean(
                number: bankerDetails["number"],
                color: bankerDetails["number"],
                index: int.parse(bankerDetails["number"]),
                isSelectedInUpperLine: bankerDetails["isSelected"]));
          }

          listSelectedNumberUpperLowerLine.add(
              {mapOfBankerSelectedNumbers.keys.toList()[i]: bankerBeanList});
        }
        print(
            "listSelectedNumberUpperLowerLine |>--> $listSelectedNumberUpperLowerLine");
      }

      model.listSelectedNumber =
          listOfSelectedNumber.isEmpty ? null : listOfSelectedNumber;
      model.listSelectedNumberUpperLowerLine =
          listSelectedNumberUpperLowerLine.isEmpty
              ? null
              : listSelectedNumberUpperLowerLine;
      model.pickedValue = panelSavedDataList[i]["pickedValue"];
      model.colorCode = panelSavedDataList[i]["colorCode"];
      model.totalNumber = panelSavedDataList[i]["totalNumber"];
      model.sideBetHeader = panelSavedDataList[i]["sideBetHeader"];

      savedPanelBeanList.add(model);
    }
    print("---------> all panelSavedData: $savedPanelBeanList");
  }

  void initializeInitialValues() {
    print(
        "previewScreen: panel Data:  ${jsonEncode(widget.gameSelectedDetails)}");
    drawRespLength = widget.gameObjectsList?.drawRespVOs?.length ?? 0;
    listPanel = widget.gameSelectedDetails;
    listConsecutiveDraws =
        widget.gameObjectsList?.consecutiveDraw?.split(",") ?? [];
    if (listConsecutiveDraws.isNotEmpty) {
      mNumberOfDraws = int.parse(listConsecutiveDraws[0]);
      drawsCount = int.parse(listConsecutiveDraws[0]);
    }

    enableDisableDrawsButton();
    recalculatePanelAmount();
  }
}
