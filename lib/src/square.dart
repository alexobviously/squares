import 'package:flutter/material.dart';
import 'package:squares/squares.dart';
import 'package:squares/src/highlight_theme.dart';

class Square extends StatelessWidget {
  final int id;
  final GlobalKey squareKey;
  final Color colour;
  final Widget? piece;
  final String? symbol;
  final bool draggable;
  final void Function(GlobalKey)? onTap;
  final void Function()? onDragCancel;
  final Color? highlight;
  late final HighlightTheme highlightTheme;
  bool get hasPiece => piece != null;
  bool get hasHighlight => highlight != null;
  Square({
    required this.id,
    required this.squareKey,
    required this.colour,
    this.piece,
    this.symbol,
    this.draggable = true,
    this.onTap,
    this.onDragCancel,
    this.highlight,
    HighlightTheme? highlightTheme,
  }) : this.highlightTheme = highlightTheme ?? HighlightTheme.basic;

  void _onTap() {
    if (onTap != null) onTap!(squareKey);
  }

  void _onDragCancel() {
    if (onDragCancel != null) onDragCancel!();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double _size = 50;
        if (constraints.maxWidth != double.infinity) {
          _size = constraints.maxWidth;
        } else if (constraints.maxHeight != double.infinity) {
          _size = constraints.maxHeight;
        }

        Widget? _piece = piece;
        if (piece != null && symbol != null && draggable) {
          _piece = Draggable<PartialMove>(
            data: PartialMove(
              from: id,
              piece: symbol!,
            ),
            child: piece!,
            dragAnchorStrategy: pointerDragAnchorStrategy,
            feedback: Transform.translate(
              offset: Offset(-_size / 2, -_size / 2),
              child: Container(
                width: _size,
                height: _size,
                child: piece,
              ),
            ),
            // feedback: Transform.translate(offset: Offset(-25, -25), child: _piece),
            childWhenDragging: Opacity(
              opacity: 0.5,
              child: piece,
            ),
            onDragStarted: () => _onTap(),
            onDraggableCanceled: (_, __) => _onDragCancel(),
            onDragEnd: (_) => _onTap(),
          );
        }

        return GestureDetector(
          onTap: _onTap,
          child: Container(
            key: squareKey,
            width: _size,
            height: _size,
            color: colour,
            child: Stack(
              children: [
                if (hasHighlight && !hasPiece) highlightTheme.empty(context, _size, highlight!),
                if (hasHighlight && hasPiece) highlightTheme.piece(context, _size, highlight!),
                if (hasPiece) _piece!,
              ],
            ),
          ),
        );
      },
    );
  }
}
