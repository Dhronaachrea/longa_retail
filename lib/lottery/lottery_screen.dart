import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:longalottoretail/drawer/longa_lotto_pos_drawer.dart';
import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/login/bloc/login_event.dart';
import 'package:longalottoretail/login/models/response/GetLoginDataResponse.dart';
import 'package:longalottoretail/lottery/lottery_bottom_nav/winning_claim/bloc/winning_claim_bloc.dart';
import 'package:longalottoretail/lottery/lottery_bottom_nav/winning_claim/bloc/winning_claim_state.dart' as win_state;
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/network/network_exception.dart';
import 'package:longalottoretail/utility/auth_bloc/auth_bloc.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_screens.dart';
import 'package:longalottoretail/utility/shared_pref.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:longalottoretail/lottery/bloc/lottery_bloc.dart';
import 'package:longalottoretail/lottery/bloc/lottery_event.dart';
import 'package:longalottoretail/lottery/bloc/lottery_state.dart';
import 'package:longalottoretail/lottery/models/otherDataClasses/panelBean.dart';
import 'package:longalottoretail/lottery/models/response/fetch_game_data_response.dart';
import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';
import 'package:longalottoretail/lottery/pick_type_screen.dart';
import 'package:longalottoretail/lottery/widgets/cancel_ticket_confirmation_dialog.dart';
import 'package:longalottoretail/lottery/widgets/draw_not_available_msg.dart';
import 'package:longalottoretail/lottery/widgets/printing_dialog.dart';
import 'package:longalottoretail/utility/UrlDrawGameBean.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:longalottoretail/utility/utils.dart';
import 'package:longalottoretail/utility/widgets/show_snackbar.dart';
import 'package:longalottoretail/lottery/models/response/RePrintResponse.dart' as re_print_resp;
import '../login/bloc/login_bloc.dart';
import '../login/bloc/login_state.dart';
import '../utility/my_timer_lottery.dart';
import 'lottery_bottom_nav/winning_claim/bloc/winning_claim_event.dart';
import 'lottery_bottom_nav/winning_claim/models/response/TicketVerifyResponse.dart';
import 'lottery_game_screen.dart';
import 'dart:math' as math;
import 'package:longalottoretail/lottery/lottery_bottom_nav/winning_claim/models/response/TicketVerifyResponse.dart' as winning_claim;

class LotteryScreen extends StatefulWidget {
  const LotteryScreen({Key? key}) : super(key: key);

  @override
  State<LotteryScreen> createState() => _LotteryScreenState();
}

class _LotteryScreenState extends State<LotteryScreen> {
  List<GameRespVOs> lotteryGameObjectList   = [];
  List<String> lotteryGameCodeList    = [];
  bool _mIsShimmerLoading = false;
  bool timeUpdating = false;
  String? currentDateTime;
  bool isLastResultOrRePrintingOrCancelling = false;
  List<String> mComingSoonGameCodeList = [];
  List<PanelBean> listPanelData   = [];
  bool isNoInternet   = false;
  BuildContext? lotteryBlocContext;
  winning_claim.ResponseData? verifyResponse;
  Map<String, dynamic> printingDataArgs               = {};
  TicketVerifyResponse? ticketVerifyResponse;
  UrlDrawGameBean?  verifyTicketUrls;


  @override
  void initState() {
    super.initState();
    ModuleBeanLst? drawerModuleBeanList     = ModuleBeanLst.fromJson(jsonDecode(UserInfo.getDrawGameBeanList));
    MenuBeanList? winningClaimMenuBeanList  = drawerModuleBeanList.menuBeanList?.where((element) => element.menuCode == "DGE_WIN_CLAIM").toList()[0];
    verifyTicketUrls  = getDrawGameUrlDetails(winningClaimMenuBeanList!, context, "verifyTicket");
    BlocProvider.of<LotteryBloc>(context).add(FetchGameDataApi(context: context));

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("UserInfo.getDgeLastSaleTicketNo : ${UserInfo.getDgeLastSaleTicketNo.runtimeType}");
    print("Condition : ${(UserInfo.getDgeLastSaleTicketNo.isNotEmpty && (UserInfo.getDgeLastSaleTicketNo != "0" || UserInfo.getDgeLastSaleTicketNo != "-1"))}");
  }

  void viewWillAppear() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: viewWillAppear,
      child: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is GetLoginDataSuccess) {
              if (state.response != null) {
                BlocProvider.of<AuthBloc>(context).add(UpdateUserInfo(loginDataResponse: state.response!));
              }
            }
          },
          child: AbsorbPointer(
            absorbing: isLastResultOrRePrintingOrCancelling,
            child: WillPopScope(
              onWillPop: () async{
                return !isLastResultOrRePrintingOrCancelling;
              },
              child: LongaScaffold(
                  showAppBar: true,
                  appBackGroundColor: LongaLottoPosColor.app_bg,
                  drawer: LongaLottoPosDrawer(drawerModuleList: const []),
                  backgroundColor: _mIsShimmerLoading ? LongaLottoPosColor.light_dark_white : LongaLottoPosColor.white,
                  appBarTitle: context.l10n.lottery_title,
                  bottomNavigationBar: AbsorbPointer(
                    absorbing: isLastResultOrRePrintingOrCancelling,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: LongaLottoPosColor.warm_grey_six, width: 0.5)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _mIsShimmerLoading
                              ? Shimmer.fromColors(
                            baseColor: Colors.grey[400]!,
                            highlightColor: Colors.grey[300]!,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: LongaLottoPosColor.warm_grey,
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width : 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[400]!,
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(3),
                                            )
                                        ),
                                      ).p(6),
                                      Container(
                                        width : 70,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[400]!,
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(10),
                                            )
                                        ),
                                      ).pOnly(left: 6, right: 6, bottom: 6),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: LongaLottoPosColor.warm_grey,
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width : 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[400]!,
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(3),
                                            )
                                        ),
                                      ).p(6),
                                      Container(
                                        width : 70,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[400]!,
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(10),
                                            )
                                        ),
                                      ).pOnly(left: 6, right: 6, bottom: 6),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: LongaLottoPosColor.warm_grey,
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width : 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[400]!,
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(3),
                                            )
                                        ),
                                      ).p(6),
                                      Container(
                                        width : 70,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[400]!,
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(10),
                                            )
                                        ),
                                      ).pOnly(left: 6, right: 6, bottom: 6),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: LongaLottoPosColor.warm_grey,
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width : 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[400]!,
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(3),
                                            )
                                        ),
                                      ).p(6),
                                      Container(
                                        width : 70,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[400]!,
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(10),
                                            )
                                        ),
                                      ).pOnly(left: 6, right: 6, bottom: 6),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                              : Align(
                            alignment: Alignment.topCenter,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: TextButton(
                                    clipBehavior: Clip.hardEdge,
                                    onPressed: () {
                                      Navigator.pushNamed(context, LongaLottoPosScreen.winningClaimScreen);
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset("assets/images/win.png", width: 25, height: 25,),
                                        const SizedBox(height: 2,),
                                        Text(context.l10n.winning_claim, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: LongaLottoPosColor.warm_grey_three))
                                      ],
                                    ),
                                  ),
                                ),
                                Container(width: .5, height: 50, color: LongaLottoPosColor.game_color_grey),
                                Expanded(
                                  child: TextButton(
                                    clipBehavior: Clip.hardEdge,
                                    onPressed: () {
                                      String selectedGameName = "";
                                      String selectedGameCode = "";
                                      String selectedDate     = "";
                                      String selectedFromTime = "";
                                      String selectedToTime   = "";
                                      UrlDrawGameBean? resultUrlsDetails;
                                      ModuleBeanLst? drawerModuleBeanList = ModuleBeanLst.fromJson(jsonDecode(UserInfo.getDrawGameBeanList));
                                      MenuBeanList? rePrintApiDetails = drawerModuleBeanList.menuBeanList?.where((element) => element.menuCode == "DGE_RESULT_LIST").toList()[0];
                                      resultUrlsDetails = getDrawGameUrlDetails(rePrintApiDetails!, context, "getSchemaByGame");

                                      if (lotteryGameObjectList.isNotEmpty) {
                                        selectedGameName = lotteryGameObjectList[0].gameName ?? "";
                                        selectedGameCode = lotteryGameObjectList[0].gameCode ?? "";
                                      }

                                      for (GameRespVOs gameResp in lotteryGameObjectList) {
                                        if (gameResp.gameCode?.isNotEmpty == true ) {
                                          lotteryGameCodeList.add(gameResp.gameCode ?? "");
                                        }
                                      }

                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return StatefulBuilder(
                                              builder: (context, StateSetter setInnerState) {
                                                return Dialog(
                                                  elevation: 5.0,
                                                  insetPadding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 1.0),
                                                  backgroundColor: LongaLottoPosColor.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                            color: LongaLottoPosColor.game_color_blue,
                                                          ),
                                                          child: Text(
                                                            context.l10n.last_result,
                                                            textAlign: TextAlign.center,
                                                            style: const  TextStyle(
                                                                fontSize: 20,
                                                                color: LongaLottoPosColor.white,
                                                                fontWeight: FontWeight.bold
                                                            ),
                                                          ).p(15),
                                                        ),
                                                        SizedBox( // for game options
                                                          width: MediaQuery.of(context).size.width,
                                                          height: 100,
                                                          child: ListView.builder(
                                                              scrollDirection: Axis.horizontal,
                                                              shrinkWrap: true,
                                                              itemCount: lotteryGameObjectList.length,
                                                              itemBuilder: (BuildContext context, int index) {
                                                                return SizedBox(
                                                                  width: MediaQuery.of(context).size.width / 3.6,
                                                                  height: 90,
                                                                  child: Ink(
                                                                    decoration: BoxDecoration(
                                                                      color: (selectedGameName == lotteryGameObjectList[index].gameName) ? LongaLottoPosColor.white : LongaLottoPosColor.light_dark_white,
                                                                      boxShadow: const [
                                                                        BoxShadow(
                                                                          color: LongaLottoPosColor.warm_grey_six,
                                                                          blurRadius: 1.0,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child: InkWell(
                                                                      onTap: () {
                                                                        setInnerState(() {
                                                                          selectedGameName = lotteryGameObjectList[index].gameName.toString();
                                                                          selectedGameCode = lotteryGameObjectList[index].gameCode.toString();
                                                                        });
                                                                      },
                                                                      child: Ink(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Image.asset(
                                                                                width : 50,
                                                                                height: 50,
                                                                                lotteryGameCodeList.contains(lotteryGameObjectList[index].gameCode)
                                                                                    ? "assets/icons/${lotteryGameObjectList[index].gameCode}.png"
                                                                                    : "assets/images/splash_logo.png"
                                                                            ),
                                                                            Flexible(
                                                                              child: Text(
                                                                                  lotteryGameObjectList[index].gameName ?? "NA",
                                                                                  maxLines: 2 ,
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                      color: (selectedGameName == lotteryGameObjectList[index].gameName) ? LongaLottoPosColor.black : LongaLottoPosColor.warm_grey_light,
                                                                                      fontWeight: FontWeight.bold
                                                                                  )
                                                                              ).pOnly(top:8),
                                                                            ),
                                                                          ],
                                                                        ).p(5),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                          ),
                                                        ),
                                                        const Divider(color: LongaLottoPosColor.game_color_blue,thickness: 3),
                                                        /*Text(
                                                            (selectedGameName == "") ? "" : "${context.l10n.select_date_to_print_text} $selectedGameName ${context.l10n.result_small}",
                                                            maxLines: 2,
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(
                                                                fontSize: 13
                                                            ),
                                                          ).pOnly(top: 10),*/
                                                        Column(
                                                          children: [
                                                            /*DateTimeFormField(
                                                                decoration: InputDecoration(
                                                                  hintStyle: const TextStyle(color: Colors.black45),
                                                                  errorStyle: const TextStyle(color: Colors.redAccent),
                                                                  border: const OutlineInputBorder(),
                                                                  suffixIcon: const Icon(Icons.event_note),
                                                                  labelText: context.l10n.select_date,
                                                                ),
                                                                firstDate: DateTime.parse("2000-01-01 00:00:00"),
                                                                lastDate: DateTime.now().add(const Duration(days: 0)),
                                                                initialDate: DateTime.now().add(const Duration(days: 0)),
                                                                mode: DateTimeFieldPickerMode.date,
                                                                autovalidateMode: AutovalidateMode.always,
                                                                validator: (DateTime? e) {
                                                                  (e?.day ?? 0) == 1 ? '' : null;
                                                                },
                                                                onDateSelected: (DateTime value) {
                                                                  setState(() {
                                                                    selectedDate = value.toString().split(" ")[0];
                                                                  });
                                                                },
                                                              ),
                                                              const SizedBox(height: 5),*/
                                                            /*Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: DateTimeFormField(
                                                                      use24hFormat: false,
                                                                      decoration: InputDecoration(
                                                                          hintStyle: const TextStyle(color: Colors.black45),
                                                                          errorStyle: const TextStyle(color: Colors.redAccent),
                                                                          border: const OutlineInputBorder(),
                                                                          suffixIcon: const Icon(Icons.access_time_rounded),
                                                                          label: Text(
                                                                            context.l10n.from_time,
                                                                            maxLines: 1,
                                                                            style: const TextStyle(
                                                                              fontSize: 12.5,
                                                                            ),
                                                                          )
                                                                      ),
                                                                      mode: DateTimeFieldPickerMode.time,
                                                                      autovalidateMode: AutovalidateMode.always,
                                                                      onDateSelected: (DateTime value) {
                                                                        setState(() {
                                                                          selectedFromTime = value.toString().split(".")[0];
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                  const Text("-", style: TextStyle(fontSize:30, fontWeight: FontWeight.w300),).p(10),
                                                                  Expanded(
                                                                    child: DateTimeFormField(
                                                                      decoration: InputDecoration(
                                                                          hintStyle: const TextStyle(color: Colors.black45),
                                                                          errorStyle: const TextStyle(color: Colors.redAccent),
                                                                          border: const OutlineInputBorder(),
                                                                          suffixIcon: const Icon(Icons.access_time_rounded),
                                                                          label: Text(
                                                                            context.l10n.to_time,
                                                                            maxLines: 1,
                                                                            style: const TextStyle(
                                                                              fontSize: 12.5,
                                                                            ),
                                                                          )
                                                                      ),

                                                                      mode: DateTimeFieldPickerMode.time,
                                                                      initialDatePickerMode: DatePickerMode.day,
                                                                      autovalidateMode: AutovalidateMode.always,
                                                                      validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                                                                      onDateSelected: (DateTime value) {
                                                                        setState(() {
                                                                          selectedToTime = value.toString().split(".")[0];
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),*/
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: InkWell(
                                                                    onTap: () {
                                                                      if (lotteryBlocContext != null) {
                                                                        Navigator.of(ctx).pop();
                                                                        BlocProvider.of<LotteryBloc>(lotteryBlocContext!).add(ResultApi(
                                                                            context: lotteryBlocContext!,
                                                                            apiUrlDetails: resultUrlsDetails,
                                                                            fromDateTime: getLastResultFromTime(selectedGameCode),
                                                                            toDateTime: DateTime.now().toString(),
                                                                            gameCode: selectedGameCode
                                                                        ));
                                                                      } else {
                                                                        ShowToast.showToast(context, "unable to get context", type: ToastType.ERROR);
                                                                      }
                                                                      /*if (selectedDate.isNotEmpty  && selectedToTime.isNotEmpty && selectedFromTime.isNotEmpty) {


                                                                        } else {
                                                                          ShowToast.showToast(context, context.l10n.please_select_date_time, type: ToastType.ERROR);
                                                                        }*/

                                                                    },
                                                                    child: Container(
                                                                      height: 50,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(7),
                                                                          color: LongaLottoPosColor.game_color_green
                                                                      ),
                                                                      child: Center(child: Text(context.l10n.show_result, style: const TextStyle(color: LongaLottoPosColor.white),textAlign: TextAlign.center).p(10)),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 30),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: InkWell(
                                                                    onTap: () {
                                                                      if (!isLastResultOrRePrintingOrCancelling) {
                                                                        Navigator.pop(context);
                                                                      }
                                                                    },
                                                                    child: Ink(
                                                                      child: Container(
                                                                        height: 50,
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              width: 1,
                                                                              color: LongaLottoPosColor.game_color_red
                                                                          ),
                                                                          borderRadius: BorderRadius.circular(7),
                                                                        ),
                                                                        child: Center(child: Text(context.l10n.close, style: const TextStyle(color: LongaLottoPosColor.game_color_red), textAlign: TextAlign.center,).p(10)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ).pOnly(left: 12, right: 12, top: 16)
                                                      ],
                                                    ).pOnly(bottom: 20),
                                                  ),
                                                );
                                              }
                                          );
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset("assets/images/result.png", width: 25, height: 25,),
                                        const SizedBox(height: 2,),
                                        Text(context.l10n.last_result, style: const TextStyle(fontSize: 10, color: LongaLottoPosColor.warm_grey_three),)
                                      ],
                                    ),
                                  ),
                                ),
                                Container(width: .5, height: 50, color: LongaLottoPosColor.game_color_grey),
                                Expanded(
                                  child: Container(
                                    color: (UserInfo.getDgeLastSaleTicketNo.isNotEmpty && UserInfo.getDgeLastSaleTicketNo != "0" && UserInfo.getDgeLastSaleTicketNo != "-1")
                                              ? LongaLottoPosColor.white
                                              : LongaLottoPosColor.light_grey.withOpacity(0.4),
                                    child: TextButton(
                                      clipBehavior: Clip.hardEdge,
                                      onPressed: () {
                                        if (UserInfo.getDgeLastSaleTicketNo.isNotEmpty && UserInfo.getDgeLastSaleTicketNo != "0" && UserInfo.getDgeLastSaleTicketNo != "-1") {
                                          CancelTicketConfirmationDialog().show(context: context, title: context.l10n.cancel_ticket, subTitle: "${context.l10n.are_you_sure_you_want_to_cancel_ticket} ${UserInfo.getLastReprintTicketNo} ?", buttonText: context.l10n.yes, isCloseButton: true, buttonClick: () {
                                            ModuleBeanLst? drawerModuleBeanList = ModuleBeanLst.fromJson(jsonDecode(UserInfo.getDrawGameBeanList));
                                            MenuBeanList? cancelTicketApiDetails = drawerModuleBeanList.menuBeanList?.where((element) => element.menuCode == "DGE_CANCEL_TICKET").toList()[0];
                                            UrlDrawGameBean? cancelTicketApiUrlsDetails = getDrawGameUrlDetails(cancelTicketApiDetails!, context, "cancelTicket");
                                            BlocProvider.of<LotteryBloc>(context).add(
                                                CancelTicketApi(
                                                    context:context,
                                                    apiUrlDetails: cancelTicketApiUrlsDetails
                                                )
                                            );
                                          });

                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset("assets/images/cancel_ticket.png", width: 25, height: 25,),
                                          const SizedBox(height: 2),
                                          Text(context.l10n.cancel, style: const TextStyle(fontSize: 10, color: LongaLottoPosColor.warm_grey_three),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(width: .5, height: 50, color: LongaLottoPosColor.game_color_grey),
                                Expanded(
                                  child: Container(
                                    color: LongaLottoPosColor.white,
                                    child: TextButton(
                                      clipBehavior: Clip.hardEdge,
                                      onPressed: () {

                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext ctx) {
                                            return StatefulBuilder(
                                              builder: (context, StateSetter setInnerState) {
                                                return Dialog(
                                                    insetPadding: const EdgeInsets.symmetric(
                                                        horizontal: 14.0, vertical: 8.0),
                                                    backgroundColor: Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(16),
                                                    ),
                                                    child: SizedBox(
                                                        width: MediaQuery.of(context).size.width,
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          decoration: BoxDecoration(
                                                              color: LongaLottoPosColor.white,
                                                              borderRadius: BorderRadius.circular(12)
                                                          ),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Align(
                                                                alignment: Alignment.centerRight,
                                                                child: Material(
                                                                  color: LongaLottoPosColor.game_color_red.withOpacity(0.2),
                                                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                                  child: InkWell(
                                                                    onTap:() {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    customBorder: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                    ),
                                                                    child: Container(
                                                                      width: 30,
                                                                      height:30,
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(width: 1, color: LongaLottoPosColor.game_color_red),
                                                                        borderRadius: const BorderRadius.all(Radius.circular(8)),

                                                                      ),
                                                                      child: const Center(child: Icon(Icons.close, size: 16, color: LongaLottoPosColor.game_color_red)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ).pOnly(top:16),
                                                              const HeightBox(10),
                                                              Image.asset("assets/images/logo.webp", width: 150, height: 100),
                                                              const HeightBox(4),
                                                              Text(
                                                                context.l10n.select_an_option_for_reprint,
                                                                textAlign: TextAlign.center,
                                                                style: const TextStyle(
                                                                  fontSize: 18,
                                                                  color: LongaLottoPosColor.black,
                                                                ),
                                                              ),
                                                              const HeightBox(20),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Material(
                                                                    color: (UserInfo.getDgeLastSaleTicketNo.isNotEmpty && UserInfo.getDgeLastSaleTicketNo != "0" && UserInfo.getDgeLastSaleTicketNo != "-1" && UserInfo.getLastReprintTicketNo.isNotEmpty) ? LongaLottoPosColor.game_color_blue : LongaLottoPosColor.game_color_grey.withOpacity(0.5),
                                                                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                                                                    child: InkWell(
                                                                      onTap: () {
                                                                        if (UserInfo.getDgeLastSaleTicketNo.isNotEmpty && UserInfo.getDgeLastSaleTicketNo != "0" && UserInfo.getDgeLastSaleTicketNo != "-1" && UserInfo.getLastReprintTicketNo.isNotEmpty) {
                                                                          Navigator.of(ctx).pop();
                                                                          ModuleBeanLst? drawerModuleBeanList = ModuleBeanLst.fromJson(jsonDecode(UserInfo.getDrawGameBeanList));
                                                                          MenuBeanList? rePrintApiDetails = drawerModuleBeanList.menuBeanList?.where((element) => element.menuCode == "DGE_REPRINT").toList()[0];
                                                                          UrlDrawGameBean? rePrintApiUrlsDetails = getDrawGameUrlDetails(rePrintApiDetails!, context, "reprintTicket");
                                                                          if (lotteryBlocContext != null) {
                                                                            BlocProvider.of<LotteryBloc>(lotteryBlocContext!).add(
                                                                                RePrintApi(
                                                                                    context:lotteryBlocContext!,
                                                                                    apiUrlDetails: rePrintApiUrlsDetails
                                                                                )
                                                                            );
                                                                          } else {
                                                                            ShowToast.showToast(context, "unable to get context", type: ToastType.ERROR);
                                                                          }
                                                                        }

                                                                      },
                                                                      customBorder: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(6),
                                                                      ),
                                                                      child: SizedBox(
                                                                        height: 50,
                                                                        child: Center(child: Text(context.l10n.sale_reprint, style: const TextStyle(color: LongaLottoPosColor.white, fontSize: 18, fontWeight: FontWeight.bold))),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const HeightBox(10),
                                                                  Material(
                                                                    color: SharedPrefUtils.getLastWinningTicketNo.isNotEmpty ? LongaLottoPosColor.game_color_green : LongaLottoPosColor.game_color_grey.withOpacity(0.5),
                                                                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                                                                    child: InkWell(
                                                                      onTap: () {
                                                                        if (SharedPrefUtils.getLastWinningTicketNo.isNotEmpty) {
                                                                          Navigator.of(ctx).pop();
                                                                          if (lotteryBlocContext != null) {
                                                                            BlocProvider.of<WinningClaimBloc>(lotteryBlocContext!).add(
                                                                                TicketVerifyApi(
                                                                                    context: context,
                                                                                    ticketNumber: SharedPrefUtils.getLastWinningTicketNo,
                                                                                    apiDetails: verifyTicketUrls
                                                                                )
                                                                            );

                                                                          } else {
                                                                            ShowToast.showToast(context, "unable to get context", type: ToastType.ERROR);
                                                                          }
                                                                        }

                                                                      },
                                                                      customBorder: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(6),
                                                                      ),
                                                                      child: SizedBox(
                                                                        height: 50,
                                                                        child: Center(child: Text(context.l10n.winning_reprint, style: const TextStyle(color: LongaLottoPosColor.white, fontSize: 18, fontWeight: FontWeight.bold))),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ) ,
                                                              const HeightBox(20),
                                                            ],
                                                          ).pSymmetric(v: 10, h: 30),
                                                        )
                                                    )
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset("assets/images/reprint.png", width: 25, height: 25,),
                                          const SizedBox(height: 2,),
                                          Text(context.l10n.reprint, style: const TextStyle(fontSize: 10, color: LongaLottoPosColor.warm_grey_three),)
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: BlocListener<WinningClaimBloc, win_state.WinningClaimState>(
                    listener: (context, state) {
                      if(state is win_state.TicketVerifyApiLoading) {
                        setState(() {
                          isLastResultOrRePrintingOrCancelling = true;
                        });
                      }
                      else if (state is win_state.TicketVerifySuccess) {
                        log(" --------------------------->>>>>>>>>|| ${jsonEncode(state.response)}");
                        var responseTicketNumber = "";
                        setState(() {
                          isLastResultOrRePrintingOrCancelling = false;
                          TicketVerifyResponse? response = state.response;
                          ticketVerifyResponse = state.response;
                          winning_claim.ResponseData? data = state.response?.responseData;
                          verifyResponse = data;

                          String showErrorMsg = "";
                          if (response == null) {
                            ShowToast.showToast(context, "response is null", type: ToastType.ERROR);

                          } else if (response.responseCode == 0) {
                            responseTicketNumber = response.responseData?.ticketNumber ?? "";
                            var responseDrawData = response.responseData?.drawData ?? [];
                            for (int i = 0; i < responseDrawData.length; i++) {
                              var panelWinList = responseDrawData[i].panelWinList ?? [];
                              for (int j = 0; j < panelWinList.length; j++) {
                                    List<String> time = responseDrawData[i].drawTime?.split(":") ?? [];
                                    String boldStatus = responseDrawData[i].winStatus ?? "";
                                    showErrorMsg = "${"$showErrorMsg ${responseDrawData[i].drawDate} ${time[0]}:${time[1]}"}\n$boldStatus\n\n";
                              }
                            }
                            showSuccessDialog(context, responseTicketNumber, data?.winClaimAmount ?? 0.0);
                          }
                        });
                      }
                      else if (state is win_state.TicketVerifyError) {
                        setState(() {
                          isLastResultOrRePrintingOrCancelling = false;
                          if(state.errorMessage == noConnection) {
                            isNoInternet = true;
                          }
                        });
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () async {
                                return false;
                              },
                              child: StatefulBuilder(
                                builder: (context, StateSetter setInnerState) {
                                  return Dialog(
                                      insetPadding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 18.0),
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: LongaLottoPosColor.white,
                                            borderRadius: BorderRadius.circular(12)
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const HeightBox(10),
                                            Image.asset("assets/images/logo.webp", width: 150, height: 100),
                                            const HeightBox(4),
                                            Text(
                                              state.errorMessage,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: LongaLottoPosColor.black,
                                              ),
                                            ),
                                            const HeightBox(30),
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: LongaLottoPosColor.game_color_red,
                                                  borderRadius: BorderRadius.all(Radius.circular(6)),
                                                ),
                                                height: 45,
                                                child: Center(child: Text(context.l10n.close, style: const TextStyle(color: LongaLottoPosColor.white, fontSize: 14))),
                                              ),
                                            ),
                                            const HeightBox(20),

                                          ],
                                        ).pSymmetric(v: 10, h: 30),
                                      ).p(4)
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: BlocListener<LotteryBloc, LotteryState>(
                      listener: (bContext, state) {
                        setState(() {
                          lotteryBlocContext = bContext;
                        });

                        /* AFTER FETCH - GAME - API RESPONSE */
                        if (state is FetchGameLoading) {
                          setState(() {
                            if (!timeUpdating) {
                              _mIsShimmerLoading = true;
                            }
                          });
                        }
                        else if (state is FetchGameSuccess) {
                          setState(() {
                            isNoInternet        = false;
                            timeUpdating        = false;
                            _mIsShimmerLoading  = false;
                            lotteryGameObjectList = state.response.responseData?.gameRespVOs ?? [];
                            if (state.response.responseData?.isTicketAutoCancelled ?? false) {
                              SharedPrefUtils.setDgeLastSaleTicketNo = "0";
                            }
                            for (GameRespVOs gameResp in lotteryGameObjectList) {
                              if (gameResp.gameCode?.isNotEmpty == true ) {
                                lotteryGameCodeList.add(gameResp.gameCode ?? "");
                              }
                            }
                            currentDateTime = state.response.responseData?.currentDate;
                            /*for (var moduleCodeVar in homeModuleCodesList) {
                              if (state.response.responseData?.moduleBeanLst?.where((element) => (element.moduleCode == moduleCodeVar)) != null) {
                                homeModuleList.add(state.response.responseData?.moduleBeanLst?.where((element) => (element.moduleCode == moduleCodeVar)).toList());
                              }
                            }
                            for (var moduleCodeVar in drawerModuleCodesList) {
                              if (state.response.responseData?.moduleBeanLst?.where((element) => (element.moduleCode == moduleCodeVar)) != null) {
                                drawerModuleList.add(state.response.responseData?.moduleBeanLst?.where((element) => (element.moduleCode == moduleCodeVar)).toList());
                              }
                            }
                            if (drawerModuleList.isNotEmpty) {
                              _mIsDrawerVisible = true;
                            } else {
                              _mIsDrawerVisible = false;
                            }*/
                          });
                        }
                        else if (state is FetchGameError) {
                          if(state.errorMessage == noConnection) {
                            setState(() {
                              isNoInternet = true;
                            });
                          }
                          setState(() {
                            timeUpdating=false;
                            _mIsShimmerLoading = false;
                          });
                          ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
                        }

                        /* AFTER RE - PRINT API RESPONSE */
                        else if (state is RePrintLoading) {
                          setState(() {
                            isLastResultOrRePrintingOrCancelling = true;
                          });
                        }
                        else if (state is RePrintSuccess) {
                          setState(() {
                            isLastResultOrRePrintingOrCancelling = false;
                          });
                          re_print_resp.ResponseData? response = state.response.responseData;
                          UserInfo.setLastSaleGameCode(response?.gameCode ?? "");
                          SharedPrefUtils.setLastReprintTicketNo = response?.ticketNumber ?? "0";
                          //SharedPrefUtils.setDgeLastSaleTicketNo = response?.ticketNumber ?? "0";

                          Map<String,dynamic> printingDataArgs      = {};
                          printingDataArgs["saleResponse"]          = jsonEncode(state.response);
                          GetLoginDataResponse loginResponse        = GetLoginDataResponse.fromJson(jsonDecode(UserInfo.getUserInfo));
                          printingDataArgs["username"]              = loginResponse.responseData?.data?.orgName ?? "";
                          printingDataArgs["currencyCode"]          = getDefaultCurrency(getLanguage());
                          printingDataArgs["panelData"]             = jsonEncode(state.response.responseData?.panelData ?? []);
                          printingDataArgs["languageCode"]          = LongaLottoRetailApp.of(context).locale.languageCode;


                          PrintingDialog().show(context: context, title: context.l10n.printing_started, isRetryButtonAllowed: false, buttonText: context.l10n.retry, printingDataArgs: printingDataArgs,
                              isRePrint: true, onPrintingDone:() {}, isPrintingForSale: false);

                        }
                        else if (state is RePrintError) {
                          setState(() {
                            if(state.errorMessage == noConnection) {
                              isNoInternet = true;
                            }
                            isLastResultOrRePrintingOrCancelling = false;
                          });
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return WillPopScope(
                                onWillPop: () async {
                                  return false;
                                },
                                child: StatefulBuilder(
                                  builder: (context, StateSetter setInnerState) {
                                    return Dialog(
                                        insetPadding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 18.0),
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: Stack(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration: BoxDecoration(
                                                      color: LongaLottoPosColor.white,
                                                      borderRadius: BorderRadius.circular(12)
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      const HeightBox(10),
                                                      Image.asset("assets/images/logo.webp", width: 150, height: 100),
                                                      const HeightBox(4),
                                                      Text(
                                                        state.errorMessage,
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          color: LongaLottoPosColor.black,
                                                        ),
                                                      ),
                                                      const HeightBox(30),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Container(
                                                          decoration: const BoxDecoration(
                                                            color: LongaLottoPosColor.game_color_red,
                                                            borderRadius: BorderRadius.all(Radius.circular(6)),
                                                          ),
                                                          height: 45,
                                                          child: Center(child: Text(context.l10n.close, style: const TextStyle(color: LongaLottoPosColor.white, fontSize: 14))),
                                                        ),
                                                      ),
                                                      const HeightBox(20),

                                                    ],
                                                  ).pSymmetric(v: 10, h: 30),
                                                ).p(4)
                                              ]
                                          ),
                                        )
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }

                        /* AFTER CANCEL API RESPONSE */
                        else if (state is CancelTicketLoading) {
                          setState(() {
                            isLastResultOrRePrintingOrCancelling = true;
                          });
                        }
                        else if (state is CancelTicketSuccess) {
                          setState(() {
                            isLastResultOrRePrintingOrCancelling = false;
                          });
                          Map<String,dynamic> printingDataArgs = {};
                          printingDataArgs["cancelTicketResponse"]  = jsonEncode(state.response);
                          GetLoginDataResponse loginResponse        = GetLoginDataResponse.fromJson(jsonDecode(UserInfo.getUserInfo));
                          printingDataArgs["username"]              = loginResponse.responseData?.data?.orgName ?? "";
                          printingDataArgs["currencyCode"]          = getDefaultCurrency(getLanguage());
                          printingDataArgs["languageCode"]          = LongaLottoRetailApp.of(context).locale.languageCode;


                          BlocProvider.of<LoginBloc>(context).add(GetLoginDataApi(context: context));
                          PrintingDialog().show(context: context, title: context.l10n.printing_started, isRetryButtonAllowed: false, buttonText: context.l10n.retry, printingDataArgs: printingDataArgs, isCancelTicket: true, onPrintingDone:(){
                          }, isPrintingForSale: false);

                          UserInfo.setLastSaleTicketNo("0");
                          UserInfo.setLastReprintTicketNo("0");
                          ShowToast.showToast(context, context.l10n.ticket_successFully_cancelled, type: ToastType.SUCCESS);
                        }
                        else if (state is CancelTicketError) {
                          setState(() {
                            if(state.errorMessage == noConnection) {
                              isNoInternet = true;
                            }
                            isLastResultOrRePrintingOrCancelling = false;
                          });
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return WillPopScope(
                                onWillPop: () async {
                                  return false;
                                },
                                child: StatefulBuilder(
                                  builder: (context, StateSetter setInnerState) {
                                    return Dialog(
                                        insetPadding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 18.0),
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: Stack(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration: BoxDecoration(
                                                      color: LongaLottoPosColor.white,
                                                      borderRadius: BorderRadius.circular(12)
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      const HeightBox(10),
                                                      Image.asset("assets/images/logo.webp", width: 150, height: 100),
                                                      const HeightBox(4),
                                                      Text(
                                                        state.errorMessage,
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          color: LongaLottoPosColor.black,
                                                        ),
                                                      ),
                                                      const HeightBox(30),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Container(
                                                          decoration: const BoxDecoration(
                                                            color: LongaLottoPosColor.game_color_red,
                                                            borderRadius: BorderRadius.all(Radius.circular(6)),
                                                          ),
                                                          height: 45,
                                                          child: Center(child: Text(context.l10n.close, style: const TextStyle(color: LongaLottoPosColor.white, fontSize: 14))),
                                                        ),
                                                      ),
                                                      const HeightBox(20),

                                                    ],
                                                  ).pSymmetric(v: 10, h: 30),
                                                ).p(4)
                                              ]
                                          ),
                                        )
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }

                        /* AFTER RESULT API RESPONSE */
                        else if (state is ResultLoading) {
                          setState(() {
                            isLastResultOrRePrintingOrCancelling = true;
                          });
                        }
                        else if (state is ResultSuccess) {
                          setState(() {
                            isLastResultOrRePrintingOrCancelling = false;
                          });
                          Navigator.pop(context);
                          Navigator.pushNamed(context, LongaLottoPosScreen.resultPreviewScreen, arguments: state.response.responseData);
                        }
                        else if (state is ResultError) {
                          setState(() {
                            if(state.errorMessage == noConnection) {
                              isNoInternet = true;
                            }
                            isLastResultOrRePrintingOrCancelling = false;
                          });
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return WillPopScope(
                                onWillPop: () async {
                                  return false;
                                },
                                child: StatefulBuilder(
                                  builder: (context, StateSetter setInnerState) {
                                    return Dialog(
                                        insetPadding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 18.0),
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: Stack(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration: BoxDecoration(
                                                      color: LongaLottoPosColor.white,
                                                      borderRadius: BorderRadius.circular(12)
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      const HeightBox(10),
                                                      Image.asset("assets/images/logo.webp", width: 150, height: 100),
                                                      const HeightBox(4),
                                                      Text(
                                                        state.errorMessage,
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          color: LongaLottoPosColor.black,
                                                        ),
                                                      ),
                                                      const HeightBox(30),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Container(
                                                          decoration: const BoxDecoration(
                                                            color: LongaLottoPosColor.game_color_red,
                                                            borderRadius: BorderRadius.all(Radius.circular(6)),
                                                          ),
                                                          height: 45,
                                                          child: Center(child: Text(context.l10n.close, style: const TextStyle(color: LongaLottoPosColor.white, fontSize: 14))),
                                                        ),
                                                      ),
                                                      const HeightBox(20),

                                                    ],
                                                  ).pSymmetric(v: 10, h: 30),
                                                ).p(4)
                                              ]
                                          ),
                                        )
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: Stack(
                        children: [
                          RefreshIndicator(
                            triggerMode: RefreshIndicatorTriggerMode.anywhere,
                            color: LongaLottoPosColor.app_blue,
                            displacement: 60,
                            edgeOffset: 1,
                            strokeWidth: 2,
                            onRefresh: () {
                              setState(() {
                                isNoInternet       = false;
                                _mIsShimmerLoading = false;
                                lotteryGameObjectList.clear();
                              });
                              return Future.delayed(const Duration(milliseconds: 300), () { BlocProvider.of<LotteryBloc>(context).add(FetchGameDataApi(context: context)); },);
                            },
                            child: isNoInternet
                                ? Stack(
                                    children: [
                                      Align(
                                        child: ListView.builder( // ListView widget is used so that Refresh indicator can work properly at case of single child(non-scrollable-widgets).
                                          itemCount: 1,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (BuildContext context, int index) {
                                            return SizedBox(
                                              height: MediaQuery.of(context).size.height - 200,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Column(
                                                  children: [
                                                    const Expanded(flex: 1, child: SizedBox()),
                                                    SizedBox(width: 300, height: 300, child: Lottie.asset('assets/lottie/no_internet.json')),
                                                    const HeightBox(10),
                                                    Text(context.l10n.no_internet,
                                                        style: const TextStyle(color: LongaLottoPosColor.game_color_red, letterSpacing: 2, fontSize: 18))
                                                        .animate(onPlay: (controller) => controller.repeat(reverse: true))
                                                        .flipH(duration: const Duration(milliseconds: 300))
                                                        .move(delay: 150.ms, duration: 1100.ms),
                                                    const Expanded(flex: 1, child: SizedBox()),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: Column(
                                            children: [
                                              SizedBox(width: 100, height: 100, child: Transform.rotate(angle: -math.pi / 2.5, child: Lottie.asset('assets/lottie/pull_to_refresh.json'))),
                                              Text(context.l10n.swipe_to_refresh, style: const TextStyle(color: LongaLottoPosColor.app_blue, letterSpacing: 2, fontSize: 14))
                                            ],
                                          )
                                      ),
                                    ]
                                  )
                                : GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.8,
                                  crossAxisCount: 2,
                                ),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: _mIsShimmerLoading ? 10 : lotteryGameObjectList.length,
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
                                            width : 70,
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
                                    ).p(6),
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
                                      child: Stack(
                                        children: [
                                          mComingSoonGameCodeList.contains(lotteryGameObjectList[index].gameCode)
                                              ? Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              width: 100,
                                              height: 25,
                                              decoration: const BoxDecoration(
                                                  color: Colors.purpleAccent,
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                                              ),
                                              child: Text(context.l10n.coming_soon, style: const TextStyle(color: LongaLottoPosColor.white)).pOnly(left: 6, top: 6),
                                            ),
                                          )
                                              : Container(),
                                          InkWell(
                                              onTap: () {
                                                if (lotteryGameObjectList[index].drawRespVOs?.isEmpty == true) {
                                                  DrawNotAvailableMsgDialog().show(context: context, title: context.l10n.draw_is_not_available, isCloseButton: true, buttonText: 'Check after sometime . . .');

                                                } else {
                                                  var lotteryGameMainBetList = lotteryGameObjectList[index].betRespVOs?.where((element) => element.winMode == "MAIN").toList()   ?? [];
                                                  var lotteryGameSideBetList = lotteryGameObjectList[index].betRespVOs?.where((element) => element.winMode == "COLOR").toList()  ?? [];
                                                  if (lotteryGameSideBetList.isEmpty && lotteryGameMainBetList.isEmpty) {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      duration: const Duration(seconds: 1),
                                                      content: Text(context.l10n.no_bets_available_please_after_some_time),
                                                    ));
                                                  } else {
                                                    if (lotteryGameMainBetList.isNotEmpty) {
                                                      if (lotteryGameMainBetList.length > 1) {
                                                        if (lotteryGameObjectList[index].gameCode?.toUpperCase() == "powerball".toUpperCase()) {
                                                          List<BetRespVOs>? betRespV0sPowerBallList = lotteryGameObjectList[index].betRespVOs?.where((element) => element.betCode?.toUpperCase().contains("plus".toUpperCase()) != true).toList() ?? [];
                                                          if (betRespV0sPowerBallList.length > 1) {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder: (_) => MultiBlocProvider(
                                                                        providers: [
                                                                          BlocProvider<LoginBloc>(
                                                                            create: (BuildContext context) => LoginBloc(),
                                                                          )
                                                                        ],
                                                                        child: PickTypeScreen(gameObjectsList: lotteryGameObjectList[index], listPanelData: []))
                                                                )
                                                            );

                                                          } else {
                                                            List<BetRespVOs>? betRespV0s = lotteryGameObjectList[index].betRespVOs ?? [];
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                  builder: (_) =>  MultiBlocProvider(
                                                                      providers: [
                                                                        BlocProvider<LotteryBloc>(
                                                                          create: (BuildContext context) => LotteryBloc(),
                                                                        )
                                                                      ],
                                                                      child: GameScreen(particularGameObjects: lotteryGameObjectList[index], pickType: betRespV0s[0].pickTypeData?.pickType ?? [], betRespV0s: betRespV0s[0], mPanelBinList: [])),
                                                                )
                                                            );
                                                          }

                                                        }

                                                        else {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (_) => MultiBlocProvider(
                                                                      providers: [
                                                                        BlocProvider<LoginBloc>(
                                                                          create: (BuildContext context) => LoginBloc(),
                                                                        )
                                                                      ],
                                                                      child: PickTypeScreen(gameObjectsList: lotteryGameObjectList[index], listPanelData: []))
                                                              )
                                                          );
                                                        }

                                                      } else {
                                                        if (lotteryGameSideBetList.isNotEmpty) {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (_) => MultiBlocProvider(
                                                                      providers: [
                                                                        BlocProvider<LoginBloc>(
                                                                          create: (BuildContext context) => LoginBloc(),
                                                                        )
                                                                      ],
                                                                      child: PickTypeScreen(gameObjectsList: lotteryGameObjectList[index], listPanelData: []))
                                                              )
                                                          );

                                                        } else {
                                                          List<BetRespVOs>? betRespV0s = lotteryGameObjectList[index].betRespVOs ?? [];
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                builder: (_) =>  MultiBlocProvider(
                                                                    providers: [
                                                                      BlocProvider<LotteryBloc>(
                                                                        create: (BuildContext context) => LotteryBloc(),
                                                                      )
                                                                    ],
                                                                    child: GameScreen(particularGameObjects: lotteryGameObjectList[index], pickType: betRespV0s[0].pickTypeData?.pickType ?? [], betRespV0s: betRespV0s[0], mPanelBinList: [])),
                                                              )
                                                          );
                                                        }
                                                      }
                                                    }
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
                                                    Column(
                                                      children: [
                                                        Image.asset(
                                                            width : 100,
                                                            height: 100,
                                                            lotteryGameCodeList.contains(lotteryGameObjectList[index].gameCode)
                                                                ?
                                                            "assets/icons/${lotteryGameObjectList[index].gameCode}.png"
                                                                : "assets/images/splash_logo.png"
                                                        ),
                                                        Text(lotteryGameObjectList[index].gameName!.toString(), style: const TextStyle(color: LongaLottoPosColor.black, fontWeight: FontWeight.bold)),
                                                        const Divider( thickness: 2,).pOnly(top: 9),
                                                      ],
                                                    ),
                                                    (lotteryGameObjectList[index].drawRespVOs?.isEmpty == true)
                                                        ? SizedBox(
                                                        width: double.infinity,
                                                        height: 50,
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: Text(context.l10n.draw_is_not_available,
                                                            style: const TextStyle(color: Colors.red),),

                                                        )
                                                    )
                                                        : SizedBox(
                                                      width: double.infinity,
                                                      height: 50,
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: MyTimerLottery(
                                                          drawDateTime: DateTime.parse(lotteryGameObjectList[index].drawRespVOs?[0].drawSaleStopTime ?? "2023-10-30 13:44:45"),
                                                          currentDateTime: DateTime.parse(currentDateTime ?? "2023-10-30 13:44:45"),
                                                          gameType: null,
                                                          gameName: lotteryGameObjectList[index].gameName,
                                                          callback: (newGameData) {
                                                            setState(() {
                                                              timeUpdating = true;
                                                              BlocProvider.of<LotteryBloc>(context).add(FetchGameDataApi(context: context));
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                          ),
                                        ],
                                      )
                                  ).p(6);
                                }
                            ).p(10),
                          ),
                          Visibility(
                            visible: isLastResultOrRePrintingOrCancelling,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              color: LongaLottoPosColor.black.withOpacity(0.7),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: Lottie.asset('assets/lottie/gradient_loading.json'))),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }

  showSuccessDialog(BuildContext context, String? ticketNumber, double? winClaimAmount) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Container();
        },
        transitionBuilder: (BuildContext _,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            child) {
          var curve = Curves.easeInOut.transform(animation.value);
          return Transform.scale(
            scale: curve,
            child: Dialog(
                elevation: 30.0,
                backgroundColor: Colors.transparent,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const HeightBox(40),
                          Text(
                            context.l10n.success,
                            style: const TextStyle(
                                color: LongaLottoPosColor.shamrock_green,
                                fontSize: 20,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          const HeightBox(20),
                          Text("${context.l10n.ticket_number}:", style: const TextStyle(color: LongaLottoPosColor.warm_grey_three, fontSize: 12)),
                          Text("$ticketNumber\n", style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                          winClaimAmount != 0.0
                              ? Column(
                            children: [
                              Text("${context.l10n.winning_amount}:", style: const TextStyle(color: LongaLottoPosColor.warm_grey_three, fontSize: 12)),
                              Text("$winClaimAmount\n", style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),

                            ],
                          )
                              : Container(),
                          const HeightBox(10),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.65,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1,color: Colors.red),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white
                                    ),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          context.l10n.close,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: Colors.red, fontSize: 14),
                                        )
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    printingDataArgs["winClaimedResponse"]  = jsonEncode(ticketVerifyResponse);
                                    printingDataArgs["lastWinningSaleTicketNo"]  = SharedPrefUtils.getLastWinningSaleTicketNo;
                                    printingDataArgs["username"]            = UserInfo.userName;
                                    printingDataArgs["currencyCode"]        = getDefaultCurrency(getLanguage());
                                    printingDataArgs["languageCode"]        = LongaLottoRetailApp.of(context).locale.languageCode;

                                    PrintingDialog().show(context: context, title: context.l10n.printing_started, isRetryButtonAllowed: false, buttonText: 'Retry', printingDataArgs: printingDataArgs, isWinClaim: true, onPrintingDone:(){
                                      Navigator.of(context).pop(true);
                                    }, isPrintingForSale: false);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.65,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red
                                    ),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          context.l10n.close_print,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: Colors.white, fontSize: 14),
                                        )
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ).pOnly(top: 40),
                    Positioned.fill(
                      top: 10,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            color: Colors.white,
                          ),
                          child: SizedBox(width: 70, height: 70, child: Lottie.asset('assets/lottie/printing_success.json')),
                        ),
                      ),
                    )
                  ],
                )
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400));
  }

  showErrorDialog(BuildContext context, String showErrorMsg) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Container();
        },
        transitionBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            child) {
          var curve = Curves.easeInOut.transform(animation.value);
          return Transform.scale(
            scale: curve,
            child: Dialog(
              elevation: 3.0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 30.0),
              backgroundColor: LongaLottoPosColor.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HeightBox(40),
                  Text(
                    context.l10n.ticket_status,
                    style: const TextStyle(
                        color: LongaLottoPosColor.game_color_red,
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  const HeightBox(20),
                  Center(child: Text(showErrorMsg, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black)).pOnly(bottom: 10)),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: LongaLottoPosColor.red
                      ),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            context.l10n.ok_cap,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: LongaLottoPosColor.white, fontSize: 18, fontWeight: FontWeight.bold),
                          )
                      ),
                    ),
                  ),
                  const HeightBox(20)
                ],
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400));
  }

}
