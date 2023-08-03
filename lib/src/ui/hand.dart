import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
// todo: switch to material's built in badge
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

  /// If true, the number of available pieces will be displayed in a small
  /// badge above each piece.
  final bool showCounts;

  /// Position of piece count badges.
  final badges.BadgePosition? badgePosition;

  /// The style of the piece count badges.
  final badges.BadgeStyle badgeStyle;

  /// Alignment of piece widgets in the main row.
  final MainAxisAlignment mainAxisAlignment;

  /// Called when the piece is tapped.
  final void Function(String)? onTap;

  /// Called when a drag is started.
  final void Function(String)? onDragStarted;

  /// Called when a drag is cancelled.
  final void Function(String)? onDragCancelled;

  /// Called when a drag ends, i.e. it was dropped on a target.
  final void Function(String, DraggableDetails)? onDragEnd;

  /// The size of pieces being dragged will be multiplied by this.
  /// 1.5 is a good value for mobile, but 1.0 is preferable for web.
  final double dragFeedbackSize;

  /// A vector to offset the position of dragged pieces by, relative to the size of the piece.
  /// No offset is recommended for web, and Offset(0,-1) for mobile, in which case
  /// the bottom of the piece will be anchored to the finger.
  final Offset dragFeedbackOffset;

  const Hand({
    required this.squareSize,
    this.stackPieces = true,
    this.theme = BoardTheme.blueGrey,
    required this.pieceSet,
    this.pieces = const [],
    this.fixedPieces = const [],
    this.showCounts = true,
    this.badgePosition,
    this.badgeStyle = const badges.BadgeStyle(),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.onTap,
    this.onDragStarted,
    this.onDragCancelled,
    this.onDragEnd,
    this.dragFeedbackSize = 2.0,
    this.dragFeedbackOffset = const Offset(0.0, -1.0),
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
      if (n > 0 && showCounts) {
        piece = badges.Badge(
          position: badgePosition,
          badgeStyle: badgeStyle,
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
        mainAxisAlignment: mainAxisAlignment,
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
            child: SizedBox(
              width: squareSize,
              height: squareSize,
              child: FittedBox(child: pieceSet.piece(context, symbol)),
            ),
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
      onTap: () => onTap?.call(symbol),
      onDragStarted: () => onDragStarted?.call(symbol),
      onDragCancelled: () => onDragCancelled?.call(symbol),
      onDragEnd: (details) => onDragEnd?.call(symbol, details),
      dragFeedbackSize: dragFeedbackSize,
      dragFeedbackOffset: dragFeedbackOffset,
    );
    return p;
  }
}
