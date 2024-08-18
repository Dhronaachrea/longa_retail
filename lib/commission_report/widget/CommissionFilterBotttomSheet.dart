import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:longalottoretail/commission_report/model/CommPickedBean.dart';
import 'package:longalottoretail/commission_report/model/DatePickedBean.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/main.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

enum CommType{ estimated, scheduled, transactional, all }
enum DateType{ lastWeek, lastMonth, custom }

class CommissionBottomSheet extends StatefulWidget {
  Function(Map<String, dynamic>) mCallBack;
  CommissionBottomSheet({Key? key, required this.mCallBack}) : super(key: key);

  @override
  State<CommissionBottomSheet> createState() => _CommissionBottomSheetState();
}

class _CommissionBottomSheetState extends State<CommissionBottomSheet> {

  var commType  = CommType.all;
  var dateValue = "";
  List<CommPickedBean> listOfCommPickedType = [];
  List<DatePickedBean> listOfDatePickedType = [];
  bool isCustomCalendarVisible = false;

  @override
  void initState() {
    super.initState();
    listOfCommPickedType.add(CommPickedBean(commType: "All", isSelected: true));
    listOfCommPickedType.add(CommPickedBean(commType: "Scheduled", isSelected: false));
    listOfCommPickedType.add(CommPickedBean(commType: "Estimated", isSelected: false));
    listOfCommPickedType.add(CommPickedBean(commType: "Transactional", isSelected: false));
    setDateCategory(commType);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Select Commission type",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: LongaLottoPosColor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                  ),
                ).pOnly(top: 20),
                GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 3.5,
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 0
                    ),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: listOfCommPickedType.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Material(
                        clipBehavior: Clip.hardEdge,
                        color: listOfCommPickedType[index].isSelected == true ? LongaLottoPosColor.game_color_blue.withOpacity(0.2) : LongaLottoPosColor.light_dark_white,
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              for(int i=0 ; i<listOfCommPickedType.length; i++) {
                                listOfCommPickedType[i].isSelected = false;
                              }
                              listOfCommPickedType[index].isSelected = true;
                              print("------> ${jsonEncode(listOfCommPickedType)}");

                              switch(listOfCommPickedType[index].commType) {
                                case "Estimated": {
                                  setDateCategory(CommType.estimated);
                                  commType = CommType.estimated;
                                  break;
                                }
                                case "Scheduled": {
                                  setDateCategory(CommType.scheduled);
                                  commType = CommType.scheduled;
                                  break;
                                }
                                case "All": {
                                  setDateCategory(CommType.all);
                                  commType = CommType.all;
                                  break;
                                }
                                case "Transactional": {
                                  setDateCategory(CommType.transactional);
                                  commType = CommType.transactional;
                                  break;
                                }
                              }
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: listOfCommPickedType[index].isSelected == true ? LongaLottoPosColor.game_color_blue : LongaLottoPosColor.light_grey),
                            ),
                            child: Center(
                              child: Text("${listOfCommPickedType[index].commType}", style: const TextStyle(
                                  fontSize: 12,
                                  color: LongaLottoPosColor.black)),
                            )),
                        ),
                      ).pOnly(right: 8);
                    }).pOnly(top: 10),
                // Wrap(
                //   children: [
                //     Material(
                //       clipBehavior: Clip.hardEdge,
                //       color: LongaLottoPosColor.game_color_blue.withOpacity(
                //           0.2),
                //       borderRadius: BorderRadius.circular(50),
                //       child: InkWell(
                //         onTap: () {
                //           setState(() {
                //             commType = CommType.estimated;
                //           });
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(50),
                //             border: Border.all(
                //                 color: LongaLottoPosColor.game_color_blue),
                //           ),
                //           child: const Text('Estimated', style: TextStyle(
                //               fontSize: 12,
                //               color: LongaLottoPosColor.black)).pOnly(
                //               top: 8, bottom: 8, left: 24, right: 24),
                //         ),
                //       ),
                //     ),
                //     const WidthBox(8),
                //     Material(
                //       clipBehavior: Clip.hardEdge,
                //       color: LongaLottoPosColor.light_dark_white,
                //       borderRadius: BorderRadius.circular(50),
                //       child: InkWell(
                //         onTap: () {
                //           setState(() {
                //             commType = CommType.scheduled;
                //           });
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(50),
                //             border: Border.all(
                //                 color: LongaLottoPosColor.light_grey),
                //           ),
                //           child: const Text('Scheduled', style: TextStyle(
                //               fontSize: 12,
                //               color: LongaLottoPosColor.black)).pOnly(
                //               top: 8, bottom: 8, left: 24, right: 24),
                //         ),
                //       ),
                //     ),
                //     const WidthBox(8),
                //     Material(
                //       clipBehavior: Clip.hardEdge,
                //       color: LongaLottoPosColor.light_dark_white,
                //       borderRadius: BorderRadius.circular(50),
                //       child: InkWell(
                //         onTap: () {
                //           setState(() {
                //             commType = CommType.all;
                //           });
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(50),
                //             border: Border.all(
                //                 color: LongaLottoPosColor.light_grey),
                //           ),
                //           child: const Text('All', style: TextStyle(
                //               fontSize: 12,
                //               color: LongaLottoPosColor.black)).pOnly(
                //               top: 8, bottom: 8, left: 24, right: 24),
                //         ),
                //       ),
                //     ),
                //     const WidthBox(8),
                //     Material(
                //       clipBehavior: Clip.hardEdge,
                //       color: LongaLottoPosColor.light_dark_white,
                //       borderRadius: BorderRadius.circular(50),
                //       child: InkWell(
                //         onTap: () {
                //           setState(() {
                //             commType = CommType.transactional;
                //           });
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(50),
                //             border: Border.all(
                //                 color: LongaLottoPosColor.light_grey),
                //           ),
                //           child: const Text('Transactional',
                //               style: TextStyle(fontSize: 12,
                //                   color: LongaLottoPosColor.black)).pOnly(
                //               top: 8, bottom: 8, left: 24, right: 24),
                //         ),
                //       ),
                //     ).pOnly(top: 8),
                //   ],
                // ).pOnly(top: 10),
                const HeightBox(16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return SizeTransition(sizeFactor: animation, child: child);
                  },
                  child: listOfDatePickedType.isNotEmpty
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text("Select Date type",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: LongaLottoPosColor.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemCount: listOfDatePickedType.length,
                              itemBuilder: (context, index) {
                                return Material(
                                  clipBehavior: Clip.hardEdge,
                                  color: listOfDatePickedType[index].isSelected == true ? LongaLottoPosColor.game_color_green.withOpacity(0.2) : LongaLottoPosColor.light_dark_white,
                                  borderRadius: BorderRadius.circular(50),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        for(int i=0 ; i<listOfDatePickedType.length; i++) {
                                          listOfDatePickedType[i].isSelected = false;
                                        }
                                        listOfDatePickedType[index].isSelected = true;
                                        if (listOfDatePickedType[index].dateType == "Custom") {
                                          isCustomCalendarVisible = true;
                                        } else {
                                          isCustomCalendarVisible = false;
                                        }
                                      });

                                      print("--listOfDatePickedType----> ${jsonEncode(listOfDatePickedType)}");
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(color: listOfDatePickedType[index].isSelected == true ? LongaLottoPosColor.game_color_green : LongaLottoPosColor.light_grey),
                                      ),
                                      child: Text("${listOfDatePickedType[index].dateType}",
                                          style: const TextStyle(fontSize: 12,
                                              color: LongaLottoPosColor.black)).pOnly(
                                          top: 8, bottom: 8, left: 24, right: 24),
                                    ),
                                  ),
                                ).pOnly(right: 8);
                              }),
                        ).pOnly(top: 10),
                        Visibility(
                          visible: isCustomCalendarVisible,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: LongaLottoPosColor.game_color_green)
                            ),
                            child: SfDateRangePicker(
                              onSelectionChanged: _onSelectionChanged,
                              selectionMode: DateRangePickerSelectionMode.range,
                              initialSelectedRange: PickerDateRange(
                                  DateTime.now().subtract(const Duration(days: 4)),
                                  DateTime.now().add(const Duration(days: 3))),
                            ),
                          ).pOnly(top:16, right:16),
                        )
                      ],
                    )
                    : Container(),
                ),
                const HeightBox(60),
                Center(
                  child: Material(
                    clipBehavior: Clip.hardEdge,
                    color: LongaLottoPosColor.app_bg,
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.mCallBack({"selectedCommType": getCommTypeValue(commType), "selectedDateRange": "21 Jul to 23 Jul, 23"});

                      },
                      child: Container(
                        width: 120,
                        child: Center(
                          child: const Text("Filter",
                              style: TextStyle(fontSize: 14,
                                  color: LongaLottoPosColor.black)).pOnly(
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
      ),
    ).pOnly(top: 8, bottom: 16, left: 24, right: 8);
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        var _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
        // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
        print("_range: $_range");
      } else if (args.value is DateTime) {
        var _selectedDate = args.value.toString();
        print("_selectedDate: $_selectedDate");
      } else if (args.value is List<DateTime>) {
        var _dateCount = args.value.length.toString();
        print("_dateCount: $_dateCount");
      } else {
        var _rangeCount = args.value.length.toString();
        print("_rangeCount: $_rangeCount");
      }
    });
  }

  List<DatePickedBean> setDateCategory(Enum commType) {
    setState(() {
      isCustomCalendarVisible = false;
    });
    listOfDatePickedType.clear();
    if(commType == CommType.scheduled) {
      listOfDatePickedType.add(DatePickedBean(dateType: "Last Month", isSelected: false));
      listOfDatePickedType.add(DatePickedBean(dateType: "Last Week", isSelected: false));
      return listOfDatePickedType;

    } else if(commType == CommType.transactional || commType == CommType.all) {
      listOfDatePickedType.add(DatePickedBean(dateType: "Last Month", isSelected: false));
      listOfDatePickedType.add(DatePickedBean(dateType: "Last Week", isSelected: false));
      listOfDatePickedType.add(DatePickedBean(dateType: "Custom", isSelected: false));
      return listOfDatePickedType;
    }
    print("listOfDatePickedType: $listOfDatePickedType");

    return listOfDatePickedType;
  }

  String getDateValue(Enum dateType) {
    if(dateType == DateType.lastWeek) {
      return "";
    } else if(dateType == DateType.lastMonth) {
      return "";
    } else if(dateType == DateType.custom) {
      return "";
    }
    return "";
  }

  String getCommTypeValue(CommType commType) {
    if (CommType.all == commType) {
      return "All";
    } else if (CommType.scheduled == commType) {
      return "Scheduled";
    } else if (CommType.transactional == commType) {
      return "Transactional";
    } else if (CommType.estimated == commType) {
      return "Estimated";
    }
    return "";
  }

}
