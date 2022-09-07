import 'package:flutter/material.dart';
import 'package:squares/src/model/types.dart';

part 'corners_marker.dart';
part 'cross_marker.dart';

/// A theme that specifies a number of widget builder functions, used to define
/// how various markers are drawn on the board.
class MarkerTheme {
  /// Used to mark empty squares that the currently selected piece could
  /// move to.
  final MarkerBuilder empty;

  /// Used to mark occupied squares that the currently selected piece could
  /// move to.
  final MarkerBuilder piece;

  const MarkerTheme({
    required this.empty,
    required this.piece,
  });

  MarkerTheme copyWith({
    MarkerBuilder? empty,
    MarkerBuilder? piece,
  }) =>
      MarkerTheme(
        empty: empty ?? this.empty,
        piece: piece ?? this.piece,
      );

  /// The default `MarkerTheme`. Circular dots for empty squares.
  static MarkerTheme basic = MarkerTheme(
    empty: dot,
    piece: roundedOutline,
  );

  /// A variant `MarkerTheme` with square dots for empty squares.
  static MarkerTheme square = MarkerTheme(
    empty: squareDot,
    piece: squareOutline,
  );

  /// Builds a circular dot in the centre of the square, with a diameter equal
  /// to 1/3 of the width of the square.
  static MarkerBuilder dot = (context, size, colour) => Container(
        width: size,
        height: size,
        child: Padding(
          padding: EdgeInsets.all(size / 3),
          child: Container(
            decoration: BoxDecoration(
              color: colour,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );

  /// Builds a square dot in the centre of the square, with a width equal
  /// to 1/3 of the width of the square.
  static MarkerBuilder squareDot = (context, size, colour) => Container(
        width: size,
        height: size,
        child: Padding(
          padding: EdgeInsets.all(size / 3),
          child: Container(
            decoration: BoxDecoration(
              color: colour,
              shape: BoxShape.rectangle,
            ),
          ),
        ),
      );

  /// Builds a rounded outline border, 1/16th the width of the square.
  static MarkerBuilder roundedOutline = (context, size, colour) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 6),
          border: Border.all(
            color: colour,
            width: size / 16,
          ),
        ),
      );

  /// Builds a square outline border, 1/16th the width of the square.
  static MarkerBuilder squareOutline = (context, size, colour) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(
            color: colour,
            width: size / 16,
          ),
        ),
      );

  static MarkerBuilder corners([double scale = 0.2]) =>
      (context, size, colour) => CustomPaint(
            painter: CornersPainter(colour: colour, scale: scale),
            child: Container(
              width: size,
              height: size,
            ),
          );

  static MarkerBuilder cross([double scale = 0.75]) =>
      (context, size, colour) => CustomPaint(
            painter: CrossPainter(colour: colour, scale: scale),
            child: Container(width: size, height: size),
          );
}
