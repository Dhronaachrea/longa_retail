import 'package:flutter/material.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:velocity_x/velocity_x.dart';

class SelectDate extends StatefulWidget {
  final String title;
  final String date;
  final VoidCallback onTap;

  const SelectDate({
    Key? key,
    required this.title,
    required this.date,
    required this.onTap,
  }) : super(key: key);

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: LongaLottoPosColor.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          border: Border.all(
            color: LongaLottoPosColor.warm_grey_six.withOpacity(0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                  color: LongaLottoPosColor.warm_grey_six.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Roboto",
                  fontSize: 16.0),
            ),
            const HeightBox(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.date,
                  style: const TextStyle(
                      color: LongaLottoPosColor.warm_grey_six,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0),
                ),
                const WidthBox(10),
                Image.asset(
                  "assets/icons/down_arrow.png",
                  width: 15,
                  height: 20,
                  color: LongaLottoPosColor.orangey_red,
                ),
              ],
            ),
          ],
        ).pSymmetric(h: 12, v: 5),
      ),
    );
  }
}
