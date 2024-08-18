import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/lottery/widgets/dialog_shimmer_container.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:velocity_x/velocity_x.dart';

class DrawNotAvailableMsgDialog {
  show({
    required BuildContext context,
    required String title,
    required String buttonText,
    bool? isBackPressedAllowed,
    bool? isCloseButton = false,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, StateSetter setInnerState) {
            return WillPopScope(
              onWillPop: () async{
                return isBackPressedAllowed ?? true;
              },
              child: Dialog(
                insetPadding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      DialogShimmerContainer(
                        color: const Color(0xFF80DDFF),
                        childWidget: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16)
                          ),
                        ).p(4),
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                            color: LongaLottoPosColor.white,
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const HeightBox(10),
                            alertTitle(title),
                            const HeightBox(40),
                            buttons(isCloseButton ?? false,buttonText, ctx),
                          ],
                        ).pSymmetric(v: 10, h: 30),
                      ).p(4)
                    ]
                  ),
                )
              ),
            );
          },
        );
      },
    );
  }

  static alertTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: LongaLottoPosColor.reddish_pink
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
        .shake()
        .move(delay: 200.ms, duration: 400.ms);
  }

  static alertSubTitle(String title) {
    return Center(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          color: LongaLottoPosColor.game_color_grey
        ),
      ),
    );
  }

  static alertSubtitle(String subtitle) {
    return Text(
      subtitle,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: LongaLottoPosColor.black,
        fontSize: 16.0,
      ),
    );
  }

  confirmButton(VoidCallback? buttonClick, String buttonText, BuildContext ctx) {
    return InkWell(
      onTap: () {
        if(buttonClick != null) {
          buttonClick();
          Navigator.of(ctx).pop();
        } else {
          Navigator.of(ctx).pop();
        }
      },
      child: Container(
        decoration: const BoxDecoration(
            color: LongaLottoPosColor.game_color_red,
            borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        height: 35,
        child: Center(child: Text(ctx.l10n.clear_cap, style: const TextStyle(color: LongaLottoPosColor.white))),
      ),
    );
  }

  buttons(bool isCloseButton,
      String buttonText, BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        isCloseButton ? Expanded(child: closeButton(ctx, buttonText)) : const SizedBox(),
      ],
    );
  }

  static closeButton(BuildContext ctx, String buttonText) {
    return InkWell(
      onTap: () {
        Navigator.of(ctx).pop();
      },
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      child: Container(
        decoration: BoxDecoration(
            color: LongaLottoPosColor.white,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: LongaLottoPosColor.game_color_blue)
        ),
        height: 35,
        child: Center(
            child: Text(buttonText, style: const TextStyle(color: LongaLottoPosColor.game_color_blue))
        ),
      )
    );
  }
}