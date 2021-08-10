import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class PromoSelector extends StatelessWidget {
  final double squareSize;
  final List<Widget> pieces;
  final BoardTheme theme;
  final bool startOnLight;
  final Function(int)? onTap;
  PromoSelector({
    required this.squareSize,
    required this.pieces,
    required this.theme,
    this.startOnLight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> squares = [];
    for (int i = 0; i < pieces.length; i++) {
      Square square = Square(
        id: i,
        squareKey: GlobalKey(),
        colour: i % 2 == (startOnLight ? 0 : 1) ? theme.lightSquare : theme.darkSquare,
        piece: pieces[i],
        onTap: onTap != null ? (key) => onTap!(i) : null,
        highlight: theme.selected,
      );
      squares.add(square);
    }
    return Container(
      width: squareSize,
      height: squareSize * squares.length,
      child: Column(children: squares),
    );
  }
}
