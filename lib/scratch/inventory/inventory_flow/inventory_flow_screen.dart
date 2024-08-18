import 'dart:convert';


import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longalottoretail/home/models/response/UserMenuApiResponse.dart';
import 'package:longalottoretail/home/widget/longa_scaffold.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/widgets/longa_lotto_pos_scaffold.dart';
import 'package:longalottoretail/utility/widgets/selectdate/select_week_month.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:longalottoretail/scratch/inventory/inventory_flow/bloc/inv_flow_bloc.dart';
import 'package:longalottoretail/scratch/inventory/inventory_flow/inv_flow_widget/inv_flow_widget.dart';
import 'package:longalottoretail/scratch/inventory/inventory_flow/model/response/inv_flow_response.dart';
import 'package:longalottoretail/utility/date_format.dart';
import 'package:longalottoretail/utility/user_info.dart';
import 'package:longalottoretail/utility/utils.dart';
import 'package:longalottoretail/utility/widgets/alert_dialog.dart';
import 'package:longalottoretail/utility/widgets/alert_type.dart';
import 'package:longalottoretail/utility/widgets/primary_button.dart';
import 'package:longalottoretail/utility/widgets/selectdate/bloc/select_date_bloc.dart';
import 'package:longalottoretail/utility/widgets/selectdate/forward.dart';
import 'package:longalottoretail/utility/widgets/selectdate/select_date.dart';
import 'inv_flow_widget/inv_flow_print.dart';

class InventoryFlowScreen extends StatefulWidget {
  final MenuBeanList? menuBeanList;

  const InventoryFlowScreen({Key? key, required this.menuBeanList})
      : super(key: key);

  @override
  State<InventoryFlowScreen> createState() => _InventoryFlowScreenState();
}

class _InventoryFlowScreenState extends State<InventoryFlowScreen> {
  bool mIsShimmerLoading = false;
  String model = "";
  InvFlowResponse? invFlowResponse;
  List<GameWiseClosingBalanceData>? gameWiseClosingBalanceData;
  bool showGameWiseClosingBalanceData = false;
  List<GameWiseClosingBalanceData>? gameWiseOpeningBalanceData;
  List<GameWiseData>? gameWiseData;
  bool showGameWiseOpeningBalanceData = false;
  bool showReceivedData = false;
  bool showReturnedData = false;
  bool showSoldData = false;
  double bottomViewHeight = 80;

  var selectedData = "";
  var fromDate = "";
  var toDate = "";

  @override
  void initState() {
    initData(
        formatDate(
            date: findFirstDateOfTheWeek(DateTime.now()).toString(),
            inputFormat: Format.apiDateFormat2,
            outputFormat: Format.apiDateFormat3),
        formatDate(
            date: findLastDateOfTheWeek(DateTime.now()).toString(),
            inputFormat: Format.apiDateFormat2,
            outputFormat: Format.apiDateFormat3)
    );
    initPlatform();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var filterList = [
      context.l10n.this_week,
      context.l10n.last_week,
      context.l10n.last_month
    ];

    if (selectedData == "") {
      selectedData = context.l10n.this_week;
    }

    return SafeArea(
      child: LongaScaffold(
        appBackGroundColor: LongaLottoPosColor.app_bg,
        backgroundColor: LongaLottoPosColor.white,
        showAppBar: true,
       // centerTitle: false,
        appBarTitle: widget.menuBeanList?.caption ?? '',
        body: BlocListener<InvFlowBloc, InvFlowState>(
          listener: (context, state) {
            if (state is GettingInvFlowReport) {
              setState(() {
                invFlowResponse = null;
                mIsShimmerLoading = true;
                showGameWiseOpeningBalanceData = false;
                showGameWiseClosingBalanceData = false;
                showReceivedData = false;
                showReturnedData = false;
                showSoldData = false;
              });
            } else if (state is GotInvFlowReport) {
              setState(() {
                invFlowResponse = state.response;
                if (invFlowResponse != null) {
                  gameWiseClosingBalanceData =
                      invFlowResponse!.gameWiseClosingBalanceData;
                  gameWiseOpeningBalanceData =
                      invFlowResponse!.gameWiseOpeningBalanceData;
                  gameWiseData = invFlowResponse!.gameWiseData;
                }
                mIsShimmerLoading = false;
              });
            } else if (state is InvFlowReportError) {
              setState(() {
                mIsShimmerLoading = false;
              });
              Alert.show(
                  context: context,
                  title: context.l10n.report_error.toUpperCase(),
                  subtitle: state.errorMessage,
                  type: AlertType.error,
                  buttonText: context.l10n.ok.toUpperCase(),
                  isDarkThemeOn: false,
                  buttonClick: () {});
            }
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: LongaLottoPosColor.white,
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedData = filterList[index];
                              });

                              if (selectedData == context.l10n.this_week) {
                                initData(
                                    fromDate = formatDate(
                                        date: findFirstDateOfTheWeek(DateTime.now())
                                            .toString(),
                                        inputFormat: Format.apiDateFormat2,
                                        outputFormat: Format.apiDateFormat3),
                                    toDate = formatDate(
                                        date: findLastDateOfTheWeek(DateTime.now())
                                            .toString(),
                                        inputFormat: Format.apiDateFormat2,
                                        outputFormat: Format.apiDateFormat3));
                              } else if (selectedData == context.l10n.last_week) {
                                initData(
                                    fromDate = formatDate(
                                        date: findFirstDateOfPreviousWeek(DateTime.now())
                                            .toString(),
                                        inputFormat: Format.apiDateFormat2,
                                        outputFormat: Format.apiDateFormat3),
                                    toDate = formatDate(
                                        date: findLastDateOfPreviousWeek(DateTime.now())
                                            .toString(),
                                        inputFormat: Format.apiDateFormat2,
                                        outputFormat: Format.apiDateFormat3));
                              } else if (selectedData == context.l10n.last_month) {
                                initData(
                                    fromDate = formatDate(
                                        date: getLastMonthStartDate(DateTime.now())
                                            .toString(),
                                        inputFormat: Format.apiDateFormat2,
                                        outputFormat: Format.apiDateFormat3),
                                    toDate = formatDate(
                                        date: getLastMonthEndDate(DateTime.now())
                                            .toString(),
                                        inputFormat: Format.apiDateFormat2,
                                        outputFormat: Format.apiDateFormat3));
                              }
                            },
                            child: SelectWeekMonth(
                                title: filterList[index], selectedData: selectedData),
                          );
                        },
                        itemCount: filterList.length,
                      ).pSymmetric(v: 8, h: 10),
                    ),
                    Container(
                      color: LongaLottoPosColor.white,
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
                              setState(() {
                                selectedData = "custom";
                              });

                              initData(
                                formatDate(
                                  date: context.read<SelectDateBloc>().fromDate,
                                  inputFormat: Format.dateFormat9,
                                  outputFormat: Format.apiDateFormat3,
                                ),
                                formatDate(
                                  date: context.read<SelectDateBloc>().toDate,
                                  inputFormat: Format.dateFormat9,
                                  outputFormat: Format.apiDateFormat3,
                                ),

                              );
                            },
                          ),
                        ],
                      ).pSymmetric(v: 16, h: 10),
                    ),
                    const HeightBox(20),
                    mIsShimmerLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[400]!,
                            highlightColor: Colors.grey[300]!,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      flex: 3,
                                      child: Text(''),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 30,
                                        margin: const EdgeInsets.all(2),
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                            color: LongaLottoPosColor.light_blue_grey),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 30,
                                        margin: const EdgeInsets.all(2),
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                            color: LongaLottoPosColor.brownish_grey_seven),
                                      ),
                                    ),
                                  ],
                                ).pSymmetric(h: 8, v: 2),
                                const ShimmerRow(),
                                const ShimmerRow(),
                                const ShimmerRow(),
                                const ShimmerRow(),
                                const ShimmerRow(),
                              ],
                            ),
                          )
                        : invFlowResponse != null
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                                color: LongaLottoPosColor
                                                    .french_blue),
                                            child: Text('')),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.all(2),
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                                color: LongaLottoPosColor
                                                    .french_blue),
                                            child: Text(context.l10n.books,
                                                style: const TextStyle(
                                                    color: LongaLottoPosColor.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Roboto",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0),
                                                textAlign: TextAlign.center)),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            margin: const EdgeInsets.all(2),
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                                color: LongaLottoPosColor
                                                    .faded_blue),
                                            child: Text(context.l10n.tickets,
                                                style: const TextStyle(
                                                    color: LongaLottoPosColor.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Roboto",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0),
                                                textAlign: TextAlign.center)),
                                      ),
                                    ],
                                  ).pSymmetric(h: 8, v: 2),
                                  FlowTableRow(
                                    typeName: context.l10n.open_balance,
                                    booksOfType:
                                        "${invFlowResponse!.booksOpeningBalance ?? 0}",
                                    ticketsOfType:
                                        "${invFlowResponse!.ticketsOpeningBalance ?? 0}",
                                    onTap: () {
                                      if (gameWiseOpeningBalanceData == null ||
                                          gameWiseOpeningBalanceData!.isEmpty) {
                                        Alert.show(
                                            context: context,
                                            title: context.l10n.inventory_flow_report,
                                            subtitle: context.l10n.no_data_available,
                                            type: AlertType.warning,
                                            buttonText: context.l10n.ok,
                                            isDarkThemeOn: false,
                                            buttonClick: () {});
                                      } else {
                                        setState(() {
                                          showGameWiseOpeningBalanceData = true;
                                        });
                                      }
                                    },
                                  ),
                                  FlowTableRow(
                                    typeName: context.l10n.received,
                                    booksOfType:
                                        "${invFlowResponse!.receivedBooks ?? 0}",
                                    ticketsOfType:
                                        "${invFlowResponse!.receivedTickets ?? 0}",
                                    onTap: () {
                                      if (gameWiseData == null ||
                                          gameWiseData!.isEmpty) {
                                        Alert.show(
                                            context: context,
                                            title: context.l10n.inventory_flow_report,
                                            subtitle: context.l10n.no_data_available,
                                            type: AlertType.warning,
                                            buttonText: context.l10n.ok,
                                            isDarkThemeOn: false,
                                            buttonClick: () {});
                                      } else {
                                        setState(() {
                                          showReceivedData = true;
                                        });
                                      }
                                    },
                                  ),
                                  FlowTableRow(
                                    typeName: context.l10n.returned,
                                    booksOfType:
                                        "${invFlowResponse!.returnedBooks ?? 0}",
                                    ticketsOfType:
                                        "${invFlowResponse!.returnedTickets ?? 0}",
                                    onTap: () {
                                      if (gameWiseData == null ||
                                          gameWiseData!.isEmpty) {
                                        Alert.show(
                                            context: context,
                                            title: context.l10n.inventory_flow_report,
                                            subtitle: context.l10n.no_data_available,
                                            type: AlertType.warning,
                                            buttonText: context.l10n.ok,
                                            isDarkThemeOn: false,
                                            buttonClick: () {});
                                      } else {
                                        setState(() {
                                          showReturnedData = true;
                                        });
                                      }
                                    },
                                  ),
                                  FlowTableRow(
                                    typeName: context.l10n.sales,
                                    booksOfType:
                                        "${invFlowResponse!.soldBooks ?? 0}",
                                    ticketsOfType:
                                        "${invFlowResponse!.soldTickets ?? 0}",
                                    onTap: () {
                                      if (gameWiseData == null ||
                                          gameWiseData!.isEmpty) {
                                        Alert.show(
                                            context: context,
                                            title: context.l10n.inventory_flow_report,
                                            subtitle: context.l10n.no_data_available,
                                            type: AlertType.warning,
                                            buttonText: context.l10n.ok,
                                            isDarkThemeOn: false,
                                            buttonClick: () {});
                                      } else {
                                        setState(() {
                                          showSoldData = true;
                                        });
                                      }
                                    },
                                  ),
                                  FlowTableRow(
                                    typeName: context.l10n.close_balance_total_balance,
                                    booksOfType:
                                        "${invFlowResponse!.booksClosingBalance ?? 0}",
                                    ticketsOfType:
                                        "${invFlowResponse!.ticketsClosingBalance ?? 0}",
                                    onTap: () {
                                      if (gameWiseClosingBalanceData == null ||
                                          gameWiseClosingBalanceData!.isEmpty) {
                                        Alert.show(
                                            context: context,
                                            title: context.l10n.inventory_flow_report,
                                            subtitle: context.l10n.no_data_available,
                                            type: AlertType.warning,
                                            buttonText: context.l10n.ok,
                                            isDarkThemeOn: false,
                                            buttonClick: () {});
                                      } else {
                                        setState(() {
                                          showGameWiseClosingBalanceData = true;
                                        });
                                      }
                                    },
                                  ),
                                  //Open Balance Details
                                  showGameWiseOpeningBalanceData &&
                                          gameWiseOpeningBalanceData != null
                                      ? Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: LongaLottoPosColor
                                                              .french_blue),
                                                  child: Text(
                                                      context.l10n.open_balance,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: const BoxDecoration(
                                                      color: LongaLottoPosColor
                                                          .french_blue),
                                                  child: Text(context.l10n.books,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: LongaLottoPosColor
                                                              .french_blue),
                                                  child: Text(context.l10n.tickets,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                          ],
                                        ).pOnly(
                                          left: 8,
                                          right: 8,
                                          top: 20,
                                          bottom: 2,
                                        )
                                      : Container(),
                                  showGameWiseOpeningBalanceData &&
                                          gameWiseOpeningBalanceData != null
                                      ? Column(
                                          children: gameWiseOpeningBalanceData!
                                              .map((element) {
                                          return FlowTableRow(
                                            detailTypeName: true,
                                            typeName: element.gameName ?? "",
                                            booksOfType:
                                                "${element.totalBooks ?? ""}",
                                            ticketsOfType:
                                                "${element.totalTickets ?? ""}",
                                            onTap: () {},
                                          );
                                        }).toList()
                                          // ],
                                          )
                                      : Container(),
                                  //Open Balance Details End

                                  //Received Details
                                  const HeightBox(20),
                                  showReceivedData && gameWiseData != null
                                      ? Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: LongaLottoPosColor
                                                              .french_blue),
                                                  child: Text(context.l10n.received,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: const BoxDecoration(
                                                      color: LongaLottoPosColor
                                                          .french_blue),
                                                  child: Text(context.l10n.books,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: LongaLottoPosColor
                                                              .french_blue),
                                                  child: Text(context.l10n.tickets,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                          ],
                                        ).pOnly(
                                          left: 8,
                                          right: 8,
                                          top: 20,
                                          bottom: 2,
                                        )
                                      : Container(),
                                  showReceivedData && gameWiseData != null
                                      ? Column(
                                          children:
                                              gameWiseData!.map((element) {
                                          return FlowTableRow(
                                            detailTypeName: true,
                                            typeName: element.gameName ?? "",
                                            booksOfType:
                                                "${element.receivedBooks ?? ""}",
                                            ticketsOfType:
                                                "${element.receivedTickets ?? ""}",
                                            onTap: () {},
                                          );
                                        }).toList()
                                          // ],
                                          )
                                      : Container(),
                                  //Received Details End

                                  //Returned Details
                                  showReturnedData && gameWiseData != null
                                      ? Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: LongaLottoPosColor
                                                              .french_blue),
                                                  child: Text(context.l10n.returned,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: const BoxDecoration(
                                                      color: LongaLottoPosColor
                                                          .french_blue),
                                                  child: Text(context.l10n.books,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: LongaLottoPosColor
                                                              .french_blue),
                                                  child: Text(context.l10n.tickets,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                          ],
                                        ).pOnly(
                                          left: 8,
                                          right: 8,
                                          top: 20,
                                          bottom: 2,
                                        )
                                      : Container(),
                                  showReturnedData && gameWiseData != null
                                      ? Column(
                                          children:
                                              gameWiseData!.map((element) {
                                          return FlowTableRow(
                                            detailTypeName: true,
                                            typeName: element.gameName ?? "",
                                            booksOfType:
                                                "${element.returnedBooks ?? ""}",
                                            ticketsOfType:
                                                "${element.returnedTickets ?? ""}",
                                            onTap: () {},
                                          );
                                        }).toList()
                                          // ],
                                          )
                                      : Container(),
                                  //Returned Details End

                                  //Sold Details
                                  showSoldData && gameWiseData != null
                                      ? Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: LongaLottoPosColor
                                                              .french_blue),
                                                  child: Text(context.l10n.sale,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: const BoxDecoration(
                                                      color: LongaLottoPosColor
                                                          .french_blue),
                                                  child: Text(context.l10n.books,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: LongaLottoPosColor
                                                              .french_blue),
                                                  child: Text(context.l10n.tickets,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                          ],
                                        ).pOnly(
                                          left: 8,
                                          right: 8,
                                          top: 20,
                                          bottom: 2,
                                        )
                                      : Container(),
                                  showSoldData && gameWiseData != null
                                      ? Column(
                                          children:
                                              gameWiseData!.map((element) {
                                          return FlowTableRow(
                                            detailTypeName: true,
                                            typeName: element.gameName ?? "",
                                            booksOfType:
                                                "${element.soldBooks ?? ""}",
                                            ticketsOfType:
                                                "${element.soldTickets ?? ""}",
                                            onTap: () {},
                                          );
                                        }).toList()
                                          // ],
                                          )
                                      : Container(),
                                  //Sold Details End

                                  //Close Balance Details
                                  showGameWiseClosingBalanceData &&
                                          gameWiseClosingBalanceData != null
                                      ? Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: LongaLottoPosColor
                                                              .french_blue),
                                                  child: Text(
                                                      context.l10n.closing_balance,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: const BoxDecoration(
                                                      color: LongaLottoPosColor
                                                          .french_blue),
                                                  child: Text(context.l10n.books,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: LongaLottoPosColor
                                                              .french_blue),
                                                  child: Text(context.l10n.tickets,
                                                      style: const TextStyle(
                                                          color:
                                                              LongaLottoPosColor.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                          ],
                                        ).pOnly(
                                          left: 8,
                                          right: 8,
                                          top: 20,
                                          bottom: 2,
                                        )
                                      : Container(),
                                  showGameWiseClosingBalanceData &&
                                          gameWiseClosingBalanceData != null
                                      ? Column(
                                          children: gameWiseClosingBalanceData!
                                              .map((element) {
                                          return FlowTableRow(
                                            detailTypeName: true,
                                            typeName: element.gameName ?? "",
                                            booksOfType:
                                                "${element.totalBooks ?? ""}",
                                            ticketsOfType:
                                                "${element.totalTickets ?? ""}",
                                            onTap: () {},
                                          );
                                        }).toList()
                                          // ],
                                          )
                                      : Container()
                                  //Close Balance Details End
                                ],
                              )
                            : Container(),
                    //Bottom view padding
                    invFlowResponse != null
                        ? HeightBox(bottomViewHeight)
                        : const SizedBox(),
                  ],
                ),
              ),
              //bottomView for print
              invFlowResponse != null && (model == "V2" || model == "M1" || model.toLowerCase()=="m1k_go")
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: bottomViewHeight,
                        width: context.screenWidth,
                        color: LongaLottoPosColor.white_two,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: PrimaryButton(
                            btnBgColor1: LongaLottoPosColor.marigold,
                            btnBgColor2: LongaLottoPosColor.marigold,
                            borderRadius: 10,
                            text: context.l10n.print_cap,
                            width: context.screenWidth / 3,
                            textColor: LongaLottoPosColor.black_four,
                            onPressed: () {
                              Map<String, dynamic> printingDataArgs = {};
                              printingDataArgs['showGameWiseOpeningBalanceData'] = jsonEncode(showGameWiseOpeningBalanceData);
                              printingDataArgs['showGameWiseClosingBalanceData'] = jsonEncode(showGameWiseClosingBalanceData);
                              printingDataArgs['showReceivedData'] = jsonEncode(showReceivedData);
                              printingDataArgs['showReturnedData'] = jsonEncode(showReturnedData);
                              printingDataArgs['showSoldData'] = jsonEncode(showSoldData);

                              printingDataArgs['invFlowResponse'] = jsonEncode(invFlowResponse);

                              printingDataArgs['startDate'] = formatDate(
                                date: context.read<SelectDateBloc>().fromDate,
                                inputFormat: Format.dateFormat9,
                                outputFormat: Format.apiDateFormat3,
                              );

                              printingDataArgs['endDate'] = formatDate(
                                date: context.read<SelectDateBloc>().toDate,
                                inputFormat: Format.dateFormat9,
                                outputFormat: Format.apiDateFormat3,
                              );
                              printingDataArgs['name'] = UserInfo.userName;

                              InvFlowPrint().show(
                                  context: context,
                                  title: context.l10n.printing_started,
                                  isCloseButton: true,
                                  printingDataArgs: printingDataArgs,
                                  isPrintingForSale: false);
                            },
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  void initData(String fromDate, String toDate) {
    BlocProvider.of<SelectDateBloc>(context).add(SetDate(fromDate: fromDate, toDate: toDate));
    BlocProvider.of<InvFlowBloc>(context).add(
      InvFlowReport(
        context: context,
        menuBeanList: widget.menuBeanList,
        startDate: fromDate,
        endDate: toDate,
      ),
    );
  }

  Future<void> initPlatform() async {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}'); // e.

      //product or model ==> M1, V2
      print('Running on ${androidInfo.device}'); // e.

      model = androidInfo.model;
    }
}
