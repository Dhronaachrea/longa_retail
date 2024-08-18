import 'dart:convert';
import 'dart:developer';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/login/bloc/login_state.dart';
import 'package:longalottoretail/login/models/response/GetLoginDataResponse.dart';
import 'package:longalottoretail/scan_and_play/depositScreen/bloc/deposit_bloc.dart';
import 'package:longalottoretail/scan_and_play/depositScreen/bloc/deposit_event.dart';
import 'package:longalottoretail/scan_and_play/depositScreen/bloc/deposit_state.dart';
import 'package:longalottoretail/scan_and_play/dialog/qrcode_dialog.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../login/bloc/login_bloc.dart';
import '../../login/bloc/login_event.dart';
import '../../lottery/widgets/printing_dialog.dart';
import '../../utility/longa_lotto_pos_color.dart';
import '../../utility/user_info.dart';
import '../../utility/utils.dart';
import '../../utility/widgets/longa_lotto_pos_text_field_underline.dart';
import '../../utility/widgets/primary_button.dart';
import '../../utility/widgets/show_snackbar.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  TextEditingController textController = TextEditingController();

  bool _loader = false;
  bool isBuyNowPrintingStarted = false;
  bool isPrintingSuccess = true;
  String qrCodeUrl = "";
  String couponCodeVar = "";
  late BuildContext mTempContext;

  @override
  void initState() {
    super.initState();
  }

  Future<int?> getBatteryInfo() async {
    var batteryInfo = await BatteryInfoPlugin().androidBatteryInfo;
    return batteryInfo?.batteryLevel;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mTempContext = context;
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = (orientation == Orientation.landscape);
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is GetLoginDataSuccess) {
          if (androidInfo?.model == "V2" ||
              androidInfo?.model == "M1" ||
              androidInfo?.model.toLowerCase() == "m1k_go" ||
              androidInfo?.model == "T2mini") {
            Navigator.pop(context);
          } else {
            setState(() {
              _loader = false;
            });
            QrCodeDialog().show(
              context: context,
              title: context.l10n.qr_code,
              buttonText: "buttonText",
              url: qrCodeUrl,
              amount:
                  "${getDefaultCurrency(getLanguage())} ${textController.text.toString()}",
              onPrintingDone: () {},
            );
          }

          textController.clear();
        } else if (state is GetLoginDataError) {
          textController.clear();
          Navigator.pop(context);
        }
      },
      child: BlocListener<DepositBloc, DepositState>(
          listener: (bContext, state) {
            if (state is DepositLoading) {
              setState(() {
                mTempContext = bContext;
                _loader = true;
              });
            }
            else if (state is DepositError) {
              setState(() {
                _loader = false;
              });
              ShowToast.showToast(context, state.errorMessage.toString(),
                  type: ToastType.ERROR);
            } else if (state is DepositSuccess) {
              if (state.response.data?.couponQRCodeUrl?.isNotEmptyAndNotNull ==
                  true) {
                setState(() {
                  qrCodeUrl = state.response.data?.couponQRCodeUrl ?? "";
                  if (state.response.data?.couponCode != null) {
                    if (state.response.data?.couponCode?.isNotEmpty == true) {
                      couponCodeVar =
                          state.response.data?.couponCode?[0].couponCode ?? "";
                    }
                  }
                });
                if (couponCodeVar.isNotEmpty) {
                  if (androidInfo?.model == "V2" ||
                      androidInfo?.model == "M1" ||
                      androidInfo?.model.toLowerCase() == "m1k_go" ||
                      androidInfo?.model == "T2mini") {
                    setState(() {
                      _loader = false;
                    });
                    Map<String, dynamic> printingDataArgs = {};
                    printingDataArgs["userName"] = UserInfo.userName;
                    printingDataArgs["userId"] = UserInfo.userId;
                    printingDataArgs["currencyCode"] =
                        getDefaultCurrency(getLanguage());
                    printingDataArgs["Amount"] = textController.text.toString();
                    printingDataArgs["url"] = qrCodeUrl;
                    printingDataArgs["couponCode"] = couponCodeVar;

                    PrintingDialog().show(
                        context: context,
                        title: context.l10n.printing_started,
                        isRetryButtonAllowed: true,
                        buttonText: context.l10n.retry,
                        printingDataArgs: printingDataArgs,
                        isRePrint: true,
                        isDepositPrintingStarted: true,
                        onPrintingDone: () {
                          //////////////////////////////////////////////////////////////////////////////// In this after success dialog getlogindata api get's called & on its response i am closing dialog.
                          BlocProvider.of<LoginBloc>(context)
                              .add(GetLoginDataApi(context: context));
                        },
                        onPrintingFailed: () {
                          if (couponCodeVar.isNotEmptyAndNotNull) {
                            BlocProvider.of<DepositBloc>(context).add(
                                CouponReversalApi(
                                    context: context,
                                    couponCode: couponCodeVar));
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        isPrintingForSale: false);
                  } else {
                    BlocProvider.of<LoginBloc>(context)
                        .add(GetLoginDataApi(context: context));
                  }
                } else {
                  ShowToast.showToast(context, context.l10n.unable_to_print_qr,
                      type: ToastType.ERROR);
                }
              } else {
                ShowToast.showToast(context, context.l10n.qr_code_unavailable,
                    type: ToastType.ERROR);
              }
            } else if (state is CouponReversalSuccess) {
              Navigator.pop(context);
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
                                        context.l10n.unable_to_print_qr,
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
            } else if (state is CouponReversalError) {
              Navigator.pop(context);
              {
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
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const HeightBox(10),
                                        Image.asset("assets/images/logo.webp",
                                            width: 150, height: 100),
                                        const HeightBox(4),
                                        Text(
                                          context.l10n
                                              .unable_to_print_now_coupon_reversal_initiated,
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
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: LongaLottoPosColor
                                                      .game_color_red,
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                                            fontSize:
                                                                isLandscape
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
            }
          },
          child: SingleChildScrollView(
            child: AbsorbPointer(
              absorbing: _loader,
              child: Container(
                margin: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        context.l10n.enter_deposit_amount,
                        style: TextStyle(
                            color: LongaLottoPosColor.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/icon_pin.png",
                            width: 30,
                            height: 30,
                          ),
                          Text(
                            UserInfo.userName,
                            style: const TextStyle(
                                color: LongaLottoPosColor.gray,
                                fontSize: 26,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 30,
                          height: 30,
                        ),
                        Text(
                          "${context.l10n.id} ${UserInfo.userId}",
                          style: const TextStyle(
                              color: LongaLottoPosColor.gray,
                              fontSize: 26,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: LongaLottoPosTextFieldUnderline(
                        hintText: context.l10n.amount,
                        maxLength: 6,
                        onEditingComplete: () {
                          proceedToApiCall();
                        },
                        inputType: TextInputType.number,
                        controller: textController,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40.0),
                      child: _loader
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                  color: LongaLottoPosColor.app_bg),
                            )
                          : PrimaryButton(
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: 52,
                              textColor: LongaLottoPosColor.black,
                              text: context.l10n.print_qr_code,
                              fontWeight: FontWeight.w700,
                              onPressed: () {
                                proceedToApiCall();
                              }),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void proceedToApiCall() {
    getBatteryInfo().then((value) {
      if (value != null) {
        if (value > 10) {
          FocusScope.of(context).requestFocus(FocusNode());
          if (textController.text.isNotEmpty) {
            if (getFormattedUserBalance()) {
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
                              width: MediaQuery.of(context).size.width,
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
                                        "${context.l10n.are_you_sure_you_want_this_amount} ${getDefaultCurrency(getLanguage())} ${getThousandSeparatorFormatAmount(textController.text)}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: LongaLottoPosColor.black,
                                        ),
                                      ),
                                      const HeightBox(30),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                              child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: LongaLottoPosColor
                                                    .game_color_red,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6)),
                                              ),
                                              height: 45,
                                              child: Center(
                                                  child: Text(
                                                      context.l10n.cancel,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor
                                                                  .white,
                                                          fontSize: 14))),
                                            ),
                                          )),
                                          const WidthBox(10),
                                          Expanded(
                                              child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              BlocProvider.of<DepositBloc>(
                                                      mTempContext)
                                                  .add(DepositApiData(
                                                      context: context,
                                                      url: "",
                                                      retailerName:
                                                          UserInfo.userName,
                                                      amount: textController
                                                          .text
                                                          .toString()));
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: LongaLottoPosColor
                                                    .game_color_green,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6)),
                                              ),
                                              height: 45,
                                              child: Center(
                                                  child: Text(
                                                      context
                                                          .l10n.continue_text,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor
                                                                  .white,
                                                          fontSize: 14))),
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
            } else {
              ShowToast.showToast(
                  context, context.l10n.insufficient_balance_for_transaction,
                  type: ToastType.ERROR);
            }
          } else {
            ShowToast.showToast(context, context.l10n.please_enter_valid_amount,
                type: ToastType.ERROR);
          }
        } else {
          ShowToast.showToast(context, context.l10n.please_charge_device,
              type: ToastType.ERROR);
        }
      }
    });
  }

  bool getFormattedUserBalance() {
    GetLoginDataResponse loginResponse =
        GetLoginDataResponse.fromJson(jsonDecode(UserInfo.getUserInfo));
    String balance =
        loginResponse.responseData?.data?.balance?.toString() ?? "";
    String creditLimit =
        loginResponse.responseData?.data?.creditLimit?.toString() ?? "";
    String splitBalance = balance.split(",")[0];
    String splitCreditLimit = creditLimit.split(",")[0];
    String formattedBalance = splitBalance.replaceAll(" ", '');
    String formattedCreditLimit = splitCreditLimit.replaceAll(" ", '');
    if ((int.parse(formattedBalance) + int.parse(formattedCreditLimit)) >=
        int.parse(textController.text)) {
      return true;
    }
    return false;
  }

/*void proceedToApiCall() {
    getBatteryInfo().then((value) {
      if (value != null) {
        if (value > 10) {
          FocusScope.of(context).requestFocus(FocusNode());
          if (textController.text.isNotEmpty && int.parse(textController.text.toString()) > 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              BlocProvider.of<DepositBloc>(context).add(
                  DepositApiData(
                      context: context,
                      url: "",
                      retailerName: UserInfo.userName,
                      amount: textController.text.toString()));
            });
          } else {
            ShowToast.showToast(
                context, context.l10n.please_enter_valid_amount,
                type: ToastType.ERROR);
          }
        } else {
          ShowToast.showToast(context, context.l10n.please_charge_device, type: ToastType.ERROR);
        }
      }
    });
  }*/
}
