import 'package:flutter/material.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';

import 'package:velocity_x/velocity_x.dart';

class SelectWeekMonth extends StatefulWidget {
  final String title;
  final String selectedData;

  const SelectWeekMonth({
    Key? key,
    required this.title,
    required this.selectedData,
  }) : super(key: key);

  @override
  State<SelectWeekMonth> createState() => _SelectWeekMonthDateState();
}

class _SelectWeekMonthDateState extends State<SelectWeekMonth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.title == widget.selectedData ?
        LongaLottoPosColor.br_lotto_green
        :LongaLottoPosColor. white,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        border: Border.all(
          color: LongaLottoPosColor.br_lotto_green,
        ),
      ),
      child: Center(
        child: FittedBox(
          child: Text(
            widget.title,
            style:   TextStyle(
                color: widget.title == widget.selectedData ?
                LongaLottoPosColor.white
                    :LongaLottoPosColor.  br_lotto_green,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontSize: 14.0),
          ).p(8),
        ),
      ),
    ).pOnly(left: 10);
  }
}
