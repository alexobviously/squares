import 'package:flutter/material.dart';

class MoveAnimation extends StatefulWidget {
  final Widget child;
  final double x;
  final double y;
  final Duration duration;
  const MoveAnimation({
    Key? key,
    required this.child,
    required this.x,
    required this.y,
    this.duration = const Duration(milliseconds: 250),
  }) : super(key: key);

  @override
  State<MoveAnimation> createState() => _MoveAnimationState();
}

class _MoveAnimationState extends State<MoveAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  )..forward();
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset(widget.x, widget.y),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }
}
