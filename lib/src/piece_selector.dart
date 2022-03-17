import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

/// A popup widget used to select pieces to be used for promotion, or for gating.
class PieceSelector extends StatelessWidget {
  final BoardTheme theme;
  final PieceSet pieceSet;
  final double squareSize;
  final List<String> pieces;
  final bool startOnLight;
  final Function(int)? onTap;
  PieceSelector({
    required this.theme,
    required this.pieceSet,
    required this.squareSize,
    required this.pieces,
    this.startOnLight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> _pieces = pieces.map((p) => pieceSet.piece(context, p)).toList();
    List<Widget> squares = [];
    for (int i = 0; i < _pieces.length; i++) {
      Square square = Square(
        id: i,
        squareKey: GlobalKey(),
        colour: i % 2 == (startOnLight ? 0 : 1) ? theme.lightSquare : theme.darkSquare,
        piece: _pieces[i],
        symbol: pieces[i],
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
