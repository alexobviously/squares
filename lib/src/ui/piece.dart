import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class Piece extends StatelessWidget {
  /// A widget that represents the piece.
  final Widget child;

  /// A single-character symbol representing the piece of the square. e.g. 'N', 'k'.
  final PartialMove move;

  /// Whether the piece on this square can be dragged.
  final bool draggable;

  /// Whether the piece can be interacted with.
  /// This must be false when any other piece is being dragged, to avoid
  /// the GestureDetector absorbing the drag.
  final bool interactible;

  /// The size of the piece being dragged will be multiplied by this.
  /// 1.5 is a good value for mobile, but 1.0 is preferable for web.
  final double dragFeedbackSize;

  /// A vector to offset the position of dragged pieces by, relative to the size of the piece.
  /// No offset is recommended for web, and Offset(0,-1) for mobile, in which case
  /// the bottom of the piece will be anchored to the finger.
  final Offset dragFeedbackOffset;

  /// Called when the piece is tapped.
  final VoidCallback? onTap;

  /// Called when a drag is started.
  final VoidCallback? onDragStarted;

  /// Called when a drag is cancelled.
  final VoidCallback? onDragCancelled;

  /// Called when a drag ends, i.e. it was dropped on a target.
  final void Function(DraggableDetails)? onDragEnd;

  const Piece({
    super.key,
    required this.child,
    required this.move,
    this.draggable = true,
    this.interactible = true,
    this.dragFeedbackSize = 2.0,
    this.dragFeedbackOffset = const Offset(0.0, -1.0),
    this.onTap,
    this.onDragStarted,
    this.onDragCancelled,
    this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    if (!interactible) return IgnorePointer(child: child);
    Widget piece = GestureDetector(
      child: child,
      onTap: onTap,
    );
    if (!draggable) return piece;

    return LayoutBuilder(
      builder: (context, constraints) {
        double size = 50;
        if (constraints.maxWidth != double.infinity) {
          size = constraints.maxWidth;
        } else if (constraints.maxHeight != double.infinity) {
          size = constraints.maxHeight;
        }
        double fbSize = size * dragFeedbackSize;

        return Draggable<PartialMove>(
          data: move,
          child: FittedBox(child: piece),
          hitTestBehavior: HitTestBehavior.translucent,
          feedback: Transform.translate(
            offset: Offset(
              ((dragFeedbackOffset.dx - 1) * fbSize) / 2,
              ((dragFeedbackOffset.dy - 1) * fbSize) / 2,
            ),
            child: SizedBox(
              width: fbSize,
              height: fbSize,
              child: piece,
            ),
          ),
          dragAnchorStrategy: pointerDragAnchorStrategy,
          childWhenDragging: Opacity(
            opacity: 0.5,
            child: piece,
          ),
          onDragStarted: onDragStarted,
          onDraggableCanceled: (_, __) => onDragCancelled?.call(),
          onDragEnd: onDragEnd,
          maxSimultaneousDrags: 1,
        );
      },
    );
  }
}
