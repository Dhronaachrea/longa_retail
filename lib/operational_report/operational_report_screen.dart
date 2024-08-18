import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/l10n/reportsExternalTranslation.dart';
import 'package:longalottoretail/operational_report/bloc/operational_report_bloc.dart';
import 'package:longalottoretail/operational_report/bloc/operational_report_event.dart';
import 'package:longalottoretail/operational_report/bloc/operational_report_state.dart';
import 'package:longalottoretail/operational_report/models/response/operational_cash_report_response.dart' as opeReport;
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:velocity_x/velocity_x.dart';

import '../home/widget/longa_scaffold.dart';
import '../lottery/widgets/printing_dialog.dart';
import '../utility/date_format.dart';
import '../utility/rounded_container.dart';
import '../utility/user_info.dart';
import '../utility/utils.dart';
import '../utility/widgets/selectdate/bloc/select_date_bloc.dart';
import '../utility/widgets/selectdate/forward.dart';
import '../utility/widgets/selectdate/select_date.dart';
import '../utility/widgets/show_snackbar.dart';
import '../saleWinTxnReport/model/get_service_list_response.dart';

class OperationalReportScreen extends StatefulWidget {
  const OperationalReportScreen({Key? key}) : super(key: key);

  @override
  State<OperationalReportScreen> createState() => _OperationalReportScreenState();
}

bool _saleListLoading = true;
bool _operationalReportLoading = true;
List<Data> _data = [];

class _OperationalReportScreenState extends State<OperationalReportScreen> {
  String _selectedItem = "";
  String _selectedItemForApiCall = "";
  String serviceCode = "";

  final List<String> _picGroup = [];

  late opeReport.OperationalCashReportResponse operationalResponse =
      opeReport.OperationalCashReportResponse();
  late List<opeReport.GameWiseData>? mGameWiseDataList = [];

  String mErrorString = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<OperationalReportBloc>(context)
          .add(ServiceList(context: context, url: ""));
    });
  }

  @override
  Widget build(BuildContext context) {
    var body = BlocListener<OperationalReportBloc, OperationalReportState>(
        listener: (context, state) {
          if (state is ServiceListLoading) {
            setState(() {
              _saleListLoading = true;
            });
          } else if (state is ServiceListError) {
            setState(() {
              _saleListLoading = false;
            });
            ShowToast.showToast(context, state.errorMessage.toString(),
                type: ToastType.ERROR);
          } else if (state is ServiceListSuccess) {
            setState(() {
              _saleListLoading = false;
              _data = state.response.responseData!.data!;

              for (var element in _data) {
                _picGroup.add(getTranslatedString(
                    context, element.serviceDisplayName ?? ""));
              }

              _selectedItem = getTranslatedString(
                  context, _data[0].serviceDisplayName ?? "");
              _selectedItemForApiCall =
                  getSelectedItemForApi(_data[0].serviceDisplayName ?? "");

              initData();
            });
          } else if (state is OperationalReportLoading) {
            setState(() {
              _operationalReportLoading = true;
            });
          } else if (state is OperationalReportError) {
            ShowToast.showToast(context, state.errorMessage,
                type: ToastType.ERROR);
            mGameWiseDataList = [];
            mErrorString = state.errorMessage;
            setState(() {
              _operationalReportLoading = false;
            });
          } else if (state is OperationalReportSuccess) {
            setState(() {
              mGameWiseDataList = [];
              _operationalReportLoading = false;
              operationalResponse = state.operationalReportApiResponse;
              mGameWiseDataList =
                  operationalResponse.responseData?.data?.gameWiseData ?? [];
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
                      child: DropdownButtonFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                    color: LongaLottoPosColor.light_dark_white,
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
                                _selectedItemForApiCall =
                                    getSelectedItemForApi(item)
                              }),
                    ),
                  ).pSymmetric(v: 5, h: 5),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
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
                    ),
                  ),
                  !_operationalReportLoading
                      ? mGameWiseDataList!.isNotEmpty
                          ? !_operationalReportLoading
                              ? Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration:
                                                    const BoxDecoration(
                                                        color:
                                                            LongaLottoPosColor
                                                                .game_color_grey),
                                                child: Text(
                                                  context.l10n.sales,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          LongaLottoPosColor
                                                              .white),
                                                  textAlign: TextAlign.center,
                                                ).p(15),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration:
                                                    const BoxDecoration(
                                                        color:
                                                            LongaLottoPosColor
                                                                .dark_gray),
                                                child: Text(
                                                  context.l10n.claims,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: LongaLottoPosColor
                                                        .white,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ).p(15),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    color: LongaLottoPosColor
                                                        .game_color_grey),
                                                child: Text(
                                                  context.l10n.claim_tax,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          LongaLottoPosColor
                                                              .white),
                                                  textAlign: TextAlign.center,
                                                ).p(15),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                mGameWiseDataList?.length ??
                                                    0,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(
                                                            context)
                                                        .size
                                                        .width,
                                                    color: LongaLottoPosColor
                                                        .pinkish_grey_two,
                                                    child: Text(
                                                      mGameWiseDataList?[
                                                                  index]
                                                              .gameName ??
                                                          "-",
                                                      style:
                                                          const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ).p(10),
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: LongaLottoPosColor
                                                                      .white),
                                                          child: Text(
                                                            mGameWiseDataList?[
                                                                        index]
                                                                    .sales ??
                                                                "-",
                                                            style: const TextStyle(
                                                                fontSize:
                                                                    16,
                                                                color: LongaLottoPosColor
                                                                    .black),
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                          ).p(15),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          decoration: const BoxDecoration(
                                                              color: LongaLottoPosColor
                                                                  .light_grey),
                                                          child: Text(
                                                            mGameWiseDataList?[
                                                                        index]
                                                                    .claims ??
                                                                "-",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  LongaLottoPosColor
                                                                      .black,
                                                            ),
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                          ).p(15),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: LongaLottoPosColor
                                                                      .white),
                                                          child: Text(
                                                            mGameWiseDataList?[
                                                                        index]
                                                                    .claimTax ??
                                                                "-",
                                                            style: const TextStyle(
                                                                fontSize:
                                                                    16,
                                                                color: LongaLottoPosColor
                                                                    .black),
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                          ).p(15),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              );
                                            }
                                          ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                context.l10n.total,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.start,
                                              ),
                                            ).pSymmetric(h: 10, v: 16),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Sales
                                                Expanded(
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                        color:
                                                            LongaLottoPosColor
                                                                .light_grey),
                                                    child: Text(
                                                      context.l10n.sales,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            LongaLottoPosColor
                                                                .black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ).p(15),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                LongaLottoPosColor
                                                                    .white),
                                                    child: Text(
                                                      operationalResponse
                                                              .responseData
                                                              ?.data
                                                              ?.totalSale ??
                                                          "-",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              LongaLottoPosColor
                                                                  .black),
                                                      textAlign:
                                                          TextAlign.center,
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
                                                        color:
                                                            LongaLottoPosColor
                                                                .light_grey),
                                                    child: Text(
                                                      context.l10n.claims,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            LongaLottoPosColor
                                                                .black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ).p(15),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                LongaLottoPosColor
                                                                    .white),
                                                    child: Text(
                                                      operationalResponse.responseData?.data?.totalClaim ?? "-",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              LongaLottoPosColor
                                                                  .black),
                                                      textAlign:
                                                          TextAlign.center,
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
                                                        color:
                                                            LongaLottoPosColor
                                                                .light_grey),
                                                    child: Text(
                                                      context.l10n.claim_tax,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            LongaLottoPosColor
                                                                .black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ).p(15),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                LongaLottoPosColor
                                                                    .white),
                                                    child: Text(
                                                      operationalResponse.responseData?.data?.totalClaimTax ?? "-",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              LongaLottoPosColor
                                                                  .black),
                                                      textAlign:
                                                          TextAlign.center,
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
                                                        color:
                                                            LongaLottoPosColor
                                                                .light_grey),
                                                    child: Text(
                                                      context.l10n.commission_sales,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            LongaLottoPosColor
                                                                .black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ).p(15),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                LongaLottoPosColor
                                                                    .white),
                                                    child: Text(
                                                      operationalResponse.responseData?.data?.salesCommision ?? "-",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              LongaLottoPosColor
                                                                  .black),
                                                      textAlign:
                                                          TextAlign.center,
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
                                                        color:
                                                            LongaLottoPosColor
                                                                .light_grey),
                                                    child: Text(
                                                      context.l10n.winnings_commission,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            LongaLottoPosColor
                                                                .black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ).p(15),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                LongaLottoPosColor
                                                                    .white),
                                                    child: Text(
                                                      operationalResponse.responseData?.data?.winningsCommision ?? "-",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              LongaLottoPosColor
                                                                  .black),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ).p(15),
                                                  ),
                                                ),
                                              ],
                                            ).pSymmetric(h: 16, v: 4),
                                            Row(
                                              children: [
                                                // Cash On Hand
                                                Expanded(
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                        color:
                                                            LongaLottoPosColor
                                                                .light_grey),
                                                    child: Text(
                                                      context.l10n.cash_on_had,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            LongaLottoPosColor
                                                                .black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ).p(15),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                LongaLottoPosColor
                                                                    .white),
                                                    child: Text(
                                                      operationalResponse.responseData?.data?.totalCashOnHand ?? "-",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              LongaLottoPosColor
                                                                  .black),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ).p(15),
                                                  ),
                                                ),
                                              ],
                                            ).pSymmetric(h: 16, v: 4),
                                          ],
                                        ),

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
                                                  printingDataArgs["operationCashReportData"] = jsonEncode(operationalResponse.responseData?.data);
                                                  printingDataArgs["reportHeaderName"] = context.l10n.operational_cash_report;

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
                                    ).pSymmetric(v: 20),
                                  ),
                                )
                              : Expanded(
                                  child: Container(
                                  alignment: Alignment.center,
                                  child: const Expanded(
                                      child: Center(
                                          child: CircularProgressIndicator())),
                                ))
                          : Expanded(
                              child: Container(
                              color: Colors.white,
                              child: Center(
                                  child: Text(mErrorString,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: LongaLottoPosColor.black
                                              .withOpacity(0.6)))),
                            ).pOnly(top: 16))
                      : Expanded(
                          child: Container(
                          alignment: Alignment.center,
                          child: const Expanded(
                              child:
                                  Center(child: CircularProgressIndicator())),
                        ).p(16))
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
                  )));

    return LongaScaffold(
      showAppBar: true,
      appBarTitle: context.l10n.operational_cash_report,
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

    BlocProvider.of<OperationalReportBloc>(context)
        .add(GetOperationalReportApiData(
      context: context,
      serviceCode: serviceCode,
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
