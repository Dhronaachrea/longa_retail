part of "sale_widget.dart";

class SeriesRandomButton extends StatelessWidget {
  final bool isMultiple;
  final double optionsButtonWidth;
  final double optionsButtonHeight;
  final double buttonRadius;
  final bool isSingle;
  final bool isRandom;
  final bool isSeries;
  final VoidCallback seriesButtonOnTap;
  final VoidCallback randomButtonOnTap;
  const SeriesRandomButton({super.key, required this.isMultiple, required this.optionsButtonWidth, required this.optionsButtonHeight, required this.buttonRadius, required this.isSingle, required this.seriesButtonOnTap, required this.randomButtonOnTap, required this.isRandom, required this.isSeries});

  @override
  Widget build(BuildContext context) {
    return isMultiple
        ? SizedBox(
      height: optionsButtonHeight + 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: seriesButtonOnTap,
            child: Container(
              width: optionsButtonWidth,
              height: optionsButtonHeight,
              decoration: BoxDecoration(
                color: isSeries
                    ? LongaLottoPosColor.medium_green
                    : LongaLottoPosColor.white,
                border: Border.all(
                  color:
                  LongaLottoPosColor.medium_green,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(buttonRadius),
                ),
              ),
              child: Center(
                  child: Text(
                    context.l10n.series,
                    style: TextStyle(
                        color: isSeries
                            ? LongaLottoPosColor.white
                            : LongaLottoPosColor
                            .medium_green),
                  )),
            ).p(5),
          ),
          InkWell(
            onTap: randomButtonOnTap,
            child: Container(
              width: optionsButtonWidth,
              height: optionsButtonHeight,
              decoration: BoxDecoration(
                color: isRandom
                    ? LongaLottoPosColor.medium_green
                    : LongaLottoPosColor.white,
                border: Border.all(
                  color:
                  LongaLottoPosColor.medium_green,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(buttonRadius),
                ),
              ),
              child: Center(
                  child: Text(
                    context.l10n.random,
                    style: TextStyle(
                        color: isRandom
                            ? LongaLottoPosColor.white
                            : LongaLottoPosColor
                            .medium_green),
                  )),
            ).p(5),
          )
        ],
      ),
    )
        : SizedBox(
      height: optionsButtonHeight + 10,
    );
  }
}
