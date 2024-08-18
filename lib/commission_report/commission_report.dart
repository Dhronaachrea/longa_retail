import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:longalottoretail/commission_report/bloc/commission_event.dart';
import 'package:longalottoretail/commission_report/model/response/CommissionDetailedDataResponse.dart';
import 'package:longalottoretail/commission_report/model/response/CommissionDetailedPreviewData.dart';
import 'package:longalottoretail/commission_report/widget/CommissionFilterBotttomSheet.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/rounded_container.dart';
import 'package:longalottoretail/utility/utils.dart';
import 'package:longalottoretail/utility/widgets/show_snackbar.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../home/widget/longa_scaffold.dart';
import 'bloc/commission_bloc.dart';
import 'bloc/commission_state.dart';
import 'package:longalottoretail/commission_report/model/response/FetchOrgCommissionResponse.dart' as fetch_org_commission_response;
import 'package:longalottoretail/commission_report/model/response/CommissionDetailedDataResponse.dart' as commission_detailed_data;

class CommissionReportScreen extends StatefulWidget {
  const CommissionReportScreen({Key? key}) : super(key: key);

  @override
  State<CommissionReportScreen> createState() => _CommissionReportScreenState();
}

class _CommissionReportScreenState extends State<CommissionReportScreen> {
  List<fetch_org_commission_response.Data>? commissionReportList           = [];
  List<commission_detailed_data.ResponseData>? commissionDetailedDataList = [];
  bool isLoading                                                        = false;
  bool isDirect                                                         = false;
  bool isCommissionDetailedDataLoading                                  = false;
  String selectedCommType                                               = "All";
  String selectedDateRange                                              = "13 Jul to 20 Jul, 23";
  String tapedDate                                                      = "";
  String setStartingDate                                                = "";
  String setEndingDate                                                  = "";
  List<Map<String, int>> wagerWinningAmtMap                             = [];
  List<Map<String, int>> wagerWinningAmtMapOriginal                     = [];
  Map<String, List<int>> mapOfAmount                                    = {};
  int wagerOrWinningAmt                                                 = 0;

  List<String> listOfLabel = ["Set name"];

  @override
  void initState() {
    BlocProvider.of<CommissionReportBloc>(context).add(FetchOrgCommission(context: context, startDate: "", endDate: "", orgId: "", commType: ""));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommissionReportBloc, CommissionReportState>(
        listener: (context, state) {
          if (state is FetchOrgCommissionLoading) {
            setState(() {
              isLoading = true;
            });
          }
          else if (state is FetchOrgCommissionSuccess) {
            setState(() {
              isLoading = false;
            });

            commissionReportList = state.response?.responseData?.data;
            isDirect = commissionReportList?.where((element) => element.directWagerComm != null).toList().isNotEmpty == true;

          }
          else if (state is FetchOrgCommissionError) {
            setState(() {
              isLoading = false;
            });
            ShowToast.showToast(context, state.errorMessage, type: ToastType.ERROR);

          } else if (state is CommissionDetailedDataLoading) {
            setState(() {
              isCommissionDetailedDataLoading = true;
            });
          }
          else if (state is CommissionDetailedDataSuccess) {
            setState(() {
              isCommissionDetailedDataLoading = false;
            });
            ResponseData? commissionDetailedDataResponse = state.response?.responseData;
            List<commission_detailed_data.Data> commissionDetailedResponseData = state.response?.responseData?.data ?? [];

            List<CommissionDetailedPreviewData> collectiveCommissionDetailedList = [];

            for(Map<String, int> i in wagerWinningAmtMap) {
              if (i["wagerAmt"] != null && i["wagerAmt"] != 0) {
                List<int>? amounts = [];
                for (commission_detailed_data.Data commData in commissionDetailedResponseData) {
                  var slabsList = commData.slabsInfo?[0].slabs ?? [];
                  for (Slabs slabDetail in slabsList) {
                    amounts.add(calculateCommissionAmount(int.parse(slabDetail.rangeTo?? ""), int.parse(slabDetail.rangeFrom?? ""), slabDetail.commRate ?? "", wagerWinningAmtMap, "Wager"));
                  }
                }
                collectiveCommissionDetailedList.add(
                    CommissionDetailedPreviewData(
                        wagerAmt: i["wagerAmt"],
                        setStartingDate: setStartingDate,
                        setEndingDate: setEndingDate,
                        commOn: "Wager",
                        amountList : amounts,
                        data : commissionDetailedDataResponse?.data
                                                                                                                                                                                                             )
                );
              }

              if (i["winningAmt"] != null && i["winningAmt"] != 0) {
                List<int>? amounts = [];
                for (commission_detailed_data.Data commData in commissionDetailedResponseData) {
                  var slabsList = commData.slabsInfo?[0].slabs ?? [];
                  for (Slabs slabDetail in slabsList) {
                    amounts.add(calculateCommissionAmount(int.parse(slabDetail.rangeTo?? ""), int.parse(slabDetail.rangeFrom?? ""), slabDetail.commRate ?? "", wagerWinningAmtMap, "Winning"));
                  }
                }

                collectiveCommissionDetailedList.add(
                    CommissionDetailedPreviewData(
                      winningAmt: i["winningAmt"],
                      setStartingDate: setStartingDate,
                      setEndingDate: setEndingDate,
                      commOn: "Winning",
                      amountList: amounts,
                      data: commissionDetailedDataResponse?.data
                    )
                );

              }
            }

            showCommissionDetailedDialog(context, tapedDate, collectiveCommissionDetailedList);

          }
          else if (state is CommissionDetailedDataError) {
            setState(() {
              isCommissionDetailedDataLoading = false;
            });
            ShowToast.showToast(context, state.errorMessage, type: ToastType.ERROR);
          }
        },
        child: LongaScaffold(
          showAppBar: true,
          appBarTitle: "Commission Report",
          extendBodyBehindAppBar: true,
          body: RoundedContainer(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0),
                                      ),
                                    ),
                                    builder: (ctx) {
                                      return CommissionBottomSheet(
                                          mCallBack: (Map<String, dynamic> selectedData) {
                                            setState(() {
                                              selectedCommType = selectedData["selectedCommType"];
                                              selectedDateRange = selectedData["selectedDateRange"];
                                              isLoading = true;
                                            });
                                            BlocProvider.of<CommissionReportBloc>(context).add(FetchOrgCommission(context: context, startDate: "", endDate: "", orgId: "", commType: ""));
                                          });
                                    });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: LongaLottoPosColor.black.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(30),

                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.filter_alt, size: 18,
                                      color: LongaLottoPosColor.light_dark_white,
                                    ),
                                    Text("Select", textAlign: TextAlign.center ,style: TextStyle(color: LongaLottoPosColor.white, fontSize: 8))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: LongaLottoPosColor.game_color_blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: LongaLottoPosColor.game_color_blue),
                            ),
                            child: Center(child: Text(selectedCommType, style: const TextStyle(fontSize: 10)).pOnly(top:8, bottom: 8)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: LongaLottoPosColor.game_color_green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: LongaLottoPosColor.game_color_green),
                            ),
                            child: Text('Date range : $selectedDateRange', style: const TextStyle(fontSize: 10)).pOnly(top:8, bottom: 8, left: 10, right: 10),
                          )
                        ],
                      ).pOnly(left: 10, right: 14, top: 10, bottom: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: const BoxDecoration(
                                  color: LongaLottoPosColor.black
                              ),
                              child: const Center(child: Text("Date", textAlign: TextAlign.center,  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: LongaLottoPosColor.white))),
                            ),
                          ),
                          const WidthBox(1),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: const BoxDecoration(
                                color: LongaLottoPosColor.black,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        )
                                    ),
                                    child: const Text("Wager\nCommission", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: LongaLottoPosColor.white)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const WidthBox(1),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: const BoxDecoration(
                                color: LongaLottoPosColor.black,
                              ),
                              child: Center(
                                child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      )
                                  ),
                                  child: const Text("Winning\nCommission", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: LongaLottoPosColor.white)),
                                ),
                              ),
                            ),
                          ),
                          const WidthBox(1),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: const BoxDecoration(
                                color: LongaLottoPosColor.black,
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    )
                                ),
                                child: const Center(child: Text("Net\nCommission", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: LongaLottoPosColor.white))),
                              ),
                            ),
                          ),
                        ],
                      ),
                      isLoading
                          ? Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return Container(
                                color: LongaLottoPosColor.light_dark_white,
                                child: Shimmer.fromColors(
                                    baseColor: Colors.grey[400]!,
                                    highlightColor: Colors.grey[300]!,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              color: LongaLottoPosColor.warm_grey,
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width : 30,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[400]!,
                                                      borderRadius: const BorderRadius.all(
                                                        Radius.circular(10),
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const WidthBox(1),
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              color: LongaLottoPosColor.warm_grey,
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width : 40,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[400]!,
                                                      borderRadius: const BorderRadius.all(
                                                        Radius.circular(10),
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const WidthBox(1),
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              color: LongaLottoPosColor.warm_grey,
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width : 40,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[400]!,
                                                      borderRadius: const BorderRadius.all(
                                                        Radius.circular(10),
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const WidthBox(1),
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              color: LongaLottoPosColor.warm_grey,
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width : 40,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[400]!,
                                                      borderRadius: const BorderRadius.all(
                                                        Radius.circular(10),
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ).p(1);
                            }).p(2),
                      )
                          : isDirect
                          ? Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: commissionReportList?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Container(
                                color: LongaLottoPosColor.light_dark_white,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Material(
                                        color: Colors.transparent,
                                        clipBehavior: Clip.hardEdge,
                                        child: Container(
                                          height: 50,
                                          decoration: const BoxDecoration(
                                              color: LongaLottoPosColor.warm_grey
                                          ),
                                          child: Center(child: Text("${formatDate(date: "${commissionReportList?[index].commissionDate}", inputFormat: "yyyy-MM-dd", outputFormat: "dd MMM, yy")}", style: const TextStyle(color: LongaLottoPosColor.black, fontSize: 14, fontWeight: FontWeight.bold))),
                                        ),
                                      ),
                                    ),
                                    const WidthBox(1),
                                    Expanded(
                                      child: Material(
                                        color: Colors.transparent,
                                        clipBehavior: Clip.hardEdge,
                                        child: InkWell(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: LongaLottoPosColor.warm_grey.withOpacity(0.3),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      )
                                                  ),
                                                  child: Text("${commissionReportList?[index].directWagerComm  ?? "NA"} ${getDefaultCurrency(getLanguage())}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const WidthBox(1),
                                    Expanded(
                                      child: Material(
                                        color: Colors.transparent,
                                        clipBehavior: Clip.hardEdge,
                                        child: InkWell(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: LongaLottoPosColor.warm_grey.withOpacity(0.2),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      )
                                                  ),
                                                  child: Text("${commissionReportList?[index].directWinningComm  ?? "NA"} ${getDefaultCurrency(getLanguage())}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const WidthBox(1),
                                    Expanded(
                                      child: Material(
                                        color: Colors.transparent,
                                        clipBehavior: Clip.hardEdge,
                                        child: InkWell(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: LongaLottoPosColor.warm_grey.withOpacity(0.1),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      )
                                                  ),
                                                  child: Text("${commissionReportList?[index].totalComm  ?? "NA"} ${getDefaultCurrency(getLanguage())}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ).p(1);
                            }).p(2),
                      )
                          : Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: commissionReportList?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Container(
                                color: LongaLottoPosColor.light_dark_white,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Material(
                                        color: Colors.transparent,
                                        clipBehavior: Clip.hardEdge,
                                        child: InkWell(
                                          onTap: () {
                                            wagerWinningAmtMap.clear();
                                            mapOfAmount.clear();
                                            if (selectedCommType == "Scheduled") {
                                              setState(() {
                                                tapedDate = commissionReportList?[index].commissionDate ?? "";
                                                setStartingDate = commissionReportList?[index].setStartingDate ?? "";
                                                setEndingDate   = commissionReportList?[index].setEndingDate ?? "";

                                                if (commissionReportList?[index].wagerAmt != null) {
                                                  Map<String, int> wagerAmtMap = {};
                                                  wagerAmtMap["wagerAmt"] = int.parse(commissionReportList?[index].wagerAmt?.split(',')[0] ?? "0");
                                                  wagerWinningAmtMap.add(wagerAmtMap);
                                                  wagerWinningAmtMapOriginal.add(wagerAmtMap);
                                                }
                                                if (commissionReportList?[index].winningAmt != null) {
                                                  Map<String, int> winningAmtMap = {};
                                                  winningAmtMap["winningAmt"] = int.parse(commissionReportList?[index].winningAmt?.split(',')[0] ?? "0");
                                                  wagerWinningAmtMap.add(winningAmtMap);
                                                  wagerWinningAmtMapOriginal.add(winningAmtMap);

                                                }
                                              });
                                              BlocProvider.of<CommissionReportBloc>(context).add(CommissionDetailedData(context: context));
                                            }
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: const BoxDecoration(
                                                color: LongaLottoPosColor.warm_grey
                                            ),
                                            child: Center(child: Text("${formatDate(date: "${commissionReportList?[index].commissionDate}", inputFormat: "yyyy-MM-dd", outputFormat: "dd MMM, yy")}", style: TextStyle(decoration: selectedCommType == "Scheduled" ? TextDecoration.underline : null, color: selectedCommType == "Scheduled" ? LongaLottoPosColor.game_color_blue : LongaLottoPosColor.black, fontSize: 14, fontWeight: FontWeight.bold))),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const WidthBox(1),
                                    Expanded(
                                      child: Material(
                                        color: Colors.transparent,
                                        clipBehavior: Clip.hardEdge,
                                        child: InkWell(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: LongaLottoPosColor.warm_grey.withOpacity(0.3),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      )
                                                  ),
                                                  child: Text("${commissionReportList?[index].tieredWagerComm  ?? "NA"} ${getDefaultCurrency(getLanguage())}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const WidthBox(1),
                                    Expanded(
                                      child: Material(
                                        color: Colors.transparent,
                                        clipBehavior: Clip.hardEdge,
                                        child: InkWell(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: LongaLottoPosColor.warm_grey.withOpacity(0.2),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      )
                                                  ),
                                                  child: Text("${commissionReportList?[index].tieredWinningComm  ?? "NA"} ${getDefaultCurrency(getLanguage())}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const WidthBox(1),
                                    Expanded(
                                      child: Material(
                                        color: Colors.transparent,
                                        clipBehavior: Clip.hardEdge,
                                        child: InkWell(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: LongaLottoPosColor.warm_grey.withOpacity(0.1),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      )
                                                  ),
                                                  child: Text("${commissionReportList?[index].totalComm  ?? "NA"} ${getDefaultCurrency(getLanguage())}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ).p(1);
                            }).p(2),
                      )

                    ],
                  ),
                  Visibility(
                    visible: isCommissionDetailedDataLoading,
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
              )
          ),
        ));
  }

  showCommissionDetailedDialog(BuildContext context, String tapedDate, List<CommissionDetailedPreviewData> collectiveCommissionDetailedList) {
    var collectiveCommissionDetailedListLength = collectiveCommissionDetailedList.length;
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
          var curve = Curves.ease.transform(animation.value);
          return Transform.scale(
            scale: curve,
            child: Dialog(
              elevation: 3.0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 100.0),
              backgroundColor: LongaLottoPosColor.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 5,
                        decoration: BoxDecoration(
                            color: LongaLottoPosColor.dark_grey.withOpacity(0.2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            )
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const HeightBox(16),
                          Text("Commission detailed view for ${formatDate(date: tapedDate, inputFormat: "yyyy-MM-dd", outputFormat: "dd MMM, yy")}",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: LongaLottoPosColor.tangerine,
                                fontSize: 14,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          Container(
                            decoration: DottedDecoration(
                              color: LongaLottoPosColor.black,
                              strokeWidth: 0.5,
                              linePosition: LinePosition.bottom,
                            ),
                            height:12,
                          ),
                          const HeightBox(12),
                          SizedBox(
                            height: 400,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: collectiveCommissionDetailedListLength,
                              itemBuilder: (context, index) {
                                return SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(border: Border.all(color: LongaLottoPosColor.app_blue, width: 2), borderRadius: BorderRadius.circular(8)),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  child: RichText(
                                                        text: TextSpan(
                                                          style: DefaultTextStyle.of(context).style,
                                                          children: <TextSpan>[
                                                            const TextSpan(text: 'Set name : ', style: TextStyle(color: LongaLottoPosColor.black, fontWeight: FontWeight.w500, fontSize: 11)),
                                                            TextSpan(text: '${collectiveCommissionDetailedList[index].data?[0].setName}', style: const TextStyle(color: LongaLottoPosColor.game_color_blue, fontWeight: FontWeight.w700, fontSize: 12)),
                                                          ],
                                                        ),
                                                      ).p(6)
                                                ),
                                                const Expanded(
                                                  child: SizedBox(),
                                                ),
                                                Container(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      style: DefaultTextStyle.of(context).style,
                                                      children: <TextSpan>[
                                                        const TextSpan(text: 'From - To : ', style: TextStyle(color: LongaLottoPosColor.black, fontWeight: FontWeight.w500, fontSize: 11)),
                                                        TextSpan(text: '${formatDate(date: "${collectiveCommissionDetailedList[index].setStartingDate}", inputFormat: "yyyy-MM-dd", outputFormat: "dd MMM")} - ${formatDate(date: "${collectiveCommissionDetailedList[index].setEndingDate}", inputFormat: "yyyy-MM-dd", outputFormat: "dd MMM, yy")}', style: const TextStyle(color: LongaLottoPosColor.game_color_blue, fontWeight: FontWeight.w700, fontSize: 12)),
                                                      ],
                                                    ),
                                                  ).p(6)
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    style: DefaultTextStyle.of(context).style,
                                                    children: <TextSpan>[
                                                      const TextSpan(text: 'Comm on : ', style: TextStyle(color: LongaLottoPosColor.black, fontWeight: FontWeight.w500, fontSize: 11)),
                                                      TextSpan(text: '${collectiveCommissionDetailedList[index].commOn}', style: const TextStyle(color: LongaLottoPosColor.game_color_blue, fontWeight: FontWeight.w700, fontSize: 12)),
                                                    ],
                                                  ),
                                                ).p(6),
                                                const Expanded(
                                                  child: SizedBox(),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: DefaultTextStyle.of(context).style,
                                                    children: <TextSpan>[
                                                      TextSpan(text: collectiveCommissionDetailedList[index].wagerAmt != null ? 'Wager Amt : ': 'Winning Amt : ', style: const TextStyle(color: LongaLottoPosColor.black, fontWeight: FontWeight.w500, fontSize: 11)),
                                                      collectiveCommissionDetailedList[index].wagerAmt != null
                                                          ? TextSpan(text: '${collectiveCommissionDetailedList[index].wagerAmt}', style: const TextStyle(color: LongaLottoPosColor.game_color_blue, fontWeight: FontWeight.w700, fontSize: 12))
                                                          : collectiveCommissionDetailedList[index].winningAmt != null
                                                            ? TextSpan(text: '${collectiveCommissionDetailedList[index].winningAmt}', style: const TextStyle(color: LongaLottoPosColor.game_color_blue, fontWeight: FontWeight.w700, fontSize: 12))
                                                            : const TextSpan(text: '0', style: TextStyle(color: LongaLottoPosColor.game_color_blue, fontWeight: FontWeight.w700, fontSize: 12))
                                                    ],
                                                  ),
                                                ).p(6),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    style: DefaultTextStyle.of(context).style,
                                                    children: <TextSpan>[
                                                      const TextSpan(text: 'Merge Slab : ', style: TextStyle(color: LongaLottoPosColor.black, fontWeight: FontWeight.w500, fontSize: 11)),
                                                      TextSpan(text: '${collectiveCommissionDetailedList[index].data?[0].isMergedSlab}', style: const TextStyle(color: LongaLottoPosColor.game_color_blue, fontWeight: FontWeight.w700, fontSize: 12)),
                                                    ],
                                                  ),
                                                ).p(6)
                                              ],
                                            )
                                          ],
                                        ),
                                      ).pOnly(bottom: 4),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: const BoxDecoration(border: Border(left: BorderSide(color: LongaLottoPosColor.black), top: BorderSide(color: LongaLottoPosColor.black))),
                                              child: Center(
                                                child: const Text("Slabs",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: LongaLottoPosColor.black,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                ).p(6),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: const BoxDecoration(border: Border(left: BorderSide(color: LongaLottoPosColor.black), right: BorderSide(color: LongaLottoPosColor.black), top: BorderSide(color: LongaLottoPosColor.black))),
                                              child: Center(
                                                child: const Text("Range",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: LongaLottoPosColor.black,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 11
                                                  ),
                                                ).p(6),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: const BoxDecoration(border: Border(top: BorderSide(color: LongaLottoPosColor.black), right: BorderSide(color: LongaLottoPosColor.black))),
                                              child: Center(
                                                child: const Text("Amount",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: LongaLottoPosColor.black,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                ).p(6),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: collectiveCommissionDetailedList[index].data?[0].slabsInfo?[0].slabs?.length ?? 0,
                                        itemBuilder: (context, slabsInfoIndex) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      decoration: const BoxDecoration(border: Border(top: BorderSide(color: LongaLottoPosColor.black), bottom: BorderSide(color: LongaLottoPosColor.black), left: BorderSide(color: LongaLottoPosColor.black))),
                                                      child: Center(
                                                        child: Text("Slab ${slabsInfoIndex+1} - ${collectiveCommissionDetailedList[index].data?[0].slabsInfo?[0].slabs?[slabsInfoIndex].commRate}%",
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                              color: LongaLottoPosColor.black,
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ).p(6),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(border: Border.all(color: LongaLottoPosColor.black)),
                                                      child: Center(
                                                        child: Text("${collectiveCommissionDetailedList[index].data?[0].slabsInfo?[0].slabs?[slabsInfoIndex].rangeFrom} - ${collectiveCommissionDetailedList[index].data?[0].slabsInfo?[0].slabs?[slabsInfoIndex].rangeTo}",
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                              color: LongaLottoPosColor.black,
                                                              fontSize: 11
                                                          ),
                                                        ).p(6),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      decoration: const BoxDecoration(border: Border(top: BorderSide(color: LongaLottoPosColor.black), bottom: BorderSide(color: LongaLottoPosColor.black), right: BorderSide(color: LongaLottoPosColor.black))),
                                                      child: Center(
                                                        child: Text("${collectiveCommissionDetailedList[index].amountList?[slabsInfoIndex]}",
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                              color: LongaLottoPosColor.black,
                                                              fontSize: 11
                                                          ),
                                                        ).p(6),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: LongaLottoPosColor.black), left: BorderSide(color: LongaLottoPosColor.black), top: BorderSide(color: LongaLottoPosColor.black), right: BorderSide(color: LongaLottoPosColor.black))),
                                              child: Center(
                                                child: const Text("",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: LongaLottoPosColor.black,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12
                                                  ),
                                                ).p(6),
                                              )
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: LongaLottoPosColor.black), left: BorderSide(color: LongaLottoPosColor.black), top: BorderSide(color: LongaLottoPosColor.black), right: BorderSide(color: LongaLottoPosColor.black))),
                                              child: Center(
                                                child: const Text("TOTAL",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: LongaLottoPosColor.black,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12
                                                  ),
                                                ).p(6),
                                              )
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(border: Border.all(color: LongaLottoPosColor.black)),
                                              child: Center(
                                                child: Text(getTotalAmt("${collectiveCommissionDetailedList[index].commOn}" , mapOfAmount),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: LongaLottoPosColor.black,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12
                                                  ),
                                                ).p(6),
                                              ),
                                            ),
                                          )
                                        ],
                                      ).pOnly(bottom: 8),
                                      Container(
                                        decoration: DottedDecoration(
                                          color: LongaLottoPosColor.black,
                                          strokeWidth: 0.5,
                                          linePosition: LinePosition.bottom,
                                        ),
                                        height:12,
                                      ),
                                      const HeightBox(16)
                                    ],
                                  ),
                                );
                              },
                            ),
                          ).pOnly(bottom: 16, left:6, right:6),
                          Center(
                            child: Material(
                              color: LongaLottoPosColor.app_blue,
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  width: 120,
                                  decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)), border: Border.all(color: LongaLottoPosColor.app_blue, width: 1)),
                                  child: Center(
                                    child: const Text("CLOSE",
                                        style: TextStyle(fontSize: 14,
                                            color: LongaLottoPosColor.white)).pOnly(
                                        top: 12, bottom: 12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const HeightBox(20)
                        ],
                      ),
                    ],
                  ),
                ).p(8),
              )
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400));
  }

  int calculateCommissionAmount(int rangeTo, int rangeFrom, String commissionRate, List<Map<String, int>> wagerWinningAmtMap, String commOn) {
    if (commOn == "Wager") {
      var wagerAmtList = wagerWinningAmtMap.where((element) => element.keys.contains("wagerAmt")).toList();
      if (wagerAmtList.isNotEmpty) {
        wagerOrWinningAmt = wagerAmtList[0]["wagerAmt"]!;
        var range         = rangeTo - rangeFrom;

        print("------------------ ~ ~ ~ ------------------");
        print("commOn             :: $commOn");
        print("wagerWinningAmtMap :: $wagerWinningAmtMap");
        print("wagerOrWinningAmt  :: $wagerOrWinningAmt");
        print("rangeFrom          :: $rangeFrom");
        print("rangeTo            :: $rangeTo");
        print("commissionRate     :: $commissionRate");
        if (wagerOrWinningAmt > 0) {
          String decimalCommRateString = "0.0";
          if (commissionRate.contains(",")) {
            decimalCommRateString = commissionRate.replaceAll(",", ".");

          } else if (commissionRate.contains(".")) {
            decimalCommRateString = commissionRate;

          } else {
            return 0;
          }

          double commRate = double.parse(decimalCommRateString);
          var commAmt = 0.0;
          if (wagerOrWinningAmt - range > 0) {
            wagerOrWinningAmt             = wagerOrWinningAmt - range;
            commAmt                       = range * (commRate / 10);
            var wagerAmtListObject        = wagerWinningAmtMap.where((element) => element.keys.contains("wagerAmt")).toList();
            int index                     = wagerWinningAmtMap.indexOf(wagerAmtListObject[0]);
            Map<String, int> wagerAmtMap  = {};
            wagerAmtMap["wagerAmt"]       = wagerOrWinningAmt;
            wagerWinningAmtMap[index]     = wagerAmtMap;

          } else {

            commAmt                       = wagerOrWinningAmt * (commRate / 10);
            var wagerAmtListObject        = wagerWinningAmtMap.where((element) => element.keys.contains("wagerAmt")).toList();
            int index                     = wagerWinningAmtMap.indexOf(wagerAmtListObject[0]);
            Map<String, int> wagerAmtMap  = {};
            wagerAmtMap["wagerAmt"]       = 0;
            wagerWinningAmtMap[index]     = wagerAmtMap;
          }

          addAmount(commOn, mapOfAmount, commAmt);
          return commAmt.toInt();

        }
      }

    } else if (commOn == "Winning") {
      var winningAmtList = wagerWinningAmtMap.where((element) => element.keys.contains("winningAmt")).toList();
      if (winningAmtList.isNotEmpty) {
        wagerOrWinningAmt = winningAmtList[0]["winningAmt"]!;
        var range         = rangeTo - rangeFrom;

        print("commOn             :: $commOn");
        print("wagerWinningAmtMap :: $wagerWinningAmtMap");
        print("wagerOrWinningAmt  :: $wagerOrWinningAmt");
        print("rangeFrom          :: $rangeFrom");
        print("rangeTo            :: $rangeTo");
        print("commissionRate     :: $commissionRate");

        if (wagerOrWinningAmt > 0) {
          String decimalCommRateString = "0.0";
          if (commissionRate.contains(",")) {
            decimalCommRateString = commissionRate.replaceAll(",", ".");

          } else if (commissionRate.contains(".")) {
            decimalCommRateString = commissionRate;

          } else {
            return 0;
          }

          double commRate = double.parse(decimalCommRateString);
          print("commRate           :: $commRate");
          var commAmt = 0.0;
          if (wagerOrWinningAmt - range > 0) {
            wagerOrWinningAmt = wagerOrWinningAmt - range;
            commAmt     = range * (commRate / 10);
            var wagerAmtListObject = wagerWinningAmtMap.where((element) => element.keys.contains("winningAmt")).toList();
            wagerWinningAmtMap.remove(wagerAmtListObject[0]);
            Map<String, int> wagerAmtMap = {};
            wagerAmtMap["winningAmt"] = wagerOrWinningAmt;
            wagerWinningAmtMap.add(wagerAmtMap);

          } else {
            commAmt     = wagerOrWinningAmt * (commRate / 10);
            var wagerAmtListObject = wagerWinningAmtMap.where((element) => element.keys.contains("winningAmt")).toList();
            wagerWinningAmtMap.remove(wagerAmtListObject[0]);
            Map<String, int> wagerAmtMap = {};
            wagerAmtMap["winningAmt"] = 0;
            wagerWinningAmtMap.add(wagerAmtMap);
          }

          addAmount(commOn, mapOfAmount, commAmt);

          return commAmt.toInt();

        }
      }
    }

    /*if ((wagerOrWinningAmt - range) > 0) {
      wagerOrWinningAmt = wagerOrWinningAmt - range;



    } else {

    }*/


    return 0;
  }

  String getTotalAmt(String commOn, Map<String, List<int>> mapOfAmount) {
    if (mapOfAmount[commOn] != null) {
      var sum = mapOfAmount[commOn]?.reduce((a, b) => a + b);
      return "$sum";
    }

    return "0";

  }

  void addAmount(String commOn, Map<String, List<int>> mapOfAmount, double amount) {
    if (mapOfAmount[commOn]!= null) {
      mapOfAmount[commOn]?.add(amount.toInt());
    } else {
      mapOfAmount[commOn] = [amount.toInt()];
    }
  }

  formatDate({required String date, required String inputFormat, required String outputFormat,}) {
    DateFormat inputDateFormat = DateFormat(inputFormat);
    DateTime input = inputDateFormat.parse(date);
    DateFormat outputDateFormat = DateFormat(outputFormat);
    return outputDateFormat.format(input);
  }


}