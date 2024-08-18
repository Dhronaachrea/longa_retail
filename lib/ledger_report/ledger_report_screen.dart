import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/l10n/reportsExternalTranslation.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/widgets/show_snackbar.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utility/date_format.dart';
import '../utility/rounded_container.dart';
import '../utility/utils.dart';
import '../utility/widgets/selectdate/bloc/select_date_bloc.dart';
import '../utility/widgets/selectdate/forward.dart';
import '../utility/widgets/selectdate/select_date.dart';
import 'bloc/ledger_report_bloc.dart';
import 'bloc/ledger_report_event.dart';
import 'bloc/ledger_report_state.dart';
import 'models/response/ledgerReportApiResponse.dart';


class LedgerReportScreen extends StatefulWidget {
  const LedgerReportScreen({Key? key}) : super(key: key);

  @override
  _LedgerReportState createState() => _LedgerReportState();
}

class _LedgerReportState extends State<LedgerReportScreen> {
  @override
  void initState() {
    BlocProvider.of<LedgerReportBloc>(context).add(GetLedgerReportApiData(
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
        BlocConsumer<LedgerReportBloc, LedgerReportState>(
          listener: (context, state) {
              if (state is LedgerReportError) {
                ShowToast.showToast(context, state.errorMessage, type: ToastType.ERROR);
              }
          },
          builder: (context, state) {
          if (state is LedgerReportLoading) {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ).p(10);
          }
          else if (state is LedgerReportSuccess) {
            LedgerReportApiResponse ledgerReportApiResponse =
                state.ledgerReportApiResponse;
            List<Transaction>? transList =
                ledgerReportApiResponse.responseData!.data!.transaction;
            String? closingBalance = state.ledgerReportApiResponse.responseData!
                .data!.balance!.closingBalance;
            String? openingBalance = state.ledgerReportApiResponse.responseData!
                .data!.balance!.openingBalance;
            String? totalCredit = state.ledgerReportApiResponse.responseData!
                .data!.balance!.totalCredit;
            String? totalDebit = state.ledgerReportApiResponse.responseData!
                .data!.balance!.totalDebit;
            return Expanded(
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
                          Text(openingBalance!,
                                  style: const TextStyle(
                                      color: LongaLottoPosColor.shamrock_green))
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
                          Text(closingBalance!,
                                  style: TextStyle(
                                      color: LongaLottoPosColor.shamrock_green))
                              .pOnly(bottom: 10)
                        ],
                      ),
                    ],
                  ).pOnly(left: 25, right: 25),
                ),
                transList!.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: transList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 70,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        alignment: Alignment.center,
                                        color: LongaLottoPosColor.light_grey
                                            .withOpacity(0.5),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                    getDate(transList[index]
                                                        .createdAt),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            LongaLottoPosColor
                                                                .black
                                                                .withOpacity(
                                                                    0.5),
                                                        fontSize: 14))
                                                .pOnly(bottom: 2),
                                            Text(
                                              getTime(
                                                  transList[index].createdAt),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: LongaLottoPosColor
                                                      .black_four
                                                      .withOpacity(0.5)),
                                            ),
                                          ],
                                        ).pOnly(left: 15, right: 15),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                    transList[index]
                                                                .serviceDisplayName !=
                                                            null
                                                        ? getTranslatedString(context, transList[index].serviceDisplayName ?? "")
                                                        : '',
                                                    style: const TextStyle(
                                                        color:
                                                            LongaLottoPosColor
                                                                .black))
                                                .pOnly(bottom: 10),
                                            Text(
                                              "${getTranslatedString(context, transList[index].particular!.split(":")[0].trim().toUpperCase())} ${transList[index].particular!.split(transList[index].particular!.split(":")[0].trim())[1]}",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: LongaLottoPosColor
                                                      .black_four
                                                      .withOpacity(0.5),
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      ).pOnly(left: 5, right: 5),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(transList[index].amount!,
                                                    style: TextStyle(
                                                        color: transList[index]
                                                                    .transactionMode ==
                                                                'Dr.'
                                                            ? LongaLottoPosColor
                                                                .tomato
                                                            : LongaLottoPosColor
                                                                .shamrock_green,
                                                        fontWeight:
                                                            FontWeight.bold))
                                                .pOnly(bottom: 10),
                                            Text(context.l10n.bal_amt,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: LongaLottoPosColor
                                                        .black_four
                                                        .withOpacity(0.4))),
                                            FittedBox(
                                              child: Text(
                                                  transList[index]
                                                      .availableBalance!,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: LongaLottoPosColor
                                                          .black_four
                                                          .withOpacity(0.6))),
                                            ),
                                          ],
                                        ).pOnly(right: 15),
                                      )
                                    ],
                                  ),
                                  Container(
                                      child: Divider(
                                    height: 2,
                                    // color: Colors.blue,
                                  ))
                                ],
                              );
                            }))
                    : Expanded(
                        child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          context.l10n.no_data_available,
                          style: TextStyle(
                              color: LongaLottoPosColor.black_four
                                  .withOpacity(0.5)),
                        ).p(10),
                      )),
                Container(
                  color: LongaLottoPosColor.pale_grey_four,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "${context.l10n.total} ${context.l10n.credit}",
                            style: TextStyle(
                                color: LongaLottoPosColor.black_four
                                    .withOpacity(0.5)),
                          ).p(10),
                          Text(totalCredit ?? "0",
                              style: const TextStyle(
                                  color: LongaLottoPosColor.shamrock_green))
                              .pOnly(bottom: 10)
                        ],
                      ),
                      Column(
                        children: [
                          Text("${context.l10n.total} ${context.l10n.debit}",
                              style: TextStyle(
                                  color: LongaLottoPosColor.black_four
                                      .withOpacity(0.5)))
                              .p(10),
                          Text(totalDebit ?? '0',
                              style: const TextStyle(
                                  color: LongaLottoPosColor.shamrock_green))
                              .pOnly(bottom: 10)
                        ],
                      ),
                    ],
                  ).pOnly(left: 25, right: 25),
                ),
              ],
            ));
          }
          else if (state is LedgerReportError) {
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
            ],
          );
        })
      ],
    );
    return LongaScaffold(
      showAppBar: true,
      appBarTitle: context.l10n.ledger_report,
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
    BlocProvider.of<LedgerReportBloc>(context).add(GetLedgerReportApiData(
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
