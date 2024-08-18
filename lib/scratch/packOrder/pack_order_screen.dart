import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';
import 'package:longalottoretail/scratch/packOrder/bloc/pack_bloc.dart';
import 'package:longalottoretail/scratch/packOrder/bloc/pack_event.dart';
import 'package:longalottoretail/scratch/packOrder/bloc/pack_state.dart';
import 'package:longalottoretail/scratch/packOrder/model/PackOrderRequest.dart';
import 'package:longalottoretail/scratch/packOrder/model/game_details_response.dart';
import 'package:longalottoretail/scratch/packOrder/model/pack_order_response.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:longalottoretail/utility/widgets/alert_dialog.dart';
import 'package:longalottoretail/utility/widgets/alert_type.dart';
import 'package:longalottoretail/utility/widgets/primary_button.dart';

class PackOrderScreen extends StatefulWidget {
  final MenuBeanList? scratchList;

  const PackOrderScreen({Key? key, required this.scratchList}) : super(key: key);

  @override
  State<PackOrderScreen> createState() => _PackOrderScreenState();
}

class _PackOrderScreenState extends State<PackOrderScreen> {
  var isLoading = false;
  int? gameId;
  double bottomViewHeight = 110;
  List<Games>? gamesList = [];
  List<int> _counter = [];
  double? totalAmount = 0;
  List<GameOrderList>? gameOrderList = [];


  @override
  void initState() {
    BlocProvider.of<PackBloc>(context).add(GameDetailsApi(
      context: context,
      scratchList: widget.scratchList,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LongaScaffold(
        appBackGroundColor: LongaLottoPosColor.app_bg,
        backgroundColor: LongaLottoPosColor.white,
        resizeToAvoidBottomInset: false,
        showAppBar: true,
        appBarTitle: widget.scratchList?.caption ?? "Pack Order",
        body: BlocListener<PackBloc, PackState>(
          listener: (context, state) {
            if (state is PackLoading) {
              setState(() {
                isLoading = true;
              });
            }
            if(state is GameDetailsSuccess)
            {
              gameOrderList!.clear();
              setState(() {
                isLoading = false;
              });
              GameDetailsResponse gameDetailsResponse = state.response;
              gamesList = gameDetailsResponse.games;
              for(var gameData in gamesList!)
              {
                _counter.add(0);
                gameOrderList!.add(GameOrderList(
                    booksQuantity: 0,
                    gameId: gameData.gameId
                ));
              }
            }
            if (state is PackSuccess) {
              PackOrderResponse packOrderResponse = state.response;
              setState(() {
                isLoading = false;
              });
              Alert.show(
                isDarkThemeOn: false,
                type: AlertType.success,
                buttonClick: () {
                  Navigator.of(context).pop();
                },
                title: context.l10n.success,
                // subtitle: packOrderResponse.responseMessage!,
                subtitle: "${context.l10n.order_is_successfully_placed_order_number} ${packOrderResponse.orderId}",
                buttonText: context.l10n.ok.toUpperCase(),
                context: context,
              );
            }
            if (state is PackError) {
              setState(() {
                isLoading = false;
              });
              Alert.show(
                type: AlertType.error,
                isDarkThemeOn: false,
                buttonClick: () {
                  Navigator.of(context).pop();
                },
                title: context.l10n.error,
                subtitle: state.errorMessage,
                buttonText: context.l10n.ok.toUpperCase(),
                context: context,
              );
            }
          },
          child: !isLoading ?
          Column(
            children: [
              Text(
                  context.l10n.select_game_pack_quantity_from_below_list,
                  style: const TextStyle(
                      color:  LongaLottoPosColor.brownish_grey_three,
                      fontWeight: FontWeight.w400,
                      fontFamily: "",
                      fontStyle:  FontStyle.normal,
                      fontSize: 14.0
                  ),
                  textAlign: TextAlign.center
              ).p(16),
              Container(
                height: 2,
                width: context.screenWidth,
                color: LongaLottoPosColor.white,
              ),
              Expanded(
                child: Stack(children: [
                  ListView.separated(
                    itemCount: gamesList!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: LongaLottoPosColor.game_color_pink.withOpacity(0.1),
                          //LongaLottoPosColor.warm_grey_new.withOpacity(0.1),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: SvgPicture.asset("assets/scratch/pack_order.svg"),
                            ).p(8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${gamesList![index].gameType! == "SCRATCH" ? "SCRATCH": gamesList![index].gameType!}#${gamesList![index].gameNumber.toString()}",
                                      style: const TextStyle(
                                          color: LongaLottoPosColor.brownish_grey_three,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Arial",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      textAlign: TextAlign.left),
                                  const SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                             TextSpan(
                                                text: "${context.l10n.price_symbol} ",
                                                style: const TextStyle(
                                                    color: LongaLottoPosColor.greyish,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Arial",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                            ),
                                            TextSpan(
                                                text: (gamesList![index].ticketsPerBook * gamesList![index].ticketPrice).toString(),
                                                style: const TextStyle(
                                                    color:  LongaLottoPosColor.medium_green,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "",
                                                    fontStyle:  FontStyle.normal,
                                                    fontSize: 14.0

                                                ),),
                                          ]
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            children: [
                                               TextSpan(
                                                text: "${context.l10n.commission_symbol} ",
                                                style: const TextStyle(
                                                    color: LongaLottoPosColor.greyish,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Arial",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                              ),
                                              TextSpan(
                                                text: "${gamesList![index].commissionPercentage.toString()}%",
                                                style: const TextStyle(
                                                    color:  LongaLottoPosColor.medium_green,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "",
                                                    fontStyle:  FontStyle.normal,
                                                    fontSize: 14.0

                                                ),),
                                            ]
                                        ),
                                      ),
                                    // Text("Price: ${(gamesList![index].ticketsPerBook * gamesList![index].ticketPrice).toString()}",
                                    //     style: const TextStyle(
                                    //         color: LongaLottoPosColor.greyish,
                                    //         fontWeight: FontWeight.w400,
                                    //         fontFamily: "Arial",
                                    //         fontStyle: FontStyle.normal,
                                    //         fontSize: 14.0),
                                    //     textAlign: TextAlign.left),
                                    // Text("Commission: ${gamesList![index].commissionPercentage.toString()}%",
                                    //     style: const TextStyle(
                                    //         color: LongaLottoPosColor.greyish,
                                    //         fontWeight: FontWeight.w400,
                                    //         fontFamily: "Arial",
                                    //         fontStyle: FontStyle.normal,
                                    //         fontSize: 14.0),
                                    //     textAlign: TextAlign.left),
                                  ],)
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                _decrementCounter(index);
                              },
                              child: SizedBox(
                                height: 3,
                                width: 15,
                                child: Image.asset("assets/scratch/minus.png", color: _counter[index] <= 0 ? LongaLottoPosColor.light_blue_grey : LongaLottoPosColor.light_navy),
                              ).pSymmetric(h: 16, v: 8),
                            ),
                             Text(_counter[index].toString(),
                                style: TextStyle(
                                    color: _counter[index] > 0 ? LongaLottoPosColor.cherry: LongaLottoPosColor.light_blue_grey,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Arial",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18.0),
                                textAlign: TextAlign.center),
                            InkWell(
                              onTap: (){
                                _incrementCounter(index);
                              },
                              child: SizedBox(
                                height: 12,
                                width: 20,
                                child: Image.asset("assets/scratch/add.png",color : LongaLottoPosColor.light_navy),
                              ).pSymmetric(h: 16, v: 8),
                            ),
                          ],
                        ).p(8),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 2,
                        width: context.screenWidth,
                        color: LongaLottoPosColor.white,
                      );
                    },
                  ).pOnly(bottom:bottomViewHeight ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: bottomViewHeight,
                      width: context.screenWidth,
                      color: LongaLottoPosColor.white,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              RichText(
                                text: TextSpan(
                                    children: [
                                       TextSpan(
                                        text: "${context.l10n.total_pack} ",
                                        style: const TextStyle(
                                            color: LongaLottoPosColor.brownish_grey_three,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Arial",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                      ),
                                      TextSpan(
                                        text: getTotalPack(),
                                        style: const TextStyle(
                                            color:  LongaLottoPosColor.medium_green,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "",
                                            fontStyle:  FontStyle.normal,
                                            fontSize: 14.0

                                        ),),
                                    ]
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                    children: [
                                       TextSpan(
                                        text: context.l10n.total_amount_symbol ?? "Total Amount :",
                                        style: const TextStyle(
                                            color: LongaLottoPosColor.brownish_grey_three,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Arial",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                      ),
                                      TextSpan(
                                        text: totalAmount.toString(),
                                        style: const TextStyle(
                                            color:  LongaLottoPosColor.medium_green,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "",
                                            fontStyle:  FontStyle.normal,
                                            fontSize: 14.0

                                        ),),
                                    ]
                                ),
                              ),
                            ],),
                            const SizedBox(height: 5,),
                            // Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       const Text("Total Amount :",
                            //           style: TextStyle(
                            //               color: LongaLottoPosColor.greyish,
                            //               fontWeight: FontWeight.w400,
                            //               fontFamily: "Arial",
                            //               fontStyle: FontStyle.normal,
                            //               fontSize: 14),
                            //           textAlign: TextAlign.center),
                            //       Text(totalAmount.toString(),
                            //           style: const TextStyle(
                            //               color: LongaLottoPosColor.greyish,
                            //               fontWeight: FontWeight.w700,
                            //               fontFamily: "Arial",
                            //               fontStyle: FontStyle.normal,
                            //               fontSize: 16),
                            //           textAlign: TextAlign.center),
                            //     ]).pOnly(bottom: 10),
                            PrimaryButton(
                              height: 50,
                              btnBgColor1: totalAmount! > 0 ? LongaLottoPosColor.medium_green : LongaLottoPosColor.medium_green.withOpacity(0.2),
                              btnBgColor2: totalAmount! > 0 ? LongaLottoPosColor.medium_green : LongaLottoPosColor.medium_green.withOpacity(0.2),
                              borderRadius: 10,
                              text: context.l10n.confirm.toUpperCase(),
                              width: context.screenWidth / 0.8,
                              textColor: LongaLottoPosColor.white,
                              onPressed: () {
                                gameOrderList!.removeWhere((element) => element.booksQuantity == 0);
                                var requestData = PackOrderRequest(
                                    gameOrderList: gameOrderList,
                                    userName: UserInfo.userName,
                                    userSessionId: UserInfo.userToken
                                );
                                if(totalAmount! > 0) {
                                  BlocProvider.of<PackBloc>(context).add(PackApi(
                                    context: context,
                                    scratchList: widget.scratchList,
                                    requestData: requestData
                                ));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            ],
          )
          : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  _incrementCounter(int index) {
    setState(() {
      _counter[index]++;
      totalAmount = totalAmount! + ((gamesList![index].ticketsPerBook * gamesList![index].ticketPrice));
    });
      gameOrderList![index] = GameOrderList(
          booksQuantity: _counter[index],
          gameId: gamesList![index].gameId
      );
  }

  _decrementCounter(int index) {
    if (_counter[index] <= 0) {
      setState(() {
        _counter[index] = 0;
        totalAmount = totalAmount! - 0 ;
      });
      gameOrderList![index] = GameOrderList(
          booksQuantity: _counter[index],
          gameId: gamesList![index].gameId
      );
    } else {
      setState(() {
        _counter[index]--;
        totalAmount = totalAmount! - (gamesList![index].ticketsPerBook * gamesList![index].ticketPrice);
      });
      gameOrderList![index] = GameOrderList(
          booksQuantity: _counter[index],
          gameId: gamesList![index].gameId
      );
    }
  }

 String getTotalPack() {
    var totalPack = 0;
    for (var element in _counter) {
totalPack = totalPack + element;
    }
    return totalPack.toString();
  }

}
