import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DialogShimmerContainer extends StatefulWidget {
  Widget childWidget;
  Color color;
  DialogShimmerContainer({Key? key, required this.childWidget, required this.color}) : super(key: key);

  @override
  State<DialogShimmerContainer> createState() => _DialogShimmerContainerState();
}

class _DialogShimmerContainerState extends State<DialogShimmerContainer> {
  @override
  Widget build(BuildContext context) {
    Widget title = Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: const Color(0xFF666870),
          borderRadius: BorderRadius.circular(16)
      ),
      child: widget.childWidget,
    );

    // here's an interesting little trick, we can nest Animate to have
    // effects that repeat and ones that only run once on the same item:
    title = title
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1200.ms, color: widget.color)
        .animate() // this wraps the previous Animate in another Animate
        .fadeIn(duration: 300.ms, curve: Curves.easeIn);

    return title;
  }
}
