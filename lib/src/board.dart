import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

/// The visual representation of the board. Can be used by itself to simply display
/// a board, or in conjunction with [BoardController] or some other wrapper to
/// manage its state and handle interactions.
class Board extends StatelessWidget {
  final GlobalKey boardKey;
  final PieceSet pieceSet;
  final BoardState state;
  final BoardTheme theme;
  final BoardSize size;

  /// The currently selected square index.
  final int? selection;

  /// The currently selected target square index (for premoves).
  final int? target;

  /// Is the game over?
  final bool gameOver;

  /// If false, premoves will be allowed.
  final bool canMove;

  /// Called when a square is tapped.
  final Function(int, GlobalKey)? onTap;

  /// Called when a piece drag is cancelled.
  final Function(int)? onDragCancel;

  /// Called when a piece moves over a new square. This includes external pieces,
  /// such as those that came from hands.
  final bool Function(PartialMove, int)? validateDrag;

  /// Called when a square accepts a piece dragged onto it.
  final Function(PartialMove, int, GlobalKey)? acceptDrag;

  /// A list of highlighted square indices. Usually this will correspond to squares
  /// that the selected piece can move to.
  final List<int> highlights;

  Board({
    required this.boardKey,
    required this.pieceSet,
    required this.state,
    required this.theme,
    this.size = const BoardSize(8, 8),
    this.selection,
    this.target,
    this.gameOver = false,
    this.canMove = false,
    this.onTap,
    this.onDragCancel,
    this.validateDrag,
    this.acceptDrag,
    this.highlights = const [],
  });

  void _onDragCancel(int square) {
    if (onDragCancel != null) onDragCancel!(square);
  }

  bool _validateDrag(PartialMove? move, int to) {
    if (move == null || validateDrag == null) return false;
    return validateDrag!(move, to);
  }

  void _acceptDrag(PartialMove? move, int to, GlobalKey squareKey) {
    if (move == null || acceptDrag == null) return;
    acceptDrag!(move, to, squareKey);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        key: boardKey,
        aspectRatio: size.h / size.v,
        child: Container(
            child: Column(
          children: List.generate(
              size.v,
              (rank) => Expanded(
                      child: Row(
                    children: List.generate(size.h, (file) {
                      int id = (state.orientation == WHITE ? rank : size.v - rank - 1) * size.h + file;
                      GlobalKey squareKey = GlobalKey();
                      String symbol = state.board.length > id ? state.board[id] : '';
                      Widget? piece = symbol.isNotEmpty ? pieceSet.piece(context, symbol) : null;
                      Color squareColour = ((rank + file) % 2 == 0) ? theme.lightSquare : theme.darkSquare;
                      if (state.lastFrom == id || state.lastTo == id)
                        squareColour = Color.alphaBlend(theme.previous, squareColour);
                      if (selection == id)
                        squareColour = Color.alphaBlend(canMove ? theme.selected : theme.premove, squareColour);
                      if (state.checkSquare == id)
                        squareColour = Color.alphaBlend(gameOver ? theme.checkmate : theme.check, squareColour);
                      if (target == id) squareColour = Color.alphaBlend(theme.premove, squareColour);
                      bool hasHighlight = highlights.contains(id);
                      return DragTarget<PartialMove>(
                        builder: (context, accepted, rejected) {
                          return Square(
                            id: id,
                            squareKey: squareKey,
                            colour: squareColour,
                            piece: piece,
                            symbol: symbol,
                            draggable: true,
                            onTap: onTap != null ? (key) => onTap!(id, key) : null,
                            onDragCancel: () => _onDragCancel(id),
                            highlight: hasHighlight ? (canMove ? theme.selected : theme.premove) : null,
                          );
                        },
                        onWillAccept: (from) => _validateDrag(from, id),
                        onAccept: (from) => _acceptDrag(from, id, squareKey),
                      );
                    }),
                  ))),
        )));
  }
}
