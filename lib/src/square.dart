import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

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
    if (_piece != null && symbol != null && draggable) {
      _piece = Draggable<PartialMove>(
        data: PartialMove(
          from: id,
          piece: symbol!,
        ),
        child: _piece,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        // TODO: generalise this
        feedback: Transform.translate(offset: Offset(-25, -25), child: _piece),
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
          child: FittedBox(
            child: Container(
              child: Stack(
                children: [
                  if (hasHighlight && !hasPiece)
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Padding(
                          // TODO: make padding dynamic
                          padding: EdgeInsets.all(hasPiece ? 5 : 35),
                          child: Container(
                            decoration: BoxDecoration(
                              color: highlight,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (hasHighlight && hasPiece)
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: highlight!,
                          width: 4.0,
                        ),
                      ),
                    ),
                  if (hasPiece)
                    Container(
                      width: 100,
                      height: 100,
                      // alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        // width: 30,
                        // height: 30,
                        child: _piece,
                      ),
                    ),
                  if (!hasPiece && !hasHighlight) Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
