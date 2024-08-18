import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/login/bloc/login_bloc.dart';
import 'package:longalottoretail/login/bloc/login_event.dart';
import 'package:longalottoretail/login/bloc/login_state.dart';
import 'package:longalottoretail/scan_and_play/withdrawalScreen/bloc/withdrawal_bloc.dart';
import 'package:longalottoretail/scan_and_play/withdrawalScreen/bloc/withdrawal_state.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:lottie/lottie.dart';
import 'package:scan/scan.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../login/models/response/GetLoginDataResponse.dart' as getLoginData;
import '../../lottery/widgets/printing_dialog.dart';
import '../../utility/date_format.dart';
import '../../utility/longa_lotto_pos_color.dart';
import '../../utility/shared_pref.dart';
import '../../utility/user_info.dart';
import '../../utility/utils.dart';
import '../../utility/widgets/show_snackbar.dart';
import 'bloc/withdrawal_event.dart';
import 'model/Pending_withdrawal_response.dart';
import 'model/update_qr_withdrawal_request.dart';

const Channel =
    MethodChannel('com.skilrock.longalottoretail/channel_afterWithdrawal');

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final ScanController _scanController = ScanController();
  bool flashOn = false;

  bool _pendingWithdrawalLoader = false;
  bool _isApproved = false;
  String mRequestId = "";
  String mDomainId = "";
  String mAliasId = "";
  String mUserId = "";
  String mAmount = "";
  String mTxnId = "";
  String mCurrentData = "";

  @override
  void initState() {
    super.initState();
    // String codeParam = "6014a374-eccd-4ce8-a4af-9e30c41da003";
    //
    // if (codeParam.length > 10) {
    //   BlocProvider.of<WithdrawalBloc>(context).add(PendingWithdrawalApiData(
    //     context: context,
    //     id: codeParam,
    //   ));
    // }
    var now = DateTime.now();
    var formatter = DateFormat('dd MMM yyyy, hh:mm aaa');
    mCurrentData = formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = (orientation == Orientation.landscape);
    FocusScope.of(context).requestFocus(FocusNode());
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is GetLoginDataSuccess) {
          setState(() {
            _isApproved = false;
            _pendingWithdrawalLoader = false;
          });
          Map<String, dynamic> printingDataArgs = {};
          getLoginData.GetLoginDataResponse loginResponse =
              getLoginData.GetLoginDataResponse.fromJson(
                  jsonDecode(UserInfo.getUserInfo));

          printingDataArgs["username"] = UserInfo.userName ?? "";
          printingDataArgs["withdrawalAmt"] = mAmount;

          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0)), //this right here
                  child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.l10n.pay_now,
                            style: const TextStyle(
                                fontSize: 24,
                                color: LongaLottoPosColor.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Text(
                              context.l10n.please_pay_to_customer,
                              style: const TextStyle(
                                  fontSize: 22,
                                  color: LongaLottoPosColor.black,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              "${getDefaultCurrency(getLanguage())}: ${getThousandSeparatorFormatAmount(mAmount)} ",
                              style: const TextStyle(
                                  fontSize: 22,
                                  color: LongaLottoPosColor.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              "${context.l10n.request_id} : $mRequestId",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: LongaLottoPosColor.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              mCurrentData,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: LongaLottoPosColor.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              PrintingDialog().show(
                                  context: context,
                                  title: context.l10n.printing_started,
                                  isRetryButtonAllowed: true,
                                  buttonText: context.l10n.retry,
                                  printingDataArgs: printingDataArgs,
                                  isAfterWithdrawal: true,
                                  onPrintingDone: () {
                                    Navigator.of(context).pop();
                                    _scanController.resume();
                                  },
                                  isPrintingForSale: false);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: LongaLottoPosColor.shamrock_green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Center(
                                  child: Text(
                                    context.l10n.close_print,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ).pOnly(top: 20, left: 20, right: 20)
                        ],
                      ),
                    ),
                  ),
                );
              });
        } else if (state is GetLoginDataError) {
          setState(() {
            _isApproved = false;
            _pendingWithdrawalLoader = false;
            _scanController.resume();
          });
        }
      },
      child: BlocListener<WithdrawalBloc, WithdrawalState>(
          listener: (bContext, state) {
            if (state is PendingWithdrawalLoading) {
              setState(() {
                _pendingWithdrawalLoader = true;
              });
            } else if (state is PendingWithdrawalError) {
              setState(() {
                _isApproved = false;
                _pendingWithdrawalLoader = false;
              });

              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext ctx) {
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
                              width: MediaQuery.of(context).size.width *
                                  (isLandscape ? 0.5 : 1),
                              child: Stack(children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: LongaLottoPosColor.white,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const HeightBox(10),
                                      Image.asset("assets/images/logo.webp",
                                          width: 150, height: 100),
                                      const HeightBox(4),
                                      Text(
                                        state.errorMessage,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: isLandscape ? 20 : 18,
                                          color: LongaLottoPosColor.black,
                                        ),
                                      ),
                                      const HeightBox(30),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const SizedBox(),
                                          const WidthBox(10),
                                          Expanded(
                                              child: InkWell(
                                            onTap: () {
                                              Navigator.of(ctx).pop();
                                              _scanController.resume();
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: LongaLottoPosColor
                                                    .game_color_red,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6)),
                                              ),
                                              height: isLandscape ? 65 : 45,
                                              child: Center(
                                                  child: Text(
                                                      context.l10n.close,
                                                      style: TextStyle(
                                                          color:
                                                              LongaLottoPosColor
                                                                  .white,
                                                          fontSize: isLandscape
                                                              ? 19
                                                              : 14))),
                                            ),
                                          )),
                                        ],
                                      ),
                                      const HeightBox(20),
                                    ],
                                  ).pSymmetric(v: 10, h: 30),
                                ).p(4)
                              ]),
                            ));
                      },
                    ),
                  );
                },
              );
            } else if (state is PendingWithdrawalSuccess) {
              _scanController.pause();
              setState(() {
                _isApproved = false;
                _pendingWithdrawalLoader = false;
              });
              if (state.response.data!.isNotEmpty &&
                  state.response.data!.length > 1) {
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: StatefulBuilder(
                        builder: (context_, StateSetter setInnerState) {
                          return Dialog(
                              insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 15.0),
                              backgroundColor: LongaLottoPosColor.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      context.l10n.pending_withdrawal_list,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: LongaLottoPosColor.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 10, right: 10),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        context
                                            .l10n.which_transaction_you_want_to,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: LongaLottoPosColor.black,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: LimitedBox(
                                      maxHeight: 400,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: state.response.data!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                            var date =  DateTime.fromMillisecondsSinceEpoch(state.response.data![index]
                                                  .createdAt!);
                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                                mRequestId = state.response
                                                    .data![index].requestId
                                                    .toString();
                                                mDomainId = state.response
                                                    .data![index].domainId
                                                    .toString();
                                                mAliasId = state
                                                    .response.data![index].aliasId
                                                    .toString();
                                                mUserId = state
                                                    .response.data![index].userId
                                                    .toString();
                                                mAmount = state
                                                    .response.data![index].amount
                                                    .toString();

                                              showAcceptDialog(isLandscape,
                                                  state, bContext, false);
                                            },
                                            child: Card(
                                              color: LongaLottoPosColor
                                                  .light_dark_white,
                                              margin: const EdgeInsets.only(
                                                  right: 10,
                                                  left: 10,
                                                  bottom: 10),
                                              elevation: 10,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          textAlign:
                                                              TextAlign.start,
                                                          "${context.l10n.request_id_cap} ${state.response.data![index].requestId!}",
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 5.0),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              text: context.l10n
                                                                  .withdraw_amount,
                                                              style: const TextStyle(
                                                                  color:
                                                                      LongaLottoPosColor
                                                                          .black),
                                                              /*defining default style is optional */
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                    text:
                                                                        " ${getDefaultCurrency(getLanguage())}${getThousandSeparatorFormatAmount(state.response.data![index].amount!.toString())}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: LongaLottoPosColor
                                                                            .dark_green)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                  "assets/images/timer.png",
                                                                  width: 15,
                                                                  height: 15),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(formatDate(
                                                                    date: date
                                                                        .toString(),
                                                                    inputFormat:
                                                                        "yyyy-MM-dd HH:mm:ss.S",
                                                                    outputFormat:
                                                                        Format
                                                                            .apiDateFormat2,
                                                                  ),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: LongaLottoPosColor
                                                                          .black))
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                            "assets/images/withdraw.png",
                                                            width: 30,
                                                            height: 30),
                                                         Text(
                                                            context.l10n.withdraw,
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    LongaLottoPosColor
                                                                        .black))
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      _scanController.resume();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: LongaLottoPosColor.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                      ),
                                      height: 45,
                                      child: const Center(
                                          child: Text("Close",
                                              style: TextStyle(
                                                  color:
                                                      LongaLottoPosColor.white,
                                                  fontSize: 14))),
                                    ),
                                  )
                                ],
                              ));
                        },
                      ),
                    );
                  },
                );
              } else if (state.response.data!.isNotEmpty) {
                mRequestId = state.response.data![0].requestId.toString();
                mDomainId = state.response.data![0].domainId.toString();
                mAliasId = state.response.data![0].aliasId.toString();
                mUserId = state.response.data![0].userId.toString();
                mAmount = state.response.data![0].amount.toString();
                showAcceptDialog(isLandscape, state, bContext, true);
              }
            } else if (state is UpdateWithdrawalLoading) {
              setState(() {
                _isApproved = true;
                _pendingWithdrawalLoader = true;
              });
            } else if (state is UpdateWithdrawalError) {
              _scanController.resume();
              setState(() {
                _isApproved = false;
                _pendingWithdrawalLoader = false;
              });
              Navigator.pop(context);
              ShowToast.showToast(context, state.errorMessage.toString(),
                  type: ToastType.ERROR);
            } else if (state is UpdateWithdrawalSuccess) {
              log("-------------------------------->>");
              setState(() {
                mRequestId = state.response.data?.requestId.toString() ?? "";
                mAmount = state.response.data?.amount.toString() ?? "";
              });
              BlocProvider.of<LoginBloc>(context)
                  .add(GetLoginDataApi(context: context));
            }
          },
          child: AbsorbPointer(
            absorbing: _pendingWithdrawalLoader,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Text(
                    context.l10n.scan_qr_code,
                    style: const TextStyle(
                        color: LongaLottoPosColor.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Stack(
                    children: [
                      ScanView(
                        controller: _scanController,
                        scanAreaScale: .7,
                        scanLineColor: LongaLottoPosColor.tomato,
                        onCapture: (data) {
                          print("data: $data");
                          if (data.contains("t")) {
                            setState(() {
                              Uri uri = Uri.dataFromString(data);
                              String? codeParam = uri.queryParameters['t'];

                              if (codeParam != null && codeParam.length > 10) {
                                BlocProvider.of<WithdrawalBloc>(context)
                                    .add(PendingWithdrawalApiData(
                                  context: context,
                                  id: codeParam,
                                ));
                              }
                            });
                          } else {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext ctx) {
                                return WillPopScope(
                                  onWillPop: () async {
                                    return false;
                                  },
                                  child: StatefulBuilder(
                                    builder:
                                        (context, StateSetter setInnerState) {
                                      return Dialog(
                                          insetPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 18.0),
                                          backgroundColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                (isLandscape ? 0.5 : 1),
                                            child: Stack(children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    color: LongaLottoPosColor
                                                        .white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const HeightBox(10),
                                                    Image.asset(
                                                        "assets/images/logo.webp",
                                                        width: 150,
                                                        height: 100),
                                                    const HeightBox(4),
                                                    Text(
                                                      context.l10n
                                                          .invalid_qr_code_please_try_another,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: isLandscape
                                                            ? 20
                                                            : 18,
                                                        color:
                                                            LongaLottoPosColor
                                                                .black,
                                                      ),
                                                    ),
                                                    const HeightBox(30),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        const SizedBox(),
                                                        const WidthBox(10),
                                                        Expanded(
                                                            child: InkWell(
                                                          onTap: () {
                                                            Navigator.of(ctx)
                                                                .pop();
                                                            _scanController
                                                                .resume();
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: LongaLottoPosColor
                                                                  .game_color_red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              6)),
                                                            ),
                                                            height: isLandscape
                                                                ? 65
                                                                : 45,
                                                            child: Center(
                                                                child: Text(
                                                                    context.l10n
                                                                        .close,
                                                                    style: TextStyle(
                                                                        color: LongaLottoPosColor
                                                                            .white,
                                                                        fontSize: isLandscape
                                                                            ? 19
                                                                            : 14))),
                                                          ),
                                                        )),
                                                      ],
                                                    ),
                                                    const HeightBox(20),
                                                  ],
                                                ).pSymmetric(v: 10, h: 30),
                                              ).p(4)
                                            ]),
                                          ));
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              _scanController.resume();
                              setState(() {
                                _isApproved = false;
                                _pendingWithdrawalLoader = false;
                              });
                            },
                            child: const Icon(
                              Icons.refresh,
                              color: LongaLottoPosColor.white,
                              size: 30,
                            ).p(10),
                          )).pOnly(right: 40),
                      Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              // on and off splash
                              setState(() {
                                flashOn = !flashOn;
                                _scanController.toggleTorchMode();
                              });
                            },
                            child: Icon(
                              (flashOn ? Icons.flash_on : Icons.flash_off),
                              color: LongaLottoPosColor.reddish_pink,
                              size: 30,
                            ).p(10),
                          )),
                      _pendingWithdrawalLoader
                          ? const Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator())
                          : Container()
                    ],
                  ),
                ),
                /*_isApproved
                    ? InkWell(
                        onTap: () {

                        },
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.09,
                          color: LongaLottoPosColor.shamrock_green,
                          child: const Center(
                            child: Text(
                              "Approved",
                              style: TextStyle(
                                  color: LongaLottoPosColor.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      )
                    : Container()*/
              ],
            ),
          )),
    );
  }

  String getLatestRequestId(PendingWithdrawalResponse pendingResponse) {
    List<Data> upcomingList = pendingResponse.data ?? [];
    if (upcomingList.isNotEmpty) {
      upcomingList.sort((a, b) {
        int comparingValue = a.requestId ?? 0;
        int compareValueTo = b.requestId ?? 0;
        return comparingValue.compareTo(compareValueTo);
      });

      return "${context.l10n.request_id}: ${upcomingList.last.requestId.toString()}";
    }
    return "${context.l10n.request_id} : NA";
  }

  String getLatestAmount(PendingWithdrawalResponse pendingResponse) {
    List<Data> upcomingList = pendingResponse.data ?? [];
    if (upcomingList.isNotEmpty) {
      upcomingList.sort((a, b) {
        int comparingValue = a.requestId ?? 0;
        int compareValueTo = b.requestId ?? 0;
        return comparingValue.compareTo(compareValueTo);
      });

      return upcomingList.last.amount.toString();
    }
    return "";
  }

  void showAcceptDialog(bool isLandscape, PendingWithdrawalSuccess state,
      BuildContext bContext, bool singleData) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
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
                    width: MediaQuery.of(context).size.width *
                        (isLandscape ? 0.5 : 1),
                    child: Stack(children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: LongaLottoPosColor.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const HeightBox(10),
                            Image.asset("assets/images/logo.webp",
                                width: 150, height: 100),
                            const HeightBox(4),
                            Text(
                              singleData == true
                                  ? getLatestRequestId(state.response)
                                  : "${context.l10n.request_id}: $mRequestId",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isLandscape ? 20 : 18,
                                color: LongaLottoPosColor.black,
                              ),
                            ),
                            const HeightBox(20),
                            Text(
                              singleData == true
                                  ?  "${context.l10n.amount} : ${getDefaultCurrency(getLanguage())} ${getThousandSeparatorFormatAmount(getLatestAmount(state.response))}":
                              "${context.l10n.amount} : ${getDefaultCurrency(getLanguage())} ${getThousandSeparatorFormatAmount(mAmount)}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isLandscape ? 20 : 18,
                                color: LongaLottoPosColor.black,
                              ),
                            ),
                            const HeightBox(30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _pendingWithdrawalLoader = true;
                                    });
                                    var data = UpdateQrWithdrawalRequest(
                                        requestId: mRequestId,
                                        domainId: mDomainId,
                                        aliasId: mAliasId,
                                        userId: mUserId,
                                        amount: mAmount,
                                        device: terminal,
                                        appType: appType,
                                        retailerId: UserInfo.userId);
                                    BlocProvider.of<WithdrawalBloc>(bContext)
                                        .add(UpdateWithdrawalApiData(
                                      context: context,
                                      updateQrWithdrawalRequest: data,
                                    ));
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color:
                                          LongaLottoPosColor.game_color_green,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                    ),
                                    height: isLandscape ? 65 : 45,
                                    child: Center(
                                        child: Text(context.l10n.accept,
                                            style: TextStyle(
                                                color: LongaLottoPosColor.white,
                                                fontSize:
                                                    isLandscape ? 19 : 14))),
                                  ),
                                )),
                                const WidthBox(10),
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    Navigator.of(ctx).pop();
                                    _scanController.resume();
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: LongaLottoPosColor.game_color_red,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                    ),
                                    height: isLandscape ? 65 : 45,
                                    child: Center(
                                        child: Text(context.l10n.cancel,
                                            style: TextStyle(
                                                color: LongaLottoPosColor.white,
                                                fontSize:
                                                    isLandscape ? 19 : 14))),
                                  ),
                                )),
                              ],
                            ),
                            const HeightBox(20),
                          ],
                        ).pSymmetric(v: 10, h: 30),
                      ).p(4)
                    ]),
                  ));
            },
          ),
        );
      },
    );
  }
}
