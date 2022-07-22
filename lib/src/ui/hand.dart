import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:squares/squares.dart';

/// A hand of pieces to drop from, such as in Crazyhouse.
class Hand extends StatelessWidget {
  // The size (width/height) of one square.
  final double squareSize;

  /// Whether to stack duplicate pieces, or lay them out individually.
  final bool stackPieces;

  /// The theme to derive colours from.
  final BoardTheme theme;

  /// The set of widgets to use for pieces on the board.
  final PieceSet pieceSet;

  /// A list of the pieces in the hand. These should be single character piece symbols.
  /// Uppercase symbols will be white, lowercase ones will be black.
  final List<String> pieces;

  /// A list of the piece types that should be fixed in the hand. These will always be
  /// present in the hand, in dulled form, even if there are no pieces of their type available.
  final List<String> fixedPieces;

  /// Position of piece count badges.
  final BadgePosition? badgePosition;

  /// Shape of piece count badges.
  final BadgeShape badgeShape;

  /// Colour of piece count badges.
  final Color badgeColour;

  const Hand({
    required this.squareSize,
    this.stackPieces = true,
    required this.theme,
    required this.pieceSet,
    required this.pieces,
    this.fixedPieces = const [],
    this.badgePosition,
    this.badgeShape = BadgeShape.circle,
    this.badgeColour = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, int> pieceMap = {};
    for (String p in fixedPieces) {
      pieceMap[p] = 0;
    }
    for (String p in pieces) {
      pieceMap[p] = (!pieceMap.containsKey(p) ? 1 : pieceMap[p]! + 1);
    }
    List<Widget> squares = [];
    pieceMap.forEach((symbol, n) {
      Widget piece = _piece(context, symbol, n);
      if (n > 0) {
        piece = Badge(
          position: badgePosition,
          shape: badgeShape,
          badgeColor: badgeColour,
          badgeContent: Text(
            '$n',
            style: TextStyle(color: Colors.white),
          ),
          child: piece,
        );
      }
      squares.add(piece);
    });
    return Container(
      height: squareSize,
      child: Row(
        children: squares,
      ),
    );
  }

  Widget _piece(
    BuildContext context,
    String symbol,
    int count,
  ) {
    Widget piece = symbol.isNotEmpty
        ? Opacity(
            opacity: count > 0 ? 1.0 : 0.5,
            child: pieceSet.piece(context, symbol),
          )
        : SizedBox(
            width: squareSize,
            height: squareSize,
          );
    final p = Piece(
      child: piece,
      draggable: count > 0,
      move: PartialMove(
        from: Squares.hand,
        piece: symbol,
      ),
    );
    return p;
  }
}
