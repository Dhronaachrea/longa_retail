import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/l10n/reportsExternalTranslation.dart';
import 'package:longalottoretail/lottery/widgets/printing_dialog.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/summarize_ledger_report/model/response/summarize_defalut_response.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:longalottoretail/utility/widgets/show_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';
import 'package:velocity_x/velocity_x.dart';
import '../home/widget/longa_scaffold.dart';
import '../utility/date_format.dart';
import '../utility/rounded_container.dart';
import '../utility/utils.dart';
import '../utility/widgets/selectdate/bloc/select_date_bloc.dart';
import '../utility/widgets/selectdate/forward.dart';
import '../utility/widgets/selectdate/select_date.dart';
import 'bloc/summarize_ledger_bloc.dart';
import 'bloc/summarize_ledger_event.dart';
import 'bloc/summarize_ledger_state.dart';

class SummarizeLedgerReportScreen extends StatefulWidget {
  const SummarizeLedgerReportScreen({Key? key}) : super(key: key);

  @override
  State<SummarizeLedgerReportScreen> createState() =>
      _SummarizeLedgerReportScreenState();
}

int selectedIndex = 0;

class _SummarizeLedgerReportScreenState
    extends State<SummarizeLedgerReportScreen> {
  String fromDate = formatDate(
    date: DateTime.now().subtract(const Duration(days: 30)).toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.dateFormat9,
  );
  String toDate = formatDate(
    date: DateTime.now().toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.dateFormat9,
  );
  String fromDateToPdf = formatDate(
    date: DateTime.now().subtract(const Duration(days: 30)).toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.dateFormat9,
  );

  String toDateToPdf = formatDate(
    date: DateTime.now().subtract(const Duration(days: 30)).toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.dateFormat9,
  );

  formatPrintDate(String date) {
    String printFormatDate = formatDate(
      date: date,
      inputFormat: Format.apiDateFormat3,
      outputFormat: Format.dateFormat9,
    );

    return printFormatDate;
  }

  pdfDateFormat(String date) {
    String printFormatDate = formatDate(
      date: date,
      inputFormat: Format.dateFormat9,
      outputFormat: Format.dateFormat7,
    );

    return printFormatDate;
  }

  @override
  Widget build(BuildContext context) {
    var body = BlocListener<SelectDateBloc, SelectDateState>(
      listener: (context, state) {
        if (state is DateUpdated) {
          print("----fromDate UI ---> ${state.fromDate}");
          print("-----toDate UI --> ${state.toDate}");
          setState(() {
            fromDate  = formatPrintDate(state.fromDate);
            toDate  = formatPrintDate(state.toDate);
          });
        }
      },
      child: Column(
        children: [
          Container(
            color: LongaLottoPosColor.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SelectDate(
                  title: context.l10n.from,
                  date: context
                      .watch<SelectDateBloc>()
                      .fromDate,
                  onTap: () {
                    context.read<SelectDateBloc>().add(
                      PickFromDate(context: context),
                    );
                  },
                ),
                SelectDate(
                  title: context.l10n.to,
                  date: context
                      .watch<SelectDateBloc>()
                      .toDate,
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  decoration: BoxDecoration(
                      border:
                      Border.all(color: LongaLottoPosColor.brownish_grey_six)),
                  alignment: Alignment.center,
                  child: DefaultTabController(
                    length: 2,
                    child: TabBar(
                      onTap: (int index) {
                        selectedIndex = index;
                        initData();
                      },
                      labelColor: LongaLottoPosColor.white_five,
                      unselectedLabelColor: LongaLottoPosColor.brownish_grey_six,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          0,
                        ),
                        color: LongaLottoPosColor.brownish_grey_six,
                      ),
                      tabs: [
                        Tab(
                          text: context.l10n.default_tab,
                        ),
                        Tab(
                          text: context.l10n.date_wise_tab,
                        )
                      ],
                    ),
                  )),
            ],
          ),
          Expanded(
            child: BlocConsumer<SummarizeLedgerBloc, SummarizeLedgerState>(
              listener: (context, state) {
                  if(state is SummarizeLedgerDateWiseError) {
                    ShowToast.showToast(context, state.errorMessage, type: ToastType.ERROR);
                  } else if(state is SummarizeLedgerDefaultSuccess){
                    fromDateToPdf = fromDate;
                    toDateToPdf = toDate;
                  }
              },
              builder: (context, state) {
                  if (state is SummarizeLedgerLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  else if (state is SummarizeLedgerDateWiseSuccess) {
                    var totalCredit = state.response.responseData?.data?.totalCredit;
                    var totalDebit = state.response.responseData?.data?.totalDebit;
                    return Column(
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
                        Container(
                          color: LongaLottoPosColor.light_dark_white,
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text(
                                context.l10n.opening_balance,
                                style: const TextStyle(
                                    color: LongaLottoPosColor.warm_grey_three,
                                    fontSize: 16),
                              ),
                              Text(
                                state.response.responseData?.data
                                    ?.openingBalance
                                    .toString() ??
                                    "",
                                style: TextStyle(color: LongaLottoPosColor.dark_green),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: state.response.responseData!.data!.ledgerData!
                                .isNotEmpty
                                ? ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: state.response.responseData!.data!
                                    .ledgerData!.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                const Divider(height: 5),
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${context.l10n.date} : ${state.response.responseData!
                                              .data!.ledgerData![index].date}",
                                          style: const TextStyle(
                                            color:
                                            LongaLottoPosColor.brownish_grey_six,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          getTranslatedString(context, state.response.responseData!.data!.ledgerData![index].txnData![0].serviceName ?? ""),
                                          style: const TextStyle(
                                              color: LongaLottoPosColor
                                                  .brownish_grey_six,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 20, 0, 0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    getTranslatedString(context, state.response.responseData!.data!.ledgerData![index].txnData![0].key1Name ?? ""),
                                                    style: TextStyle(
                                                        color: LongaLottoPosColor
                                                            .brownish_grey_six,
                                                        fontSize: 18),
                                                  ),
                                                  Text(
                                                    state
                                                        .response
                                                        .responseData!
                                                        .data!
                                                        .ledgerData![
                                                    index]
                                                        .txnData![0]
                                                        .key1 ??
                                                        "",
                                                    style: const TextStyle(
                                                        color: LongaLottoPosColor
                                                            .brownish_grey_six,
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    getTranslatedString(context, state.response.responseData!.data!.ledgerData![index].txnData![0].key2Name ?? ""),
                                                    style: const TextStyle(
                                                        color: LongaLottoPosColor
                                                            .brownish_grey_six,
                                                        fontSize: 18),
                                                  ),
                                                  Text(
                                                    state
                                                        .response
                                                        .responseData!
                                                        .data!
                                                        .ledgerData![
                                                    index]
                                                        .txnData![0]
                                                        .key2 ??
                                                        "",
                                                    style: const TextStyle(
                                                        color: LongaLottoPosColor
                                                            .brownish_grey_six,
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    context.l10n.net_amount,
                                                    style: const TextStyle(
                                                        color: LongaLottoPosColor
                                                            .brownish_grey_six,
                                                        fontSize: 18),
                                                  ),
                                                  Text(
                                                    state
                                                        .response
                                                        .responseData!
                                                        .data!
                                                        .ledgerData![
                                                    index]
                                                        .txnData![0]
                                                        .rawNetAmount ??
                                                        "",
                                                    style: const TextStyle(
                                                        color: LongaLottoPosColor
                                                            .brownish_grey_six,
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                })
                                : Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    context.l10n.no_data_available,
                                    style: TextStyle(
                                        color: LongaLottoPosColor.black_four
                                            .withOpacity(0.5)),
                                  ).p(10),
                                )
                        ),

                        Container(
                          color: LongaLottoPosColor.light_dark_white,
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.l10n.closing_balance,
                                style: const TextStyle(
                                    color: LongaLottoPosColor.warm_grey_three,
                                    fontSize: 16),
                              ),
                              Text(
                                state.response.responseData?.data
                                    ?.closingBalance
                                    .toString() ??
                                    "",
                                style: const TextStyle(color: LongaLottoPosColor.dark_green),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  else if (state is SummarizeLedgerDefaultSuccess) {

                    var totalCredit = state.response.responseData?.data?.totalCredit;
                    var totalDebit = state.response.responseData?.data?.totalDebit;

                    return Stack(
                      children: [
                        Column(
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
                            Container(
                              color: LongaLottoPosColor.light_dark_white,
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              padding: const EdgeInsets.all(10),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    context.l10n.opening_balance,
                                    style: const TextStyle(
                                        color: LongaLottoPosColor.warm_grey_three,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    state.response.responseData?.data
                                        ?.openingBalance
                                        .toString() ??
                                        "",
                                    style: TextStyle(color: LongaLottoPosColor.dark_green),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: state.response.responseData!.data!.ledgerData!
                                    .isNotEmpty
                                    ? ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: state.response.responseData!.data!
                                        .ledgerData!.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                    const Divider(height: 5),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 10),
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslatedString(context, state.response.responseData?.data?.ledgerData?[index].serviceName ?? ""),
                                              style: TextStyle(
                                                  color: LongaLottoPosColor
                                                      .brownish_grey_six,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 20, 0, 0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        getTranslatedString(context, state.response.responseData!.data!.ledgerData![index].key1Name ?? ""),
                                                        style: TextStyle(
                                                            color: LongaLottoPosColor
                                                                .brownish_grey_six,
                                                            fontSize: 18),
                                                      ),
                                                      Text(
                                                        getTranslatedString(context, state.response.responseData!.data!.ledgerData![index].key1 ?? ""),
                                                        style: TextStyle(
                                                            color: LongaLottoPosColor
                                                                .brownish_grey_six,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        getTranslatedString(context, state.response.responseData!.data!.ledgerData![index].key2Name ?? ""),
                                                        style: TextStyle(
                                                            color: LongaLottoPosColor
                                                                .brownish_grey_six,
                                                            fontSize: 18),
                                                      ),
                                                      Text(
                                                        state
                                                            .response
                                                            .responseData!
                                                            .data!
                                                            .ledgerData![
                                                        index]
                                                            .key2 ??
                                                            "",
                                                        style: TextStyle(
                                                            color: LongaLottoPosColor
                                                                .brownish_grey_six,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        context.l10n.net_amount,
                                                        style: TextStyle(
                                                            color: LongaLottoPosColor
                                                                .brownish_grey_six,
                                                            fontSize: 18),
                                                      ),
                                                      Text(
                                                        state
                                                            .response
                                                            .responseData!
                                                            .data!
                                                            .ledgerData![
                                                        index]
                                                            .netAmount ??
                                                            "",
                                                        style: TextStyle(
                                                            color: LongaLottoPosColor
                                                                .brownish_grey_six,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    })
                                    : Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        context.l10n.no_data_available,
                                        style: TextStyle(
                                            color: LongaLottoPosColor.black_four
                                                .withOpacity(0.5)),
                                      ).p(10),
                                    )),
                            Container(
                              color: LongaLottoPosColor.light_dark_white,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    context.l10n.closing_balance,
                                    style: const TextStyle(
                                        color: LongaLottoPosColor.warm_grey_three,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    state.response.responseData?.data
                                        ?.closingBalance
                                        .toString() ??
                                        "",
                                    style: TextStyle(color: LongaLottoPosColor.dark_green),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        state.response.responseData?.data?.ledgerData?.isNotEmpty == true
                            ? Positioned(
                          bottom: 60,
                          right: 20,
                          child: InkWell(
                            onTap: () async {
                              if (androidInfo?.model == "V2" || androidInfo?.model == "M1" || androidInfo?.model == "T2mini" || androidInfo?.model.toLowerCase()=="m1k_go") {

                                Map<String, dynamic> printingDataArgs = {};
                                printingDataArgs["userName"] = UserInfo.organisationID;
                                printingDataArgs["userId"] = UserInfo.userId;
                                printingDataArgs["currencyCode"] = getDefaultCurrency(getLanguage());
                                printingDataArgs["toAndFromDate"] = "${fromDate} to ${toDate}";
                                printingDataArgs["summarizeReport"] = jsonEncode(state.response);
                                printingDataArgs["languageCode"] = LongaLottoRetailApp.of(context).locale.languageCode;

                                PrintingDialog().show(
                                    context: context,
                                    title: "Printing started",
                                    isRetryButtonAllowed: true,
                                    buttonText: 'Retry',
                                    printingDataArgs: printingDataArgs,
                                    isSummarizeReport: true,
                                    onPrintingDone: () {
                                      Navigator.pop(context);
                                      //BlocProvider.of<LoginBloc>(context).add(GetLoginDataApi(context: context));
                                    },
                                    onPrintingFailed: () {
                                      Navigator.pop(context);
                                      /*if (couponCodeVar.isNotEmptyAndNotNull) {
                                        //BlocProvider.of<DepositBloc>(context).add(CouponReversalApi(context: context, couponCode: couponCodeVar));

                                      } else {
                                        Navigator.pop(context);
                                      }*/

                                      //Navigator.pop(context);
                                    },
                                    isPrintingForSale: false);

                              }
                              else {
                                final pdf = pdfLib.Document();
                                final img = await rootBundle.load('assets/images/pdf_logo.webp');
                                final imageBytes = img.buffer.asUint8List();
                                pdfLib.Image logoImage = pdfLib.Image(pdfLib.MemoryImage(imageBytes));
                                final boldTtf = pdfLib.Font.ttf(await rootBundle.load('assets/fonts/roboto/Roboto-Bold.ttf'));
                                final mediumTtf = pdfLib.Font.ttf(await rootBundle.load('assets/fonts/roboto/Roboto-Medium.ttf'));
                                final regularTtf = pdfLib.Font.ttf(await rootBundle.load('assets/fonts/roboto/Roboto-Regular.ttf'));
                                List<LedgerData>? ledgerData = state.response.responseData!.data!.ledgerData;
                                if(ledgerData != null && ledgerData.isNotEmpty){
                                  List<pdfLib.TableRow> listItemTableRow = ledgerData.mapIndexed((ledgerDataItem, index) => pdfLib.TableRow(
                                    children: [
                                      pdfLib.Expanded(
                                        flex: 1,
                                        child: pdfLib.Container(
                                          padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                          child: pdfLib.Text(
                                            getTranslatedString(context, ledgerDataItem.serviceName ?? emptyValueText),
                                            textAlign: pdfLib.TextAlign.left,
                                            style: pdfLib.TextStyle(
                                              fontSize: pdfHeadingTextSize,
                                              font: boldTtf,
                                            ),
                                          ),
                                        ),
                                      ),
                                      pdfLib.Expanded(
                                        flex: 1,
                                        child: pdfLib.Container(
                                          padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                          child: pdfLib.Text(
                                            getTranslatedString(context, ledgerDataItem.key1 ?? emptyValueText),
                                            textAlign: pdfLib.TextAlign.right,
                                            style: pdfLib.TextStyle(
                                              fontSize: 14,
                                              font: boldTtf,
                                            ),
                                          ),
                                        ),
                                      ),
                                      pdfLib.Expanded(
                                        flex: 1,
                                        child: pdfLib.Container(
                                          padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                          child: pdfLib.Text(
                                            getTranslatedString(context, ledgerDataItem.key2 ?? emptyValueText),
                                            textAlign: pdfLib.TextAlign.right,
                                            style: pdfLib.TextStyle(
                                              fontSize: 14,
                                              font: boldTtf,
                                            ),
                                          ),
                                        ),
                                      ),
                                      pdfLib.Expanded(
                                        flex: 1,
                                        child: pdfLib.Container(
                                          padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                          child: pdfLib.Text(
                                            getTranslatedString(context, ledgerDataItem.netAmount ?? emptyValueText),
                                            textAlign: pdfLib.TextAlign.right,
                                            style: pdfLib.TextStyle(
                                              fontSize: 14,
                                              font: boldTtf,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )).toList();
                                  listItemTableRow .insert(0, pdfLib.TableRow(
                                    children: [
                                      pdfLib.Expanded(
                                        flex: 1,
                                        child: pdfLib.Container(
                                          color: pdfTotalBackgroundColor,
                                          padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                          child: pdfLib.Text(
                                            context.l10n.total,
                                            textAlign: pdfLib.TextAlign.left,
                                            style: pdfLib.TextStyle(
                                              fontSize: pdfTotalTextSize,
                                              font: boldTtf,
                                            ),
                                          ),
                                        ),
                                      ),
                                      pdfLib.Expanded(
                                        flex: 1,
                                        child: pdfLib.Container(
                                          color: pdfTotalBackgroundColor,
                                          padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                          child: pdfLib.Text(
                                            getTotalCreditOrWinning(ledgerData),
                                            textAlign: pdfLib.TextAlign.right,
                                            style: pdfLib.TextStyle(
                                              fontSize: pdfTotalTextSize,
                                              font: boldTtf,
                                            ),
                                          ),
                                        ),
                                      ),
                                      pdfLib.Expanded(
                                        flex: 1,
                                        child: pdfLib.Container(
                                          color: pdfTotalBackgroundColor,
                                          padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                          child: pdfLib.Text(
                                            getTotalDebitOrSale(ledgerData),
                                            textAlign: pdfLib.TextAlign.right,
                                            style: pdfLib.TextStyle(
                                              fontSize: pdfTotalTextSize,
                                              font: boldTtf,
                                            ),
                                          ),
                                        ),
                                      ),
                                      pdfLib.Expanded(
                                        flex: 1,
                                        child: pdfLib.Container(
                                          color: pdfTotalBackgroundColor,
                                          padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                          child: pdfLib.Text(
                                            getTotalNetAmount(ledgerData),
                                            textAlign: pdfLib.TextAlign.right,
                                            style: pdfLib.TextStyle(
                                              fontSize: pdfTotalTextSize,
                                              font: boldTtf,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),);
                                  listItemTableRow .insert(0, pdfLib.TableRow(
                                    children: [
                                      pdfLib.Expanded(
                                        flex: 1,
                                        child: pdfLib.Container(
                                          padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                          color : pdfHeadingBackgroundColor,
                                          child: pdfLib.Center(
                                            child: pdfLib.Text(
                                              context.l10n.service,
                                              style: pdfLib.TextStyle(
                                                fontSize: pdfHeadingTextSize,
                                                font: boldTtf,
                                                color: pdfHeadingTextColor,
                                              ),
                                            ),
                                          ),
                                        ),),
                                      pdfLib.Expanded(
                                        flex: 1,
                                        child: pdfLib.Container(
                                          padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                          color : pdfHeadingBackgroundColor,
                                          child: pdfLib.Center(
                                            child: pdfLib.Text(
                                              "${context.l10n.credit}/${context.l10n.winning}",
                                              style: pdfLib.TextStyle(
                                                fontSize: pdfHeadingTextSize,
                                                font: boldTtf,
                                                color: pdfHeadingTextColor,
                                              ),
                                            ),
                                          ),
                                        ),),
                                      pdfLib.Expanded(
                                        flex: 1,
                                        child: pdfLib.Container(
                                          padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                          color : pdfHeadingBackgroundColor,
                                          child: pdfLib.Center(
                                            child: pdfLib.Text(
                                              "${context.l10n.debit}/${context.l10n.sale}",
                                              style: pdfLib.TextStyle(
                                                fontSize: pdfHeadingTextSize,
                                                font: boldTtf,
                                                color: pdfHeadingTextColor,
                                              ),
                                            ),
                                          ),
                                        ),),
                                      pdfLib.Expanded(
                                        flex: 1,
                                        child: pdfLib.Container(
                                          padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                          color : pdfHeadingBackgroundColor,
                                          child: pdfLib.Center(
                                            child: pdfLib.Text(
                                              context.l10n.net_amount,
                                              style: pdfLib.TextStyle(
                                                fontSize: pdfHeadingTextSize,
                                                font: boldTtf,
                                                color: pdfHeadingTextColor,
                                              ),
                                            ),
                                          ),
                                        ),),
                                    ],
                                  ),);
                                 pdf.addPage(
                                      pdfLib.Page(
                                          pageFormat: PdfPageFormat.a4,
                                          build: (pdfLib.Context pdfContext)  {
                                              return pdfLib.Column(
                                                children: [
                                                  pdfLib.Container(
                                                    child: pdfLib.Row(
                                                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                                                        children: [
                                                          pdfLib.Column (
                                                            mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                                                            mainAxisSize: pdfLib.MainAxisSize.min,
                                                            crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                                                            children: [
                                                              pdfLib.Text(context.l10n.summarize_ledger_report.toUpperCase(), style: pdfLib.TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: pdfLib.FontWeight.bold,
                                                                font: boldTtf,
                                                              ),
                                                              ),
                                                              pdfLib.Text("${pdfDateFormat(fromDateToPdf)} - ${pdfDateFormat(toDateToPdf)}", style: pdfLib.TextStyle(
                                                                fontSize: 14,
                                                                font: mediumTtf,
                                                              ),),
                                                            ],
                                                          ),
                                                          pdfLib.Container(
                                                            width: 150,
                                                            height: 70,
                                                            child:logoImage,
                                                          ),
                                                        ]
                                                    ),
                                                  ),
                                                  pdfLib.Container(height: 20),
                                                  pdfLib.Container(
                                                    //padding: const pdfLib.EdgeInsets.all(5),
                                                      width: double.infinity,
                                                      child: pdfLib.Table(
                                                        border: pdfLib.TableBorder.all(color: PdfColors.black, width: tableBorderWidth),
                                                        children: [
                                                          pdfLib.TableRow(
                                                            children: [
                                                              pdfLib.Expanded(
                                                                flex: 1,
                                                                child: pdfLib.Container(
                                                                  padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                                                  color : pdfHeadingBackgroundColor,
                                                                  child: pdfLib.Center(
                                                                    child: pdfLib.Text(
                                                                      context.l10n.opening_balance,
                                                                      style: pdfLib.TextStyle(
                                                                        fontSize: pdfHeadingTextSize,
                                                                        font: boldTtf,
                                                                        color: pdfHeadingTextColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),),
                                                              pdfLib.Expanded(
                                                                flex: 1,
                                                                child: pdfLib.Container(
                                                                  padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                                                  color : pdfHeadingBackgroundColor,
                                                                  child: pdfLib.Center(
                                                                    child: pdfLib.Text(
                                                                      context.l10n.closing_balance,
                                                                      style: pdfLib.TextStyle(
                                                                        fontSize: pdfHeadingTextSize,
                                                                        font: boldTtf,
                                                                        color: pdfHeadingTextColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          pdfLib.TableRow(
                                                            children: [
                                                              pdfLib.Expanded(
                                                                flex: 1,
                                                                child: pdfLib.Container(
                                                                  padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                                                  child: pdfLib.Center(
                                                                    child: pdfLib.Text(
                                                                      state.response.responseData?.data
                                                                          ?.openingBalance
                                                                          .toString() ??
                                                                          emptyValueText,
                                                                      style: pdfLib.TextStyle(
                                                                        fontSize: 14,
                                                                        font: boldTtf,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              pdfLib.Expanded(
                                                                flex: 1,
                                                                child:pdfLib.Container(
                                                                  padding: const pdfLib.EdgeInsets.all(pdfCellPadding),
                                                                  child: pdfLib.Center(
                                                                      child:pdfLib.Text(
                                                                        state.response.responseData?.data
                                                                            ?.closingBalance
                                                                            .toString() ??
                                                                            emptyValueText,
                                                                        style: pdfLib.TextStyle(
                                                                          fontSize: 14,
                                                                          font: boldTtf,
                                                                        ),
                                                                      )
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                  ),
                                                  pdfLib.Container(height: 30),
                                                  pdfLib.Container(
                                                    child: pdfLib.Table(
                                                      border: pdfLib.TableBorder.all(color: PdfColors.black, width: tableBorderWidth),
                                                      children: listItemTableRow,
                                                    ),
                                                  )
                                                ],
                                              );
                                          }
                                      )
                                  );
                                }
                                // Get the app's documents directory
                                final appDocDir = await getDownloadsDirectory();
                                // Generate a unique filename with a timestamp
                                final timestamp = DateTime.now().millisecondsSinceEpoch;
                                final fileName = 'summarize_ledger_rep_$timestamp.pdf';
                                // Specify the file path for the PDF
                                final pdfPath = "${appDocDir?.path}/$fileName";
                                // Print the PDF to a physical printer
                                await Printing.layoutPdf(
                                  onLayout: (PdfPageFormat format) async => pdf.save(),);

                                log("PDF saved to: $pdfPath");
                              }

                            },
                            child: Container(
                              width:50,
                              height:50,
                              decoration: BoxDecoration(
                                  color: LongaLottoPosColor.light_golden_rod,
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              child: const Icon(Icons.print),
                            ),
                          ),
                        )
                            : Container()
                      ],
                    );
                  }
                  else if (state is SummarizeLedgerDateWiseError) {
                    return Container();
                  }
                  return Container();
                }),
          )
        ],
      ),
    ) ;
    return LongaScaffold(
      showAppBar: true,
      appBarTitle: context.l10n.summarize_ledger_report,
      extendBodyBehindAppBar: true,
      body: RoundedContainer(child: body),
    );

  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    BlocProvider.of<SummarizeLedgerBloc>(context).add(SummarizeLedgerModel(
      url: "",
      type: selectedIndex == 0 ? "default" : "datewise",
      context: context,
      startDate: formatDate(
        date: context
            .read<SelectDateBloc>()
            .fromDate,
        inputFormat: Format.dateFormat9,
        outputFormat: Format.apiDateFormat3,
      ),
      endDate: formatDate(
        date: context
            .read<SelectDateBloc>()
            .toDate,
        inputFormat: Format.dateFormat9,
        outputFormat: Format.apiDateFormat3,
      ),
    ));
  }

  String getTotalCreditOrWinning(List<LedgerData> ledgerData) {
    double key1Value = 0.0;
    for(LedgerData item in ledgerData){
      String? dotKey1 = item.key1?.replaceAll(",", ".");
      String? trimmedKey1 =  dotKey1?.replaceAll(RegExp(r'[^\d.-]'), ''); // Remove non-numeric characters;
      double decimalKey1 = double.parse(trimmedKey1??'0');
      key1Value += decimalKey1;
    }
    String key1ValueString = key1Value.toString();
    return (key1ValueString.replaceAll(".", ","));
  }

  String getTotalDebitOrSale(List<LedgerData> ledgerData) {
    double key2Value = 0.0;
    for(LedgerData item in ledgerData){
      String? dotKey2 = item.key2?.replaceAll(",", ".");
      String? trimmedKey2 =  dotKey2?.replaceAll(RegExp(r'[^\d.-]'), ''); // Remove non-numeric characters;
      double decimalKey2 = double.parse(trimmedKey2??'0');
      key2Value += decimalKey2;
    }
    String key2ValueString = key2Value.toString();
    return (key2ValueString.replaceAll(".", ","));

  }

  String getTotalNetAmount(List<LedgerData> ledgerData) {
    double netAmountValue = 0.0;
    for(LedgerData item in ledgerData){
      String? dotNetAmount = item.netAmount?.replaceAll(",", ".");
      String? trimmedNetAmount =  dotNetAmount?.replaceAll(RegExp(r'[^\d.-]'), '');
      double decimalNetAmount = double.parse(trimmedNetAmount??'0');
      netAmountValue += decimalNetAmount;
    }
    String netAmountValueString = netAmountValue.toString();
    return (netAmountValueString.replaceAll(".", ","));
  }
}
