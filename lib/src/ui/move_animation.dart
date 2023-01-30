import 'package:flutter/material.dart';

/// Builds a sliding animation for [child], presumably a piece.
class MoveAnimation extends StatefulWidget {
  /// The widget (piece) to animate.
  final Widget child;

  /// Offset to move from in the x axis.
  final double x;

  /// Offset to move from in the y axis.
  final double y;

  /// Duration of the animation.
  final Duration duration;

  /// Curve to use for the animation.
  final Curve curve;

  const MoveAnimation({
    super.key,
    required this.child,
    required this.x,
    required this.y,
    Duration? duration,
    Curve? curve,
  })  : duration = duration ?? const Duration(milliseconds: 250),
        curve = curve ?? Curves.easeInQuad;

  @override
  State<MoveAnimation> createState() => _MoveAnimationState();
}

class _MoveAnimationState extends State<MoveAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  )..forward();
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset(widget.x, widget.y),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ),
  );

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
