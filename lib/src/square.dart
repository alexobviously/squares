import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class Square extends StatelessWidget {
  final int id;
  final GlobalKey squareKey;
  final Color colour;
  final Widget? piece;
  final bool draggable;
  final void Function(GlobalKey)? onTap;
  final void Function()? onDragCancel;
  final Color? highlight;
  bool get hasPiece => piece != null;
  bool get hasHighlight => highlight != null;
  Square({
    required this.id,
    required this.squareKey,
    required this.colour,
    this.piece,
    this.draggable = true,
    this.onTap,
    this.onDragCancel,
    this.highlight,
  });

  void _onTap() {
    if (onTap != null) onTap!(squareKey);
  }

  void _onDragCancel() {
    if (onDragCancel != null) onDragCancel!();
  }

  @override
  Widget build(BuildContext context) {
    Widget? _piece = piece;
    if (_piece != null && draggable) {
      _piece = Draggable<int>(
        data: id,
        child: _piece,
        feedback: _piece,
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: _piece,
        ),
        onDragStarted: () => _onTap(),
        onDraggableCanceled: (_, __) => _onDragCancel(),
        onDragEnd: (_) => _onTap(),
      );
    }
    return AspectRatio(
      aspectRatio: 1.0,
      child: GestureDetector(
        //behavior: HitTestBehavior.translucent,
        onTap: _onTap,
        onLongPress: () => print('lp $id'),
        child: Container(
          key: squareKey,
          color: colour,
          child: Stack(
            children: [
              if (hasHighlight)
                Padding(
                  // TODO: make padding dynamic
                  padding: EdgeInsets.all(hasPiece ? 1 : 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: highlight,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              if (hasPiece)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: _piece,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
