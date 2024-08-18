import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/l10n/reportsExternalTranslation.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:velocity_x/velocity_x.dart';

import '../home/widget/longa_scaffold.dart';
import '../utility/date_format.dart';
import '../utility/rounded_container.dart';
import '../utility/utils.dart';
import '../utility/widgets/selectdate/bloc/select_date_bloc.dart';
import '../utility/widgets/selectdate/forward.dart';
import '../utility/widgets/selectdate/select_date.dart';
import '../utility/widgets/show_snackbar.dart';
import 'bloc/sale_win_bloc.dart';
import 'bloc/sale_win_event.dart';
import 'bloc/sale_win_state.dart';
import 'model/get_sale_report_response.dart';
import 'model/get_service_list_response.dart';

class SaleWinTransactionReport extends StatefulWidget {
  const SaleWinTransactionReport({Key? key}) : super(key: key);

  @override
  State<SaleWinTransactionReport> createState() =>
      _SaleWinTransactionReportState();
}

bool _saleListLoading = true;
bool _saleWinTransactionLoading = true;
List<Data> _data = [];

class _SaleWinTransactionReportState extends State<SaleWinTransactionReport> {
  String _selectedItem = "";
  String _selectedItemForApiCall = "";
  String serviceCode = "";
  String? totalCredit;
  String? totalDebit;

  final List<String> _picGroup = [];

  late GetSaleReportResponse transactionResponse = GetSaleReportResponse();
  late List<TransactionData> mTransactionList = [];

  String mErrorString = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<SaleWinBloc>(context)
          .add(SaleList(context: context, url: ""));
    });
  }

  @override
  Widget build(BuildContext context) {
    var body = BlocListener<SaleWinBloc, SaleWinState>(
        listener: (context, state) {
          if (state is SaleListLoading) {
            setState(() {
              _saleListLoading = true;
            });
          } else if (state is SaleListError) {
            setState(() {
              _saleListLoading = false;
            });
            ShowToast.showToast(context, state.errorMessage.toString(),
                type: ToastType.ERROR);
          } else if (state is SaleListSuccess) {
            setState(() {
              _saleListLoading = false;
              _data = state.response.responseData!.data!;

              for (var element in _data) {
                _picGroup.add(getTranslatedString(context, element.serviceDisplayName ?? ""));
              }

              _selectedItem = getTranslatedString(context, _data[0].serviceDisplayName ?? "");
              _selectedItemForApiCall = getSelectedItemForApi(_data[0].serviceDisplayName ?? "");

              initData();
            });
          } else if (state is SaleWinTaxListLoading) {
            setState(() {
              _saleWinTransactionLoading = true;
            });
          } else if (state is SaleWinTaxListError) {
            ShowToast.showToast(context, state.errorMessage,
                type: ToastType.ERROR);
            mTransactionList = [];
            mErrorString = state.errorMessage;
            setState(() {
              _saleWinTransactionLoading = false;
            });
          } else if (state is SaleWinTaxListSuccess) {
            setState(() {
              mTransactionList = [];
              _saleWinTransactionLoading = false;
              transactionResponse = state.response;
              mTransactionList = transactionResponse.responseData!.data!.transactionData!;
              /*totalCredit = state.response.responseData?.data?.totalCredit;
              totalDebit = state.response.responseData?.data?.totalDebit;*/
            });
          }
        },
        child: _data.isNotEmpty
            ? Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    )),
                    margin: const EdgeInsets.all(18),
                    child: SizedBox(
                      height: 48,
                      child: Container(
                        child: DropdownButtonFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                            ),
                            isExpanded: true,
                            isDense: true,
                            value: _selectedItem,
                            selectedItemBuilder: (BuildContext context) {
                              return _picGroup.map<Widget>((String item) {
                                return DropdownMenuItem(
                                    value: item, child: Text(item));
                              }).toList();
                            },
                            items: _picGroup.map((item) {
                              if (item == _selectedItem) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Container(
                                      height: 48.0,
                                      width: double.infinity,
                                      color:
                                          LongaLottoPosColor.light_dark_white,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          item,
                                        ),
                                      )),
                                );
                              } else {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }
                            }).toList(),
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Cannot Empty' : null,
                            onChanged: (item) => {
                              _selectedItem = item!,
                              _selectedItemForApiCall = getSelectedItemForApi(item)
                            }),
                      ),
                    ),
                  ).pSymmetric(v: 5, h: 5),
                  Row(
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
                  ),
                  !_saleWinTransactionLoading
                    ? mTransactionList.isNotEmpty
                        ? !_saleWinTransactionLoading
                            ? Expanded(
                            child: Column(
                              children: [
                                Container(
                                  color: LongaLottoPosColor.warm_grey,
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: mTransactionList.isNotEmpty
                                      ? Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              context.l10n.total_sale,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: LongaLottoPosColor
                                                      .black_four),
                                            ),
                                            Text(
                                                transactionResponse
                                                    .responseData
                                                    ?.data
                                                    ?.total
                                                    ?.sumOfSale
                                                    ?.toString() ??
                                                    "",
                                                style: const TextStyle(
                                                    color: LongaLottoPosColor
                                                        .shamrock_green)).pOnly(top: 4)
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              context.l10n.total_winning,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: LongaLottoPosColor
                                                      .black_four),
                                            ),
                                            Text(
                                                transactionResponse
                                                    .responseData
                                                    ?.data
                                                    ?.total
                                                    ?.sumOfWinning
                                                    ?.toString() ??
                                                    "",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: LongaLottoPosColor
                                                        .shamrock_green)).pOnly(top: 4)
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              context.l10n.net_amount,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: LongaLottoPosColor
                                                      .black_four),
                                            ),
                                            Text(
                                                transactionResponse
                                                    .responseData
                                                    ?.data
                                                    ?.total
                                                    ?.netSale
                                                    ?.toString() ??
                                                    "",
                                                style: TextStyle(
                                                  color: double.parse(transactionResponse
                                                      .responseData
                                                      ?.data
                                                      ?.total
                                                      ?.rawNetSale ??
                                                      "0.0") >
                                                      0.0
                                                      ? LongaLottoPosColor
                                                      .shamrock_green
                                                      : LongaLottoPosColor
                                                      .tomato,
                                                )).pOnly(top: 4)
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              context.l10n.total_comm,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: LongaLottoPosColor
                                                      .black_four),
                                            ),
                                            Text(
                                                transactionResponse
                                                    .responseData
                                                    ?.data
                                                    ?.total
                                                    ?.rawNetCommission
                                                    ?.toString() ??
                                                    "",
                                                style: const TextStyle(
                                                    color: LongaLottoPosColor
                                                        .shamrock_green)).pOnly(top: 4)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ).pOnly(left: 15, right: 15)
                                      : Container(),
                                ),
                                if (mTransactionList.isNotEmpty ?? false)
                                  Expanded(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount: mTransactionList.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Container(
                                                      height: 100,
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.25,
                                                      alignment: Alignment.center,
                                                      color: LongaLottoPosColor
                                                          .light_grey
                                                          .withOpacity(0.5),
                                                      child: Column(
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: [
                                                          Text(
                                                              getDate(mTransactionList[
                                                              index]
                                                                  .createdAt),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  color: LongaLottoPosColor
                                                                      .black
                                                                      .withOpacity(
                                                                      0.5),
                                                                  fontSize: 14))
                                                              .pOnly(bottom: 2),
                                                          Text(
                                                            getTime(
                                                                mTransactionList[
                                                                index]
                                                                    .createdAt),
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                LongaLottoPosColor
                                                                    .black_four
                                                                    .withOpacity(
                                                                    0.5)),
                                                          ),
                                                        ],
                                                      ).pOnly(left: 15, right: 15),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.5,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text("${getTranslatedString(context, mTransactionList[index].txnTypeCode ?? "")} : ${mTransactionList[index].gameName ?? ""}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                                  color:
                                                                  LongaLottoPosColor
                                                                      .black))
                                                              .pOnly(bottom: 10),
                                                          Text(
                                                            "${context.l10n.user_id} : ${mTransactionList[index].userId ?? ""}",
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                color:
                                                                LongaLottoPosColor
                                                                    .black_four
                                                                    .withOpacity(
                                                                    0.5),
                                                                fontStyle: FontStyle
                                                                    .italic,
                                                                fontSize: 14),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                          ),
                                                          Text(
                                                            "${context.l10n.transaction_id} : ${mTransactionList[index].txnId ?? ""}",
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                color:
                                                                LongaLottoPosColor
                                                                    .black_four
                                                                    .withOpacity(
                                                                    0.5),
                                                                fontStyle: FontStyle
                                                                    .italic,
                                                                fontSize: 14),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                          ),
                                                          Text(
                                                            "${context.l10n.comm_amt} : ${mTransactionList[index].orgCommValue ?? ""}",
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                color:
                                                                LongaLottoPosColor
                                                                    .black_four
                                                                    .withOpacity(
                                                                    0.5),
                                                                fontStyle: FontStyle
                                                                    .italic,
                                                                fontSize: 14),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ).pOnly(left: 5, right: 5),
                                                    Container(
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.2,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                              mTransactionList[
                                                              index]
                                                                  .txnValue ??
                                                                  "",
                                                              style: TextStyle(
                                                                  color: (mTransactionList[index].txnTypeCode ??
                                                                      "") ==
                                                                      "Sale"
                                                                      ? LongaLottoPosColor
                                                                      .tomato
                                                                      : LongaLottoPosColor
                                                                      .shamrock_green,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                              .pOnly(bottom: 10),
                                                          Text(context.l10n.balance,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: LongaLottoPosColor
                                                                      .black_four
                                                                      .withOpacity(
                                                                      0.4))),
                                                          FittedBox(
                                                            child: Text(
                                                                mTransactionList[
                                                                index]
                                                                    .orgNetAmount ??
                                                                    "",
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: LongaLottoPosColor
                                                                        .black_four
                                                                        .withOpacity(
                                                                        0.6))),
                                                          ),
                                                        ],
                                                      ).pOnly(right: 15),
                                                    )
                                                  ],
                                                ),
                                                Container(
                                                    child: const Divider(
                                                      height: 2,
                                                      // color: Colors.blue,
                                                    ))
                                              ],
                                            );
                                          }))
                                else
                                  Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          mErrorString,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: LongaLottoPosColor.black_four
                                                  .withOpacity(0.5)),
                                        ).p(10),
                                      )),

                              ],
                            ))
                            : Expanded(
                                child: Container(
                          alignment: Alignment.center,
                          child: const Expanded(
                              child:
                              Center(child: CircularProgressIndicator())),
                        )
                              )

                        : Expanded(
                            child: Container(color: Colors.white, child: Center(child: Text(mErrorString, textAlign: TextAlign.center, style: TextStyle(color: LongaLottoPosColor.black.withOpacity(0.6)))),).pOnly(top: 16)
                          )
                  :  Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: const Expanded(
                            child:
                            Center(child: CircularProgressIndicator())),
                      ).p(16)
                  )

                ],
              )
            : _saleListLoading
                ? Expanded(
                    child: Container(
                    alignment: Alignment.center,
                    child: const Expanded(
                        child: Center(child: CircularProgressIndicator())),
                  ))
                : Expanded(
                    child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      context.l10n.no_data_available,
                      style: TextStyle(
                          color:
                              LongaLottoPosColor.black_four.withOpacity(0.5)),
                    ).p(10),
                  ))

    );

    return LongaScaffold(
      showAppBar: true,
      appBarTitle: context.l10n.sale_win_txn_report,
      extendBodyBehindAppBar: true,
      body: RoundedContainer(child: body),
    );
  }

  initData() {
    log("_selectedItemForApiCall -- $_selectedItemForApiCall");
    for (var element in _data) {
      if (element.serviceDisplayName == _selectedItemForApiCall) {
        setState(() {
          serviceCode = element.serviceCode!;
        });
        break;
      }
    }
    log("_selectedItemForApiCall -serviceCode- $serviceCode");

    BlocProvider.of<SaleWinBloc>(context).add(SaleWinTxnReport(
      context: context,
      serviceCode: serviceCode,
      startDate: formatDate(
        date: context.read<SelectDateBloc>().fromDate,
        inputFormat: Format.dateFormat9,
        outputFormat: Format.apiDateFormat3,
      ),
      endDate: formatDate(
        date: context.read<SelectDateBloc>().toDate,
        inputFormat: Format.dateFormat9,
        outputFormat: Format.apiDateFormat3,
      ),
    ));
  }

  String getDate(String? createdAt) {
    String fromDate = formatDate(
      date: createdAt!,
      inputFormat: Format.apiDateFormat,
      outputFormat: Format.dateFormat,
    );
    List<String> splitag = fromDate.split(",");
    String? splitag1 = splitag[0];
    return splitag1;
  }

  String getTime(String? createdAt) {
    String fromDate = formatDate(
      date: createdAt!,
      inputFormat: Format.apiDateFormat,
      outputFormat: Format.dateFormat,
    );
    List<String> splitag = fromDate.split(",");
    String? splitag2 = splitag[1];
    return splitag2;
  }

  String getSelectedItemForApi(String item) {
    if (item == "Jeu de tirage au sort") {
      return "Draw Game";

    } else if (item == "JOUEUR ET GESTION") {
      return "Player And Management";

    } else if (item == "PAIEMENTS AU DÉTAIL") {
      return "Retail Payments";
    }
    return item;

  }
}
