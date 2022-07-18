import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class BoardBackground extends StatelessWidget {
  /// Dimensions of the board.
  final BoardSize size;

  /// Determines which way around the board is facing.
  /// 0 (white) will place the white pieces at the bottom,
  /// and 1 will place the black pieces there.
  final int orientation;

  /// Colour scheme for the board.
  final BoardTheme theme;

  /// Sq=uares that should be highlighted (i.e. have their background colour set).
  /// The key is the square index.
  final Map<int, HighlightType> highlights;

  /// Squares that should be marked. The key is the square index.
  final Map<int, Marker> markers;

  /// Widget builders for the various types of square highlights used.
  late final MarkerTheme markerTheme;

  BoardBackground({
    super.key,
    this.size = BoardSize.standard,
    this.orientation = WHITE,
    this.theme = BoardTheme.BROWN,
    this.highlights = const {},
    this.markers = const {},
    MarkerTheme? highlightTheme,
  }) : this.markerTheme = highlightTheme ?? MarkerTheme.basic;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: size.h / size.v,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double squareSize = constraints.maxWidth / size.h;
          return Column(
            children: List.generate(
              size.v,
              (rank) => Expanded(
                child: Row(
                  children: List.generate(
                    size.h,
                    (file) => _square(context, rank, file, squareSize),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _square(BuildContext context, int rank, int file, double squareSize) {
    int id = (orientation == WHITE ? rank : size.v - rank - 1) * size.h +
        (orientation == WHITE ? file : size.h - file - 1);

    Color squareColour = ((rank + file) % 2 == 0) ? theme.lightSquare : theme.darkSquare;
    if (highlights.containsKey(id)) {
      squareColour = Color.alphaBlend(
        theme.highlight(highlights[id]!),
        squareColour,
      );
    }

    Widget? marker;
    if (markers.containsKey(id)) {
      final m = markers[id]!;
      marker = m.hasPiece
          ? markerTheme.piece(context, squareSize, theme.highlight(m.colour))
          : markerTheme.empty(context, squareSize, theme.highlight(m.colour));
    }

    return Container(
      width: squareSize,
      height: squareSize,
      color: squareColour,
      child: marker,
    );
  }
}
