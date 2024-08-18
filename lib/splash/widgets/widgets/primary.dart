import 'dart:async';
import 'package:flutter/material.dart';
import 'package:longalottoretail/utility/utils.dart';

enum ButtonType {
  solid,
  line_art,
}

class PrimaryButton extends StatefulWidget {
  final String? text;
  final VoidCallback onPressed;
  final bool? enabled;
  final Widget? child;
  final double? borderRadius;
  final double? width;
  final EdgeInsets? margin;
  final double? height;
  final ButtonType? type;
  final Color? color;
  final Color? textColor;

  const PrimaryButton({
    Key? key,
    required this.onPressed,
    this.text,
    this.enabled = true,
    this.child,
    this.borderRadius,
    this.width,
    this.margin,
    this.height,
    this.type = ButtonType.solid,
    this.color,
    this.textColor,
  }) : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool didPressOnce = false;
  @override
  Widget build(BuildContext context) {
    var enabledStyle = ElevatedButton.styleFrom(
      primary: widget.color ?? const Color(0xfffecc58),
      onPrimary: widget.textColor ?? const Color(0xff270132),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 35),
      ),
    );
    var disabledStyle = ElevatedButton.styleFrom(
      primary: widget.color ?? const Color(0xfffecc58),
      onPrimary: widget.textColor ?? Colors.white,
      shadowColor: Colors.transparent,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 35),
      ),
    );
    var lineArtStyle = ElevatedButton.styleFrom(
      primary: Colors.transparent,
      onPrimary: const Color(0xff270132), // textColor
      shadowColor: Colors.transparent,
      elevation: 10,
      onSurface: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 35),
      ),
      side: const BorderSide(width: 1, color: Color(0xff270132)),
    );
    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 18),
      child: ElevatedButton(
        onPressed: widget.enabled == true
            ? didPressOnce == false
                ? () {
                    setState(() => didPressOnce = true);
                    widget.onPressed();
                    Timer(buttonClickThreshold, () {
                      if (!mounted) return;
                      setState(() => didPressOnce = false);
                    });
                  }
                : () {}
            : () {},
        style: widget.type == ButtonType.solid
            ? (widget.enabled == true ? enabledStyle : disabledStyle)
            : lineArtStyle,
        child: widget.text != null
            ? FittedBox(
                fit: BoxFit.fitHeight,
                child: Center(
                  child: Text(
                    widget.text!,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: (widget.type == ButtonType.line_art)
                          ? const Color(0xff270132)
                          : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : widget.child,
      ),
    );
  }
}
