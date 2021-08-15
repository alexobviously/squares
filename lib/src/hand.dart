import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:squares/squares.dart';

class Hand extends StatelessWidget {
  final double squareSize;
  final bool stackPieces;
  final BoardTheme theme;
  final PieceSet pieceSet;
  final List<String> pieces;
  final List<String>? fixedPieces;

  const Hand({
    required this.squareSize,
    this.stackPieces = true,
    required this.theme,
    required this.pieceSet,
    required this.pieces,
    this.fixedPieces,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, int> _pieces = {};
    if (fixedPieces != null) fixedPieces!.forEach((p) => _pieces[p] = 0);
    pieces.forEach((p) => _pieces[p] = (!_pieces.containsKey(p) ? 1 : _pieces[p]! + 1));
    List<Widget> squares = [];
    int i = 0;
    _pieces.forEach((symbol, num) {
      Widget square = Square(
        id: i,
        draggable: num > 0,
        squareKey: GlobalKey(),
        colour: Color(0x00000000),
        piece: symbol.isNotEmpty
            ? Opacity(
                opacity: num > 0 ? 1.0 : 0.5,
                child: pieceSet.piece(context, symbol),
              )
            : null,
      );
      if (num > 0)
        square = Badge(
          badgeContent: Text(
            '$num',
            style: TextStyle(color: Colors.white),
          ),
          child: square,
        );
      squares.add(square);
      i++;
    });
    return Container(
      height: squareSize,
      child: Row(
        children: squares,
      ),
    );
  }
}
