import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/lottery/widgets/shimmer_text.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/widgets/show_snackbar.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../l10n/printingExceptionsExternalTranslation.dart';
import 'dialog_shimmer_container.dart';

const Channel = MethodChannel('com.skilrock.longalottoretail/test');
const ChannelWithdrawal = MethodChannel('com.skilrock.longalottoretail/channel_afterWithdrawal');

class PrintingDialog {
  Color mColor = LongaLottoPosColor.game_color_orange;
  bool isPrintingFailed = false;
  bool isPrintingSuccess = false;
  bool isBuyNowPrintingStarted = true;
  String mTitle = "";
  String mSubTitle = "";
  show({
    required BuildContext context,
    required String title,
    required String buttonText,
    bool? isBackPressedAllowed,
    required Map<String, dynamic> printingDataArgs,
    bool? isRetryButtonAllowed = false,
    required bool isPrintingForSale,
    required VoidCallback onPrintingDone,
    VoidCallback? onPrintingFailed,
    bool isCancelTicket = false,
    bool isRePrint = false,
    bool isLastResult = false,
    bool isDepositPrintingStarted = false,
    bool isWinClaim = false,
    bool isAfterWithdrawal = false,
    bool isSummarizeReport = false,
    bool isBalanceInvoiceReport = false,
    bool isOperationalReport = false
  }) {
    mTitle = title;

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: StatefulBuilder(
            builder: (context, StateSetter setInnerState) {
              Future<void> buyNow(BuildContext context,
                  Map<String, dynamic> printingDataArgs) async {
                setInnerState(() {
                  isBuyNowPrintingStarted = false;
                });
                try {
                  print(" >>>>>>");
                  final dynamic receivedResponse = await Channel.invokeMethod('buy', printingDataArgs);
                  print("receivedResponse --> $receivedResponse");
                  if (receivedResponse) {
                    setInnerState(() {
                      isPrintingSuccess   = true;
                      isPrintingFailed    = false;
                      mTitle              = context.l10n.printing_success;
                      mColor              = LongaLottoPosColor.shamrock_green;
                      mSubTitle           = "";
                    });
                    Future.delayed(const Duration(seconds: 3), () async {
                      onPrintingDone();
                      Navigator.of(context).pop();
                      print("-------------dialog on printing done.");
                    });
                  }

                } on PlatformException catch (e) {
                  setInnerState(() {
                    mColor              = LongaLottoPosColor.game_color_red;
                    isPrintingFailed    = true;
                    mTitle            = context.l10n.printing_failed;
                    mSubTitle           = "${e.message}";
                  });
                  if (onPrintingFailed != null) {
                    onPrintingFailed();

                  }

                  print("----mColor----> $mColor");
                  print("----1111111---- ${e.message}");
                }
              }

              Future<void> cancelTicket(BuildContext context, Map<String, dynamic> printingDataArgs) async{
                setInnerState(() {
                  isBuyNowPrintingStarted = false;
                });
                try {
                  print(" >>>>>>");
                  final dynamic receivedResponse = await Channel.invokeMethod('dgeCancelTicket', printingDataArgs);
                  print("receivedResponse --> $receivedResponse");
                  if (receivedResponse) {
                    setInnerState(() {
                      isPrintingSuccess   = true;
                      isPrintingFailed    = false;
                      mTitle              = context.l10n.printing_success;
                      mColor              = LongaLottoPosColor.shamrock_green;
                      mSubTitle           = "";
                    });
                    Future.delayed(const Duration(seconds: 3), () async {
                      onPrintingDone();
                      Navigator.of(context).pop(true);
                      print("-------------dialog on printing done.");
                    });
                  }
                } on PlatformException catch (e) {
                  setInnerState(() {
                    mColor              = LongaLottoPosColor.game_color_red;
                    isPrintingFailed    = true;
                    mTitle            = context.l10n.printing_failed;
                    mSubTitle           = "${e.message}";
                  });

                  print("----mColor----> $mColor");
                  print("----1111111---- ${e.message}");
                }
              }

              Future<void> lastResult(BuildContext context,
                  Map<String, dynamic> printingDataArgs) async {
                setInnerState(() {
                  isBuyNowPrintingStarted = false;
                });
                try {
                  print(" >>>>>>");
                  final dynamic receivedResponse = await Channel.invokeMethod(
                      'dgeLastResult', printingDataArgs);
                  print("receivedResponse --> $receivedResponse");
                  if (receivedResponse) {
                    setInnerState(() {
                      isPrintingSuccess   = true;
                      isPrintingFailed    = false;
                      mTitle              = context.l10n.printing_success;
                      mColor              = LongaLottoPosColor.shamrock_green;
                      mSubTitle           = "";
                    });
                    Future.delayed(const Duration(seconds: 3), () async {
                      onPrintingDone();
                      Navigator.of(context).pop(true);
                      print("-------------dialog on printing done.");
                    });
                  }
                } on PlatformException catch (e) {
                  setInnerState(() {
                    mColor              = LongaLottoPosColor.game_color_red;
                    isPrintingFailed    = true;
                    mTitle            = context.l10n.printing_failed;
                    mSubTitle           = "${e.message}";
                  });

                  print("----mColor----> $mColor");
                  print("----1111111---- ${e.message}");
                }
              }

              Future<void> rePrint(BuildContext context,
                  Map<String, dynamic> printingDataArgs) async {
                setInnerState(() {
                  isBuyNowPrintingStarted = false;
                });
                try {
                  print(" >>>>>>");
                  final dynamic receivedResponse = await Channel.invokeMethod(
                      'dgeReprint', printingDataArgs);
                  print("receivedResponse --> $receivedResponse");
                  if (receivedResponse) {
                    setInnerState(() {
                      isPrintingSuccess = true;
                      isPrintingFailed = false;
                      mTitle = context.l10n.printing_success;
                      mColor = LongaLottoPosColor.shamrock_green;
                      mSubTitle = "";
                    });
                    Future.delayed(const Duration(seconds: 3), () async {
                      onPrintingDone();
                      Navigator.of(context).pop(true);
                      print("-------------dialog on printing done.");
                    });
                  }
                } on PlatformException catch (e) {
                  setInnerState(() {
                    mColor = LongaLottoPosColor.game_color_red;
                    isPrintingFailed = true;
                    mTitle = context.l10n.printing_failed;
                    mSubTitle = "${e.message}";
                  });

                  print("----mColor----> $mColor");
                  print("----1111111---- ${e.message}");
                }
              }

              Future<void> depositPrintResult(BuildContext context,
                  Map<String, dynamic> printingDataArgs) async {
                setInnerState(() {
                  isBuyNowPrintingStarted = false;
                });
                try {
                  print(" >>>>>>");
                  final dynamic receivedResponse = await const MethodChannel(
                          'com.skilrock.longalottoretail/notification_print')
                      .invokeMethod('notificationPrint', printingDataArgs);
                  if (receivedResponse) {
                    setInnerState(() {
                      isPrintingSuccess   = true;
                      isPrintingFailed    = false;
                      mTitle              = context.l10n.printing_success;
                      mColor              = LongaLottoPosColor.shamrock_green;
                      mSubTitle           = "";
                    });
                    Future.delayed(const Duration(seconds: 1), () async {
                      onPrintingDone();
                      if (onPrintingFailed == null) {
                        Navigator.of(context).pop(true);
                      }
                      print("-------------dialog on printing done.");
                    });
                  }
                } on PlatformException catch (e) {
                  //ShowToast.showToast(context, "e: ${e.message}");
                  if (onPrintingFailed != null) {
                    onPrintingFailed();

                  } else {
                    setInnerState(() {
                      mColor              = LongaLottoPosColor.game_color_red;
                      isPrintingFailed    = true;
                      mTitle            = context.l10n.printing_failed;
                      mSubTitle           = "${e.message}";
                    });
                  }

                  print("----mColor----> $mColor");
                  print("----1111111---- ${e.message}");
                }
              }

              Future<void> summarizeReport(BuildContext context,
                  Map<String, dynamic> printingDataArgs) async {
                setInnerState(() {
                  isBuyNowPrintingStarted = false;
                });
                try {
                  print(" >>>>>>");
                  final dynamic receivedResponse = await const MethodChannel(
                      'com.skilrock.longalottoretail/test')
                      .invokeMethod('summarizeReport', printingDataArgs);
                  if (receivedResponse) {
                    setInnerState(() {
                      isPrintingSuccess   = true;
                      isPrintingFailed    = false;
                      mTitle              = context.l10n.printing_success;
                      mColor              = LongaLottoPosColor.shamrock_green;
                      mSubTitle           = "";
                    });
                    Future.delayed(const Duration(seconds: 1), () async {
                      onPrintingDone();
                      if (onPrintingFailed == null) {
                        Navigator.of(context).pop(true);
                      }
                      print("-------------dialog on printing done.");
                    });
                  }
                } on PlatformException catch (e) {
                  ShowToast.showToast(context, "e: ${e.message}");
                  if (onPrintingFailed != null) {
                    onPrintingFailed();

                  } else {
                    setInnerState(() {
                      mColor              = LongaLottoPosColor.game_color_red;
                      isPrintingFailed    = true;
                      mTitle            = context.l10n.printing_failed;
                      mSubTitle           = "${e.message}";
                    });
                  }

                  print("----mColor----> $mColor");
                  print("----1111111---- ${e.message}");
                }
              }


              Future<void> balanceInvoiceReport(BuildContext context,
                  Map<String, dynamic> printingDataArgs) async {
                setInnerState(() {
                  isBuyNowPrintingStarted = false;
                });
                try {
                  print(" >>>>>>");
                  final dynamic receivedResponse = await const MethodChannel(
                      'com.skilrock.longalottoretail/test')
                      .invokeMethod('balanceInvoiceReport', printingDataArgs);
                  if (receivedResponse) {
                    setInnerState(() {
                      isPrintingSuccess   = true;
                      isPrintingFailed    = false;
                      mTitle              = context.l10n.printing_success;
                      mColor              = LongaLottoPosColor.shamrock_green;
                      mSubTitle           = "";
                    });
                    Future.delayed(const Duration(seconds: 1), () async {
                      onPrintingDone();
                      if (onPrintingFailed == null) {
                        Future.delayed(const Duration(seconds: 3), () async {
                          Navigator.of(context).pop(true);
                        });

                      }
                      print("-------------dialog on printing done.");
                    });
                  }
                } on PlatformException catch (e) {
                  ShowToast.showToast(context, "e: ${e.message}");

                  if (onPrintingFailed != null) {
                    Future.delayed(const Duration(seconds: 3), () async {
                      onPrintingFailed();
                      Navigator.of(context).pop(true);
                    });

                  } else {
                    setInnerState(() {
                      mColor              = LongaLottoPosColor.game_color_red;
                      isPrintingFailed    = true;
                      mTitle            = context.l10n.printing_failed;
                      mSubTitle           = "${e.message}";
                    });
                  }

                  print("----mColor----> $mColor");
                  print("----1111111---- ${e.message}");
                }
              }


              Future<void> operationalCashReport(BuildContext context,
                  Map<String, dynamic> printingDataArgs) async {
                setInnerState(() {
                  isBuyNowPrintingStarted = false;
                });
                try {
                  print(" >>>>>>");
                  final dynamic receivedResponse = await const MethodChannel(
                      'com.skilrock.longalottoretail/test')
                      .invokeMethod('operationalCashReport', printingDataArgs);
                  if (receivedResponse) {
                    setInnerState(() {
                      isPrintingSuccess   = true;
                      isPrintingFailed    = false;
                      mTitle              = context.l10n.printing_success;
                      mColor              = LongaLottoPosColor.shamrock_green;
                      mSubTitle           = "";
                    });
                    Future.delayed(const Duration(seconds: 1), () async {
                      onPrintingDone();
                      if (onPrintingFailed == null) {
                        Future.delayed(const Duration(seconds: 3), () async {
                          Navigator.of(context).pop(true);
                        });

                      }
                      print("-------------dialog on printing done.");
                    });
                  }
                } on PlatformException catch (e) {
                  ShowToast.showToast(context, "e: ${e.message}");

                  if (onPrintingFailed != null) {
                    Future.delayed(const Duration(seconds: 3), () async {
                      onPrintingFailed();
                      Navigator.of(context).pop(true);
                    });

                  } else {
                    setInnerState(() {
                      mColor              = LongaLottoPosColor.game_color_red;
                      isPrintingFailed    = true;
                      mTitle            = context.l10n.printing_failed;
                      mSubTitle           = "${e.message}";
                    });
                  }

                  print("----mColor----> $mColor");
                  print("----1111111---- ${e.message}");
                }
              }


              Future<void> winningClaim(BuildContext context, Map<String, dynamic> printingDataArgs) async{
                setInnerState((){
                  isBuyNowPrintingStarted = false;
                });
                try {
                  print(" >>>>>>");
                  final dynamic receivedResponse = await Channel.invokeMethod('winClaim', printingDataArgs);
                  print("receivedResponse --> $receivedResponse");
                  if (receivedResponse) {
                    setInnerState(() {
                      isPrintingSuccess   = true;
                      isPrintingFailed    = false;
                      mTitle              = context.l10n.printing_success;
                      mColor              = LongaLottoPosColor.shamrock_green;
                      mSubTitle           = "";
                    });
                    Future.delayed(const Duration(seconds: 3), () async {
                      onPrintingDone();
                      Navigator.of(context).pop(true);
                      print("-------------dialog on printing done.");
                    });
                  }

                } on PlatformException catch (e) {
                  setInnerState(() {
                    mColor              = LongaLottoPosColor.game_color_red;
                    isPrintingFailed    = true;
                    mTitle            = context.l10n.printing_failed;
                    mSubTitle           = "${e.message}";
                  });
                  if (onPrintingFailed != null) {
                    onPrintingFailed();
                  }


                  print("----mColor----> $mColor");
                  print("----1111111---- ${e.message}");
                }
              }

              Future<void> afterWithdrawal(BuildContext context,
                  Map<String, dynamic> printingDataArgs) async {
                setInnerState(() {
                  isBuyNowPrintingStarted = false;
                });
                try {
                  print(" >>>WITHDRAWAL>>>");
                  final dynamic receivedResponse = await ChannelWithdrawal.invokeMethod('afterWithdrawal', printingDataArgs);
                  print("receivedResponse --> $receivedResponse");
                  if (receivedResponse) {
                    setInnerState(() {
                      isPrintingSuccess   = true;
                      isPrintingFailed    = false;
                      mTitle              = context.l10n.printing_success;
                      mColor              = LongaLottoPosColor.shamrock_green;
                      mSubTitle           = "";
                    });
                    Future.delayed(const Duration(seconds: 3), () async {
                      onPrintingDone();
                      Navigator.of(context).pop();
                      print("-------------dialog on printing done.");
                    });
                  }

                } on PlatformException catch (e) {
                  setInnerState(() {
                    mColor              = LongaLottoPosColor.game_color_red;
                    isPrintingFailed    = true;
                    mTitle            = context.l10n.printing_failed;
                    mSubTitle           = getPrintingFailedTranslatedMsg(context, e.message ?? "");
                  });

                  print("----mColor----> $mColor");
                  print("----1111111---- ${e.message}");
                }
              }

              if (isBuyNowPrintingStarted && isDepositPrintingStarted && !isWinClaim && !isAfterWithdrawal && !isSummarizeReport) {
                //Deposit Print
                depositPrintResult(context, printingDataArgs);
              } else if (isBuyNowPrintingStarted && !isCancelTicket && !isRePrint && !isLastResult && !isWinClaim && !isAfterWithdrawal && !isSummarizeReport && !isBalanceInvoiceReport) {
               //BuyNOw dge ticket
                buyNow(context, printingDataArgs);
              } else if (isBuyNowPrintingStarted && isCancelTicket && !isRePrint && !isLastResult && !isWinClaim && !isAfterWithdrawal && !isSummarizeReport && !isBalanceInvoiceReport) {
                //Cancel TIcket Print
                cancelTicket(context, printingDataArgs);
              } else if (isBuyNowPrintingStarted && isRePrint && !isCancelTicket && !isLastResult && !isWinClaim && !isAfterWithdrawal && !isSummarizeReport && !isBalanceInvoiceReport) {
                rePrint(context, printingDataArgs);
              } else if (isBuyNowPrintingStarted && isLastResult && !isRePrint && !isCancelTicket && !isWinClaim && !isAfterWithdrawal && !isSummarizeReport && !isBalanceInvoiceReport) {
                lastResult(context, printingDataArgs);
              } else if (isBuyNowPrintingStarted && isWinClaim && !isAfterWithdrawal && !isSummarizeReport && !isBalanceInvoiceReport) {
                winningClaim(context, printingDataArgs);
              } else if (isBuyNowPrintingStarted && isAfterWithdrawal && !isSummarizeReport && !isBalanceInvoiceReport) {
                //Print Afterwithdraw
                afterWithdrawal(context, printingDataArgs);
              } else if (isBuyNowPrintingStarted && isSummarizeReport) {
                //SummarizeReport
                summarizeReport(context, printingDataArgs);
              }
         /*     else if (isBuyNowPrintingStarted && isBalanceInvoiceReport) {
                //BalanceInvoiceReport
                balanceInvoiceReport(context, printingDataArgs);
              }else if (isBuyNowPrintingStarted && isOperationalReport) {
                //Operation Cash Report
                operationalCashReport(context, printingDataArgs);
              }*/

              return WillPopScope(
                onWillPop: () async {
                  return isBackPressedAllowed ?? true;
                },
                child: Dialog(
                    insetPadding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 24.0),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SizedBox(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(children: [
                        DialogShimmerContainer(
                          color: mColor,
                          childWidget: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16)),
                          ).p(4),
                        ),
                        Container(
                          height: 250,
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
                              isPrintingForSale
                                  ? alertBuyDoneTitle(context)
                                  : Container(),
                              const HeightBox(10),
                              alertTitle(title),
                              const HeightBox(10),
                              alertSubTitle(mSubTitle),
                              const HeightBox(10),
                              isPrintingFailed
                                  ? SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Lottie.asset(
                                          'assets/lottie/printing_failed.json'))
                                  : isPrintingSuccess
                                      ? SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: Lottie.asset(
                                              'assets/lottie/printing_success.json'))
                                      : SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: Lottie.asset(
                                              'assets/lottie/printer.json')),
                              const HeightBox(10),
                              isPrintingFailed
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        isRetryButtonAllowed == true
                                            ? Expanded(
                                                child: InkWell(
                                                    onTap: () {
                                                      setInnerState(() {
                                                        mColor = LongaLottoPosColor
                                                            .game_color_orange;
                                                        isPrintingFailed =
                                                            false;
                                                        isPrintingSuccess =
                                                            false;
                                                        mTitle = context.l10n.printing;
                                                        isBuyNowPrintingStarted =
                                                            true;
                                                        mSubTitle = "";
                                                      });
                                                      /*if (isDepositPrintingStarted) {
                                                        depositPrintResult(context, printingDataArgs);
                                                      } else if (!isCancelTicket && !isRePrint) {
                                                        buyNow(context,
                                                            printingDataArgs);
                                                      } else if (isCancelTicket &&
                                                          !isRePrint) {
                                                        cancelTicket(context,
                                                            printingDataArgs);
                                                      } else if (isRePrint && !isCancelTicket) {
                                                        rePrint(context,
                                                            printingDataArgs);
                                                      }*/

                                                      if (isBuyNowPrintingStarted && isDepositPrintingStarted && !isWinClaim && !isAfterWithdrawal && !isSummarizeReport) {
                                                        print("00000000000000000000000000000000000");
                                                        depositPrintResult(context, printingDataArgs);
                                                      } else if (isBuyNowPrintingStarted && !isCancelTicket && !isRePrint && !isLastResult && !isWinClaim && !isAfterWithdrawal && !isSummarizeReport) {
                                                        print("1111111111111111111111111111111111111");
                                                        buyNow(context, printingDataArgs);
                                                      } else if (isBuyNowPrintingStarted && isCancelTicket && !isRePrint && !isLastResult && !isWinClaim && !isAfterWithdrawal && !isSummarizeReport) {
                                                        print("222222222222222222222222222222222222");
                                                        cancelTicket(context, printingDataArgs);
                                                      } else if (isBuyNowPrintingStarted && isRePrint && !isCancelTicket && !isLastResult && !isWinClaim && !isAfterWithdrawal && !isSummarizeReport) {
                                                        print("333333333333333333333333333333333333");
                                                        rePrint(context, printingDataArgs);
                                                      } else if (isBuyNowPrintingStarted && isLastResult && !isRePrint && !isCancelTicket && !isWinClaim && !isAfterWithdrawal && !isSummarizeReport) {
                                                        print("4444444444444444444444444444444444444");
                                                        lastResult(context, printingDataArgs);
                                                      } else if (isBuyNowPrintingStarted && isWinClaim && !isAfterWithdrawal && !isSummarizeReport) {
                                                        print("55555555555555555555555555555555555555");
                                                        winningClaim(context, printingDataArgs);
                                                      } else if (isBuyNowPrintingStarted && isAfterWithdrawal && !isSummarizeReport) {
                                                        print("6666666666666666666666666666666666666666");
                                                        afterWithdrawal(context, printingDataArgs);
                                                      } else if (isBuyNowPrintingStarted && isSummarizeReport) {
                                                        summarizeReport(context, printingDataArgs);
                                                      }
                                                    },
                                                    customBorder:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              LongaLottoPosColor
                                                                  .white,
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          6)),
                                                          border: Border.all(
                                                              color: LongaLottoPosColor
                                                                  .game_color_orange)),
                                                      height: 35,
                                                      child: Center(
                                                          child: Text(
                                                              buttonText,
                                                              style: const TextStyle(
                                                                  color: LongaLottoPosColor
                                                                      .game_color_orange))),
                                                    )))
                                            : const SizedBox(),
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
                                            height: 35,
                                            child: Center(
                                                child: Text(context.l10n.close,
                                                    style: const TextStyle(
                                                        color:
                                                            LongaLottoPosColor
                                                                .white))),
                                          ),
                                        )),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ).pSymmetric(v: 10, h: 30),
                        ).p(4)
                      ]),
                    )),
              );
            },
          ),
        );
      },
    );
  }

  alertTitle(String title) {
    return TextShimmer(
      color: mColor,
      text: mTitle,
    );
  }

  alertSubTitle(String subTitle,
      {Color subtitleColor = LongaLottoPosColor.red}) {
    return Center(
      child: Text(
        subTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10, color: LongaLottoPosColor.red),
      ),
    );
  }

  alertBuyDoneTitle(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.you_purchased_successfully,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 13,
            letterSpacing: 2,
            color: LongaLottoPosColor.game_color_blue),
      ),
    );
  }
}
