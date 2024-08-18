import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../lottery/widgets/shimmer_text.dart';


class QrCodeDialog {
  Color mColor = LongaLottoPosColor.game_color_orange;
  bool isPrintingFailed = false;
  bool isPrintingSuccess = false;
  bool isBuyNowPrintingStarted = true;
  String mTitle = "Printing";
  String mSubTitle = "";
  String mUrl = "";
  String mAmount = "";



  show({
    required BuildContext context,
    required String title,
    required String buttonText,
    required String url,
    required String amount,
    bool? isBackPressedAllowed,
    bool? isCloseButton = false,
    required VoidCallback onPrintingDone,
  }) {
    mTitle = title;
    mUrl = url;
    mAmount = amount;

    DefaultCacheManager manager = DefaultCacheManager();
    manager.emptyCache(); //clears all data in cache.

    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = (orientation == Orientation.landscape);

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: StatefulBuilder(
            builder: (context, StateSetter setInnerState) {
              return Dialog(
                  insetPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 18.0),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * (isLandscape ? 0.5 : 1),
                    child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
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
                                const HeightBox(20),
                                Text(
                                   mAmount,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: isLandscape ? 20 : 18,
                                      color: LongaLottoPosColor.black,
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: CachedNetworkImage(
                                      imageUrl: "$url?${DateTime.now().millisecondsSinceEpoch}",
                                      cacheManager: manager,
                                      progressIndicatorBuilder: (context, url, downloadProgress) {
                                        return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              (downloadProgress.progress == null)
                                                ? CircularProgressIndicator(
                                            value: downloadProgress.progress,
                                            color: LongaLottoPosColor.game_color_green)
                                                : CircularProgressIndicator(
                                                  value: downloadProgress.progress,
                                                  color: LongaLottoPosColor.game_color_green),
                                              downloadProgress.progress != null ? Text("${downloadProgress.progress?.toInt()} %", textAlign: TextAlign.center) : Container()
                                            ]
                                        );
                                      },
                                      errorWidget: (context, url, error) => const Icon(Icons.error), // Error widget
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(),
                                    const WidthBox(10),
                                    Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(ctx).pop();
                                            onPrintingDone();
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: LongaLottoPosColor.game_color_red,
                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                            ),
                                            height: isLandscape ? 65 : 45,
                                            child: Center(child: Text("CLOSE", style: TextStyle(color: LongaLottoPosColor.white, fontSize: isLandscape ? 19 : 14))),
                                          ),
                                        )
                                    ),
                                  ],
                                ) ,
                                const HeightBox(20),

                              ],
                            ).pSymmetric(v: 10, h: 30),
                          ).p(4)
                        ]
                    ),
                  )
              );
            },
          ),
        );
      },
    );
  }

  alertTitle(String title) {
    return TextShimmer(
      color: mColor,
      text: mTitle,
    );
  }

  alertSubTitle(String subTitle, bool isLandscape, {Color subtitleColor = LongaLottoPosColor.red}) {
    return Center(
      child: Text(
        subTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: isLandscape ? 13 : 10,
            color: LongaLottoPosColor.red
        ),
      ),
    );
  }

  alertBuyDoneTitle(bool isLandscape) {
    return Center(
      child: Text(
        "You purchased successfully.",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: isLandscape ? 15 : 13,
            letterSpacing: 2,
            color: LongaLottoPosColor.game_color_blue
        ),
      ),
    );
  }


}
