import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:squares/squares.dart';

/// A hand of pieces to drop from, such as in Crazyhouse.
class Hand extends StatelessWidget {
  // The width/height of one square.
  final double squareSize;
  final bool stackPieces;
  final BoardTheme theme;
  final PieceSet pieceSet;

  /// A list of the pieces in the hand. These should be single character piece symbols.
  /// Uppercase symbols will be white, lowercase ones will be black.
  final List<String> pieces;

  /// A list of the piece types that should be fixed in the hand. These will always be
  /// present in the hand, in dulled form, even if there are no pieces of their type available.
  final List<String>? fixedPieces;

  // Position of piece count badges.
  final BadgePosition? badgePosition;
  // Shape of piece count badges.
  final BadgeShape badgeShape;
  // Colour of piece count badges.
  final Color badgeColour;

  const Hand({
    required this.squareSize,
    this.stackPieces = true,
    required this.theme,
    required this.pieceSet,
    required this.pieces,
    this.fixedPieces,
    this.badgePosition,
    this.badgeShape = BadgeShape.circle,
    this.badgeColour = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, int> pieceMap = {};
    if (fixedPieces != null) fixedPieces!.forEach((p) => pieceMap[p] = 0);
    pieces.forEach((p) => pieceMap[p] = (!pieceMap.containsKey(p) ? 1 : pieceMap[p]! + 1));
    List<Widget> squares = [];
    int i = 0;
    pieceMap.forEach((symbol, n) {
      Widget square = Square(
        id: Squares.hand,
        draggable: n > 0,
        squareKey: GlobalKey(),
        colour: Color(0x00000000),
        piece: symbol.isNotEmpty
            ? Opacity(
                opacity: n > 0 ? 1.0 : 0.5,
                child: pieceSet.piece(context, symbol),
              )
            : null,
        symbol: symbol,
        // onTap: (key) => print('onTap $symbol'),
        // onDragCancel: () => print('onDC $symbol'),
      );
      if (n > 0) {
        square = Badge(
          position: badgePosition,
          shape: badgeShape,
          badgeColor: badgeColour,
          badgeContent: Text(
            '$n',
            style: TextStyle(color: Colors.white),
          ),
          child: square,
        );
      }
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