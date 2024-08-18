import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/balance_invoice_report/bloc/balance_invoice_report_bloc.dart';
import 'package:longalottoretail/balance_invoice_report/bloc/balance_invoice_report_event.dart';
import 'package:longalottoretail/balance_invoice_report/bloc/balance_invoice_report_state.dart';
import 'package:longalottoretail/balance_invoice_report/models/response/balance_invoice_report_response.dart';
import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/widgets/show_snackbar.dart';
import 'package:velocity_x/velocity_x.dart';

import '../lottery/widgets/printing_dialog.dart';
import '../utility/date_format.dart';
import '../utility/rounded_container.dart';
import '../utility/user_info.dart';
import '../utility/utils.dart';
import '../utility/widgets/selectdate/bloc/select_date_bloc.dart';
import '../utility/widgets/selectdate/forward.dart';
import '../utility/widgets/selectdate/select_date.dart';

class BalanceInvoiceReportScreen extends StatefulWidget {
  const BalanceInvoiceReportScreen({Key? key}) : super(key: key);

  @override
  State<BalanceInvoiceReportScreen> createState() =>
      _BalanceInvoiceReportState();
}

class _BalanceInvoiceReportState extends State<BalanceInvoiceReportScreen> {
  @override
  void initState() {
    BlocProvider.of<BalanceInvoiceReportBloc>(context)
        .add(GetBalanceInvoiceReportApiData(
      context: context,
      fromDate: formatDate(
        date: context.read<SelectDateBloc>().fromDate,
        inputFormat: Format.dateFormat9,
        outputFormat: Format.apiDateFormat3,
      ),
      toDate: formatDate(
        date: context.read<SelectDateBloc>().toDate,
        inputFormat: Format.dateFormat9,
        outputFormat: Format.apiDateFormat3,
      ),
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var body = Column(
      children: [
        Container(
          color: LongaLottoPosColor.white,
          // constraints: BoxConstraints(
          //   minHeight: context.screenHeight / 7,
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SelectDate(
                title: context.l10n.from,
                date: context.watch<SelectDateBloc>().fromDate,
                onTap: () {
                  context.read<SelectDateBloc>().add(
                        PickFromDate(context: context),
                      );
                },
              ),
              SelectDate(
                title: context.l10n.to,
                date: context.watch<SelectDateBloc>().toDate,
                onTap: () {
                  context.read<SelectDateBloc>().add(
                        PickToDate(context: context),
                      );
                },
              ),
              Forward(
                onTap: () {
                  // context.read<DepWithBloc>().add(
                  //       GetDepWith(
                  //         context: context,
                  //         fromDate: context.watch<SelectDateBloc>().fromDate,
                  //         toDate: context.watch<SelectDateBloc>().toDate,
                  //       ),
                  //     );
                  initData();
                },
              ),
            ],
          ).pSymmetric(v: 16, h: 10),
        ),
        BlocConsumer<BalanceInvoiceReportBloc, BalanceInvoiceReportState>(
            listener: (context, state) {
          if (state is BalanceInvoiceReportError) {
            ShowToast.showToast(context, state.errorMessage,
                type: ToastType.ERROR);
          }
        }, builder: (context, state) {
          if (state is BalanceInvoiceReportLoading) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ).p(10);
          } else if (state is BalanceInvoiceReportSuccess) {
            Data? balanceInvoiceData =
                state.balanceInvoiceReportApiResponse.responseData?.data;
            String? closingBalance = balanceInvoiceData?.closingBalance ?? "-";
            String? openingBalance = balanceInvoiceData?.openingBalance ?? "-";
            return Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: LongaLottoPosColor.pale_grey_four,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              context.l10n.opening_balance,
                              style: TextStyle(
                                  color: LongaLottoPosColor.black_four
                                      .withOpacity(0.5)),
                            ).p(10),
                            Text(openingBalance,
                                    style: const TextStyle(
                                        color:
                                            LongaLottoPosColor.shamrock_green))
                                .pOnly(bottom: 10)
                          ],
                        ),
                        Column(
                          children: [
                            Text(context.l10n.closing_balance,
                                    style: TextStyle(
                                        color: LongaLottoPosColor.black_four
                                            .withOpacity(0.5)))
                                .p(10),
                            Text(closingBalance,
                                    style: const TextStyle(
                                        color:
                                            LongaLottoPosColor.shamrock_green))
                                .pOnly(bottom: 10)
                          ],
                        ),
                      ],
                    ).pOnly(left: 25, right: 25),
                  ),
                  if (balanceInvoiceData != null) Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Sales
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: LongaLottoPosColor.light_grey),
                                    child: Text(
                                      context.l10n.sales,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: LongaLottoPosColor.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ).p(15),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: LongaLottoPosColor.white),
                                    child: Text(
                                      balanceInvoiceData.sales ?? "-",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: LongaLottoPosColor.black),
                                      textAlign: TextAlign.center,
                                    ).p(15),
                                  ),
                                ),
                              ],
                            ).pSymmetric(h: 16, v: 4),
                            Row(
                              children: [
                                // Claims
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: LongaLottoPosColor.light_grey),
                                    child: Text(
                                      context.l10n.claims,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: LongaLottoPosColor.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ).p(15),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: LongaLottoPosColor.white),
                                    child: Text(
                                      balanceInvoiceData.claims ?? "-",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: LongaLottoPosColor.black),
                                      textAlign: TextAlign.center,
                                    ).p(15),
                                  ),
                                ),
                              ],
                            ).pSymmetric(h: 16, v: 4),
                            Row(
                              children: [
                                // Claim Tax
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: LongaLottoPosColor.light_grey),
                                    child: Text(
                                      context.l10n.claim_tax,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: LongaLottoPosColor.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ).p(15),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: LongaLottoPosColor.white),
                                    child: Text(
                                      balanceInvoiceData.claimTax ?? "-",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: LongaLottoPosColor.black),
                                      textAlign: TextAlign.center,
                                    ).p(15),
                                  ),
                                ),
                              ],
                            ).pSymmetric(h: 16, v: 4),
                            Row(
                              children: [
                                // Commission Sales
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: LongaLottoPosColor.light_grey),
                                    child: Text(
                                      context.l10n.commission_sales,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: LongaLottoPosColor.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ).p(15),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: LongaLottoPosColor.white),
                                    child: Text(
                                      balanceInvoiceData.salesCommission ?? "-",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: LongaLottoPosColor.black),
                                      textAlign: TextAlign.center,
                                    ).p(15),
                                  ),
                                ),
                              ],
                            ).pSymmetric(h: 16, v: 4),
                            Row(
                              children: [
                                // Commission Winnings
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: LongaLottoPosColor.light_grey),
                                    child: Text(
                                      context.l10n.winnings_commission,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: LongaLottoPosColor.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ).p(15),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: LongaLottoPosColor.white),
                                    child: Text(
                                      balanceInvoiceData.winningsCommission ??
                                          "-",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: LongaLottoPosColor.black),
                                      textAlign: TextAlign.center,
                                    ).p(15),
                                  ),
                                ),
                              ],
                            ).pSymmetric(h: 16, v: 4),
                            Row(
                              children: [
                                // payments
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: LongaLottoPosColor.light_grey),
                                    child: Text(
                                      context.l10n.payments,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: LongaLottoPosColor.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ).p(15),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: LongaLottoPosColor.white),
                                    child: Text(
                                      balanceInvoiceData.payments ?? "-",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: LongaLottoPosColor.black),
                                      textAlign: TextAlign.center,
                                    ).p(15),
                                  ),
                                ),
                              ],
                            ).pSymmetric(h: 16, v: 4),
                            Row(
                              children: [
                                // payments
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: LongaLottoPosColor.light_grey),
                                    child: Text(
                                      context.l10n.debit_credit_txn,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: LongaLottoPosColor.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ).p(15),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: LongaLottoPosColor.white),
                                    child: Text(
                                      balanceInvoiceData.creditDebitTxn ?? "-",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: LongaLottoPosColor.black),
                                      textAlign: TextAlign.center,
                                    ).p(15),
                                  ),
                                ),
                              ],
                            ).pSymmetric(h: 16, v: 4),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextButton(
                                  style: ButtonStyle(
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              const EdgeInsets.only(
                                                  left: 40,
                                                  right: 40,
                                                  top: 12,
                                                  bottom: 12)),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: const BorderSide(color: Colors.red)))),

                                  onPressed: () {
                                    if (androidInfo?.model == "V2" || androidInfo?.model == "M1" || androidInfo?.model == "T2mini") {

                                      Map<String, dynamic> printingDataArgs = {};
                                      printingDataArgs["orgId"] = UserInfo.organisationID;
                                      printingDataArgs["orgName"] = UserInfo.organisation;
                                      printingDataArgs["toAndFromDate"] = "08-02-2023 to 08-02-2024";
                                      printingDataArgs["balanceInvoiceData"] = jsonEncode(balanceInvoiceData);
                                        printingDataArgs["reportHeaderName"] = context.l10n.balance_invoice_report;

                                      PrintingDialog().show(
                                          context: context,
                                          title: "Printing started",
                                          buttonText: 'Retry',
                                          isBalanceInvoiceReport:true,
                                          printingDataArgs: printingDataArgs,
                                          onPrintingDone: () {
                                            Navigator.pop(context);
                                          },
                                          onPrintingFailed: () {

                                          },
                                          isPrintingForSale: false);
                                    }

                                  },
                                  child: Text(context.l10n.print_cap, style: TextStyle(fontSize: 16, color: LongaLottoPosColor.white))),
                            ),
                          ],
                        ) else Expanded(
                          child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            context.l10n.no_data_available,
                            style: TextStyle(
                                color: LongaLottoPosColor.black_four
                                    .withOpacity(0.5)),
                          ).p(10),
                        )),
                ],
              ),
            ));
          } else if (state is BalanceInvoiceReportError) {
            return Container();
          }
          return Column(
            children: [
              Container(
                color: LongaLottoPosColor.white,
                // constraints: BoxConstraints(
                //   minHeight: context.screenHeight / 7,
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectDate(
                      title: context.l10n.from,
                      date: context.watch<SelectDateBloc>().fromDate,
                      onTap: () {
                        context.read<SelectDateBloc>().add(
                              PickFromDate(context: context),
                            );
                      },
                    ),
                    SelectDate(
                      title: context.l10n.to,
                      date: context.watch<SelectDateBloc>().toDate,
                      onTap: () {
                        context.read<SelectDateBloc>().add(
                              PickToDate(context: context),
                            );
                      },
                    ),
                    Forward(
                      onTap: () {
                        initData();
                      },
                    ),
                  ],
                ).pSymmetric(v: 16, h: 10),
              ),
            ],
          );
        })
      ],
    );
    return LongaScaffold(
      showAppBar: true,
      appBarTitle: context.l10n.balance_invoice_report,
      extendBodyBehindAppBar: true,
      body: RoundedContainer(child: body),
    );
  }

  String getDate(String? createdAt) {
    String fromDate = formatDate(
      date: createdAt.toString(),
      inputFormat: Format.apiDateFormat,
      outputFormat: Format.dateFormat,
    );
    List<String> splitag = fromDate.split(",");
    String? splitag1 = splitag[0];
    return splitag1;
  }

  String getTime(String? createdAt) {
    String fromDate = formatDate(
      date: createdAt.toString(),
      inputFormat: Format.apiDateFormat,
      outputFormat: Format.dateFormat,
    );
    List<String> splitag = fromDate.split(",");
    String? splitag2 = splitag[1];
    return splitag2;
  }

  initData() {
    BlocProvider.of<BalanceInvoiceReportBloc>(context)
        .add(GetBalanceInvoiceReportApiData(
      context: context,
      fromDate: formatDate(
        date: context.read<SelectDateBloc>().fromDate,
        inputFormat: Format.dateFormat9,
        outputFormat: Format.apiDateFormat3,
      ),
      toDate: formatDate(
        date: context.read<SelectDateBloc>().toDate,
        inputFormat: Format.dateFormat9,
        outputFormat: Format.apiDateFormat3,
      ),
    ));
  }
}
