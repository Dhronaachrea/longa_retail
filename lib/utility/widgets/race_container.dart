import 'package:flutter/material.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';

class RaceContainer extends StatefulWidget {
  String? dayTime;
  String? dateType;

  RaceContainer(this.dayTime, this.dateType, {Key? key}) : super(key: key);

  @override
  _RaceContainerState createState() => _RaceContainerState();
}

class _RaceContainerState extends State<RaceContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 4, right: 4),
      margin: const EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 5),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          // border: Border.all(color: LongaLottoPosColor.cherry, width: 1),
          color: LongaLottoPosColor.white),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.dayTime!,
              style: const TextStyle(
                // color: LongaLottoPosColor.white,
                fontWeight: FontWeight.w400,
                fontFamily: "Roboto",
                fontStyle: FontStyle.normal,
                fontSize: 12.0,
              )),
          Text(widget.dateType!,
              style: const TextStyle(
                // color: LongaLottoPosColor.white,
                fontWeight: FontWeight.w400,
                fontFamily: "Roboto",
                fontStyle: FontStyle.normal,
                fontSize: 12.0,
              )),
        ],
      ),
    );
  }
}
