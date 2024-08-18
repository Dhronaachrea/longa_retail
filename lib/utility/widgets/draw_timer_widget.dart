import 'package:flutter/material.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:velocity_x/velocity_x.dart';

import 'my_timer.dart';

class DrawTimerWidget extends StatefulWidget {
  const DrawTimerWidget({Key? key}) : super(key: key);

  @override
  _DrawTimerWidgetState createState() => _DrawTimerWidgetState();
}

class _DrawTimerWidgetState extends State<DrawTimerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: LongaLottoPosColor.navy_blue,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: context.screenWidth * 0.46,
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                color: LongaLottoPosColor.red),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Played Tickets',
                        style: TextStyle(
                          color: LongaLottoPosColor.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        )),
                    Text('For this Draw',
                        style: TextStyle(
                          color: LongaLottoPosColor.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 10.0,
                        )),
                  ],
                ),
                SizedBox(
                  height: 15,
                  child: VerticalDivider(
                    color: LongaLottoPosColor.black.withOpacity(0.4),
                    thickness: 1,
                  ),
                ),
                Text('05',
                    style: TextStyle(
                      color: LongaLottoPosColor.white,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0,
                    )
                ),
              ],
            ),
          ),
          Container(
            width: context.screenWidth * 0.36,
            padding: EdgeInsets.only(left: 10, right: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Current\nDraw In',
                    style: TextStyle(
                      color: LongaLottoPosColor.white,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 11.0,
                    )),
                MyTimer(
                  // pick4: 'pick',
                    createdAt: '2020-10-18T05:05:39.000+00:00',
                    // updatedAt: responseData![index].updatedAt
                    updatedAt: '2020-10-14T03:04:39.000+00:00')
              ],
            ),
          )
        ],
      ).pOnly(left: 10, right: 10, top: 5, bottom: 5),
    );
  }
}
