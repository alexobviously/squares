import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class Board extends StatelessWidget {
  final GlobalKey boardKey;
  final PieceSet pieceSet;
  final BoardState state;
  final BoardTheme theme;
  final BoardSize size;
  final int? selection;
  final int? target;
  final bool gameOver;
  final bool canMove;
  final Function(int, GlobalKey)? onTap;
  final Function(int)? onDragCancel;
  final bool Function(int, int)? validateDrag;
  final Function(int, int, GlobalKey)? acceptDrag;
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

  bool _validateDrag(int? from, int to) {
    if (from == null || validateDrag == null) return false;
    return validateDrag!(from, to);
  }

  void _acceptDrag(int? from, int to, GlobalKey squareKey) {
    if (from == null || acceptDrag == null) return;
    acceptDrag!(from, to, squareKey);
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
                      return DragTarget<int>(
                        builder: (context, accepted, rejected) {
                          return Square(
                            id: id,
                            squareKey: squareKey,
                            colour: squareColour,
                            piece: piece,
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
