import 'package:flutter/material.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:velocity_x/velocity_x.dart';

class SecondaryButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final Widget? child;
  final double? borderRadius;
  final bool isFilled;
  final IconData? icon;
  final double? height;
  final double? width;
  final Color? fillColor;
  final Color? borderColor;
  final double? fontSize;
  final Color? iconColor;
  final Color? textColor;

  const SecondaryButton({
    Key? key,
    this.text,
    required this.onPressed,
    this.child,
    this.borderRadius,
    this.isFilled = false,
    this.icon,
    this.height,
    this.width,
    this.fillColor,
    this.borderColor,
    this.fontSize,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: icon != null
          ? const BorderRadius.all(
              Radius.circular(40.0),
            )
          : BorderRadius.circular(30),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: height ?? 61,
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: isFilled ? fillColor : null,
            border: Border.all(color: borderColor ?? Colors.white, width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius ?? 25.0),
            ),
          ),
          child: Text(
            text ?? '',
            style: TextStyle(
              fontSize: fontSize ?? 18,
              color: textColor ?? LongaLottoPosColor.white,
            ),
            overflow: TextOverflow.ellipsis,
          ).pOnly(left: 6, right: 6),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final bool? enabled;
  final Widget? child;
  final double? borderRadius;
  final double? width;
  final EdgeInsets? margin;
  final double? height;

  // final ButtonType? type;
  final Color? textColor;
  final Color? borderColor;
  final Color? btnBgColor1;
  final Color? btnBgColor2;
  final Color? fillEnableColor;
  final Color? fillDisableColor;
  final bool? isDarkThemeOn;
  final double? textSize;
  final FontWeight? fontWeight;
  final bool isCancelBtn;

  const PrimaryButton({
    Key? key,
    this.text,
    required this.onPressed,
    this.enabled,
    this.child,
    this.borderRadius,
    this.width,
    this.margin,
    this.height,
    // this.type = ButtonType.solid,
    this.textColor,
    this.borderColor,
    this.fillEnableColor,
    this.fillDisableColor,
    this.isDarkThemeOn = true,
    this.textSize,
    this.btnBgColor1,
    this.btnBgColor2,
    this.fontWeight,
    this.isCancelBtn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
          height: height ?? 61,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: fillEnableColor,
              gradient: !isCancelBtn
                  ? LinearGradient(colors: [
                      btnBgColor1 ?? LongaLottoPosColor.butter_scotch,
                      btnBgColor2 ?? LongaLottoPosColor.orangey_red,
                    ])
                  : null,
              borderRadius: BorderRadius.circular(borderRadius ?? 40),
              border: Border.all(
                  color: borderColor ?? LongaLottoPosColor.reddish_pink,
                  width: isCancelBtn ? 3.0 : 0.0)),
          // margin: const EdgeInsets.all(10),
          child: Text(
            text ?? '',
            style: TextStyle(
              fontSize: textSize ?? 18,
              fontWeight: fontWeight ?? FontWeight.w800,
              color: textColor ?? LongaLottoPosColor.white,
            ),
          )),
    );
  }
}
