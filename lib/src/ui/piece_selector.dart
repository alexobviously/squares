import 'dart:math';

import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

/// A popup widget used to select pieces to be used for promotion, or for gating.
class PieceSelector extends StatelessWidget {
  final PieceSelectorData data;
  final BoardTheme theme;

  /// Widget builders for the various types of square markers used.
  late final MarkerTheme markerTheme;
  final PieceSet pieceSet;
  final double squareSize;
  final Function(int)? onTap;

  PieceSelector({
    required this.data,
    required this.theme,
    MarkerTheme? markerTheme,
    required this.pieceSet,
    required this.squareSize,
    this.onTap,
  }) : markerTheme = markerTheme ?? MarkerTheme.basic;

  @override
  Widget build(BuildContext context) {
    List<Widget> pieces =
        data.pieces.map((p) => p == null ? Container() : pieceSet.piece(context, p)).toList();
    return Container(
      width: squareSize,
      height: squareSize * pieces.length,
      child: Column(
        children: [
          ...pieces.asMap().entries.map(
                (e) => GestureDetector(
                  onTap: () => onTap?.call(e.key),
                  child: Container(
                    width: squareSize,
                    height: squareSize,
                    color: e.key % 2 == (data.startLight ? 0 : 1)
                        ? theme.lightSquare
                        : theme.darkSquare,
                    child: Stack(
                      children: [
                        markerTheme.piece(context, squareSize, theme.selected),
                        e.value,
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class PositionedPieceSelector extends StatelessWidget {
  final PieceSelectorData data;
  final BoardState boardState;
  final BoardSize boardSize;
  final BoardTheme theme;

  /// Widget builders for the various types of square markers used.
  late final MarkerTheme markerTheme;
  final PieceSet pieceSet;
  final double squareSize;
  final Function(int)? onTap;

  PositionedPieceSelector({
    required this.data,
    required this.boardState,
    required this.boardSize,
    required this.theme,
    MarkerTheme? markerTheme,
    required this.pieceSet,
    required this.squareSize,
    this.onTap,
  }) : markerTheme = markerTheme ?? MarkerTheme.basic;

  @override
  Widget build(BuildContext context) {
    int square = data.gate ? (data.gatingSquare ?? data.square) : data.square;
    int rank = boardSize.squareRank(square) - 1;
    int file = boardSize.squareFile(square);
    bool flip = (data.gate && boardState.orientation == boardState.player) ||
        ((boardState.orientation == Squares.white && rank == 0) ||
            (boardState.orientation == Squares.black && rank == boardSize.maxRank));
    if (boardState.orientation == Squares.white) {
      rank = boardSize.v - rank - 1;
    }
    if (boardState.orientation == Squares.black) {
      file = boardSize.h - file - 1;
    }
    if (flip) {
      rank = rank - data.pieces.length + 1;
    }
    double x = squareSize * file;
    double y = squareSize * rank;
    return Positioned(
      left: x,
      top: y,
      child: PieceSelector(
        data: data,
        theme: theme,
        markerTheme: markerTheme,
        pieceSet: pieceSet,
        squareSize: squareSize,
        onTap: onTap,
      ),
    );
  }
}