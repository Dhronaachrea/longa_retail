part of "sale_widget.dart";

class SingleMultipleButton extends StatelessWidget {
  final VoidCallback singleButtonOnTap;
  final VoidCallback multipleButtonOnTap;
  final double optionsButtonWidth;
  final double optionsButtonHeight;
  final double buttonRadius;
  final bool isSingle;
  final bool isMultiple;
  const SingleMultipleButton({required this.singleButtonOnTap, required this.multipleButtonOnTap, required this.optionsButtonWidth, super.key, required this.optionsButtonHeight, required this.isSingle, required this.buttonRadius, required this.isMultiple});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: singleButtonOnTap,
          child: Container(
            width: optionsButtonWidth,
            height: optionsButtonHeight,
            decoration: BoxDecoration(
                color: isSingle
                    ? LongaLottoPosColor.grape_purple
                    : LongaLottoPosColor.white,
                border: Border.all(
                  color: LongaLottoPosColor.grape_purple,
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(buttonRadius),
                    bottomLeft:
                    Radius.circular(buttonRadius))),
            child: Center(
                child: Text(
                  context.l10n.single,
                  style: TextStyle(
                      color: isSingle
                          ? LongaLottoPosColor.white
                          : LongaLottoPosColor.grape_purple),
                )),
          ),
        ),
        InkWell(
          onTap: multipleButtonOnTap,
          child: Container(
            width: optionsButtonWidth,
            height: optionsButtonHeight,
            decoration: BoxDecoration(
                color: isMultiple
                    ? LongaLottoPosColor.grape_purple
                    : LongaLottoPosColor.white,
                border: Border.all(
                  color: LongaLottoPosColor.grape_purple,
                ),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(buttonRadius),
                    bottomRight:
                    Radius.circular(buttonRadius))),
            child: Center(
                child: Text(
                  context.l10n.multiple,
                  style: TextStyle(
                      color: isMultiple
                          ? LongaLottoPosColor.white
                          : LongaLottoPosColor.grape_purple),
                )),
          ),
        )
      ],
    ).p(2);
  }
}
