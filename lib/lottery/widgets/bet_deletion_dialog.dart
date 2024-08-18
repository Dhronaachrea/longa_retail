import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/lottery/models/otherDataClasses/panelBean.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:longalottoretail/utility/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class BetDeletionDialog {
  show({
    required BuildContext context,
    required String title,
    required String buttonText,
    required PanelBean panelBeanDetails,
    bool? isBackPressedAllowed,
    required Function(PanelBean) onButtonClick,
    bool? isCloseButton = false,
  }) {
    var numberOfLines = panelBeanDetails.numberOfLines ?? 0;
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
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                backgroundColor: LongaLottoPosColor.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/icons/deletion.svg", width: 70, height: 70, color: LongaLottoPosColor.game_color_red),
                    Container(
                      decoration: DottedDecoration(
                        color: LongaLottoPosColor.ball_border_bg,
                        strokeWidth: 0.5,
                        linePosition: LinePosition.bottom,
                      ),
                      height:12,
                    ),
                    const HeightBox(10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 120,
                          child: panelBeanDetails.isMainBet == true
                              ? Center(child: Text(panelBeanDetails.pickedValue ?? "?", overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(color: LongaLottoPosColor.black, fontSize: 13,fontWeight: FontWeight.bold)))

                              : Center(child: Text(panelBeanDetails.pickName ?? "?", overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(color: LongaLottoPosColor.black, fontSize: 13,fontWeight: FontWeight.bold))),
                        ),
                        Container(width: 1, color: LongaLottoPosColor.game_color_grey, height: 20),
                        Text("${panelBeanDetails.amount?.toInt()} ${getDefaultCurrency(getLanguage())}", textAlign: TextAlign.left, style: const TextStyle(color: LongaLottoPosColor.black, fontWeight: FontWeight.bold, fontSize: 13))
                      ],
                    ),
                    const HeightBox(10),
                    Text(
                        panelBeanDetails.isMainBet == true
                            ? numberOfLines > 2
                            ? "${context.l10n.main_bet}   |   ${panelBeanDetails.pickName}   |   ${context.l10n.no_of_lines}: ${panelBeanDetails.numberOfLines}"
                            : "${context.l10n.main_bet}   |   ${panelBeanDetails.pickName}   |   ${context.l10n.no_of_line}: ${panelBeanDetails.numberOfLines}"

                            : numberOfLines > 2
                            ? "${context.l10n.side_bet}   |   ${panelBeanDetails.pickName}   |   ${context.l10n.no_of_lines}: ${panelBeanDetails.numberOfLines}"
                            : "${context.l10n.side_bet}   |   ${panelBeanDetails.pickName}   |   ${context.l10n.no_of_line}: ${panelBeanDetails.numberOfLines}",
                        textAlign: TextAlign.left, style: const TextStyle(color: LongaLottoPosColor.black, fontSize: 12)),
                    Container(
                      decoration: DottedDecoration(
                        color: LongaLottoPosColor.ball_border_bg,
                        strokeWidth: 0.5,
                        linePosition: LinePosition.bottom,
                      ),
                      height:12,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Center(child: Text(context.l10n.are_you_sure_you_want_to_delete_above, textAlign: TextAlign.center, style: const TextStyle(color: LongaLottoPosColor.red, fontSize: 14, fontWeight: FontWeight.w400)).p(10)),
                    const HeightBox(20),
                    buttons(isCloseButton ?? false, onButtonClick, buttonText, ctx, panelBeanDetails),
                    const HeightBox(10),
                  ],
                ).pSymmetric(v: 20, h: 50),
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
        color: LongaLottoPosColor.black,
        fontWeight: FontWeight.w700,
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

  confirmButton(Function(PanelBean) panelBeanCallback, String buttonText, BuildContext ctx, PanelBean panelBeanDetails) {
    return InkWell(
      onTap: () {
        panelBeanCallback(panelBeanDetails);
        Navigator.of(ctx).pop();
      },
      child: Container(
        decoration: const BoxDecoration(
          color: LongaLottoPosColor.game_color_red,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        height: 35,
        child: Center(child: Text(ctx.l10n.ok_cap, style: const TextStyle(color: LongaLottoPosColor.white))),
      ),
    );
  }

  buttons(bool isCloseButton, Function(PanelBean) panelBean, String buttonText, BuildContext ctx, PanelBean panelBeanDetails) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        isCloseButton ? Expanded(child: closeButton(ctx)) : const SizedBox(),
        const WidthBox(10),
        Expanded(child: confirmButton(panelBean, buttonText, ctx, panelBeanDetails))
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
              border: Border.all(color: LongaLottoPosColor.game_color_red)
          ),
          height: 35,
          child: Center(child: Text(ctx.l10n.cancel, style: const TextStyle(color: LongaLottoPosColor.game_color_red))),
        )
    );
  }
}
