import 'package:flutter/material.dart';
import 'package:squares/piece_set.dart';

class Square extends StatelessWidget {
  final int id;
  final Color colour;
  final Widget? piece;
  final VoidCallback? onTap;
  final Color? highlight;
  bool get hasPiece => piece != null;
  bool get hasHighlight => highlight != null;
  const Square({
    required this.id,
    required this.colour,
    this.piece,
    this.onTap,
    this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GestureDetector(
        //behavior: HitTestBehavior.translucent,
        onTap: () => onTap!(),
        onLongPress: () => print('lp $id'),
        child: Container(
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
