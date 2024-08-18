import 'package:flutter/material.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:velocity_x/velocity_x.dart';

class CancelTicketConfirmationDialog {
  show({
    required BuildContext context,
    required String title,
    required String subTitle,
    required String buttonText,
    bool? isBackPressedAllowed,
    required VoidCallback buttonClick,
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
                backgroundColor: LongaLottoPosColor.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const HeightBox(10),
                        alertTitle(title),
                        const HeightBox(20),
                        alertSubTitle(subTitle),
                        const HeightBox(20),
                        buttons(isCloseButton ?? false, buttonClick, buttonText, ctx),
                        const HeightBox(10),
                      ],
                    ).pSymmetric(v: 20, h: 50),
                  ],
                ),
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
        fontSize: 20,
        color: LongaLottoPosColor.black
      ),
    );
  }

  static alertSubTitle(String title) {
    return Center(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 13,
          color: LongaLottoPosColor.game_color_red
        ),
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
        child: Center(child: Text(buttonText, style: const TextStyle(color: LongaLottoPosColor.white))),
      ),
    );
  }

  buttons(bool isCloseButton, VoidCallback buttonClick,
      String buttonText, BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        isCloseButton ? Expanded(child: closeButton(ctx)) : const SizedBox(),
        const WidthBox(10),
        Expanded(child: confirmButton(buttonClick, buttonText, ctx)),
      ],
    );
  }

  static closeButton(BuildContext ctx) {
    return InkWell(
      onTap: () {
        Navigator.of(ctx).pop();
      },
      child: Container(
        decoration: BoxDecoration(
            color: LongaLottoPosColor.white,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: LongaLottoPosColor.dark_green)
        ),
        height: 35,
        child: Center(child: Text(ctx.l10n.no, style: const TextStyle(color: LongaLottoPosColor.dark_green))),
      )
    );
  }
}
