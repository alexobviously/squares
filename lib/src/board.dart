import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class Board extends StatelessWidget {
  final GlobalKey boardKey;
  final PieceSet pieceSet;
  final BoardState state;
  final BoardTheme theme;
  final BoardSize size;
  final int? selection;
  final bool gameOver;
  final bool canMove;
  final Function(int, GlobalKey)? onTap;
  final List<int> highlights;

  Board({
    required this.boardKey,
    required this.pieceSet,
    required this.state,
    required this.theme,
    this.size = const BoardSize(8, 8),
    this.selection,
    this.gameOver = false,
    this.canMove = false,
    this.onTap,
    this.highlights = const [],
  });

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
                      int id = rank * size.h + file;
                      String symbol = state.board.length > id ? state.board[id] : '';
                      Widget? piece = symbol.isNotEmpty ? pieceSet.piece(context, symbol) : null;
                      Color squareColour = ((rank + file) % 2 == 0) ? theme.lightSquare : theme.darkSquare;
                      if (state.lastFrom == id || state.lastTo == id)
                        squareColour = Color.alphaBlend(theme.previous, squareColour);
                      if (selection == id) squareColour = Color.alphaBlend(theme.selected, squareColour);
                      if (state.checkSquare == id)
                        squareColour = Color.alphaBlend(gameOver ? theme.checkmate : theme.check, squareColour);
                      bool hasHighlight = highlights.contains(id);
                      return Square(
                        id: rank * size.h + file,
                        colour: squareColour,
                        piece: piece,
                        onTap: onTap != null ? (key) => onTap!(id, key) : null,
                        highlight: hasHighlight ? theme.selected : null,
                      );
                    }),
                  ))),
        )));
  }
}
