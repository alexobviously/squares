import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class Square extends StatelessWidget {
  final int id;
  final Color colour;
  final Widget? piece;
  final void Function(GlobalKey)? onTap;
  final Color? highlight;
  late GlobalKey _key;
  bool get hasPiece => piece != null;
  bool get hasHighlight => highlight != null;
  Square({
    required this.id,
    required this.colour,
    this.piece,
    this.onTap,
    this.highlight,
  }) {
    _key = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GestureDetector(
        //behavior: HitTestBehavior.translucent,
        onTap: onTap != null ? () => onTap!(_key) : null,
        onLongPress: () => print('lp $id'),
        child: Container(
          key: _key,
          color: colour,
          child: Stack(
            children: [
              if (hasHighlight)
                Padding(
                  // TODO: make padding dynamic
                  padding: EdgeInsets.all(hasPiece ? 1 : 10),
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
                    child: piece,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
