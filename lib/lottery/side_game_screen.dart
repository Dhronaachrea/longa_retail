import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:longalottoretail/drawer/longa_lotto_pos_drawer.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/widgets/longa_lotto_pos_scaffold.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:longalottoretail/lottery/models/otherDataClasses/selectedSideBetColorBean.dart';
import 'package:longalottoretail/lottery/models/response/fetch_game_data_response.dart';
import 'package:longalottoretail/lottery/models/otherDataClasses/panelBean.dart';
import 'package:longalottoretail/lottery/pick_type_screen.dart';
import 'package:longalottoretail/lottery/widgets/added_bet_cart_msg.dart';
import 'package:longalottoretail/utility/utils.dart';

import '../login/bloc/login_bloc.dart';

/*
    created by Rajneesh Kr.Sharma on 7 May, 23 | Edited on 30 May, 23
*/

class SideGameScreen extends StatefulWidget {
  final GameRespVOs? gameObjectsList;
  List<PanelBean>? listPanelData;
  String betCategory;

  SideGameScreen({Key? key, this.gameObjectsList, this.listPanelData, required this.betCategory}) : super(key: key);

  @override
  State<SideGameScreen> createState() => _SideGameScreenState();
}

class _SideGameScreenState extends State<SideGameScreen> {
  late FlipCardController _controller;
  List<BetRespVOs> lotteryGameFirstBallSideBetList              = [];
  List<BetRespVOs> lotteryGameLastBallSideBetList               = [];
  List<PickType> sideBetFrontBallPickTypeList                   = [];
  List<BetRespVOs> lotteryGameAllBallSideBetList                = [];
  List<PickType> sideBetAllBallPickTypeList                     = [];
  List<PickType> sideBetLastBallPickTypeList                    = [];
  late Color selectedColor                                      = LongaLottoPosColor.white;
  List<SelectedSideBetColorBean> sideBetPickedBallColorList     = [];
  Map<String, PanelBean> panelBeanMap                           = {};
  int betCount                                                  = 0;
  int betAmount                                                 = 0;


  @override
  void initState() {
    _controller                     = FlipCardController();

    List<String> allBallList        = ["HILL/VALLEY", "INCREASING/DECREASING", "MOREODDEVEN", "FIRSTFIVEBALLSUM", "MOREEVENODD", "AnyBallColor", "AnyBallSum"];
    lotteryGameFirstBallSideBetList = widget.gameObjectsList?.betRespVOs?.where((element) => element.betCode?.toUpperCase().contains("FirstBall".toUpperCase()) == true).toList() ?? [];
    lotteryGameLastBallSideBetList  = widget.gameObjectsList?.betRespVOs?.where((element) => element.betCode?.toUpperCase().contains("LastBall".toUpperCase()) == true).toList()  ?? [];
    lotteryGameAllBallSideBetList   = widget.gameObjectsList?.betRespVOs?.where((betRespObj) {
      for (var allBallListBetCodesSubString in allBallList) {
        if (betRespObj.betCode?.toUpperCase().contains(allBallListBetCodesSubString.toUpperCase()) == true) {
          return true;
        }
      }
      return false;
    }).toList() ?? [];

    var listPanelData = widget.listPanelData?.length ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(listPanelData > 0) {
        _controller.toggleCard();
      }
    });
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LongaLottoPosScaffold(
        showAppBar: true,
        onBackButton: (widget.listPanelData == null || widget.listPanelData?.isEmpty == true) ? null : () {
          AddedBetCartMsg().show(context: context, title: "Bet on cart !", subTitle: "You have some item in your cart. If you leave the game your cart will be cleared.", buttonText: "CLEAR", isCloseButton: true, buttonClick: () {
            Navigator.of(context).pop();
          });
        },
        drawer: LongaLottoPosDrawer(drawerModuleList: const []),
        backgroundColor: LongaLottoPosColor.light_dark_white,
        appBarTitle: Text(widget.gameObjectsList?.gameName ?? "NA", style: const TextStyle(fontSize: 18, color: LongaLottoPosColor.white)),
        body: Stack(
          children: [
            Column(
            children: [
              widget.betCategory == "FirstBall"
                  ? Expanded(
                    child: lotteryGameFirstBallSideBetList.isNotEmpty == true
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: lotteryGameFirstBallSideBetList.length ,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int firstBallSideBetListIndex) {
                                  List<PickType> pickType = lotteryGameFirstBallSideBetList[firstBallSideBetListIndex].pickTypeData?.pickType ?? [];
                                  List<MatchDetail> lotteryGameFirstBallColorPrizeSchema = widget.gameObjectsList?.gameSchemas?.matchDetail?.where((element) => element.betType == lotteryGameFirstBallSideBetList[firstBallSideBetListIndex].betCode).toList() ?? [];
                                  return Column(
                                          children: [
                                            Row(
                              children: [
                                Align(alignment: Alignment.centerLeft, child: Text(lotteryGameFirstBallSideBetList[firstBallSideBetListIndex].betDispName ?? "NA", style: const TextStyle(color: LongaLottoPosColor.black, fontSize: 14, fontWeight: FontWeight.bold))).p(16),
                                Text("Pays ${lotteryGameFirstBallColorPrizeSchema.isNotEmpty ? lotteryGameFirstBallColorPrizeSchema[0].prizeAmount : "NA"} ${getDefaultCurrency(getLanguage())}", style: const TextStyle(color: LongaLottoPosColor.game_color_red, fontSize: 12)),
                                Expanded(flex: 2, child: Container()),
                                Align(alignment: Alignment.centerLeft, child: Text("Bet ${lotteryGameFirstBallSideBetList[firstBallSideBetListIndex].unitPrice} ${getDefaultCurrency(getLanguage())}" , style: const TextStyle(color: LongaLottoPosColor.app_blue, fontSize: 14, fontWeight: FontWeight.bold))).pOnly(right: 8),
                              ],
                            ),
                                            if (lotteryGameFirstBallSideBetList[firstBallSideBetListIndex].betCode?.toUpperCase().contains("color".toUpperCase()) == true)
                                            SizedBox(
                              height: 70,
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: pickType.length ,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (BuildContext context, int index) {
                                    for(PickType i in pickType) {
                                      sideBetPickedBallColorList.add(SelectedSideBetColorBean(pickType: i, isSelected: false));
                                    }
                                    return SizedBox(
                                      width: 70,
                                      child: OutlinedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                            return getColors(sideBetPickedBallColorList[index].isSelected == true ? sideBetPickedBallColorList[index].pickType?.code ?? "WHITE" : "WHITE");
                                          }),
                                          side: sideBetPickedBallColorList[index].isSelected == true ? null : MaterialStateProperty.all(BorderSide(color: getColors(pickType[index].code ?? ""), width: 2.0, style: BorderStyle.solid)),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0))

                                          ),
                                        ),
                                        child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset("assets/icons/checked.svg", width: 10, height: 10, color: LongaLottoPosColor.white).pOnly(bottom: 4),
                                                Text(sideBetPickedBallColorList[index].pickType?.code ?? "", style: const TextStyle(color: LongaLottoPosColor.white, fontSize: 8, fontStyle: FontStyle.normal)),
                                              ],
                                            )
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (sideBetPickedBallColorList[index].isSelected == true) {
                                              sideBetPickedBallColorList[index].isSelected = false;
                                              panelBeanMap.remove(lotteryGameFirstBallSideBetList[firstBallSideBetListIndex].betCode ?? "");

                                            } else {
                                              for(int i=0; i<sideBetPickedBallColorList.length; i++) {
                                                sideBetPickedBallColorList[i].isSelected = false;
                                              }
                                              sideBetPickedBallColorList[index].isSelected = true;
                                              panelBeanMap[lotteryGameFirstBallSideBetList[firstBallSideBetListIndex].betCode ?? ""] = getPanelBean(lotteryGameFirstBallSideBetList[firstBallSideBetListIndex], sideBetPickedBallColorList[index].pickType, sideBetPickedBallColorList[index].pickType?.code ?? "");
                                            }
                                          });
                                          calculateTotalAmount();
                                          setNumberOfBets();
                                        },
                                      ),
                                    ).pOnly(right: 8);
                                  }
                              ),
                            ).pOnly(bottom: 16, left: 16)
                                            else SizedBox(
                              height: 60,
                              child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: .5,
                                    crossAxisCount: 1,
                                  ),
                                  padding: EdgeInsets.zero,
                                  itemCount: pickType.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (BuildContext context, int index) {
                                    List<PickType> pickType = lotteryGameFirstBallSideBetList[firstBallSideBetListIndex].pickTypeData?.pickType ?? [];
                                    return Ink(
                                      decoration: BoxDecoration(
                                        color: panelBeanMap[lotteryGameFirstBallSideBetList[firstBallSideBetListIndex].betCode ?? ""]?.pickCode == pickType[index].code ? LongaLottoPosColor.game_color_red : LongaLottoPosColor.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: LongaLottoPosColor.warm_grey_six,
                                            blurRadius: 2.0,
                                          ),
                                        ],
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          if (lotteryGameFirstBallSideBetList[firstBallSideBetListIndex].betCode?.isNotEmpty == true) {
                                            if (panelBeanMap[lotteryGameFirstBallSideBetList[firstBallSideBetListIndex].betCode ?? ""]?.pickCode == pickType[index].code) {
                                              panelBeanMap.remove(lotteryGameFirstBallSideBetList[firstBallSideBetListIndex].betCode ?? "");
                                            } else {
                                              panelBeanMap[lotteryGameFirstBallSideBetList[firstBallSideBetListIndex].betCode ?? ""] = getPanelBean(lotteryGameFirstBallSideBetList[firstBallSideBetListIndex], pickType[index], null);
                                            }
                                          }
                                          calculateTotalAmount();
                                          setNumberOfBets();
                                        },
                                        customBorder: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Ink(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Center(child: Text(pickType[index].name ?? "NA", style: TextStyle(color: panelBeanMap[lotteryGameFirstBallSideBetList[firstBallSideBetListIndex].betCode ?? ""]?.pickCode == pickType[index].code ? LongaLottoPosColor.white : LongaLottoPosColor.black, fontSize: 14))),
                                              Text("Pays ${lotteryGameFirstBallColorPrizeSchema.isNotEmpty ? lotteryGameFirstBallColorPrizeSchema[0].prizeAmount : "NA"} ${getDefaultCurrency(getLanguage())}", style: TextStyle(color: panelBeanMap[lotteryGameFirstBallSideBetList[firstBallSideBetListIndex].betCode ?? ""]?.pickCode == pickType[index].code ? LongaLottoPosColor.neon_yellow : LongaLottoPosColor.game_color_red, fontSize: 12)),
                                            ],
                                          )
                                        ),
                                      ),
                                    ).pOnly(left: 10, bottom: 10);
                                  }
                              ),
                            ).pOnly(bottom: 16)
                                          ],
                                    );
                                }
                              )
                            : Container(),
                    )
                  : Container(),

              widget.betCategory == "LastBall"
                ? Expanded(
                  child: lotteryGameLastBallSideBetList.isNotEmpty == true
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: lotteryGameLastBallSideBetList.length ,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int lastBallSideBetListIndex) {
                                List<PickType> pickType = lotteryGameLastBallSideBetList[lastBallSideBetListIndex].pickTypeData?.pickType ?? [];
                                List<MatchDetail> lotteryGameLastBallColorPrizeSchema = widget.gameObjectsList?.gameSchemas?.matchDetail?.where((element) => element.betType == lotteryGameLastBallSideBetList[lastBallSideBetListIndex].betCode).toList() ?? [];
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Align(alignment: Alignment.centerLeft, child: Text(lotteryGameLastBallSideBetList[lastBallSideBetListIndex].betDispName ?? "NA", style: const TextStyle(color: LongaLottoPosColor.black, fontSize: 14, fontWeight: FontWeight.bold))).p(16),
                                        Text("Pays ${lotteryGameLastBallColorPrizeSchema.isNotEmpty ? lotteryGameLastBallColorPrizeSchema[0].prizeAmount : "NA"} ${getDefaultCurrency(getLanguage())}", style: const TextStyle(color: LongaLottoPosColor.game_color_red, fontSize: 12)),
                                        Expanded(flex: 2, child: Container()),
                                        Align(alignment: Alignment.centerLeft, child: Text("Bet ${lotteryGameLastBallSideBetList[lastBallSideBetListIndex].unitPrice} ${getDefaultCurrency(getLanguage())}", style: const TextStyle(color: LongaLottoPosColor.app_blue, fontSize: 14, fontWeight: FontWeight.bold))).pOnly(right: 8),
                                      ],
                                    ),
                                    if (lotteryGameLastBallSideBetList[lastBallSideBetListIndex].betCode?.toUpperCase().contains("color".toUpperCase()) == true)
                                      SizedBox(
                                        height: 70,
                                        child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: pickType.length ,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context, int index) {
                                              for(PickType i in pickType) {
                                                sideBetPickedBallColorList.add(SelectedSideBetColorBean(pickType: i, isSelected: false));
                                              }
                                              return SizedBox(
                                                width: 70,
                                                child: OutlinedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                                      return getColors(sideBetPickedBallColorList[index].isSelected == true ? sideBetPickedBallColorList[index].pickType?.code ?? "WHITE" : "WHITE");
                                                    }),
                                                    side: sideBetPickedBallColorList[index].isSelected == true ? null : MaterialStateProperty.all(BorderSide(color: getColors(pickType[index].code ?? ""), width: 2.0, style: BorderStyle.solid)),
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0))

                                                    ),
                                                  ),
                                                  child: Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          SvgPicture.asset("assets/icons/checked.svg", width: 10, height: 10, color: LongaLottoPosColor.white).pOnly(bottom: 4),
                                                          Text(sideBetPickedBallColorList[index].pickType?.code ?? "", style: const TextStyle(color: LongaLottoPosColor.white, fontSize: 8, fontStyle: FontStyle.normal)),
                                                        ],
                                                      )
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (sideBetPickedBallColorList[index].isSelected == true) {
                                                        sideBetPickedBallColorList[index].isSelected = false;
                                                        panelBeanMap.remove(lotteryGameLastBallSideBetList[lastBallSideBetListIndex].betCode ?? "");

                                                      } else {
                                                        for(int i=0; i<sideBetPickedBallColorList.length; i++) {
                                                          sideBetPickedBallColorList[i].isSelected = false;
                                                        }
                                                        sideBetPickedBallColorList[index].isSelected = true;
                                                        panelBeanMap[lotteryGameLastBallSideBetList[lastBallSideBetListIndex].betCode ?? ""] = getPanelBean(lotteryGameLastBallSideBetList[lastBallSideBetListIndex], sideBetPickedBallColorList[index].pickType, sideBetPickedBallColorList[index].pickType?.code ?? "");
                                                      }
                                                    });
                                                    calculateTotalAmount();
                                                    setNumberOfBets();
                                                  },
                                                ),
                                              ).pOnly(right: 8);
                                            }
                                        ),
                                      ).pOnly(bottom: 16, left: 16)
                                    else SizedBox(
                                      height: 60,
                                      child: GridView.builder(
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: .5,
                                            crossAxisCount: 1,
                                          ),
                                          padding: EdgeInsets.zero,
                                          itemCount: pickType.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Ink(
                                              decoration: BoxDecoration(
                                                color: panelBeanMap[lotteryGameLastBallSideBetList[lastBallSideBetListIndex].betCode ?? ""]?.pickCode == pickType[index].code ? LongaLottoPosColor.game_color_red : LongaLottoPosColor.white,
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: LongaLottoPosColor.warm_grey_six,
                                                    blurRadius: 2.0,
                                                  ),
                                                ],
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  if (lotteryGameLastBallSideBetList[lastBallSideBetListIndex].betCode?.isNotEmpty == true) {
                                                    if (panelBeanMap[lotteryGameLastBallSideBetList[lastBallSideBetListIndex].betCode ?? ""]?.pickCode == pickType[index].code) {
                                                      panelBeanMap.remove(lotteryGameLastBallSideBetList[lastBallSideBetListIndex].betCode ?? "");
                                                    } else {
                                                      panelBeanMap[lotteryGameLastBallSideBetList[lastBallSideBetListIndex].betCode ?? ""] = getPanelBean(lotteryGameLastBallSideBetList[lastBallSideBetListIndex], pickType[index], null);
                                                    }
                                                  }
                                                  calculateTotalAmount();
                                                  setNumberOfBets();
                                                },
                                                customBorder: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Ink(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Center(child: Text(pickType[index].name ?? "NA", style: TextStyle(color: panelBeanMap[lotteryGameLastBallSideBetList[lastBallSideBetListIndex].betCode ?? ""]?.pickCode == pickType[index].code ? LongaLottoPosColor.white : LongaLottoPosColor.black, fontSize: 14))),
                                                        Text("Pays ${lotteryGameLastBallColorPrizeSchema.isNotEmpty ? lotteryGameLastBallColorPrizeSchema[0].prizeAmount : "NA"} ${getDefaultCurrency(getLanguage())}", style: TextStyle(color: panelBeanMap[lotteryGameLastBallSideBetList[lastBallSideBetListIndex].betCode ?? ""]?.pickCode == pickType[index].code ? LongaLottoPosColor.neon_yellow : LongaLottoPosColor.game_color_red, fontSize: 12)),
                                                      ],
                                                    )
                                                ),
                                              ),
                                            ).pOnly(left: 10, bottom: 10);
                                          }
                                      ),
                                    ).pOnly(bottom: 16)
                                  ],
                                );
                              }
                            )
                          : Container(),
                  )
                : Container(),

              widget.betCategory == "All"
                ? Expanded(
                    child: lotteryGameAllBallSideBetList.isNotEmpty == true
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: lotteryGameAllBallSideBetList.length ,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int allBallSideBetListIndex) {
                                  List<PickType> pickType = lotteryGameAllBallSideBetList[allBallSideBetListIndex].pickTypeData?.pickType ?? [];
                                  List<MatchDetail> lotteryGameAllBallColorPrizeSchema = widget.gameObjectsList?.gameSchemas?.matchDetail?.where((element) => element.betType == lotteryGameAllBallSideBetList[allBallSideBetListIndex].betCode).toList() ?? [];
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Align(alignment: Alignment.centerLeft, child: Text(lotteryGameAllBallSideBetList[allBallSideBetListIndex].betDispName ?? "NA", style: const TextStyle(color: LongaLottoPosColor.black, fontSize: 14, fontWeight: FontWeight.bold))).p(16),
                                          Text("Pays ${lotteryGameAllBallColorPrizeSchema.isNotEmpty ? lotteryGameAllBallColorPrizeSchema[0].prizeAmount : "NA"} ${getDefaultCurrency(getLanguage())}", style: const TextStyle(color: LongaLottoPosColor.game_color_red, fontSize: 12)),
                                          Expanded(flex: 2, child: Container()),
                                          Align(alignment: Alignment.centerLeft, child: Text("Bet ${lotteryGameAllBallSideBetList[allBallSideBetListIndex].unitPrice} ${getDefaultCurrency(getLanguage())}", style: const TextStyle(color: LongaLottoPosColor.app_blue, fontSize: 14, fontWeight: FontWeight.bold))).pOnly(right: 8),
                                        ],
                                      ),
                                      if (lotteryGameAllBallSideBetList[allBallSideBetListIndex].betCode?.toUpperCase().contains("color".toUpperCase()) == true)
                                        SizedBox(
                                          height: 70,
                                          child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              itemCount: pickType.length ,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (BuildContext context, int index) {
                                                for(PickType i in pickType) {
                                                  sideBetPickedBallColorList.add(SelectedSideBetColorBean(pickType: i, isSelected: false));
                                                }
                                                return SizedBox(
                                                  width: 70,
                                                  child: OutlinedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                                        return getColors(sideBetPickedBallColorList[index].isSelected == true ? sideBetPickedBallColorList[index].pickType?.code ?? "WHITE" : "WHITE");
                                                      }),
                                                      side: sideBetPickedBallColorList[index].isSelected == true ? null : MaterialStateProperty.all(BorderSide(color: getColors(pickType[index].code ?? ""), width: 2.0, style: BorderStyle.solid)),
                                                      shape: MaterialStateProperty.all(
                                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0))

                                                      ),
                                                    ),
                                                    child: Center(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            SvgPicture.asset("assets/icons/checked.svg", width: 10, height: 10, color: LongaLottoPosColor.white).pOnly(bottom: 4),
                                                            Text(sideBetPickedBallColorList[index].pickType?.code ?? "", style: const TextStyle(color: LongaLottoPosColor.white, fontSize: 8, fontStyle: FontStyle.normal)),
                                                          ],
                                                        )
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        if (sideBetPickedBallColorList[index].isSelected == true) {
                                                          sideBetPickedBallColorList[index].isSelected = false;
                                                          panelBeanMap.remove(lotteryGameAllBallSideBetList[allBallSideBetListIndex].betCode ?? "");

                                                        } else {
                                                          for(int i=0; i<sideBetPickedBallColorList.length; i++) {
                                                            sideBetPickedBallColorList[i].isSelected = false;
                                                          }
                                                          sideBetPickedBallColorList[index].isSelected = true;
                                                          panelBeanMap[lotteryGameAllBallSideBetList[allBallSideBetListIndex].betCode ?? ""] = getPanelBean(lotteryGameAllBallSideBetList[allBallSideBetListIndex], sideBetPickedBallColorList[index].pickType, sideBetPickedBallColorList[index].pickType?.code ?? "");
                                                        }
                                                      });
                                                      calculateTotalAmount();
                                                      setNumberOfBets();
                                                    },
                                                  ),
                                                ).pOnly(right: 8);
                                              }
                                          ),
                                        ).pOnly(bottom: 16, left: 16)
                                      else SizedBox(
                                        height: 60,
                                        child: GridView.builder(
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: .5,
                                              crossAxisCount: 1,
                                            ),
                                            padding: EdgeInsets.zero,
                                            itemCount: pickType.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Ink(
                                                decoration: BoxDecoration(
                                                  color: panelBeanMap[lotteryGameAllBallSideBetList[allBallSideBetListIndex].betCode ?? ""]?.pickCode == pickType[index].code ? LongaLottoPosColor.game_color_red : LongaLottoPosColor.white,
                                                  borderRadius: const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: LongaLottoPosColor.warm_grey_six,
                                                      blurRadius: 2.0,
                                                    ),
                                                  ],
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    if (lotteryGameAllBallSideBetList[allBallSideBetListIndex].betCode?.isNotEmpty == true) {
                                                      if (panelBeanMap[lotteryGameAllBallSideBetList[allBallSideBetListIndex].betCode ?? ""]?.pickCode == pickType[index].code) {
                                                        panelBeanMap.remove(lotteryGameAllBallSideBetList[allBallSideBetListIndex].betCode ?? "");
                                                      } else {
                                                        panelBeanMap[lotteryGameAllBallSideBetList[allBallSideBetListIndex].betCode ?? ""] = getPanelBean(lotteryGameAllBallSideBetList[allBallSideBetListIndex], pickType[index], null);
                                                      }
                                                    }
                                                    calculateTotalAmount();
                                                    setNumberOfBets();
                                                  },
                                                  customBorder: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Ink(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Center(child: Text(pickType[index].name ?? "NA", style: TextStyle(color: panelBeanMap[lotteryGameAllBallSideBetList[allBallSideBetListIndex].betCode ?? ""]?.pickCode == pickType[index].code ? LongaLottoPosColor.white : LongaLottoPosColor.black, fontSize: 14))),
                                                          Text("Pays ${lotteryGameAllBallColorPrizeSchema.isNotEmpty ? lotteryGameAllBallColorPrizeSchema[0].prizeAmount : "NA"} ${getDefaultCurrency(getLanguage())}", style: TextStyle(color: panelBeanMap[lotteryGameAllBallSideBetList[allBallSideBetListIndex].betCode ?? ""]?.pickCode == pickType[index].code ? LongaLottoPosColor.neon_yellow : LongaLottoPosColor.game_color_red, fontSize: 12)),
                                                        ],
                                                      )
                                                  ),
                                                ),
                                              ).pOnly(left: 10, bottom: 10);
                                            }
                                        ),
                                      ).pOnly(bottom: 16)
                                    ],
                                  );
                                }
                              )
                            : Container(),
                  )
                : Container()
            ],
          ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FlipCard(
                controller: _controller,
                flipOnTouch: false,
                fill: Fill.fillBack, // Fill the back side of the card to make in the same size as the front.
                direction: FlipDirection.VERTICAL, // default
                side: CardSide.FRONT, // The side to initially display.
                front: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: LongaLottoPosColor.light_dark_white,
                  child: const Center(child: Text("", textAlign: TextAlign.center, style: TextStyle(color: LongaLottoPosColor.game_color_grey, fontSize: 14))),
                ),
                back: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: LongaLottoPosColor.ball_border_light_bg,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              resetGame();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/reset.svg', width: 16, height: 16, color: LongaLottoPosColor.game_color_red).pOnly(bottom: 2),
                                const Align(alignment: Alignment.center, child: Text("Reset", style: TextStyle(color: LongaLottoPosColor.game_color_grey, fontSize: 12))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(alignment: Alignment.center, child: Text("$betCount", style: const TextStyle(color: LongaLottoPosColor.game_color_red, fontWeight: FontWeight.bold, fontSize: 16))),
                            const Align(alignment: Alignment.center, child: Text("No. of Bets", style: TextStyle(color: LongaLottoPosColor.game_color_grey, fontSize: 12))),
                          ],
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(alignment: Alignment.center, child: Text("$betAmount", style: const TextStyle(color: LongaLottoPosColor.game_color_red, fontWeight: FontWeight.bold, fontSize: 16))),
                            Align(alignment: Alignment.center, child: Text("Bet Value (${getDefaultCurrency(getLanguage())})", style: const TextStyle(color: LongaLottoPosColor.game_color_grey, fontSize: 12))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              for(var i=0 ; i< panelBeanMap.length; i++) {
                                PanelBean? mPanelBean = panelBeanMap[panelBeanMap.keys.toList()[i]];
                                if(mPanelBean != null) {
                                  widget.listPanelData?.add(mPanelBean);
                                }
                              }
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider<LoginBloc>(
                                            create: (BuildContext context) => LoginBloc(),
                                          )
                                        ],
                                        child: PickTypeScreen(gameObjectsList: widget.gameObjectsList, listPanelData: widget.listPanelData)
                                      )
                                  )
                              );
                            },
                            child: Ink(
                              color: LongaLottoPosColor.game_color_red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/icons/plus.svg', width: 16, height: 16, color: LongaLottoPosColor.white),
                                  const Align(alignment: Alignment.center, child: Text("ADD BET", style: TextStyle(color: LongaLottoPosColor.white, fontWeight: FontWeight.bold, fontSize: 14))).pOnly(left: 4),
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
            )
          ],
        ),
      ),
    );
  }

  Color getColors(String colorName) {
    if (colorName.toUpperCase().contains("PINK")) {
      return LongaLottoPosColor.game_color_pink;

    } else if (colorName.toUpperCase().contains("RED")) {
      return LongaLottoPosColor.game_color_red;

    } else if (colorName.toUpperCase().contains("ORANGE")) {
      return LongaLottoPosColor.game_color_orange;

    } else if (colorName.toUpperCase().contains("BROWN")) {
      return LongaLottoPosColor.game_color_brown;

    } else if (colorName.toUpperCase().contains("GREEN")) {
      return LongaLottoPosColor.game_color_green;

    } else if (colorName.toUpperCase().contains("CYAN")) {
      return LongaLottoPosColor.game_color_cyan;

    } else if (colorName.toUpperCase().contains("BLUE")) {
      return LongaLottoPosColor.game_color_blue;

    } else if (colorName.toUpperCase().contains("MAGENTA")) {
      return LongaLottoPosColor.game_color_magenta;

    } else if (colorName.toUpperCase().contains("GREY")) {
      return LongaLottoPosColor.game_color_grey;

    } else if (colorName.toUpperCase().contains("BLACK")) {
      return LongaLottoPosColor.black;

    } else if (colorName.toUpperCase().contains("WHITE")) {
      return LongaLottoPosColor.white;

    } else {
      return LongaLottoPosColor.game_color_black;
    }
  }

  PanelBean getPanelBean(BetRespVOs selectedBetTypeData, PickType? selectedPickTypeObject, String? colorCode) {
    PanelBean model           = PanelBean();
    model.pickedValue         = selectedPickTypeObject?.range?[0].pickValue;
    model.amount              = selectedBetTypeData.unitPrice;
    model.winMode             = selectedBetTypeData.winMode;
    model.betName             = selectedBetTypeData.betDispName;
    model.pickName            = selectedPickTypeObject?.name;
    model.betCode             = selectedBetTypeData.betCode;
    model.pickCode            = selectedPickTypeObject?.code;
    model.pickConfig          = selectedPickTypeObject?.range?[0].pickConfig;
    model.betAmountMultiple   = 1;
    model.selectBetAmount     = selectedBetTypeData.unitPrice?.toInt();
    model.numberOfDraws       = 1;
    model.numberOfLines       = 1;
    model.unitPrice           = selectedBetTypeData.unitPrice ?? 1;
    model.isQuickPick         = false;
    model.isQpPreGenerated    = false;
    model.isMainBet           = false;
    model.colorCode           = colorCode;

    return model;
  }

  void setNumberOfBets() {
    setState(() {
      betCount = panelBeanMap.length;
    });
    if (_controller.state?.isFront == true) {
      _controller.toggleCard();
    }
  }

  void calculateTotalAmount() {
    var amount = 0;
    for(int i=0 ; i< panelBeanMap.length; i++) {
      var amt = (panelBeanMap.values.toList()[i].amount)?.toInt() ?? 0;
      amount = (amount + amt).toInt();
    }
    setState(() {
      betAmount = amount;
    });
    if (_controller.state?.isFront == true) {
      _controller.toggleCard();
    }
  }

  void resetGame() {
    setState(() {
      panelBeanMap.clear();
      sideBetPickedBallColorList.clear();
      betCount = 0;
      betAmount = 0;
    });
    calculateTotalAmount();
    if(_controller.state?.isFront != true) {
      _controller.toggleCard();
    }
  }
}
