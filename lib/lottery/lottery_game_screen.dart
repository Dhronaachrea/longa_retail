import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:longalottoretail/drawer/longa_lotto_pos_drawer.dart';
import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/lottery/bloc/lottery_bloc.dart';
import 'package:longalottoretail/lottery/models/otherDataClasses/panelBean.dart';
import 'package:longalottoretail/lottery/models/response/fetch_game_data_response.dart';
import 'package:longalottoretail/lottery/pick_type_screen.dart';
import 'package:longalottoretail/lottery/preview_game_screen.dart';
import 'package:longalottoretail/lottery/widgets/added_bet_cart_msg.dart';
import 'package:longalottoretail/lottery/widgets/other_available_bet_amounts.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/widgets/show_snackbar.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import '../login/bloc/login_bloc.dart';
import '../utility/SlideRightRoute.dart';
import '../utility/utils.dart';
import 'models/otherDataClasses/bankerBean.dart';
import 'models/otherDataClasses/betAmountBean.dart';
import 'models/otherDataClasses/quickPickBetAmountBean.dart';

/*
    created by Rajneesh Kr.Sharma on 7 May, 23
*/
List<PickType> getPickTypeWithQp(Map<String, dynamic> mInputData) {

  List<PickType>? originalPickType  = mInputData["betRespVOs"] != null ? mInputData["betRespVOs"].pickTypeData?.pickType : mInputData["pickType"];
  List<PickType> newPickType        = [];

  if (originalPickType != null) {
    for(PickType model in originalPickType) {
      newPickType.add(model);
      // loop for rangeObjectIndex
      if(model.range?[0].qpAllowed?.toUpperCase() == "yes".toUpperCase()) {
        var qpData                    = PickType();
        qpData.code                   = model.code;
        qpData.description            = model.description;
        if (model.name?.toUpperCase() == "Manual".toUpperCase()) {
          qpData.name                 = "QP";

        } else {
          qpData.name                 = "${model.name} QP";
        }

        List<Range1> rangeList = model.range ?? [];
        List<Range1> totalRangeList   = [];

        for(int i=0; i < rangeList.length; i++) {
          var range = Range1();
          range.pickValue             = model.range?[i].pickValue;
          range.qpAllowed             = model.range?[i].qpAllowed;
          range.pickCount             = model.range?[i].pickCount;
          range.pickConfig            = model.range?[i].pickConfig;
          range.pickMode              = "QP";

          totalRangeList.add(range);
        }

        qpData.range                  = totalRangeList;
        newPickType.add(qpData);
      }
    }
  }

  return newPickType;
}

Map<String, Map<String, int>> setNoPickLimits(Map<String, dynamic> mInputData) {
  List<Range1> range1 = mInputData["pickType"].range ?? [];
  if (range1.isNotEmpty) {
    for(int i=0; i< range1.length; i++) {
      mInputData["ballPickingLimits"]["$i"] = {
        "minSelectionLimit" : int.parse(range1[i].pickCount?.split(",")[0].toString() ?? "0"),
        "maxSelectionLimit" : int.parse(range1[i].pickCount?.split(",")[1].toString() ?? "0"),
      };
    }

  } else {
    //ShowToast.showToast(context, context.l10n.no_pick_type_available, type: ToastType.INFO);
  }
  return mInputData["ballPickingLimits"];
}

Map<String, dynamic> setInitialValues(Map<String, dynamic> mInputData) {
  mInputData["selectedPickType"]    = {"Manual": true};
  mInputData["selectedBetTypeData"]    = mInputData["betRespV0s"];

  mInputData["ballObjectsRange"]    = mInputData["particularGameObjects"]?.numberConfig?.range ?? [];
  mInputData["isDuplicateBallInSecondPanel"]    = mInputData["particularGameObjects"]?.duplicateBallInSecondPanel ?? false;

  var ballObjectsRangeLength = 0;
  if(mInputData["particularGameObjects"]?.duplicateBallInSecondPanel == true) {
    ballObjectsRangeLength = mInputData["ballObjectsRange"]?.isNotEmpty == true ? mInputData["ballObjectsRange"]?.length ?? 0 : 0;
  } else {
    ballObjectsRangeLength = 1;
  }
  Map<String, Range> ballObjectsMap  = {};
  for(int i = 0; i < ballObjectsRangeLength; i++) {
    if (mInputData["ballObjectsRange"]?[i] != null) {
      ballObjectsMap["$i"] = mInputData["ballObjectsRange"]![i];
    }
  }
  mInputData["ballObjectsMap"] = ballObjectsMap;
  for (int i=0; i< ballObjectsMap.length ; i++) {
    Range? rangeBall      = ballObjectsMap["$i"];
    List<Ball>? ballList  =  rangeBall?.ball ?? [];
    mInputData["lotteryGameColorList"].clear();
    if (ballList.isNotEmpty) {
      for (Ball ballDetails in ballList) {
        if (ballDetails.color != null && ballDetails.color != "") {
          if(getColors(ballDetails.color!) != null) {
            if (!mInputData["lotteryGameColorList"].contains(getColors(ballDetails.color!)) ) {
              mInputData["lotteryGameColorList"].add(getColors(ballDetails.color!));
            }
          }
        }
      }
      mInputData["lotteryGameColorList"] = mInputData["lotteryGameColorList"];
    }
  }

  mInputData["lotteryGameMainBetList"] = mInputData["particularGameObjects"]?.betRespVOs?.where((element) => element.winMode == "MAIN").toList()   ?? [];
  mInputData["lotteryGameSideBetList"] = mInputData["particularGameObjects"]?.betRespVOs?.where((element) => element.winMode == "COLOR").toList()  ?? [];

  return mInputData;
}

Map<String, dynamic> setBetAmount(Map<String, dynamic> mInputData) {
  print("setBetAmount()");
  print("mInputData[selectedBetTypeData]: ${mInputData["selectedBetTypeData"]}");
  print("mInputData[selectedBetTypeData]?.unitPrice?.toInt(): ${mInputData["selectedBetTypeData"]?.unitPrice?.toInt()}");
  if (mInputData["selectedBetTypeData"] != null) {
    int unitPrice                  = mInputData["selectedBetTypeData"]?.unitPrice?.toInt() ?? 1;
    int maxBetAmtMul                  = mInputData["selectedBetTypeData"]?.maxBetAmtMul ?? 0;
    int count                         = maxBetAmtMul * unitPrice.toInt();
    //int count                         = maxBetAmtMul~/unitPrice;
    print("count: $count");
    print("unitPrice: $unitPrice");
    int index = 0;
    if(count > 0) {
      var betArrayLength = maxBetAmtMul;

      if (unitPrice < 1) {
        for (int i = 1; i<= betArrayLength; i++) {
          if (unitPrice * i * maxBetAmtMul <= maxBetAmtMul * unitPrice) {
            FiveByNinetyBetAmountBean model = FiveByNinetyBetAmountBean();
            model.amount                    = unitPrice * i * maxBetAmtMul;
            model.isSelected                = false;
            mInputData["listBetAmount"].add(model);
          }
        }
      } else {
        for (int i = 1; i<= betArrayLength; i++) {
          if (unitPrice <= maxBetAmtMul * unitPrice) {
            FiveByNinetyBetAmountBean model = FiveByNinetyBetAmountBean();
            model.amount                    = unitPrice * i;
            model.isSelected                = false;
            mInputData["listBetAmount"].add(model);
          }
        }
      }

      if(mInputData["listBetAmount"].isNotEmpty) {
        int amtListLength = mInputData["listBetAmount"].length;

        mInputData["listBetAmountLength"] = amtListLength > 5 ? 3 : amtListLength;

        if(mInputData["listBetAmount"].length > 5) {
          mInputData["isOtherAmountAvailable"]      = true;

        } else if (mInputData["listBetAmount"].length == 5) {
          mInputData["isOtherAmountAvailable"]      = false;

        } else if (mInputData["listBetAmount"].length == 4) {
          mInputData["isOtherAmountAvailable"]      = false;

        } else if (mInputData["listBetAmount"].length == 3) {
          mInputData["isOtherAmountAvailable"]      = false;

        } else if (mInputData["listBetAmount"].length == 2) {
          mInputData["isOtherAmountAvailable"]      = false;

        } else if (mInputData["listBetAmount"].length == 1) {
          mInputData["isOtherAmountAvailable"]      = false;
        }
      }
    }
  }

  print("------------------> ${mInputData}");

  return mInputData;
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
    case "NO_COLOR":
      return LongaLottoPosColor.tangerine;
    default:
      return Colors.transparent;
  }
}

class GameScreen extends StatefulWidget {
  final GameRespVOs? particularGameObjects;
  final List<PickType>? pickType;
  final BetRespVOs? betRespV0s;
  List<PanelBean>? mPanelBinList;

  GameScreen({Key? key, this.particularGameObjects, this.pickType, this.betRespV0s, this.mPanelBinList}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  Ball? ball;
  Color? upperLineBallColor;
  PickType selectedPickTypeObject = PickType();
  late BetRespVOs? selectedBetTypeData;
  late FlipCardController _controller;
  late FlipCardController _pickController;
  late final AnimationController _inOutAnimationController;
  late final Animation<double> _inOutAnimation;
  late final Animation<double> _inOutOffAnimation;

  List<Color?> lotteryGameColorList                                 = [];
  int maxSelectionLimit = 0, minSelectionLimit                      = 0;
  Map<String, Map<String, int>> ballPickingLimits                   = {};
  Map<String, List<String>> listOfSelectedNosMap                    = {};
  Map<String, List<BankerBean>>listOfSelectedUpperLowerLinesNosMap  = {};
  String selectedBetAmount                                          = "0";
  String betValue                                                   = "0";
  List<FiveByNinetyBetAmountBean> listBetAmount                     = [];
  int listBetAmountLength                                           = 0;
  List<QuickPickBetAmountBean> listQuickPick                        = [];
  bool mIsQpSelecting                                               = false;
  Map<String,bool> selectedPickType                                 = {};                          ////////////////////////////////////////
  Map<String,bool> selectedBetAmountValue                           = {};                          ////////////////////////////////////////
  String ballPickInstructions                                       = "";
  bool mIsToggleAllowed                                             = false;
  bool isOtherAmountAvailable                                       = false;
  bool isBankerPickType                                             = false;
  bool isUpperLine                                                  = true;
  int lowerLineBankerPickedNoIndex
  = 0;
  int upperLineBankerPickedNoIndex                                  = 0;
  int mRangeObjectIndex                                             = 0;
  int mMultiplePickTypeIndex                                        = 0;
  bool isMultiplePickType                                           = false;
  bool isPowerBallPlus                                              = false;
  List<Range>? ballObjectsRange                                     = [];
  Map<String, Range> ballObjectsMap                                 = {};
  var lotteryGameMainBetList                                        = [];
  var lotteryGameSideBetList                                        = [];
  List<PanelBean>? mPanelBinListTemp = [];
  bool isEdit = false;
  PanelBean? editPanelBeanData;
  bool isQp = false;
  List mNewPickTypeList = [];
  bool _isGameBuilding = false;
  bool isDuplicateBallInSecondPanel = false;
  final GlobalKey _widgetKey = GlobalKey();

  Future<void> processDataInBackground() async {
    setState(() {
      _isGameBuilding = true;
    });
    print("starting to gather huge data");

    List<PickType> processedData = await compute(getPickTypeWithQp, {"betRespVOs": widget.betRespV0s, "pickType" : widget.pickType});
    print("processedData:1:$processedData");

    print("selectedPickTypeObject:$selectedPickTypeObject");
    mNewPickTypeList = processedData;
    selectedPickTypeObject = mNewPickTypeList[0];
    /*setState(() {


    });*/
    processDataInBackgroundSetLimit();
  }

  Future<void> processDataInBackgroundSetLimit() async {
    print("starting to gather huge data");

    Map<String, Map<String, int>> processedData = await compute(setNoPickLimits, {"ballPickingLimits": ballPickingLimits, "pickType" : selectedPickTypeObject});
    print("processedData:2:$processedData");

    print("ballPickingLimits:$ballPickingLimits");

    ballPickingLimits = processedData;
    minSelectionLimit = int.parse(selectedPickTypeObject.range?[0].pickCount?.split(",")[0] ?? "0");
    maxSelectionLimit = int.parse(selectedPickTypeObject.range?[0].pickCount?.split(",")[1] ?? "0");
    /*setState(() {
    });*/
    processDataInBackgroundSetBetAmount();
  }

  /*setInitialValues() {
    selectedPickType            = {"Manual": true};
    selectedBetTypeData         = widget.betRespV0s!;

    ballObjectsRange            = widget.particularGameObjects?.numberConfig?.range ?? [];
    var ballObjectsRangeLength  = ballObjectsRange?.isNotEmpty == true ? ballObjectsRange?.length ?? 0 : 0;
    for(int i = 0; i < ballObjectsRangeLength; i++) {
      if (ballObjectsRange?[i] != null) {
        ballObjectsMap["$i"] = ballObjectsRange![i];
      }
    }
    for (int i=0; i< ballObjectsMap.length ; i++) {
      getColorListLength(ballObjectsMap, i);
    }

    lotteryGameMainBetList = widget.particularGameObjects?.betRespVOs?.where((element) => element.winMode == "MAIN").toList()   ?? [];
    lotteryGameSideBetList = widget.particularGameObjects?.betRespVOs?.where((element) => element.winMode == "COLOR").toList()  ?? [];
  }*/

  Future<void> processDataInBackgroundSetInitialValue() async {
    print("starting to gather huge data");

    Map<String, dynamic> processedData = await compute(setInitialValues, {"selectedPickType" : {}, "betRespV0s": widget.betRespV0s,
      "ballObjectsRange": ballObjectsRange, "particularGameObjects" : widget.particularGameObjects, "lotteryGameColorList" : lotteryGameColorList,
      "ballObjectsMap": ballObjectsMap, "lotteryGameMainBetList": lotteryGameMainBetList, "lotteryGameSideBetList": lotteryGameSideBetList, "isDuplicateBallInSecondPanel": isDuplicateBallInSecondPanel});
    print("processedData:3:$processedData");
    selectedPickType    = processedData["selectedPickType"];
    selectedBetTypeData    = processedData["selectedBetTypeData"];
    ballObjectsMap    = processedData["ballObjectsMap"];
    ballObjectsRange    = processedData["ballObjectsRange"];
    lotteryGameColorList    = processedData["lotteryGameColorList"];
    lotteryGameMainBetList  = processedData["lotteryGameMainBetList"];
    lotteryGameSideBetList  = processedData["lotteryGameSideBetList"];
    isDuplicateBallInSecondPanel  = processedData["isDuplicateBallInSecondPanel"];
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _isGameBuilding = false;

      });
    });

  }

  Future<void> processDataInBackgroundSetBetAmount() async {
    print("starting to gather huge data");

    Map<String, dynamic> processedData = await compute(setBetAmount,   {"selectedBetTypeData": widget.betRespV0s, "listBetAmount": listBetAmount,
      "listBetAmountLength" : listBetAmountLength, "isOtherAmountAvailable" :isOtherAmountAvailable});
    print("processedData:4:$processedData");
    listBetAmount    = processedData["listBetAmount"];
    listBetAmountLength    = processedData["listBetAmountLength"];
    isOtherAmountAvailable    = processedData["isOtherAmountAvailable"];
    /*setState(() {

    });*/
    setSelectedBetAmountForHighlighting(0);
    setInitialBetAmount();
    processDataInBackgroundSetInitialValue();
  }

  @override
  void initState() {
    super.initState();
    // ⚠️Please don't disturb the order. ️

    _controller               = FlipCardController();
    _pickController           = FlipCardController();

    processDataInBackground();
    /*
    checkIsPowerBallPlusEnabled();
    setBetAmount();
    setInitialBetAmount();*/

    _inOutAnimationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _inOutAnimation           = Tween<double>(begin: 1, end: 0.75)
        .animate(_inOutAnimationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _inOutAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _inOutAnimationController.forward();
        }
      });

    _inOutOffAnimation = Tween<double>(begin: 1, end: 1)
        .animate(_inOutAnimationController);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Build Completed");
      DateTime now = DateTime.now();
      print('after timestamp: ${now.hour}:${now.minute}:${now.second}.${now.millisecond}');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didchangeDependencies");
    setState(() {
      ballPickInstructions        = widget.pickType?[0].description ?? context.l10n.please_select_numbers;
    });
  }

  @override
  void dispose() {
    _inOutAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.mPanelBinList == null || widget.mPanelBinList?.isEmpty == true;
      },
      child: LongaScaffold(
        showAppBar: true,
        onBackButton: (widget.mPanelBinList == null || widget.mPanelBinList?.isEmpty == true) ? null : () {
          AddedBetCartMsg().show(context: context, title: context.l10n.bet_on_cart, subTitle: context.l10n.you_have_some_item_in_your_cart, buttonText: context.l10n.clear_cap, isCloseButton: true, buttonClick: () {
            Navigator.of(context).pop();
          });
        },
        drawer: LongaLottoPosDrawer(drawerModuleList: const []),
        backgroundColor: LongaLottoPosColor.white,
        appBackGroundColor: LongaLottoPosColor.app_bg,
        appBarTitle:widget.particularGameObjects?.gameName ?? "NA",
        body: SafeArea(
          child: AbsorbPointer(
            absorbing: mIsQpSelecting,
            child: _isGameBuilding
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 120, height: 120, child: Lottie.asset('assets/lottie/game_building.json')),
                    Text(context.l10n.game_is_building)
                    /*TextShimmer(
                            color: LongaLottoPosColor.game_color_blue,
                            text: "",
                          )*/
                  ],
                )
            )
            : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ballObjectsMap.length,
                          itemBuilder: (BuildContext context, int rangeObjectIndex) {
                            return Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: Center(child: Text(getBallInstructionMsg(widget.particularGameObjects?.gameCode ?? ""), textAlign: TextAlign.center, style: const TextStyle(color: LongaLottoPosColor.game_color_grey, fontSize: 14))),
                                ),
                                // Color tiles
                                /*GridView.builder(
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 6,
                                            crossAxisCount: getColumnCount(rangeObjectIndex),
                                          ),
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: getColorListLength(ballObjectsMap, rangeObjectIndex),
                                          itemBuilder: (BuildContext context, int index) {
                                            return Ink(
                                              decoration: const BoxDecoration(
                                                  color: LongaLottoPosColor.white,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(10),
                                                  )
                                              ),
                                              child: Container(width: 20, height: 5, decoration: BoxDecoration(color: lotteryGameColorList[index], borderRadius: BorderRadius.circular(6))),
                                            ).p(1);
                                          }
                                      ),*/
                                GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: lotteryGameColorList.isNotEmpty ? lotteryGameColorList.length < 5 ? 2 : 1 : 1,
                                        crossAxisCount: 7,
                                        mainAxisSpacing: 2,
                                        crossAxisSpacing: 2
                                    ),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: widget.particularGameObjects?.numberConfig?.range?[rangeObjectIndex].ball?.length ?? 0 ?? 0,
                                    itemBuilder: (BuildContext context, int index) {
                                      return InkWell(
                                          onTap: () {
                                            ball = widget.particularGameObjects?.numberConfig?.range?[rangeObjectIndex].ball?[index];
                                            betValueCalculation(rangeObjectIndex);

                                            if (ball != null) {
                                              if(selectedPickType.keys.first.contains("QP")) {
                                                ShowToast.showToast(context, context.l10n.numbers_cannot_be_picked_manually_for_this_bet_type, type: ToastType.INFO);

                                              } else {

                                                if(isDuplicateBallInSecondPanel == false) {
                                                  // for Single UI Panel MultiBet

                                                  for(int i=0; i< listOfSelectedNosMap.length; i++) {
                                                    if (listOfSelectedNosMap["$i"]?.contains(ball?.number) == true) {
                                                      setState(() {
                                                        mRangeObjectIndex = i;
                                                      });
                                                      break;
                                                    }
                                                  }
                                                  var totalPanelToBeSelected = 0;
                                                  for (int i=0; i< listOfSelectedNosMap.length; i++) {
                                                    if (listOfSelectedNosMap["$i"]?.contains(ball?.number) == false) {
                                                      if(listOfSelectedNosMap["$i"]?.length == ballPickingLimits["$i"]?["maxSelectionLimit"]) {
                                                        totalPanelToBeSelected += 1;
                                                      }
                                                    }
                                                  }
                                                  if (totalPanelToBeSelected == widget.particularGameObjects?.numberConfig?.range?.length) {
                                                    ShowToast.showToast(context, context.l10n.sorry_you_cannot_select_more_than_chosen_numbers, type: ToastType.INFO);

                                                  } else {
                                                    if (listOfSelectedNosMap["$mRangeObjectIndex"]?.length == ballPickingLimits["$mRangeObjectIndex"]?["maxSelectionLimit"]) {
                                                      if (listOfSelectedNosMap["$mRangeObjectIndex"]?.contains(ball?.number) == false) {
                                                        setState(() {
                                                          mRangeObjectIndex += 1;
                                                        });
                                                      }
                                                    }

                                                    print("mRangeObjectIndex > $mRangeObjectIndex");

                                                    if (listOfSelectedNosMap["$mRangeObjectIndex"]?.length != ballPickingLimits["$mRangeObjectIndex"]?["maxSelectionLimit"]) {
                                                      if (listOfSelectedNosMap["$mRangeObjectIndex"]?.contains(ball?.number) == true) {
                                                        print("iinnnn");
                                                        listOfSelectedNosMap["$mRangeObjectIndex"]?.remove(ball?.number);
                                                        if(mRangeObjectIndex != 0) {
                                                          setState(() {
                                                            mRangeObjectIndex = 0;
                                                          });
                                                        }
                                                      } else {
                                                        List<String> addTemp = listOfSelectedNosMap["$mRangeObjectIndex"] ?? [];
                                                        addTemp.add(ball?.number ?? "");
                                                        listOfSelectedNosMap["$mRangeObjectIndex"] = addTemp;
                                                      }

                                                    } else {
                                                      if (listOfSelectedNosMap["$mRangeObjectIndex"]?.contains(ball?.number) == true) {
                                                        print("iinnnn");
                                                        listOfSelectedNosMap["$mRangeObjectIndex"]?.remove(ball?.number);
                                                        if(mRangeObjectIndex != 0) {
                                                          setState(() {
                                                            mRangeObjectIndex = 0;
                                                          });
                                                        }

                                                      } else {
                                                        setState(() {
                                                          mRangeObjectIndex += 1;
                                                        });
                                                      }
                                                    }

                                                    print("mRangeObjectIndex :::::: $mRangeObjectIndex");
                                                    print("listOfSelectedNosMap ----------------------------> $listOfSelectedNosMap");

                                                  }

                                                } else {
                                                  // for Double UI Panel MultiBet

                                                  setState(() {
                                                    mRangeObjectIndex = rangeObjectIndex;
                                                    if (selectedPickTypeObject.code?.toUpperCase() == "Banker".toUpperCase()) {
                                                      List<BankerBean> listOfSelectedNoUpperLower = listOfSelectedUpperLowerLinesNosMap["$rangeObjectIndex"] ?? [];
                                                      var upperLineNosList                        = listOfSelectedNoUpperLower.where((element) => element.isSelectedInUpperLine == true).toList();
                                                      var lowerLineNosList                        = listOfSelectedNoUpperLower.where((element) => element.isSelectedInUpperLine == false).toList();
                                                      List<BankerBean> lowerLineDetails           = [];

                                                      if (lowerLineNosList.isNotEmpty) {
                                                        lowerLineDetails = lowerLineNosList.where((element) => element.number == ball?.number).toList();
                                                      }

                                                      if (upperLineNosList.isNotEmpty == true && upperLineNosList[0].number == ball?.number) {
                                                        if (isUpperLine == false) {
                                                          setState(() {
                                                            isUpperLine = true;
                                                          });
                                                          ShowToast.showToast(context, "${ball?.number} ${context.l10n.assigned_to_upper_line_please_unselect_from_upper_line_to_chose_for_lower_line}", type: ToastType.INFO);

                                                        } else {
                                                          upperLineBankerPickedNoIndex = index;
                                                          listOfSelectedUpperLowerLinesNosMap["$rangeObjectIndex"]?.remove(upperLineNosList[0]);
                                                        }
                                                      }

                                                      else if (lowerLineDetails.isNotEmpty == true) {
                                                        var lowerLineDetails = lowerLineNosList.where((element) => element.number == ball?.number).toList();
                                                        if(lowerLineDetails.isNotEmpty) {
                                                          if (isUpperLine) {
                                                            setState(() {
                                                              isUpperLine = false;
                                                            });
                                                            ShowToast.showToast(context, "${ball?.number} ${context.l10n.assigned_to_lower_line_please_unselect_from_lower_line_to_chose_for_upper_line}", type: ToastType.INFO);

                                                          } else {
                                                            lowerLineBankerPickedNoIndex = index;
                                                            listOfSelectedUpperLowerLinesNosMap["$rangeObjectIndex"]?.remove(lowerLineDetails[0]);
                                                          }
                                                        }
                                                      }

                                                      else {
                                                        if(isUpperLine) {
                                                          setNoPickLimitsForBanker(true, selectedPickTypeObject);
                                                          var upperLineNosList = listOfSelectedUpperLowerLinesNosMap["$rangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == true).toList() ?? [];
                                                          var mMaxSelectionLimit = ballPickingLimits["$rangeObjectIndex"]?["maxSelectionLimit"] ?? 0;
                                                          if (upperLineNosList.length < mMaxSelectionLimit) {
                                                            if(ball?.number != null) {
                                                              List<BankerBean> addTemp = listOfSelectedUpperLowerLinesNosMap["$rangeObjectIndex"] ?? [];
                                                              addTemp.add(BankerBean(number: ball?.number, color: ball?.color, index: index, isSelectedInUpperLine: true));
                                                              listOfSelectedUpperLowerLinesNosMap["$rangeObjectIndex"] = addTemp;
                                                              upperLineBankerPickedNoIndex = index;
                                                            }

                                                          } else {
                                                            ShowToast.showToast(context, context.l10n.you_have_reached_the_maximum_selection_limit_for_upper_line, type: ToastType.INFO);
                                                          }

                                                        } else {
                                                          setNoPickLimitsForBanker(false, selectedPickTypeObject);
                                                          var lowerLineNosList    = listOfSelectedUpperLowerLinesNosMap["$rangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == false).toList() ?? [];
                                                          var mMaxSelectionLimit  = ballPickingLimits["$rangeObjectIndex"]?["maxSelectionLimit"] ?? 0;
                                                          if (lowerLineNosList.length < mMaxSelectionLimit) {
                                                            if(ball?.number != null) {
                                                              List<BankerBean> addTemp = listOfSelectedUpperLowerLinesNosMap["$rangeObjectIndex"] ?? [];
                                                              addTemp.add(BankerBean(number: ball?.number, color: ball?.color, index: index, isSelectedInUpperLine: false));
                                                              listOfSelectedUpperLowerLinesNosMap["$rangeObjectIndex"] = addTemp;
                                                              lowerLineBankerPickedNoIndex = index;
                                                            }

                                                          } else {
                                                            ShowToast.showToast(context, context.l10n.you_have_reached_the_maximum_selection_limit_for_lower_line, type: ToastType.INFO);
                                                          }
                                                        }
                                                      }
                                                    }
                                                    else if (listOfSelectedNosMap["$rangeObjectIndex"]?.contains(ball?.number) == true) {
                                                      listOfSelectedNosMap["$rangeObjectIndex"]?.remove(ball?.number);
                                                      if (selectedBetTypeData?.betCode?.toUpperCase() == "DirectFirst".toUpperCase()) {
                                                        switchToPickType("Direct1");

                                                      }
                                                      else if (selectedBetTypeData?.betCode?.toUpperCase() == "Direct2".toUpperCase()) {
                                                        if (selectedPickTypeObject.name?.toUpperCase() == "QP".toUpperCase() && selectedPickTypeObject.range?[rangeObjectIndex].pickMode?.toUpperCase() == "QP".toUpperCase()) {
                                                          switchToPickType("Direct2");
                                                        }
                                                        if (selectedPickTypeObject.name?.toUpperCase() == "Perm QP".toUpperCase() && selectedPickTypeObject.range?[rangeObjectIndex].pickMode?.toUpperCase() == "QP".toUpperCase()) {
                                                          switchToPickType("Perm2");
                                                        }
                                                        if (selectedPickTypeObject.name?.toUpperCase() == "Banker1AgainstAll QP".toUpperCase() && selectedPickTypeObject.range?[rangeObjectIndex].pickMode == "QP".toUpperCase()) {
                                                          switchToPickType("Banker1AgainstAll");
                                                        }

                                                      } else if (selectedBetTypeData?.betCode?.toUpperCase() == "Direct3".toUpperCase()) {
                                                        if (selectedPickTypeObject.name?.toUpperCase() == "QP".toUpperCase() && selectedPickTypeObject.range?[rangeObjectIndex].pickMode == "QP".toUpperCase()) {
                                                          switchToPickType("Direct3");
                                                        }
                                                        if (selectedPickTypeObject.name?.toUpperCase() == "Perm QP".toUpperCase() && selectedPickTypeObject.range?[rangeObjectIndex].pickMode == "QP".toUpperCase()) {
                                                          switchToPickType("Perm3");
                                                        }

                                                      } else if (selectedBetTypeData?.betCode?.toUpperCase() == "Direct4".toUpperCase()) {
                                                        switchToPickType("Direct4");

                                                      } else if (selectedBetTypeData?.betCode?.toUpperCase() == "Direct5".toUpperCase()) {
                                                        switchToPickType("Direct5");
                                                      }

                                                    }
                                                    else {
                                                      var listOfSelectedNosLength = listOfSelectedNosMap["$rangeObjectIndex"]?.length ?? 0;
                                                      var mMaxSelectionLimit = ballPickingLimits["$rangeObjectIndex"]?["maxSelectionLimit"] ?? 0;
                                                      if (listOfSelectedNosLength < mMaxSelectionLimit) {
                                                        if (ball?.number != null) {
                                                          List<String> addTemp = listOfSelectedNosMap["$rangeObjectIndex"] ?? [];
                                                          addTemp.add(ball?.number ?? "");
                                                          listOfSelectedNosMap["$rangeObjectIndex"] = addTemp;
                                                          if (selectedBetTypeData?.betCode?.toUpperCase() == "Direct2".toUpperCase() && selectedPickTypeObject.name?.toUpperCase() == "Perm QP".toUpperCase() && selectedPickTypeObject.range?[rangeObjectIndex].pickMode == "QP".toUpperCase()) {
                                                            switchToPickType("Perm2");
                                                          }
                                                          if (selectedBetTypeData?.betCode?.toUpperCase() == "Direct3".toUpperCase() && selectedPickTypeObject.name?.toUpperCase() == "Perm QP".toUpperCase() && selectedPickTypeObject.range?[rangeObjectIndex].pickMode == "QP".toUpperCase()) {
                                                            switchToPickType("Perm3");
                                                          }
                                                        }

                                                      } else {

                                                        if (widget.particularGameObjects?.familyCode?.toUpperCase() == "MultiSet".toUpperCase()) {
                                                          var mMaxSelectionLimit = ballPickingLimits["$rangeObjectIndex"]?["maxSelectionLimit"] ?? 0;
                                                          ShowToast.showToast(context, "${context.l10n..sorry_you_cannot_select_more_than} $mMaxSelectionLimit ${context.l10n.numbers}", type: ToastType.INFO);

                                                        } else {
                                                          var mMaxSelectionLimit = ballPickingLimits["$rangeObjectIndex"]?["maxSelectionLimit"] ?? 0;
                                                          //String msg = mMaxSelectionLimit > 1 ? "Sorry, you cannot select more than $mMaxSelectionLimit numbers for ${selectedPickTypeObject.name!}!" : "Sorry, you cannot select more than $mMaxSelectionLimit number for ${selectedPickTypeObject.name!}!";
                                                          String msg = context.l10n.sorry_you_cannot_select_more_than_chosen_numbers;
                                                          ShowToast.showToast(context, msg, type: ToastType.INFO);
                                                        }
                                                      }
                                                    }
                                                  });
                                                }

                                                if(selectedPickTypeObject.code?.toUpperCase() == "Banker".toUpperCase()) {
                                                  var upperLineNosList = listOfSelectedUpperLowerLinesNosMap["$rangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == true).toList() ?? [];
                                                  var lowerLineNosList = listOfSelectedUpperLowerLinesNosMap["$rangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == false).toList() ?? [];

                                                  if (upperLineNosList.isEmpty && lowerLineNosList.isEmpty) {
                                                    if (_controller.state?.isFront == false) {
                                                      _controller.toggleCard();
                                                    }

                                                  } else {
                                                    if (_controller.state?.isFront == true) {
                                                      _controller.toggleCard();
                                                    }
                                                  }
                                                } else {
                                                  var listOfSelectedNosList = listOfSelectedNosMap["$rangeObjectIndex"] ?? [];

                                                  if (listOfSelectedNosList.isNotEmpty) {
                                                    if (_controller.state?.isFront == true) {
                                                      _controller.toggleCard();
                                                    }
                                                  } else {
                                                    var nosCounts = 0;
                                                    for(int i=0;i<listOfSelectedNosMap.length; i++) {
                                                      if(listOfSelectedNosMap["$i"]?.isNotEmpty == true) {
                                                        nosCounts +=1;
                                                      }
                                                    }
                                                    if (nosCounts < 1) {
                                                      reset();
                                                      _controller.toggleCard();
                                                    }
                                                  }
                                                }
                                                betValueCalculation(rangeObjectIndex);
                                              }
                                            }
                                            else {
                                              ShowToast.showToast(context, context.l10n.balls_do_not_present, type: ToastType.INFO);
                                            }
                                          },
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: isDuplicateBallInSecondPanel == false
                                              ? Container(
                                            width:100,
                                            height:100,
                                            decoration: BoxDecoration(
                                                color:  getBallColorForMultiBet(listOfSelectedNosMap, ball?.number ?? "0", index),
                                                borderRadius: const BorderRadius.all(Radius.circular(30)),
                                                border: isMultiSetBallAvailable(listOfSelectedNosMap, index) ? Border.all(color: Colors.transparent, width: 2) : Border.all(color: LongaLottoPosColor.ball_border_bg, width: 1)
                                            ),
                                            child: Center(child: Text("${index+1}".length == 1 ? "0${index+1}" : "${index+1}", style: TextStyle(color: isMultiSetBallAvailable(listOfSelectedNosMap, index) ? LongaLottoPosColor.white : LongaLottoPosColor.ball_border_bg, fontSize: 12, fontWeight: isMultiSetBallAvailable(listOfSelectedNosMap, index) ? FontWeight.bold : FontWeight.w400))),
                                          )
                                              : Container(
                                            width:100,
                                            height:100,
                                            decoration: BoxDecoration(
                                                color:  getBallColor(listOfSelectedNosMap["$rangeObjectIndex"] ?? [] , index),
                                                borderRadius: const BorderRadius.all(Radius.circular(30)),
                                                border: isBallAvailable(listOfSelectedNosMap["$rangeObjectIndex"] ?? [], index, rangeObjectIndex) ? Border.all(color: Colors.transparent, width: 2) : Border.all(color: LongaLottoPosColor.ball_border_bg, width: 1)
                                            ),
                                            child: Center(child: Text("${index+1}".length == 1 ? "0${index+1}" : "${index+1}", style: TextStyle(color: isBallAvailable(listOfSelectedNosMap["$rangeObjectIndex"] ?? [], index, rangeObjectIndex) ? LongaLottoPosColor.white : LongaLottoPosColor.ball_border_bg, fontSize: 12, fontWeight: isBallAvailable(listOfSelectedNosMap["$rangeObjectIndex"] ?? [], index, rangeObjectIndex) ? FontWeight.bold : FontWeight.w400))),
                                          )
                                      ).p(2);
                                    }
                                ),
                                isDuplicateBallInSecondPanel == true
                                    ?
                                ballObjectsMap.isNotEmpty
                                    ? rangeObjectIndex != ballObjectsMap.length - 1
                                    ? const Text("+", style: TextStyle(color: LongaLottoPosColor.game_color_grey, fontSize: 20, fontWeight: FontWeight.bold)).pSymmetric(v:8)
                                    : Container()
                                    : Container()
                                    : Container(),
                              ],
                            );
                          }
                      ).pOnly(bottom: 2),
                      Align(alignment: Alignment.centerLeft, child: Text(context.l10n.pick_type, style: const TextStyle(color: LongaLottoPosColor.black, fontWeight: FontWeight.bold, fontSize: 14))).pOnly(top: 20, bottom: 2),
                      FlipCard(
                          controller: _pickController,
                          flipOnTouch: false,
                          fill: Fill.fillBack,
                          direction: FlipDirection.VERTICAL,
                          side: CardSide.FRONT,
                          front: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: mNewPickTypeList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: selectedPickType[mNewPickTypeList[index].name] == true ? LongaLottoPosColor.game_color_red : LongaLottoPosColor.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(6),
                                        ),
                                        border: Border.all(color: LongaLottoPosColor.game_color_red)
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isQp = true;
                                        });
                                        selectedPickTypeData(mNewPickTypeList[index]);
                                        int counter = 5;
                                        /*Timer.periodic(const Duration(milliseconds: 100), (timer) {
                                            counter--;
                                            if (counter == 0) {
                                              print('Cancel timer');
                                              timer.cancel();
                                            }
                                          });*/
                                      },
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Center(child: SizedBox(width:50, child: Text(mNewPickTypeList[index].name?.toUpperCase() == "MANUAL" ? context.l10n.manual : context.l10n.qp, textAlign: TextAlign.center, style: TextStyle(color: selectedPickType[mNewPickTypeList[index].name] == true ? LongaLottoPosColor.white : LongaLottoPosColor.game_color_red, fontSize: 10, fontWeight: selectedPickType[mNewPickTypeList[index].name] == true ? FontWeight.bold : FontWeight.w400)))),
                                    ),
                                  ).p(2);
                                }
                            ).pOnly(bottom: 2),
                          ),
                          back: isBankerPickType
                              ? Row(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isUpperLine = true;
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                                              border: Border.all(color: isUpperLine ? LongaLottoPosColor.game_color_green : LongaLottoPosColor.white, width: 1.5)
                                          ),
                                          child: Align(alignment: Alignment.centerLeft, child: Text(context.l10n.upper_line, style: const TextStyle(color: LongaLottoPosColor.black, fontWeight: FontWeight.bold, fontSize: 14))).p(8),
                                        ),
                                      ],
                                    ),
                                  ).pOnly(right: 8),
                                  Center(
                                      child: Container(
                                        width: 20,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: listOfSelectedUpperLowerLinesNosMap["$mRangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == true).toList().isNotEmpty == true? getBallBankersNoColor(listOfSelectedUpperLowerLinesNosMap["$mRangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == true).toList() ?? [], (upperLineBankerPickedNoIndex), mRangeObjectIndex) : Colors.transparent,
                                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                                          //border: isBankerBallNoAvailable(listOfSelectedUpperLowerLinesNosMap["$mRangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == true).toList() ?? [], upperLineBankerPickedNoIndex, mRangeObjectIndex) ? Border.all(color: Colors.transparent, width: 1) : Border.all(color: LongaLottoPosColor.game_color_grey, width: 1)
                                        ),
                                      )
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          isUpperLine = false;
                                        });
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                  border: Border.all(color: isUpperLine ? LongaLottoPosColor.white : LongaLottoPosColor.game_color_green, width: 1.5)
                                              ),
                                              child: Align(alignment: Alignment.centerLeft,
                                                  child: Text(context.l10n.lower_line, style: const TextStyle(color: LongaLottoPosColor.black, fontWeight: FontWeight.bold, fontSize: 14))).p(10)
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                          child: listOfSelectedUpperLowerLinesNosMap["$mRangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == false).toList().isEmpty == true
                                              ? Container(
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              color: LongaLottoPosColor.white,
                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                              //border: Border.all(color: LongaLottoPosColor.game_color_grey, width: 1)
                                            ),
                                          )
                                              : Container(
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              color: LongaLottoPosColor.white,
                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                            ),
                                            child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                itemCount: listOfSelectedUpperLowerLinesNosMap["$mRangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == false).toList().length,
                                                itemBuilder: (BuildContext context, int indx) {
                                                  return Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: getBallBankersNoColor(listOfSelectedUpperLowerLinesNosMap["$mRangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == false).toList().isNotEmpty == true
                                                          ? listOfSelectedUpperLowerLinesNosMap["$mRangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == false).toList().where((element) => element.number == "${listOfSelectedUpperLowerLinesNosMap["$mRangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == false).toList()[indx].number}").toList() ?? [] : [], listOfSelectedUpperLowerLinesNosMap["$mRangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == false).toList()[indx].index ?? 0, mRangeObjectIndex),
                                                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                                                    ),
                                                  ).p(2);
                                                }
                                            ),
                                          )
                                      ),
                                    ),
                                  ],
                                ).pOnly(left: 10),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isBankerPickType = false;
                                    listOfSelectedUpperLowerLinesNosMap.clear();
                                  });
                                  if(_pickController.state?.isFront == false) {
                                    _pickController.toggleCard();
                                  }
                                  for(QuickPickBetAmountBean i in listQuickPick) {
                                    i.isSelected = false;
                                  }
                                  if (listOfSelectedUpperLowerLinesNosMap.isEmpty) {
                                    switchToPickType(selectedBetTypeData?.betCode ?? "");
                                  }
                                },
                                child: Container(
                                    color: LongaLottoPosColor.white,
                                    child: SvgPicture.asset("assets/icons/cross.svg", width: 18, height: 18, color: LongaLottoPosColor.game_color_red)
                                ),
                              ).pOnly(left: 5),
                            ],
                          )
                              : isMultiplePickType
                              ? Row(
                            children: [
                              Container(
                                width: 70,
                                height: 50,
                                color: LongaLottoPosColor.white,
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: context.l10n.pick_ball_panel, style: const TextStyle(color: LongaLottoPosColor.black,fontWeight: FontWeight.w400, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: getPermRangeList(selectedPickTypeObject).length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: LongaLottoPosColor.white,
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(6),
                                            ),
                                            border: Border.all(color: LongaLottoPosColor.game_color_grey)
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              mMultiplePickTypeIndex = index;
                                              isMultiplePickType = false;
                                              setPermQpList(rangeObjectIndex: index);
                                            });
                                          },
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Center(child: SizedBox(width: 30, child: Text("${index + 1}", textAlign: TextAlign.center, style: const TextStyle(color: LongaLottoPosColor.black, fontSize: 12, fontWeight: FontWeight.bold)))),
                                        ),
                                      ).p(2);
                                    }
                                ).pOnly(right: 10),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isBankerPickType = false;
                                    listOfSelectedNosMap.clear();
                                  });
                                  if(_pickController.state?.isFront == false) {
                                    _pickController.toggleCard();
                                  }
                                  for(QuickPickBetAmountBean i in listQuickPick) {
                                    i.isSelected = false;
                                  }
                                  if (listOfSelectedNosMap.isEmpty) {
                                    switchToPickType(selectedBetTypeData?.betCode ?? "");
                                  }
                                },
                                child: Container(
                                    color: LongaLottoPosColor.white,
                                    child: SvgPicture.asset("assets/icons/cross.svg", width: 18, height: 18, color: LongaLottoPosColor.game_color_red)
                                ),
                              ),
                            ],
                          )
                              : Row(
                            children: [
                              Container(
                                width: 70,
                                height: 50,
                                color: LongaLottoPosColor.white,
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: context.l10n.perm_qp, style: const TextStyle(color: LongaLottoPosColor.black, fontWeight: FontWeight.w400, fontSize: 12)),
                                        TextSpan(text: "\n ( ${ballPickingLimits["$mMultiplePickTypeIndex"]?["minSelectionLimit"]} - ${ballPickingLimits["$mMultiplePickTypeIndex"]?["maxSelectionLimit"]} )", style: const TextStyle(color: LongaLottoPosColor.game_color_grey, fontWeight: FontWeight.w400, fontSize: 10, fontStyle: FontStyle.italic)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: listQuickPick.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: listQuickPick[index].isSelected == true ? LongaLottoPosColor.game_color_red : LongaLottoPosColor.white,
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(6),
                                            ),
                                            border: Border.all(color: listQuickPick[index].isSelected == true ? LongaLottoPosColor.game_color_red : LongaLottoPosColor.game_color_grey)
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              for(QuickPickBetAmountBean i in listQuickPick) {
                                                i.isSelected = false;
                                              }
                                              listQuickPick[index].isSelected = true;
                                            });
                                            qpGenerator(widget.particularGameObjects?.numberConfig?.range?[mMultiplePickTypeIndex].ball ?? [], listQuickPick[index].number ?? 0, rangeObjectIndex: mMultiplePickTypeIndex);
                                          },
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Center(child: SizedBox(width: 30, child: Text("${listQuickPick[index].number}", textAlign: TextAlign.center, style: TextStyle(color: listQuickPick[index].isSelected == true ? LongaLottoPosColor.white : LongaLottoPosColor.black, fontSize: 12, fontWeight: FontWeight.bold)))),
                                        ),
                                      ).p(2);
                                    }
                                ).pOnly(right: 10),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isBankerPickType = false;
                                    var pickTypeObjectLength = selectedPickTypeObject.range?.length ?? 0;
                                    if(pickTypeObjectLength > 1) {
                                      isMultiplePickType = true;
                                    } else {
                                      listOfSelectedNosMap.clear();
                                      if(_pickController.state?.isFront == false) {
                                        _pickController.toggleCard();
                                      }
                                      for(QuickPickBetAmountBean i in listQuickPick) {
                                        i.isSelected = false;
                                      }
                                      if (listOfSelectedNosMap.isEmpty) {
                                        switchToPickType(selectedBetTypeData?.betCode ?? "");
                                      }
                                    }
                                  });

                                },
                                child: Container(
                                    color: LongaLottoPosColor.white,
                                    child: SvgPicture.asset("assets/icons/cross.svg", width: 18, height: 18, color: LongaLottoPosColor.game_color_red)
                                ),
                              ),
                            ],
                          )
                      ),
                      Container(
                        decoration: DottedDecoration(
                          color: LongaLottoPosColor.ball_border_bg,
                          strokeWidth: 0.5,
                          linePosition: LinePosition.bottom,
                        ),
                        height:12,
                        width: MediaQuery.of(context).size.width,
                      ),
                      listBetAmount.isNotEmpty ? Align(alignment: Alignment.centerLeft, child: Text("${context.l10n.bet_amount} (${getDefaultCurrency(getLanguage())})", style: const TextStyle(color: LongaLottoPosColor.black, fontWeight: FontWeight.bold, fontSize: 14))).pOnly(top: 20, bottom: 2) : Container(),
                      listBetAmount.isNotEmpty
                          ? listBetAmount.length == 1
                            ? Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 50,
                            height: 40,
                            decoration: BoxDecoration(
                                color: LongaLottoPosColor.white,
                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                                border: Border.all(color: LongaLottoPosColor.ball_border_bg)
                            ),
                            child: Center(child: Text("${listBetAmount[0].amount}", style: const TextStyle(color: LongaLottoPosColor.game_color_grey, fontSize: 16, fontWeight: FontWeight.bold)).p(4)),
                          ),
                        )
                            : Row(
                        children: [
                          SizedBox(
                            height: 45,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: listBetAmountLength,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      if (listBetAmount[index].amount != null) {
                                        setSelectedBetAmountForHighlighting(index);
                                        selectedBetAmountValue.clear();
                                        selectedBetAmountValue[listBetAmount[index].amount.toString()] = true;
                                        onBetAmountClick(listBetAmount[index].amount!);
                                      }
                                    },
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Container(
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: selectedBetAmountValue["${listBetAmount[index].amount}"] == true ? LongaLottoPosColor.game_color_red : LongaLottoPosColor.white,
                                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                                          border: Border.all(color: LongaLottoPosColor.game_color_red)
                                      ),
                                      child: Align(alignment: Alignment.center, child: Text("${listBetAmount[index].amount}", style: TextStyle(color: selectedBetAmountValue["${listBetAmount[index].amount}"] == true ? LongaLottoPosColor.white : LongaLottoPosColor.game_color_red, fontSize: 10))).p(4),
                                    ),
                                  ).p(2);
                                }),
                          ),
                          Visibility(
                            visible: isOtherAmountAvailable,
                            child: Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  if(isOtherAmountAvailable) {
                                    OtherAvailableBetAmountAlertDialog().show(context: context, title: "${context.l10n.select_amount} (${getDefaultCurrency(getLanguage())})", buttonText: "Select", isCloseButton: true, listOfAmounts: listBetAmount, buttonClick: (selectedBetAmount) {
                                      setState(() {
                                        selectedBetAmountValue.clear();
                                        selectedBetAmountValue["$selectedBetAmount"] = true;
                                      });
                                      onBetAmountClick(selectedBetAmount);
                                    });
                                  }
                                },
                                customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Ink(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: LongaLottoPosColor.white,
                                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                                      border: Border.all(color: LongaLottoPosColor.game_color_red)
                                  ),
                                  child: Stack(
                                    children: [
                                      Align(alignment: Alignment.center, child: Text(context.l10n.other, style: const TextStyle(color: LongaLottoPosColor.red, fontSize: 10))),
                                      Align(
                                          alignment: Alignment.bottomRight,
                                          child:
                                          SizedBox(width: 30, height: 30, child: Lottie.asset('assets/lottie/tap.json'))
                                      ),
                                    ],
                                  ),
                                ),
                              ).p(2),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Ink(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: LongaLottoPosColor.game_color_red,
                                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                                  border: Border.all(color: LongaLottoPosColor.game_color_red)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(alignment: Alignment.center, child: Text(context.l10n.bet_amount, style: const TextStyle(color: LongaLottoPosColor.white, fontSize: 10))),
                                  Align(alignment: Alignment.center, child: Text(selectedBetAmount, style: const TextStyle(color: LongaLottoPosColor.white, fontSize: 16, fontWeight: FontWeight.bold))),
                                ],
                              ),
                            ).p(2),
                          )
                        ],
                      )
                          : Container(),
                      listBetAmount.isNotEmpty ? const HeightBox(50) : Container()
                    ],
                  ).p(8),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      color: LongaLottoPosColor.ball_border_light_bg,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AbsorbPointer(
                            absorbing: isQp,
                            child: Stack(
                              children: [
                                lotteryGameMainBetList.length == 1 && lotteryGameSideBetList.isEmpty
                                    ? Material(
                                  child: InkWell(
                                    onTap: () {
                                      addingBet(false);
                                    },
                                    child: Ink(
                                      width: 110,
                                      color: LongaLottoPosColor.game_color_red,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset('assets/icons/plus.svg', width: 15, height: 16, color: LongaLottoPosColor.white).pOnly(left: 4),
                                          Align(alignment: Alignment.center, child: Text(context.l10n.add_bet_cap, textAlign: TextAlign.center, style: const TextStyle(color: LongaLottoPosColor.white, fontWeight: FontWeight.bold, fontSize: 12))).pOnly(right: 4),
                                          Container(
                                              width: 18,
                                              height: 18,
                                              decoration: BoxDecoration(color: LongaLottoPosColor.white, borderRadius: BorderRadius.circular(50)),
                                              child: Center(child: Text("${widget.mPanelBinList?.length}", textAlign: TextAlign.center, style: const TextStyle(color: LongaLottoPosColor.red, fontWeight: FontWeight.bold, fontSize: 12)))
                                          ),

                                        ],
                                      ).pOnly(right:2),
                                    ),
                                  ),
                                )
                                    : Container(),

                                isEdit
                                    ? Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: 110,
                                      color: LongaLottoPosColor.game_color_red.withOpacity(0.4),
                                    ),
                                  ),
                                )
                                    : Container(),

                              ],
                            ),
                          ),
                          const VerticalDivider(width: 1),
                          Expanded(
                            child: Stack(
                              children: [
                                Material(
                                  child: InkWell(
                                    onTap: () {
                                      selectedPickTypeData(mNewPickTypeList[0]); // to select manual pickType
                                      reset();
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/icons/reset.svg', width: 18, height: 18, color: LongaLottoPosColor.game_color_red).pOnly(bottom: 2),
                                        Align(alignment: Alignment.center, child: Text(context.l10n.reset, style: const TextStyle(color: LongaLottoPosColor.game_color_grey, fontSize: 10))),
                                      ],
                                    ),
                                  ),
                                ),
                                isEdit
                                    ? Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: 110,
                                      color: LongaLottoPosColor.light_grey.withOpacity(0.6),
                                    ),
                                  ),
                                )
                                    : Container(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(betValue, textAlign: TextAlign.center, style: const TextStyle(color: LongaLottoPosColor.game_color_red, fontWeight: FontWeight.bold, fontSize: 16)).pOnly(bottom: 2),
                                Text("${context.l10n.bet_value} (${getDefaultCurrency(getLanguage())})", textAlign: TextAlign.center, style: const TextStyle(color: LongaLottoPosColor.game_color_grey, fontSize: 10)),
                              ],
                            ),
                          ),
                          const VerticalDivider(width: 1),
                          lotteryGameMainBetList.length == 1 && lotteryGameSideBetList.isEmpty
                              ? Expanded(
                            child: Material(
                              child: InkWell(
                                onTap: () {
                                  print("listOfSelectedNosMap: $listOfSelectedNosMap");
                                  if (widget.mPanelBinList?.isEmpty == true) {
                                    if (listOfSelectedNosMap.isEmpty) {
                                      ShowToast.showToast(context, context.l10n.no_bet_selected_please_select_any_bet, type: ToastType.INFO);
                                    } else {
                                      bool isApplicable = true;
                                      for(var i=0; i< ballPickingLimits.length; i++) {
                                        var mMinSelectionLimit = ballPickingLimits["$i"]?["minSelectionLimit"] ?? 0;
                                        var mListOfSelectedNos = listOfSelectedNosMap["$i"]?.length ?? 0;
                                        if (mListOfSelectedNos < mMinSelectionLimit) {
                                          String msg = "";
                                          if (widget.particularGameObjects?.familyCode?.toUpperCase() == "MultiSet".toUpperCase()) {
                                            msg = mMinSelectionLimit > 1 ? "${context.l10n.select_at_least} ${ballPickingLimits["0"]?["minSelectionLimit"]} ${context.l10n.numbers_and} ${ballPickingLimits["1"]?["minSelectionLimit"]} ${context.l10n.bonus_number_from_panel_for} ${selectedPickTypeObject.name}." : "${context.l10n.select_at_least} ${ballPickingLimits["0"]?["minSelectionLimit"]} ${context.l10n.numbers_and} ${ballPickingLimits["1"]?["minSelectionLimit"]} ${context.l10n.bonus_number_from_panel_for} ${selectedPickTypeObject.name}.";

                                          } else {
                                            msg = mMinSelectionLimit > 1 ? "${"${context.l10n.select_at_least} $mMinSelectionLimit ${context.l10n.numbers_for} ${selectedPickTypeObject.name}"}." : "${context.l10n.select_at_least} $mMinSelectionLimit ${context.l10n.numbers_for} ${selectedPickTypeObject.name}.";
                                          }
                                          ShowToast.showToast(context, msg, type: ToastType.INFO);
                                          setState(() {
                                            isApplicable = false;
                                          });
                                          break;

                                        }
                                      }

                                      if (isApplicable) {
                                        addingBet(true);
                                      }

                                    }

                                  } else {
                                    var mPanelBinListObject = widget.mPanelBinList?.where((element) => element.pickName == editPanelBeanData?.pickName).toList();
                                    if (isEdit) {
                                      if (mPanelBinListObject?.isNotEmpty == true) {}
                                      var mPanelBinListObjectIndex = widget.mPanelBinList?.indexOf(editPanelBeanData!) ?? -1;
                                      print("mPanelBinListObjectIndex: $mPanelBinListObjectIndex");

                                      editPanelBeanData?.pickName = selectedPickTypeObject.name;
                                      editPanelBeanData?.selectBetAmount = int.parse(selectedBetAmount);
                                      editPanelBeanData?.amount = double.parse(betValue);
                                      if (selectedBetAmount != "0") {
                                        if (selectedBetTypeData?.unitPrice != null) {
                                          double mUnitPrice = selectedBetTypeData?.unitPrice ?? 1;
                                          editPanelBeanData?.betAmountMultiple = int.parse(selectedBetAmount) ~/ mUnitPrice;
                                        }
                                      }
                                      String pickedValues = "";
                                      if (widget.particularGameObjects?.familyCode?.toUpperCase() == "MultiSet".toUpperCase()) {
                                        var listOfSelectedNosLength = listOfSelectedNosMap.length;
                                        List<String> pkV = [];
                                        for(int i=0; i<listOfSelectedNosLength; i++) {
                                          var afterJoinPickedValues = listOfSelectedNosMap["$i"]?.join(',') ?? "";
                                          if (afterJoinPickedValues.isNotEmpty) {
                                            pkV.add(afterJoinPickedValues);
                                          }
                                        }
                                        pickedValues = pkV.join("#");

                                      } else {
                                        var listOfSelectedNosLength = listOfSelectedNosMap.length;
                                        for(int i=0; i<listOfSelectedNosLength; i++) {
                                          pickedValues = listOfSelectedNosMap["$i"]?.join(',') ?? "";
                                        }
                                      }
                                      editPanelBeanData?.pickedValue = pickedValues;
                                      editPanelBeanData?.listSelectedNumber = [listOfSelectedNosMap];
                                      if (selectedPickTypeObject.name?.contains("QP") == true) {
                                        editPanelBeanData?.isQpPreGenerated = true;
                                        editPanelBeanData?.isQuickPick = true;

                                      } else {
                                        editPanelBeanData?.isQpPreGenerated = false;
                                        editPanelBeanData?.isQuickPick = false;
                                      }
                                      log("after change : preview: BEFORE -> ${jsonEncode(widget.mPanelBinList)}");
                                      setState(() {
                                        if(mPanelBinListObjectIndex != -1) {
                                          widget.mPanelBinList?[mPanelBinListObjectIndex] = editPanelBeanData!;
                                        }
                                      });
                                      log("after change : preview: AFTER -> ${jsonEncode(widget.mPanelBinList)}");
                                      var mListOfSelectedNos = 0;
                                      var mMinSelectionLimit = 0;
                                      var isApplicable = true;

                                      for(var i=0; i< ballPickingLimits.length; i++) {
                                        mMinSelectionLimit = ballPickingLimits["$i"]?["minSelectionLimit"] ?? 0;
                                        mListOfSelectedNos = listOfSelectedNosMap["$i"]?.length ?? 0;
                                        print("mListOfSelectedNos: $mListOfSelectedNos");
                                        print("mMinSelectionLimit: $mMinSelectionLimit");
                                        if (mListOfSelectedNos < mMinSelectionLimit) {
                                          print("11111111111111111");
                                          String msg = "";
                                          if (widget.particularGameObjects?.familyCode?.toUpperCase() == "MultiSet".toUpperCase()) {
                                            msg = mMinSelectionLimit > 1 ? "${context.l10n.select_at_least} ${ballPickingLimits["0"]?["minSelectionLimit"]} ${context.l10n.numbers_and} ${ballPickingLimits["1"]?["minSelectionLimit"]} ${context.l10n.bonus_number_from_panel_for} ${selectedPickTypeObject.name}." : "${context.l10n.select_at_least} ${ballPickingLimits["0"]?["minSelectionLimit"]} ${context.l10n.numbers_and} ${ballPickingLimits["1"]?["minSelectionLimit"]} ${context.l10n.bonus_number_from_panel_for} ${selectedPickTypeObject.name}.";

                                          } else {
                                            msg = mMinSelectionLimit > 1 ? "${"${context.l10n.select_at_least} $mMinSelectionLimit ${context.l10n.numbers_for} ${selectedPickTypeObject.name}"}." : "${context.l10n.select_at_least} $mMinSelectionLimit ${context.l10n.numbers_for} ${selectedPickTypeObject.name}.";
                                          }
                                          print("2222222222222");

                                          ShowToast.showToast(context, msg, type: ToastType.INFO);
                                          setState(() {
                                            isApplicable = false;
                                          });
                                          break;

                                        }
                                      }
                                      if (isApplicable) {

                                        Navigator.push(context, SlideRightRoute(
                                            page: MultiBlocProvider(
                                              providers: [
                                                BlocProvider<LotteryBloc>(
                                                  create: (BuildContext context) => LotteryBloc(),
                                                )
                                              ],
                                              child: PreviewGameScreen(gameSelectedDetails: widget.mPanelBinList ?? [], gameObjectsList: widget.particularGameObjects, onComingToPreviousScreen: (String onComingToPreviousScreen) {
                                                switch(onComingToPreviousScreen) {
                                                  case "isAllPreviewDataDeleted" : {
                                                    setState(() {
                                                      widget.mPanelBinList?.clear();
                                                      overAllReset();
                                                      isEdit = false;
                                                    });
                                                    break;
                                                  }

                                                  case "isBuyPerformed" : {
                                                    setState(() {
                                                      widget.mPanelBinList?.clear();
                                                      overAllReset();
                                                      isEdit = false;
                                                    });
                                                    break;
                                                  }
                                                }
                                              },
                                                selectedGamesData: (List<PanelBean> selectedAllGameData) {
                                                  setState(() {
                                                    print("22222222222");
                                                    var pickTypeObject = mNewPickTypeList.where((element) => element.name == selectedAllGameData[0].pickName).toList();
                                                    selectedPickTypeObject = pickTypeObject[0];
                                                    setNoPickLimitsAgain(selectedPickTypeObject);
                                                    listOfSelectedNosMap = selectedAllGameData[0].listSelectedNumber![0];
                                                    selectedPickType            = {selectedAllGameData[0].pickName ?? "Manual": true};
                                                    selectedBetTypeData         = widget.betRespV0s!;
                                                    ballPickInstructions        = widget.pickType?[0].description ?? context.l10n.please_select_numbers;

                                                    int selectedBetAmtTemp = selectedAllGameData[0].selectBetAmount ?? 1;
                                                    selectedBetAmountValue["$selectedBetAmtTemp"] = true;
                                                    selectedBetAmount = "$selectedBetAmtTemp";

                                                    log("listOfSelectedNosMap:$listOfSelectedNosMap");
                                                    log("selectedAllGameData::${jsonEncode(selectedAllGameData)}");
                                                    isEdit = false;
                                                    overAllReset();
                                                    widget.mPanelBinList = selectedAllGameData;
                                                  });
                                                },
                                                selectedGamesDataForEdit: (PanelBean selectedGameEditData) {
                                                  print("selectedGamesDataForEdit--------------------->");
                                                  setEditData(selectedGameEditData);
                                                },
                                              ),
                                            )));
                                      }

                                    } else {
                                      print("---- NO EDIT -----");

                                      Navigator.push(context, SlideRightRoute(
                                          page: MultiBlocProvider(
                                            providers: [
                                              BlocProvider<LotteryBloc>(
                                                create: (BuildContext context) => LotteryBloc(),
                                              )
                                            ],
                                            child: PreviewGameScreen(gameSelectedDetails: widget.mPanelBinList ?? [], gameObjectsList: widget.particularGameObjects, onComingToPreviousScreen: (String onComingToPreviousScreen) {
                                              switch(onComingToPreviousScreen) {
                                                case "isAllPreviewDataDeleted" : {
                                                  setState(() {
                                                    widget.mPanelBinList?.clear();
                                                    overAllReset();
                                                    isEdit = false;
                                                  });
                                                  break;
                                                }

                                                case "isBuyPerformed" : {
                                                  setState(() {
                                                    widget.mPanelBinList?.clear();
                                                    overAllReset();
                                                    isEdit = false;
                                                  });
                                                  break;
                                                }
                                              }
                                            },
                                              selectedGamesData: (List<PanelBean> selectedAllGameData) {
                                                setState(() {
                                                  isEdit = false;
                                                  overAllReset();
                                                  widget.mPanelBinList = selectedAllGameData;
                                                });
                                              },
                                              selectedGamesDataForEdit: (PanelBean selectedGameEditData) {
                                                print("selectedGamesDataForEdit--------------------->");
                                                setEditData(selectedGameEditData);
                                              },
                                            ),
                                          )));
                                    }
                                  }

                                },
                                child: Ink(
                                  color: LongaLottoPosColor.game_color_red,
                                  child: Align(alignment: Alignment.center, child: Text(isEdit ? context.l10n.update : context.l10n.proceed, textAlign: TextAlign.center, style: const TextStyle(color: LongaLottoPosColor.white, fontWeight: FontWeight.bold, fontSize: 14))).pOnly(left: 4),
                                ),
                              ),
                            ),
                          )
                              : Expanded(
                            child: Material(
                              child: InkWell(
                                onTap: () {
                                  {
                                    {
                                      var mListOfSelectedNos = 0;
                                      var mMinSelectionLimit = 0;
                                      var isApplicable = true;

                                      for(var i=0; i< ballPickingLimits.length; i++) {
                                        mMinSelectionLimit = ballPickingLimits["$i"]?["minSelectionLimit"] ?? 0;
                                        mListOfSelectedNos = listOfSelectedNosMap["$i"]?.length ?? 0;
                                        if (mListOfSelectedNos < mMinSelectionLimit) {
                                          String msg = "";
                                          if (widget.particularGameObjects?.familyCode?.toUpperCase() == "MultiSet".toUpperCase()) {
                                            msg = mMinSelectionLimit > 1 ? "${context.l10n.select_at_least} ${ballPickingLimits["0"]?["minSelectionLimit"]} ${context.l10n.numbers_and} ${ballPickingLimits["1"]?["minSelectionLimit"]} ${context.l10n.bonus_number_from_panel_for} ${selectedPickTypeObject.name}." : "${context.l10n.select_at_least} ${ballPickingLimits["0"]?["minSelectionLimit"]} ${context.l10n.numbers_and} ${ballPickingLimits["1"]?["minSelectionLimit"]} ${context.l10n.bonus_number_from_panel_for} ${selectedPickTypeObject.name}.";

                                          } else {
                                            msg = mMinSelectionLimit > 1 ? "${"${context.l10n.select_at_least} $mMinSelectionLimit ${context.l10n.numbers_for} ${selectedPickTypeObject.name}"}." : "${context.l10n.select_at_least} $mMinSelectionLimit ${context.l10n.numbers_for} ${selectedPickTypeObject.name}.";
                                          }
                                          ShowToast.showToast(context, msg, type: ToastType.INFO);
                                          setState(() {
                                            isApplicable = false;
                                          });
                                          break;

                                        }
                                      }

                                      if (isApplicable) {
                                        addBet();
                                      }
                                    }
                                  }

                                },
                                child: Ink(
                                  color: LongaLottoPosColor.game_color_red,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/icons/plus.svg', width: 16, height: 16, color: LongaLottoPosColor.white),
                                      Align(alignment: Alignment.center, child: Text(context.l10n.add_bet_cap, style: const TextStyle(color: LongaLottoPosColor.white, fontWeight: FontWeight.bold, fontSize: 14))).pOnly(left: 4),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  setNoPickLimitsAgain(PickType pickType) {
    List<Range1> range1 = pickType.range ?? [];
    if (range1.isNotEmpty) {
      for(int i=0; i< range1.length; i++) {
        setState(() {
          ballPickingLimits["$i"] = {
            "minSelectionLimit" : int.parse(range1[i].pickCount?.split(",")[0].toString() ?? "0"),
            "maxSelectionLimit" : int.parse(range1[i].pickCount?.split(",")[1].toString() ?? "0"),
          };

          minSelectionLimit = int.parse(selectedPickTypeObject.range?[0].pickCount?.split(",")[0] ?? "0");
          maxSelectionLimit = int.parse(selectedPickTypeObject.range?[0].pickCount?.split(",")[1] ?? "0");
        });
      }
      log("ballPickingLimits:: $ballPickingLimits");

    } else {
      //ShowToast.showToast(context, context.l10n.no_pick_type_available, type: ToastType.INFO);
    }

  }

  setSelectedBetAmountForHighlighting(int position) {
    if (listBetAmount.isNotEmpty) {
      for (int index = 0; index < listBetAmount.length; index++) {
        listBetAmount[index].isSelected = position == index;
      }
    }
  }

  onBetAmountClick(int amount) {

    setState(() {
      selectedBetAmount = amount.toString();
    });
    betValueCalculation(mRangeObjectIndex);
  }

  betValueCalculation(int rangeObjectIndex) {
    if (selectedPickTypeObject.code?.toUpperCase() == "Banker".toUpperCase()) {
      var minUpperLineSelectionLimit  = int.parse(selectedPickTypeObject.range?[rangeObjectIndex].pickCount?.split("-")[0].split(",")[0] ?? "0");
      var minLowerLineSelectionLimit  = int.parse(selectedPickTypeObject.range?[rangeObjectIndex].pickCount?.split("-")[1].split(",")[0] ?? "0");
      var upperLineNosList            = listOfSelectedUpperLowerLinesNosMap["$rangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == true).toList() ?? [];
      var lowerLineNosList            = listOfSelectedUpperLowerLinesNosMap["$rangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == false).toList() ?? [];

      if (upperLineNosList.length >= minUpperLineSelectionLimit && lowerLineNosList.length >= minLowerLineSelectionLimit) {
        if (widget.particularGameObjects?.familyCode?.toUpperCase() == "MultiSet".toUpperCase()) {
          if (isPowerBallPlus) {
            int amount = (int.parse(selectedBetAmount) * 1) * 2;
            setState(() {
              betValue = "$amount";
            });

          } else {
            int amount = (int.parse(selectedBetAmount) * 1);
            setState(() {
              betValue = "$amount";
            });
          }
        } else {
          int amount = (int.parse(selectedBetAmount) * getNumberOfLines());
          setState(() {
            betValue = "$amount";
          });
        }

      } else {
        setState(() {
          betValue = "0";
        });
      }

    } else {
      var listOfSelectedNosMapLength = listOfSelectedNosMap["$rangeObjectIndex"]?.length ?? 0;
      var mMinSelectionLimit = ballPickingLimits["$rangeObjectIndex"]?["minSelectionLimit"] ?? 0;
      if (listOfSelectedNosMapLength >= mMinSelectionLimit) {
        if (widget.particularGameObjects?.familyCode?.toUpperCase() == "MultiSet".toUpperCase()) {
          if (isPowerBallPlus) {
            int amount = (int.parse(selectedBetAmount) * 1) * 2;
            setState(() {
              betValue = "$amount";
            });

          } else {
            int amount = (int.parse(selectedBetAmount) * 1);
            setState(() {
              betValue = "$amount";
            });
          }
        } else {
          int amount = (int.parse(selectedBetAmount) * getNumberOfLines());
          setState(() {
            betValue = "$amount";
          });
        }
      } else {
        setState(() {
          betValue = "0";
        });
      }
    }
  }

  int getNumberOfLines() {
    var listOfSelectedNosMapListLength = listOfSelectedNosMap["$mRangeObjectIndex"]?.length ?? 0;

    if (selectedPickTypeObject.code?.toUpperCase() == "Perm2".toUpperCase()) {
      return nCr(listOfSelectedNosMapListLength, 2);
    }
    if (selectedPickTypeObject.code?.toUpperCase() == "Perm3".toUpperCase()) {
      return nCr(listOfSelectedNosMapListLength, 3);
    }
    if (selectedPickTypeObject.code?.toUpperCase() == "Perm4".toUpperCase()) {
      return nCr(listOfSelectedNosMapListLength, 4);
    }
    if (selectedPickTypeObject.code?.toUpperCase() == "Perm5".toUpperCase()) {
      return nCr(listOfSelectedNosMapListLength, 5);
    }
    if (selectedPickTypeObject.code?.toUpperCase() == "Perm6".toUpperCase()) {
      return nCr(listOfSelectedNosMapListLength, 6);
    }
    if (selectedPickTypeObject.code?.toUpperCase() == "Perm7".toUpperCase()) {
      return nCr(listOfSelectedNosMapListLength, 7);
    }
    if (selectedPickTypeObject.code?.toUpperCase() == "Perm8".toUpperCase()) {
      return nCr(listOfSelectedNosMapListLength, 8);
    }
    if (selectedPickTypeObject.code?.toUpperCase() == "Perm9".toUpperCase()) {
      return nCr(listOfSelectedNosMapListLength, 9);
    }
    if (selectedPickTypeObject.code?.toUpperCase() == "Banker".toUpperCase()) {
      var upperLineNosList = listOfSelectedUpperLowerLinesNosMap["$mRangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == true).toList() ?? [];
      var lowerLineNosList = listOfSelectedUpperLowerLinesNosMap["$mRangeObjectIndex"]?.where((element) => element.isSelectedInUpperLine == false).toList() ?? [];

      return upperLineNosList.length * lowerLineNosList.length;
    }
    if (selectedPickTypeObject.code?.toUpperCase() == "Banker1AgainstAll".toUpperCase()) {
      return 89;
    }
    return 1;
  }

  selectedPickTypeData(PickType mPickType) {
    log("-------> PickType Name : ${mPickType.name}");
    setState(() {
      selectedPickTypeObject                  = mPickType;
      ballPickInstructions                    = mPickType.description ?? context.l10n.please_select_numbers;
      selectedPickType.clear();
      selectedPickType[mPickType.name ?? ""]  = true;

      if (!isEdit) {
        reset();
      } else {
        if(mPickType.name?.toUpperCase() == "QP".toUpperCase()) {
          reset();
        }
      }

      if (mPickType.name?.toUpperCase() == "QP".toUpperCase()) {
        setNoPickLimitsAgain(mPickType);

        List<Range1> pickTypeRangeList = mPickType.range ?? [];
        if(pickTypeRangeList.isNotEmpty) {
          setState(() {
            mIsQpSelecting = true;
            _inOutAnimationController.forward();
          });
          Timer(const Duration(seconds: 0), () {
            setState(() {
              mIsQpSelecting = false;
            });
            for(int i = 0; i< pickTypeRangeList.length ;i++) {
              var minSLimit = ballPickingLimits["$i"]?["minSelectionLimit"] ?? 0;
              var maxSLimit = ballPickingLimits["$i"]?["maxSelectionLimit"] ?? 0;
              log("rangeObjectIndex : $i | minLimit : ${ballPickingLimits["$i"]?["minSelectionLimit"]} | maxLimit : ${ballPickingLimits["$i"]?["maxSelectionLimit"]}");
              if (minSLimit == maxSLimit) {
                qpGenerator(widget.particularGameObjects?.numberConfig?.range?[i].ball ?? [], maxSLimit, rangeObjectIndex: i);
              }
            }
            log("listOfSelectedNosMap -----------------------> $listOfSelectedNosMap");
            setState(() {
              isQp = false;
            });
          });
        }
      }
      else if(mPickType.name?.toUpperCase() == "Perm QP".toUpperCase()) {
        int pickTypeRangeCount = mPickType.range?.length ?? 0;
        setNoPickLimitsAgain(mPickType);
        setState(() {
          if(pickTypeRangeCount > 1) {
            isMultiplePickType = true;
            getPermRangeList(mPickType);

          } else {
            isMultiplePickType = false;
            mMultiplePickTypeIndex = 0;
            setPermQpList();
          }
        });

        if (_pickController.state?.isFront == true) {
          _pickController.toggleCard();
        }
      }
      else if (mPickType.name?.toUpperCase() == "Banker".toUpperCase()) {
        setNoPickLimitsForBanker(isUpperLine ? true : false, mPickType);
        setState(() {
          isBankerPickType = true;
        });
        if (_pickController.state?.isFront == true) {
          _pickController.toggleCard();
        }

      }
      else {
        setNoPickLimitsAgain(selectedPickTypeObject);
      }

      if (mPickType.range?[0].pickMode?.toUpperCase() == "FixedSet".toUpperCase()) {
        setNoPickLimitsAgain(mPickType);
        List<Range1> pickTypeRangeList = mPickType.range ?? [];

        if(pickTypeRangeList.isNotEmpty) {
          for(int i = 0; i< pickTypeRangeList.length ;i++) {
            var minSLimit = ballPickingLimits["$i"]?["minSelectionLimit"] ?? 0;
            var maxSLimit = ballPickingLimits["$i"]?["maxSelectionLimit"] ?? 0;
            log("rangeObjectIndex : $i | minLimit : ${ballPickingLimits["$i"]?["minSelectionLimit"]} | maxLimit : ${ballPickingLimits["$i"]?["maxSelectionLimit"]}");
            if (minSLimit == maxSLimit) {
              List<String> pickedNosList = [];
              pickedNosList = selectedPickTypeObject.range?[i].pickValue?.split(",") ?? [];

              if (pickedNosList.isNotEmpty == true) {
                qpWithFixedNoGenerator(pickedNosList, maxSLimit, rangeObjectIndex: i);
              }
            }
          }
        }
      }
      if (mPickType.code?.toUpperCase().contains("HOT") == true) {
        setNoPickLimitsAgain(mPickType);

        List<Range1> pickTypeRangeList = mPickType.range ?? [];
        if(pickTypeRangeList.isNotEmpty) {
          for(int i = 0; i< pickTypeRangeList.length ;i++) {
            var minSLimit = ballPickingLimits["$i"]?["minSelectionLimit"] ?? 0;
            var maxSLimit = ballPickingLimits["$i"]?["maxSelectionLimit"] ?? 0;
            log("rangeObjectIndex : $i | minLimit : ${ballPickingLimits["$i"]?["minSelectionLimit"]} | maxLimit : ${ballPickingLimits["$i"]?["maxSelectionLimit"]}");
            if (minSLimit == maxSLimit) {
              var replacedStringList = widget.particularGameObjects?.hotNumbers?.replaceAll("[", "").replaceAll("]", "").replaceAll(" ", "").split(",") ?? [];
              if (replacedStringList.isNotEmpty == true) {
                qpWithFixedNoGenerator(replacedStringList, maxSLimit, rangeObjectIndex: i);
              }
            }
          }
        }
      }
      if (mPickType.code?.toUpperCase().contains("COLD") == true) {
        setNoPickLimitsAgain(mPickType);

        List<Range1> pickTypeRangeList = mPickType.range ?? [];
        if(pickTypeRangeList.isNotEmpty) {
          for(int i = 0; i< pickTypeRangeList.length ;i++) {
            var minSLimit = ballPickingLimits["$i"]?["minSelectionLimit"] ?? 0;
            var maxSLimit = ballPickingLimits["$i"]?["maxSelectionLimit"] ?? 0;
            log("rangeObjectIndex : $i | minLimit : ${ballPickingLimits["$i"]?["minSelectionLimit"]} | maxLimit : ${ballPickingLimits["$i"]?["maxSelectionLimit"]}");
            if (minSLimit == maxSLimit) {
              var replacedStringList = widget.particularGameObjects?.coldNumbers?.replaceAll("[", "").replaceAll("]", "").replaceAll(" ", "").split(",") ?? [];
              if (replacedStringList.isNotEmpty == true) {
                qpWithFixedNoGenerator(replacedStringList, maxSLimit, rangeObjectIndex: i);
              }
            }
          }
        }
      }
    });
  }

  List<QuickPickBetAmountBean> setPermQpList({int rangeObjectIndex=0}) {
    var mMinSelectionLimit = ballPickingLimits["$rangeObjectIndex"]?["minSelectionLimit"] ?? 0;
    var mMaxSelectionLimit = ballPickingLimits["$rangeObjectIndex"]?["maxSelectionLimit"] ?? 0;
    listQuickPick.clear();
    for (int count=mMinSelectionLimit; count <= mMaxSelectionLimit; count++) {
      QuickPickBetAmountBean model = QuickPickBetAmountBean();
      model.number = count;
      model.isSelected = false;
      listQuickPick.add(model);
    }

    return listQuickPick;
  }

  List<Range1> getPermRangeList(PickType mPickType) {
    List<Range1> pickTypeRange = mPickType.range ?? [];
    return pickTypeRange;
  }

  setNoPickLimitsForBanker(bool isUpperLine, PickType pickType) {
    List<Range1> range1 = pickType.range ?? [];
    if (range1.isNotEmpty) {
      for(int i=0; i< range1.length; i++) {
        setState(() {
          ballPickingLimits["$i"] = {
            "minSelectionLimit" : int.parse(range1[i].pickCount?.split("-")[isUpperLine ? 0 : 1].split(",")[0] ?? "0"),
            "maxSelectionLimit" : int.parse(range1[i].pickCount?.split("-")[isUpperLine ? 0 : 1].split(",")[1] ?? "0")
          };
        });
      }
      log("limits::$ballPickingLimits");

    } else {
      //ShowToast.showToast(context, context.l10n.no_pick_type_available, type: ToastType.INFO);
    }

  }

  switchToPickType(String pickCode) {
    /*if (selectedBetTypeData != null) {
      List<PickType> pickTypeList = getPickTypeWithQp(betRespVOs: selectedBetTypeData);
      setState(() {
        for (int index = 0; index < pickTypeList.length; index++) {

          PickType pickedType     = pickTypeList[index];
          if (pickedType.code?.toUpperCase() == pickCode.toUpperCase()) {
            ballPickInstructions = pickedType.description ?? context.l10n.please_select_numbers;
            selectedPickTypeObject = pickedType;
            setNoPickLimits(pickTypeList[index]);
            selectedPickTypeData(getPickTypeWithQp()[index]);
            break;
          }
        }
      });
    }*/
  }


  overAllReset() {
    setState(() {
      mRangeObjectIndex = 0;
      listOfSelectedNosMap = {};
      selectedPickTypeObject    = mNewPickTypeList[0];
      selectedPickType = {selectedPickTypeObject.name ?? "Manual": true};
      selectedBetAmountValue.clear();
      if (listBetAmount.isNotEmpty) {
        selectedBetAmount   = "${listBetAmount[0].amount ?? 0}";
        selectedBetAmountValue[listBetAmount[0].amount.toString()] = true;

      } else {
        selectedBetAmount   = "0";
      }
      setSelectedBetAmountForHighlighting(0);
      for (int i=0; i< listOfSelectedUpperLowerLinesNosMap.length; i++) {
        var listOfSelectedUpperLowerLinesNosList = listOfSelectedUpperLowerLinesNosMap["$i"] ?? [];
        listOfSelectedUpperLowerLinesNosList.clear();
      }

      isUpperLine = true;
      betValue = "0";
      lowerLineBankerPickedNoIndex  = 0;
      upperLineBankerPickedNoIndex  = 0;
      if(_controller.state?.isFront == false) {
        _controller.state?.toggleCard();
      }
    });
  }

  reset() {
    setState(() {
      mRangeObjectIndex = 0;
      listOfSelectedNosMap = {};
      /*for (int i=0; i< listOfSelectedNosMap.length; i++) {
        var listOfSelectedNosList = listOfSelectedNosMap["$i"] ?? [];
        listOfSelectedNosList.clear();
      }*/
      for (int i=0; i< listOfSelectedUpperLowerLinesNosMap.length; i++) {
        var listOfSelectedUpperLowerLinesNosList = listOfSelectedUpperLowerLinesNosMap["$i"] ?? [];
        listOfSelectedUpperLowerLinesNosList.clear();
      }

      isUpperLine = true;
      betValue = "0";
      lowerLineBankerPickedNoIndex  = 0;
      upperLineBankerPickedNoIndex  = 0;
      if(_controller.state?.isFront == false) {
        _controller.state?.toggleCard();
      }
    });
  }

  bool isBallAvailable(List<String> ballList, int index, int rangeObjectIndex) {
    if (ballList.contains(widget.particularGameObjects?.numberConfig?.range?[rangeObjectIndex].ball?[index].number)) {
      return true;
    }
    return false;
  }

  Color getBallColor(List<String> ballList, int index) {
    print("<--------------------------------------- getBallColor ----------------------------------->");
    var colorName = "";
    if (ballList.contains(widget.particularGameObjects?.numberConfig?.range?[0].ball?[index].number)) {

      if (widget.particularGameObjects?.numberConfig?.range?[0].ball?[index].color.isNotEmptyAndNotNull == true) {
        colorName = widget.particularGameObjects?.numberConfig?.range?[0].ball?[index].color ?? "";

      } else {
        colorName = "NO_COLOR";
      }
    }
    return getColors(colorName) ?? Colors.transparent;
  }

  bool isBankerBallNoAvailable(List<BankerBean> ballList, int index, int rangeObjectIndex) {
    var ballDetails = ballList.where((element) => element.number == widget.particularGameObjects?.numberConfig?.range?[rangeObjectIndex].ball?[index].number).toList();

    if (ballDetails.isNotEmpty) {
      return true;
    }
    return false;
  }

  Color getBallBankersNoColor(List<BankerBean> ball, int index, int rangeObjectIndex) {
    var colorName = "";

    var ballDetails = ball.where((element) => element.number == widget.particularGameObjects?.numberConfig?.range?[rangeObjectIndex].ball?[index].number).toList();
    if(ballDetails.isNotEmpty) {
      if (ballDetails[0].color.isNotEmptyAndNotNull) {
        colorName = ballDetails[0].color ?? "";
      } else {
        colorName = "NO_COLOR";
      }
    }
    return getColors(colorName) ?? Colors.transparent;
  }


  checkIsPowerBallPlusEnabled() {
    log("checkIsPowerBallPlusEnabled");
    List<PanelBean> powerPlusEnabledAvailable = widget.mPanelBinList?.where((element) => element.isPowerBallPlus == true).toList() ?? [];
    if (powerPlusEnabledAvailable.isNotEmpty) {
      isPowerBallPlus = true;
    }
  }

  setInitialBetAmount() {
    if (listBetAmount.isNotEmpty) {
      selectedBetAmount   = "${listBetAmount[0].amount ?? 0}";
      selectedBetAmountValue[listBetAmount[0].amount.toString()] = true;

    } else {
      selectedBetAmount   = "0";
    }
  }

  addBet() {
    PanelBean model = PanelBean();
    if (selectedPickTypeObject.code?.toUpperCase() == "Banker".toUpperCase()) {
      List<BankerBean> upperLineNosObjectList = [], lowerLineNosObjectList = [];

      for (int i=0; i< listOfSelectedUpperLowerLinesNosMap.length; i++) {
        List<BankerBean> listOfSelectedUpperLowerLinesNosList = listOfSelectedUpperLowerLinesNosMap["$i"] ?? [];
        upperLineNosObjectList            = listOfSelectedUpperLowerLinesNosList.where((element) => element.isSelectedInUpperLine == true).toList();
        lowerLineNosObjectList            = listOfSelectedUpperLowerLinesNosList.where((element) => element.isSelectedInUpperLine == false).toList();
      }

      List<String> listLowerLine = [];
      for (BankerBean i in  lowerLineNosObjectList) {
        if (i.number != null) {
          listLowerLine.add(i.number!);
        }
      }

      String? pickedValues                    = "${upperLineNosObjectList[0].number}-${listLowerLine.join(",")}";
      model.listSelectedNumberUpperLowerLine  = [listOfSelectedUpperLowerLinesNosMap];
      model.pickedValue                       = pickedValues;

    } else {
      String pickedValues = "";

      if (widget.particularGameObjects?.familyCode?.toUpperCase() == "MultiSet".toUpperCase()) {
        var listOfSelectedNosLength = listOfSelectedNosMap.length;
        List<String> pkV = [];
        for(int i=0; i<listOfSelectedNosLength; i++) {
          var afterJoinPickedValues = listOfSelectedNosMap["$i"]?.join(',') ?? "";
          if (afterJoinPickedValues.isNotEmpty) {
            pkV.add(afterJoinPickedValues);
          }
        }
        pickedValues = pkV.join("#");

      } else {
        var listOfSelectedNosLength = listOfSelectedNosMap.length;
        for(int i=0; i<listOfSelectedNosLength; i++) {
          pickedValues = listOfSelectedNosMap["$i"]?.join(',') ?? "";
        }
      }

      model.listSelectedNumber  = [listOfSelectedNosMap];
      model.pickedValue         = pickedValues;
      model.isPowerBallPlus     = isPowerBallPlus;
    }

    model.gameName        = widget.particularGameObjects?.gameName;
    model.amount          = double.parse(betValue);
    model.winMode         = selectedBetTypeData?.winMode;
    model.betName         = selectedBetTypeData?.betDispName;
    model.pickName        = selectedPickTypeObject.name;
    model.betCode         = selectedBetTypeData?.betCode;
    model.pickCode        = selectedPickTypeObject.code;
    model.pickConfig      = selectedPickTypeObject.range?[0].pickConfig;
    model.isPowerBallPlus = isPowerBallPlus;

    if (selectedBetAmount != "0") {
      if (selectedBetTypeData?.unitPrice != null) {
        double mUnitPrice = selectedBetTypeData?.unitPrice ?? 1;
        model.betAmountMultiple = int.parse(selectedBetAmount) ~/ mUnitPrice;
      }
    }
    model.selectBetAmount     = int.parse(selectedBetAmount);
    model.unitPrice           = selectedBetTypeData?.unitPrice ?? 1;
    model.numberOfDraws       = 1;
    model.numberOfLines       = getNumberOfLines();
    model.isMainBet           = true;

    if (selectedPickTypeObject.name?.contains("QP") == true) {
      model.isQuickPick       = true;
      model.isQpPreGenerated  = true;

    } else {
      model.isQuickPick       = false;
      model.isQpPreGenerated  = false;
    }
    if(widget.mPanelBinList != null) {
      widget.mPanelBinList?.add(model);
    }

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<LoginBloc>(
                  create: (BuildContext context) => LoginBloc(),
                )
              ],
              child: PickTypeScreen(gameObjectsList: widget.particularGameObjects, listPanelData: widget.mPanelBinList),
            )
        )
    );
  }

  int getColorListLength(Map<String, dynamic> ballObjectsMap, int index) {
    Range? rangeBall      = ballObjectsMap["$index"];
    List<Ball>? ballList  =  rangeBall?.ball ?? [];
    lotteryGameColorList.clear();
    if (ballList.isNotEmpty) {
      for (Ball ballDetails in ballList) {
        if (ballDetails.color != null && ballDetails.color != "") {
          if(getColors(ballDetails.color!) != null) {
            if (!lotteryGameColorList.contains(getColors(ballDetails.color!)) ) {
              lotteryGameColorList.add(getColors(ballDetails.color!));
            }
          }
        }
      }
      return lotteryGameColorList.length;
    }
    return 0;
  }

  int getColumnCount(int index) {
    int totalBall   = getMaxBallLimit(ballObjectsMap , index);
    int columnCount = 9;

    if(lotteryGameColorList.isEmpty) {
      for(int j=7; j<=10; j++) {
        if (totalBall % j == 0) {
          columnCount = j;
          break;
        }
      }
      return 7;

    } else {
      return lotteryGameColorList.length;
    }
  }

  int getMaxBallLimit(Map<String, dynamic> ballObjectsMap, int index) {
    Range? rangeBall = ballObjectsMap["$index"];

    List<Ball>? ballList =  rangeBall?.ball ?? [];
    if (ballList.isNotEmpty) {
      return ballList.length;
    }
    return 0;
  }

  qpGenerator(List<Ball> numberConfig, int numbersToBeQp, {int rangeObjectIndex = 0}) {
    for(int i=0;i<rangeObjectIndex +1;i++) {}
    math.Random random = math.Random();
    List<String> listOfQpNumber = [];
    log("INITIAL listOfQpNumber.length -> ${listOfQpNumber.length}");
    log("INITIAL numbersToBeQp -> $numbersToBeQp");
    while(listOfQpNumber.length < numbersToBeQp) {
      String randomNo = (random.nextInt(numberConfig.length) + 1).toString();

      log("INITIAL listOfSelectedNosMap[0]: -> ${listOfSelectedNosMap["0"]}");
      log("INITIAL randomNo -> $randomNo");
      log("INITIAL rangeObjectIndex -> $rangeObjectIndex");

      if(rangeObjectIndex == 1) {
        if (listOfSelectedNosMap["0"]?.contains(randomNo.length == 1 ? "0$randomNo" : randomNo) == false) {
          log("false .contains(randomNo): -> ${listOfSelectedNosMap["0"]?.contains(randomNo.length == 1 ? "0$randomNo" : randomNo)}");
          if (!listOfQpNumber.contains(randomNo.length == 1 ? "0$randomNo" : randomNo)) {
            listOfQpNumber.add(randomNo.length == 1 ? "0$randomNo" : randomNo);
          }
        } else {
          log("true .contains(randomNo): -> ${listOfSelectedNosMap["0"]?.contains(randomNo.length == 1 ? "0$randomNo" : randomNo)}");

        }
      } else {
        if (!listOfQpNumber.contains(randomNo.length == 1 ? "0$randomNo" : randomNo)) {
          listOfQpNumber.add(randomNo.length == 1 ? "0$randomNo" : randomNo);
        }
        print("else - listOfQpNumber -> $listOfQpNumber");

      }
    }

    /*reset();
    setState(() {
      var listOfSelectedNosList = listOfSelectedNosMap["$rangeObjectIndex"] ?? [];
      listOfSelectedNosList.clear();
    });*/

    setQpDelay(listOfQpNumber, rangeObjectIndex: rangeObjectIndex);
  }

  qpWithFixedNoGenerator(List<String> numbersPicked, int numbersToBeQp, {int rangeObjectIndex = 0}) {
    setState(() {
      mIsQpSelecting = true;
      _inOutAnimationController.forward();
    });

    List<String> listOfQpNumber = [];
    listOfQpNumber = numbersPicked;

    setState(() {
      var listOfSelectedNosList = listOfSelectedNosMap["$rangeObjectIndex"] ?? [];
      listOfSelectedNosList.clear();
    });

    setQpDelay(listOfQpNumber, rangeObjectIndex: rangeObjectIndex);
  }

  setQpDelay(List<String> listOfQpNumber, {rangeObjectIndex = 0}) {
    setState(() {
      /*var listOfSelectedNosList = listOfSelectedNosMap["$rangeObjectIndex"] ?? [];
      listOfSelectedNosList.clear();*/
      for (String i in listOfQpNumber) {
        var listOfSelectedNosList = listOfSelectedNosMap["$rangeObjectIndex"] ?? [];
        listOfSelectedNosList.add(i.length == 1 ? "0$i" : i);
        listOfSelectedNosMap["$rangeObjectIndex"] = listOfSelectedNosList;
      }
    });
    betValueCalculation(rangeObjectIndex);
  }

  bool isMultiSetBallAvailable(Map<String, List<String>> listOfSelectedNosMap, int index) {
    if (listOfSelectedNosMap.isNotEmpty) {
      for(int i=0; i< listOfSelectedNosMap.length; i++) {
        if (listOfSelectedNosMap["$i"]?.contains(widget.particularGameObjects?.numberConfig?.range?[0].ball?[index].number) == true) {
          return true;
        }
      }
    }
    return false;
  }

  Color getBallColorForMultiBet(Map<String, List<String>> listOfSelectedNosMap, String chosenBall, int index) {
    var colorName = "";
    if (listOfSelectedNosMap.isNotEmpty) {
      for(int i=0; i< listOfSelectedNosMap.length; i++) {
        print("i: $i");
        print("widget.particularGameObjects?.numberConfig?.range?[0].ball?[index].number : ${widget.particularGameObjects?.numberConfig?.range?[0].ball?[index].number}");
        if(listOfSelectedNosMap["$i"]?.contains(widget.particularGameObjects?.numberConfig?.range?[0].ball?[index].number) == true) {
          var lonKey = listOfSelectedNosMap.entries.firstWhere((entry) => entry.value == listOfSelectedNosMap["$i"]).key;
          print("lonKey: $lonKey");

          /*switch(lonKey) {
            case "0": {
              colorName = "NO_COLOR";
              break;
            }

            case "1": {
              colorName = "RED";

              break;
            }
            default: {
              colorName = "";
            }
          }*/
          if (lonKey == "1") {
            print("color will be red");
            colorName = "RED";
            break;

          } else if(lonKey == "0") {
            print("color will be tangerine");
            colorName = "NO_COLOR";
            break;

          } else {
            print("color will be dafault ----->");
            colorName = "";

          }

        } else {
          colorName = "";
        }
      }
    }
    return getColors(colorName) ?? Colors.transparent;
  }

  addBetIfOnly1BetType() {
    PanelBean model = PanelBean();
    String pickedValues = "";

    if (widget.particularGameObjects?.familyCode?.toUpperCase() == "MultiSet".toUpperCase()) {
      var listOfSelectedNosLength = listOfSelectedNosMap.length;
      List<String> pkV = [];
      for(int i=0; i<listOfSelectedNosLength; i++) {
        var afterJoinPickedValues = listOfSelectedNosMap["$i"]?.join(',') ?? "";
        if (afterJoinPickedValues.isNotEmpty) {
          pkV.add(afterJoinPickedValues);
        }
      }
      pickedValues = pkV.join("#");

    } else {
      var listOfSelectedNosLength = listOfSelectedNosMap.length;
      for(int i=0; i<listOfSelectedNosLength; i++) {
        pickedValues = listOfSelectedNosMap["$i"]?.join(',') ?? "";
      }
    }

    model.listSelectedNumber  = [listOfSelectedNosMap];
    model.pickedValue         = pickedValues;
    model.isPowerBallPlus     = isPowerBallPlus;

    model.gameName            = widget.particularGameObjects?.gameName;
    model.amount              = double.parse(betValue);
    model.winMode             = selectedBetTypeData?.winMode;
    model.betName             = selectedBetTypeData?.betDispName;
    model.pickName            = selectedPickTypeObject.name;
    model.betCode             = selectedBetTypeData?.betCode;
    model.pickCode            = selectedPickTypeObject.code;
    model.pickConfig          = selectedPickTypeObject.range?[0].pickConfig;
    model.isPowerBallPlus     = isPowerBallPlus;

    if (selectedBetAmount != "0") {
      if (selectedBetTypeData?.unitPrice != null) {
        double mUnitPrice = selectedBetTypeData?.unitPrice ?? 1;
        model.betAmountMultiple = int.parse(selectedBetAmount) ~/ mUnitPrice;
      }
    }
    model.selectBetAmount     = int.parse(selectedBetAmount);
    model.unitPrice           = selectedBetTypeData?.unitPrice ?? 1;
    model.numberOfDraws       = 1;
    model.numberOfLines       = getNumberOfLines();
    model.isMainBet           = true;

    if (selectedPickTypeObject.name?.contains("QP") == true) {
      model.isQuickPick       = true;
      model.isQpPreGenerated  = true;

    } else {
      model.isQuickPick       = false;
      model.isQpPreGenerated  = false;
    }
    if(widget.mPanelBinList != null) {
      setState(() {
        widget.mPanelBinList?.add(model);
      });
      print("before reset: ${jsonEncode(widget.mPanelBinList)}");
      overAllReset();
      print("after reset: ${jsonEncode(widget.mPanelBinList)}");
    }

    /*Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>  MultiBlocProvider(
              providers: [
                BlocProvider<LotteryBloc>(
                  create: (BuildContext context) => LotteryBloc(),
                )
              ],
              child: GameScreen(particularGameObjects: widget.particularGameObjects, pickType: widget.betRespV0s?.pickTypeData?.pickType ?? [], betRespV0s: widget.betRespV0s, mPanelBinList: widget.mPanelBinList ?? [])),
        )
    );*/
  }

  void setEditData(PanelBean? mEditPanelData) {
    setState(() {
      editPanelBeanData = mEditPanelData;
      isEdit = true;
      var pickTypeObject = mNewPickTypeList.where((element) => element.name == mEditPanelData?.pickName).toList();
      selectedPickTypeObject = pickTypeObject[0];
      setNoPickLimitsAgain(selectedPickTypeObject);
      listOfSelectedNosMap        = mEditPanelData?.listSelectedNumber?[0] ?? {};
      selectedPickType            = {mEditPanelData?.pickName ?? "Manual": true};
      selectedBetTypeData         = widget.betRespV0s!;
      ballPickInstructions        = pickTypeObject[0].description ?? context.l10n.please_select_numbers;

      selectedBetAmountValue.clear();
      int selectedBetAmtTemp = mEditPanelData?.selectBetAmount ?? 1;
      selectedBetAmountValue["$selectedBetAmtTemp"] = true;
      selectedBetAmount = "$selectedBetAmtTemp";
      betValue = "${mEditPanelData?.amount?.toInt()}";

      log("setEditData: listOfSelectedNosMap:$listOfSelectedNosMap");
    });
  }

  void addingBet(bool isFromProceedBtn) {
    var maxPanel = widget.particularGameObjects?.maxPanelAllowed ?? 0;
    var panelDataListLength = widget.mPanelBinList?.length ?? 0;
    if (panelDataListLength < maxPanel) {
      var mListOfSelectedNos = 0;
      var mMinSelectionLimit = 0;
      var isApplicable = true;

      for(var i=0; i< ballPickingLimits.length; i++) {
        mMinSelectionLimit = ballPickingLimits["$i"]?["minSelectionLimit"] ?? 0;
        mListOfSelectedNos = listOfSelectedNosMap["$i"]?.length ?? 0;
        print("mListOfSelectedNos: $mListOfSelectedNos");
        print("mMinSelectionLimit: $mMinSelectionLimit");
        if (mListOfSelectedNos < mMinSelectionLimit) {
          String msg = "";
          if (widget.particularGameObjects?.familyCode?.toUpperCase() == "MultiSet".toUpperCase()) {
            msg = mMinSelectionLimit > 1 ? "${context.l10n.select_at_least} ${ballPickingLimits["0"]?["minSelectionLimit"]} ${context.l10n.numbers_and} ${ballPickingLimits["1"]?["minSelectionLimit"]} ${context.l10n.bonus_number_from_panel_for} ${selectedPickTypeObject.name}." : "${context.l10n.select_at_least} ${ballPickingLimits["0"]?["minSelectionLimit"]} ${context.l10n.numbers_and} ${ballPickingLimits["1"]?["minSelectionLimit"]} ${context.l10n.bonus_number_from_panel_for} ${selectedPickTypeObject.name}.";
          } else {
            msg = mMinSelectionLimit > 1 ? "${"${context.l10n.select_at_least} $mMinSelectionLimit ${context.l10n.numbers_for} ${selectedPickTypeObject.name}"}." : "${context.l10n.select_at_least} $mMinSelectionLimit ${context.l10n.numbers_for} ${selectedPickTypeObject.name}.";
          }
          ShowToast.showToast(context, msg, type: ToastType.INFO);
          setState(() {
            isApplicable = false;
          });
          break;

        }
      }
      if (isApplicable) {
        addBetIfOnly1BetType();
      }

    } else {
      ShowToast.showToast(context, context.l10n.max_panel_limit_reached, type: ToastType.ERROR);
    }

    if (isFromProceedBtn) {
      Navigator.push(context, SlideRightRoute(
          page: MultiBlocProvider(
            providers: [
              BlocProvider<LotteryBloc>(
                create: (BuildContext context) => LotteryBloc(),
              )
            ],
            child: PreviewGameScreen(gameSelectedDetails: widget.mPanelBinList ?? [], gameObjectsList: widget.particularGameObjects, onComingToPreviousScreen: (String onComingToPreviousScreen) {
              switch(onComingToPreviousScreen) {
                case "isAllPreviewDataDeleted" : {
                  setState(() {
                    widget.mPanelBinList?.clear();
                    overAllReset();
                    isEdit = false;
                  });
                  break;
                }

                case "isBuyPerformed" : {
                  setState(() {
                    widget.mPanelBinList?.clear();
                    overAllReset();
                    isEdit = false;
                  });
                  break;
                }
              }
            },
              selectedGamesData: (List<PanelBean> selectedAllGameData) {
                setState(() {
                  isEdit = false;
                  overAllReset();
                  widget.mPanelBinList = selectedAllGameData;
                });
              },
              selectedGamesDataForEdit: (PanelBean selectedGameEditData) {
                print("selectedGamesDataForEdit--------------------->");
                setEditData(selectedGameEditData);
              },
            ),
          )));

    }
  }

  String getBallInstructionMsg(String gameCode) {
    if (gameCode == "DailyLotto2") {
      return context.l10n.select_any_5_numbers_from_a_pool_of_1_to_36;

    } else if (gameCode == "EightByTwentyFour") {
      return context.l10n.select_any_8_numbers_from_a_pool_of_1_to_24;
    }
    return "";
  }

}