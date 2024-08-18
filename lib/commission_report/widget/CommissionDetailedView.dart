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

class CommissionDetailedView extends StatefulWidget {
  Function(Map<String, dynamic>) mCallBack;
  CommissionDetailedView({Key? key, required this.mCallBack}) : super(key: key);

  @override
  State<CommissionDetailedView> createState() => _CommissionDetailedViewState();
}

class _CommissionDetailedViewState extends State<CommissionDetailedView> {

  var commType  = CommType.all;
  var dateValue = "";
  List<CommPickedBean> listOfCommPickedType = [];
  List<DatePickedBean> listOfDatePickedType = [];
  bool isCustomCalendarVisible = false;

  @override
  void initState() {
    super.initState();
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Commission Detailed View for 1 Jul 2023",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: LongaLottoPosColor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                  ),
                ).pOnly(top: 20),
                const HeightBox(20),
                Container(
                  height: 170,
                  decoration: BoxDecoration(
                      border: Border.all(width: .2, color: LongaLottoPosColor.light_grey)
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex:2,
                                child: Text("Set name",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: LongaLottoPosColor.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                              Text("From Date", style: TextStyle(color: LongaLottoPosColor.game_color_grey, fontSize: 12)),
                            ],
                          ),
                        ],
                      ).p(8);
                    },
                  ).p(4),
                ).pOnly(bottom: 16, left:24, right:24),
                Center(
                  child: Material(
                    clipBehavior: Clip.hardEdge,
                    color: LongaLottoPosColor.app_bg,
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: () {


                      },
                      child: Container(
                        width: 120,
                        child: Center(
                          child: const Text("Close",
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

  formatDate({required String date, required String inputFormat, required String outputFormat,}) {
    DateFormat inputDateFormat = DateFormat(inputFormat);
    DateTime input = inputDateFormat.parse(date);
    DateFormat outputDateFormat = DateFormat(outputFormat);
    return outputDateFormat.format(input);
  }


}
