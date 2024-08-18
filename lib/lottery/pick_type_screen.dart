import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:longalottoretail/drawer/longa_lotto_pos_drawer.dart';
import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:longalottoretail/lottery/bloc/lottery_bloc.dart';
import 'package:longalottoretail/lottery/models/response/fetch_game_data_response.dart';
import 'package:longalottoretail/lottery/preview_game_screen.dart';
import 'package:longalottoretail/lottery/side_game_screen.dart';
import 'package:longalottoretail/lottery/widgets/added_bet_cart_msg.dart';
import 'package:longalottoretail/utility/utils.dart';
import '../login/bloc/login_bloc.dart';
import 'lottery_game_screen.dart';
import 'models/otherDataClasses/panelBean.dart';

/*
    created by Rajneesh Kr.Sharma on 7 May, 23
*/

class PickTypeScreen extends StatefulWidget {
  final GameRespVOs? gameObjectsList;
  List<PanelBean>? listPanelData;

  PickTypeScreen({Key? key, this.gameObjectsList, this.listPanelData}) : super(key: key);

  @override
  State<PickTypeScreen> createState() => _PickTypeScreenState();
}

class _PickTypeScreenState extends State<PickTypeScreen> {
  List<BetRespVOs>? lotteryGameMainBetList    = [];
  List<BetRespVOs>? lotteryGameSideBetList    = [];
  final bool _mIsShimmerLoading               = false;
  String totalAmount                          = "0";
  var maxPanelAllowed                         = 0;

  @override
  void initState() {
    super.initState();
    lotteryGameMainBetList = widget.gameObjectsList?.betRespVOs?.where((element) => element.winMode == "MAIN").toList()   ?? [];
    if (widget.gameObjectsList?.gameCode?.toUpperCase() == "powerball".toUpperCase()) {
      List<BetRespVOs>? betRespV0sList = widget.gameObjectsList?.betRespVOs?.where((element) => element.betCode?.toUpperCase().contains("plus".toUpperCase()) != true).toList();
      if (betRespV0sList?.isNotEmpty == true) {
        lotteryGameMainBetList = betRespV0sList;
      }
    }
    lotteryGameMainBetList = lotteryGameMainBetList?.isNotEmpty == true ? lotteryGameMainBetList : [];
    lotteryGameSideBetList = widget.gameObjectsList?.betRespVOs?.where((element) => element.winMode == "COLOR").toList()  ?? [];
    calculateTotalAmount();
    lotteryGameSideBetList = widget.gameObjectsList?.betRespVOs?.where((element) => element.winMode != "MAIN").toList()  ?? [];
    maxPanelAllowed = widget.gameObjectsList?.maxPanelAllowed ?? 0;

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.listPanelData == null || widget.listPanelData?.isEmpty == true;
      },
      child: LongaScaffold(
        showAppBar: true,
        appBackGroundColor: LongaLottoPosColor.app_bg,
        onBackButton: (widget.listPanelData == null || widget.listPanelData?.isEmpty == true) ? null : () {
          AddedBetCartMsg().show(context: context, title: "Bet on cart !", subTitle: "You have some item in your cart. If you leave the game your cart will be cleared.", buttonText: "CLEAR", isCloseButton: true, buttonClick: () {
            Navigator.of(context).pop();
          });
        },
        drawer: LongaLottoPosDrawer(drawerModuleList: const []),
        backgroundColor: _mIsShimmerLoading ? LongaLottoPosColor.light_dark_white : LongaLottoPosColor.white,
        appBarTitle: widget.gameObjectsList?.gameName,
        body: SafeArea(
          child: Column(
              children: [
                const Align(alignment: Alignment.centerLeft, child: Text("Main Bet", style: TextStyle(color: LongaLottoPosColor.black, fontSize: 14, fontWeight: FontWeight.bold))).p(10),
                GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.8,
                      crossAxisCount: 3,
                    ),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: _mIsShimmerLoading ? 10 : lotteryGameMainBetList?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return _mIsShimmerLoading
                          ? Shimmer.fromColors(
                        baseColor: Colors.grey[400]!,
                        highlightColor: Colors.grey[300]!,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: LongaLottoPosColor.warm_grey,
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width : 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.grey[400]!,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    )
                                ),
                              ).pOnly(bottom: 10),
                              Container(
                                width : 80,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: Colors.grey[400]!,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    )
                                ),
                              ),
                            ],
                          ),
                        ).pOnly(left: 18, bottom: 12),
                      )
                          : Ink(
                        decoration: const BoxDecoration(
                          color: LongaLottoPosColor.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: LongaLottoPosColor.warm_grey_six,
                              blurRadius: 2.0,
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            List<BetRespVOs>? betRespV0s = widget.gameObjectsList?.betRespVOs?.where((element) => element.betCode == lotteryGameMainBetList?[index].betCode).toList();
                            print("-----------------> $betRespV0s");
                            print("------------betRespV0s 0-----> ${betRespV0s?[0]}");
                            if (betRespV0s != null) {
                              var listPanelDataLength = widget.listPanelData?.length ?? 0;
                              if (listPanelDataLength < maxPanelAllowed) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) =>  MultiBlocProvider(
                                          providers: [
                                            BlocProvider<LotteryBloc>(
                                              create: (BuildContext context) => LotteryBloc(),
                                            )
                                          ],
                                          child: GameScreen(particularGameObjects: widget.gameObjectsList, pickType: betRespV0s[0].pickTypeData?.pickType ?? [], betRespV0s: betRespV0s[0], mPanelBinList: widget.listPanelData ?? [])),
                                    )
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text("Max panel limit reached !"),
                                ));
                              }

                            }
                          },
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Ink(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(lotteryGameMainBetList?[index].betDispName ?? "NA", style: const TextStyle(color: LongaLottoPosColor.black, fontSize: 14))
                              ],
                            ),
                          ),
                        ),
                      ).pOnly(left: 10, bottom: 10);
                    }
                ).pOnly(right: 10),
                const HeightBox(40),
                lotteryGameSideBetList?.isNotEmpty == true
                    ? const Align(alignment: Alignment.centerLeft, child: Text("Side Bet", style: TextStyle(color: LongaLottoPosColor.black, fontSize: 14, fontWeight: FontWeight.bold))).pOnly(left: 10, bottom: 10)
                    : Container(),
                lotteryGameSideBetList?.isNotEmpty == true
                    ? Row(
                  children: [
                    Ink(
                      decoration: const BoxDecoration(
                        color: LongaLottoPosColor.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: LongaLottoPosColor.warm_grey_six,
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          var listPanelDataLength = widget.listPanelData?.length ?? 0;
                          if (listPanelDataLength < maxPanelAllowed) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) =>  MultiBlocProvider(
                                      providers: [
                                        BlocProvider<LotteryBloc>(
                                          create: (BuildContext context) => LotteryBloc(),
                                        )
                                      ],
                                      child: SideGameScreen(gameObjectsList: widget.gameObjectsList, listPanelData: widget.listPanelData, betCategory: "FirstBall"),
                                    )
                                )
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text("Max panel limit reached !"),
                            ));
                          }
                        },
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Ink(
                          child: const Text("First Ball", style: TextStyle(color: LongaLottoPosColor.black, fontSize: 14)).p(18),
                        ),
                      ),
                    ).pOnly(left: 12, bottom: 12),
                    Ink(
                      decoration: const BoxDecoration(
                        color: LongaLottoPosColor.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: LongaLottoPosColor.warm_grey_six,
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          var listPanelDataLength = widget.listPanelData?.length ?? 0;
                          if (listPanelDataLength < maxPanelAllowed) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) =>  MultiBlocProvider(
                                      providers: [
                                        BlocProvider<LotteryBloc>(
                                          create: (BuildContext context) => LotteryBloc(),
                                        )
                                      ],
                                      child: SideGameScreen(gameObjectsList: widget.gameObjectsList, listPanelData: widget.listPanelData, betCategory: "LastBall"),
                                    )
                                )
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text("Max panel limit reached !"),
                            ));
                          }
                        },
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text("Last Ball", style: TextStyle(color: LongaLottoPosColor.black, fontSize: 14)).p(18),
                      ),
                    ).pOnly(left: 18, bottom: 12),
                    Ink(
                      decoration: const BoxDecoration(
                        color: LongaLottoPosColor.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: LongaLottoPosColor.warm_grey_six,
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          var listPanelDataLength = widget.listPanelData?.length ?? 0;
                          if (listPanelDataLength < maxPanelAllowed) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) =>  MultiBlocProvider(
                                      providers: [
                                        BlocProvider<LotteryBloc>(
                                          create: (BuildContext context) => LotteryBloc(),
                                        )
                                      ],
                                      child: SideGameScreen(gameObjectsList: widget.gameObjectsList, listPanelData: widget.listPanelData, betCategory: "All"),
                                    )
                                )
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text("Max panel limit reached !"),
                            ));
                          }
                        },
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Ink(
                            child: const Text("First 5 balls", style: TextStyle(color: LongaLottoPosColor.black, fontSize: 14)).p(18)
                        ),
                      ),
                    ).pOnly(left: 18, bottom: 12)
                  ],
                )
                    : Container(),
                Expanded(child: Container()),
                Container(
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
                            Align(alignment: Alignment.center, child: Text(widget.listPanelData != null ? "${widget.listPanelData?.length}" : "0", style: const TextStyle(color: LongaLottoPosColor.game_color_red, fontWeight: FontWeight.bold, fontSize: 16))),
                            const Align(alignment: Alignment.center, child: Text("Total Bets", style: TextStyle(color: LongaLottoPosColor.game_color_grey, fontSize: 12))),
                          ],
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(alignment: Alignment.center, child: Text(totalAmount, style: const TextStyle(color: LongaLottoPosColor.game_color_red, fontWeight: FontWeight.bold, fontSize: 16))),
                            Align(alignment: Alignment.center, child: Text("Total Bet Value (${getDefaultCurrency(getLanguage())})", style: const TextStyle(color: LongaLottoPosColor.game_color_grey, fontSize: 12))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              if (widget.listPanelData?.isEmpty == true) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text("No bet selected, please select any bet !"),
                                ));
                              } else {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (_) =>  MultiBlocProvider(
                                          providers: [
                                            BlocProvider<LotteryBloc>(
                                              create: (BuildContext context) => LotteryBloc(),
                                            ),
                                            BlocProvider<LoginBloc>(
                                              create: (BuildContext context) => LoginBloc(),
                                            )
                                          ],
                                          child: PreviewGameScreen(gameSelectedDetails: widget.listPanelData ?? [], gameObjectsList: widget.gameObjectsList, onComingToPreviousScreen: (String onComingToPreviousScreen) {
                                            switch(onComingToPreviousScreen) {
                                              case "isAllPreviewDataDeleted" : {
                                                setState(() {
                                                  widget.listPanelData?.clear();
                                                  calculateTotalAmount();
                                                });
                                                break;
                                              }

                                              case "isBuyPerformed" : {
                                                setState(() {
                                                  widget.listPanelData?.clear();
                                                  calculateTotalAmount();
                                                });
                                                break;
                                              }
                                            }
                                          }, selectedGamesData: (List<PanelBean> selectedAllGameData) {
                                            log("on back: ${jsonEncode(selectedAllGameData)}");
                                            setState(() {
                                              widget.listPanelData = selectedAllGameData;
                                            });
                                            calculateTotalAmount();
                                          })),
                                      //child: LotteryScreen()),
                                    )
                                );
                              }
                            },
                            child: Ink(
                              color: LongaLottoPosColor.game_color_red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/icons/buy.svg', width: 20, height: 20, color: LongaLottoPosColor.white),
                                  const Align(alignment: Alignment.center, child: Text("PROCEED", style: TextStyle(color: LongaLottoPosColor.white, fontWeight: FontWeight.bold, fontSize: 14))).pOnly(left: 4),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }

  calculateTotalAmount() {
    int amount = 0;
    if (widget.listPanelData != null) {
      for (PanelBean model in widget.listPanelData!) {
        if (model.amount != null) {
          amount = (amount + model.amount!).toInt();
        }
      }

      String strAmount = "${getDefaultCurrency(getLanguage())} $amount";
      totalAmount = strAmount;

    }
  }
}
