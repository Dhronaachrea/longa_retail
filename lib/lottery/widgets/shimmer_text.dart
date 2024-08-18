import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TextShimmer extends StatefulWidget {
  Color color;
  String text;
  TextShimmer({Key? key, required this.color, required this.text}) : super(key: key);

  @override
  State<TextShimmer> createState() => _TextShimmerState();
}

class _TextShimmerState extends State<TextShimmer> {
  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      widget.text,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF666870),
      )
    );

    title = title
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1200.ms, color: widget.color)
        .animate() // this wraps the previous Animate in another Animate
        .fadeIn(duration: 300.ms, curve: Curves.easeIn);

    return title;
  }
}
