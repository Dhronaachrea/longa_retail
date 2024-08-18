import 'package:flutter/material.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child;

  const RoundedContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height * 0.3,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                "assets/images/banner.webp",
              ),
            ),
          ),
        ),
        Container(
          clipBehavior: Clip.hardEdge,
          width: double.infinity,
          margin: EdgeInsets.only(top: size.height * 0.17),
          //padding: EdgeInsets.only(top: size.height * 0.01),
          decoration: const BoxDecoration(
              color: LongaLottoPosColor.ball_border_light_bg,
              boxShadow: [BoxShadow(blurRadius: 25.0)],
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: child,
        ),
      ],
    );
  }
}
