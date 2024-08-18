import 'package:flutter/material.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/lottery/models/otherDataClasses/betAmountBean.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:velocity_x/velocity_x.dart';

class OtherAvailableBetAmountAlertDialog {
  int betAmount = -1;
  show({
    required BuildContext context,
    required String title,
    required String buttonText,
    required List<FiveByNinetyBetAmountBean> listOfAmounts,
    bool? isBackPressedAllowed,
    required Function(int) buttonClick,
    bool? isCloseButton = false,
  }) {
    for(FiveByNinetyBetAmountBean i in listOfAmounts) {
      if(i.isSelected == true) {
        betAmount = i.amount ?? -1;
      }
    }

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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const HeightBox(10),
                          alertTitle(title),
                          const HeightBox(20),
                          GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1,
                                crossAxisCount: 4,
                              ),
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: listOfAmounts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Ink(
                                  decoration: const BoxDecoration(
                                      color: LongaLottoPosColor.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(6),
                                      )
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      print(listOfAmounts[index].amount);
                                      if (listOfAmounts[index].amount != null) {
                                        betAmount = listOfAmounts[index].amount!;
                                      }

                                      setInnerState(() {
                                        for(FiveByNinetyBetAmountBean i in listOfAmounts) {
                                          i.isSelected = false;
                                        }
                                        listOfAmounts[index].isSelected = true;
                                      });
                                    },
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:  listOfAmounts[index].isSelected == true ? LongaLottoPosColor.game_color_red : LongaLottoPosColor.white,
                                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                                          border:  listOfAmounts[index].isSelected == true ? Border.all(color: Colors.transparent, width: 2) : Border.all(color: LongaLottoPosColor.ball_border_bg, width: 1)
                                      ),
                                      child: Center(child: Text("${listOfAmounts[index].amount}", style: TextStyle(color: listOfAmounts[index].isSelected == true ? LongaLottoPosColor.white : LongaLottoPosColor.ball_border_bg, fontSize: 12, fontWeight: listOfAmounts[index].isSelected == true ? FontWeight.bold : FontWeight.w400))),
                                    ),
                                  ).p(2),
                                );
                              }),
                          const HeightBox(20),
                          buttons(isCloseButton ?? false, buttonClick, buttonText, ctx),
                          const HeightBox(10),
                        ],
                      ).pSymmetric(v: 20, h: 50),
                    ],
                  ),
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

  confirmButton(Function(int)? buttonClick, String buttonText, BuildContext ctx) {
    return InkWell(
      onTap: () {
        if(buttonClick != null) {
          buttonClick(betAmount);
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
        child: Center(child: Text(ctx.l10n.ok_cap, style: const TextStyle(color: LongaLottoPosColor.white))),
      ),
    );
  }

  buttons(bool isCloseButton, Function(int) buttonClick,
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
            border: Border.all(color: LongaLottoPosColor.game_color_red)
        ),
        height: 35,
        child: Center(child: Text(ctx.l10n.cancel, style: const TextStyle(color: LongaLottoPosColor.game_color_red))),
      )
    );
  }
}
