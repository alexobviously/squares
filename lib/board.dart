import 'package:flutter/material.dart';
import 'package:squares/board_state.dart';
import 'package:squares/piece_set.dart';
import 'package:squares/square.dart';
import 'package:squares/squares.dart';
import 'package:squares/types.dart';

class Board extends StatelessWidget {
  final GlobalKey boardKey;
  final PieceSet pieceSet;
  final BoardState state;
  final BoardSize size;
  final Color? light;
  final Color? dark;
  final Color? highlightFromColour;
  final Color? highlightToColour;
  final Color? checkColour;
  final Color? checkmateColour;
  final int? selectedFrom;
  final int? selectedTo;
  final int? checkSquare;
  final bool gameOver;
  final bool canMove;
  final Function(int, GlobalKey)? onTap;
  final List<int> highlights;

  Board({
    required this.boardKey,
    required this.pieceSet,
    required this.state,
    this.size = const BoardSize(8, 8),
    this.light,
    this.dark,
    this.highlightFromColour,
    this.highlightToColour,
    this.checkColour,
    this.checkmateColour,
    this.selectedFrom,
    this.selectedTo,
    this.checkSquare,
    this.gameOver = false,
    this.canMove = false,
    this.onTap,
    this.highlights = const [],
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color _light = light ?? theme.primaryColorLight;
    Color _dark = dark ?? theme.primaryColorDark;
    Color _highlightFrom = highlightFromColour ?? theme.accentColor;
    Color _highlightTo = highlightToColour ?? theme.accentColor;
    Color _check = checkColour ?? theme.secondaryHeaderColor;
    Color _checkmate = checkmateColour ?? theme.errorColor;
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
                      Color squareColour = ((rank + file) % 2 == 0) ? _light : _dark;
                      if (selectedFrom == id) squareColour = _highlightFrom;
                      if (selectedTo == id) squareColour = _highlightTo;
                      if (checkSquare == id) squareColour = gameOver ? _checkmate : _check;
                      bool hasHighlight = highlights.contains(id);
                      return Square(
                        id: rank * size.h + file,
                        colour: squareColour,
                        piece: piece,
                        onTap: onTap != null ? (key) => onTap!(id, key) : null,
                        highlight: hasHighlight ? Colors.orange.withAlpha(120) : null,
                      );
                    }),
                  ))),
        )));
  }
}
