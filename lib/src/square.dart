import 'package:flutter/material.dart';
import 'package:squares/squares.dart';
import 'package:squares/src/highlight_theme.dart';

/// A single square on a chess board or piece selector.
/// Optionally contains a [piece].
class Square extends StatelessWidget {
  /// A unique id identifying this square within a `Board` or `Hand`.
  /// Usually dervied from the rank and file of the square within the board.
  final int id;

  /// A key that will be given to the interior square widget.
  /// Used for getting the position of the square for promotion selector popups.
  final GlobalKey squareKey;

  /// Background colour of the square.
  final Color colour;

  /// A widget that represents the piece on the square.
  final Widget? piece;

  /// A single-character symbol representing the piece of the square. e.g. 'N', 'k'.
  final String? symbol;

  /// Whether the piece on this square can be dragged.
  final bool draggable;

  /// The size of the piece being dragged will be multiplied by this.
  /// 1.5 is a good value for mobile, but 1.0 is preferable for web.
  final double dragFeedbackSize;

  /// A callback for when the square is tapped, or a drag is started or finished.
  final void Function(GlobalKey)? onTap;

  /// A callback for when a drag action is cancelled.
  final void Function()? onDragCancel;

  /// The colour to use for highlight decoration, usually this is used for when a square is being
  /// highlighted for targeting.
  /// Leave as null for no highlight.
  final Color? highlight;

  /// The theme to use when building piece/square highlights.
  /// See `HighlightTheme` for more details.
  late final HighlightTheme highlightTheme;

  /// Is there a piece on this square?
  bool get hasPiece => piece != null;

  /// Is this square highlighted?
  bool get hasHighlight => highlight != null;

  Square({
    required this.id,
    required this.squareKey,
    required this.colour,
    this.piece,
    this.symbol,
    this.draggable = true,
    this.dragFeedbackSize = 1.5,
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
          double _fbSize = _size * dragFeedbackSize;
          _piece = Draggable<PartialMove>(
            data: PartialMove(
              from: id,
              piece: symbol!,
            ),
            child: piece!,
            dragAnchorStrategy: pointerDragAnchorStrategy,
            feedback: Transform.translate(
              offset: Offset(-_fbSize / 2, -_fbSize / 2),
              child: Container(
                width: _fbSize,
                height: _fbSize,
                child: piece,
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.5,
              child: piece!,
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
                if (hasPiece) Container(width: _size, height: _size, child: FittedBox(child: _piece!)),
              ],
            ),
          ),
        );
      },
    );
  }
}
