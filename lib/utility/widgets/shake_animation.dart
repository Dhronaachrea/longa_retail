import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final double horizontalPadding;
  final double animationRange;
  final ShakeController controller;
  final Duration animationDuration;

  const ShakeWidget({
    Key? key,
    required this.child,
    this.horizontalPadding = 20,
    this.animationRange = 18,
    required this.controller,
    this.animationDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _ShakeWidgetState createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.setState(this);
    });
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
      value: 0,
    );

    _animation = Tween(begin: 0.0, end: widget.animationRange)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_controller)
      ..addStatusListener(
            (status) {
          if (status == AnimationStatus.completed) {
            _controller.reverse();
          }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation ,
      builder: (context, child) {
        return Container(
          transform: Matrix4.translationValues(_animation.value, 0, 0),
          child: widget.child,
        );
      },
    );
  }
}

class ShakeController {
  _ShakeWidgetState _state = _ShakeWidgetState();

  void setState(_ShakeWidgetState state) {
    _state = state;
  }

  Future<void> shake() {
    return _state._controller.forward(from: 0.0);
  }

  void dispose() {
    _state._controller.stop();
    _state._controller.dispose();
  }
}
