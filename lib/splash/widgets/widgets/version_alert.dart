import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:longalottoretail/l10n/l10n.dart';
import 'package:longalottoretail/splash/widgets/widgets/primary.dart';
import 'package:longalottoretail/splash/widgets/widgets/tertiary.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../utility/longa_lotto_pos_color.dart';

enum VersionAlertType {
  mandatory,
  optional,
}

class VersionAlert {
  static show({
    required BuildContext context,
    required VersionAlertType type,
    required String message,
    String? description,
    VoidCallback? onUpdate,
    VoidCallback? onCancel,
  }) {
    bool isLoading = false;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Center(
              child: Material(
                color: Colors.transparent,
                child: Wrap(
                  children: [
                    Stack(
                        children:[
                          Container(
                            margin: const EdgeInsets.all(18),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                    ]),

                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: LongaLottoPosColor.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [

                                        const HeightBox(15),
                                        const HeightBox(10),
                                        const Text(
                                          "Longa Lotto Retail",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: LongaLottoPosColor.navy_blue,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const HeightBox(8),
                                        Text(
                                          message,
                                          style: const TextStyle(
                                            color: LongaLottoPosColor.app_blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        description != null
                                            ? Text(
                                          description,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ).py8()
                                            : Container(),
                                        const HeightBox(20),
                                        type == VersionAlertType.optional
                                            ? isLoading
                                                ? SizedBox(height: 20,).pOnly(left: 30,right: 30)
                                                : Row(children: [
                                                Expanded(
                                                  child: TertiaryButton(
                                                    textColor: LongaLottoPosColor.game_color_red,
                                                    type: ButtonType.line_art,
                                                    onPressed: onCancel != null
                                                        ? () {
                                                      Navigator.of(ctx).pop();
                                                      onCancel();
                                                    }
                                                        : () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    text: (context.l10n.no).toString(),
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const WidthBox(10),
                                                Expanded(
                                                  child: TertiaryButton(
                                                    color: LongaLottoPosColor.butter_scotch,
                                                    onPressed: onUpdate != null
                                                        ? () {
                                                      // Navigator.of(ctx).pop();
                                                      setState((){
                                                        isLoading = false;
                                                      });
                                                      onUpdate();
                                                    }
                                                        : () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    text: (context.l10n.update).toString(),
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],).pOnly(left: 30,right: 30)
                                            : isLoading
                                                ? SizedBox(height: 20,).pOnly(left: 30,right: 30)
                                                : TertiaryButton(
                                              color: LongaLottoPosColor.game_color_red,
                                              width: context.screenWidth,
                                              onPressed: onUpdate != null
                                                  ? () {
                                                // Navigator.of(ctx).pop();
                                                setState((){
                                                  isLoading = false;
                                                });
                                                onUpdate();
                                              }
                                                  : () {
                                                Navigator.of(ctx).pop();
                                              },
                                              text: (context.l10n.update).toString(),
                                            ).pOnly(left: 30,right: 30),

                                        /*isLoading
                                            ? LinearProgressIndicator(
                                                color: LongaLottoPosColor.navy_blue,
                                              )
                                            : Container()*/
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              top: -30,
                              left: 110,
                              child: Image.asset('assets/images/logo.webp',width: 150, height: 130,
                              )
                          ),
                        ]
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
