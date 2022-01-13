import 'package:flutter/material.dart';
import 'package:squares/src/types.dart';

/// A theme that specifies a number of widget builder functions, used to define
/// how various highlights are drawn on the board.
class HighlightTheme {
  /// Used to highlight empty squares that the currently selected piece could
  /// move to.
  final HighlightBuilder empty;

  /// Used to highlight occupied squares that the currently selected piece could
  /// move to.
  final HighlightBuilder piece;

  const HighlightTheme({required this.empty, required this.piece});

  HighlightTheme copyWith({
    HighlightBuilder? empty,
    HighlightBuilder? piece,
  }) =>
      HighlightTheme(
        empty: empty ?? this.empty,
        piece: piece ?? this.piece,
      );

  /// The default `HighlightTheme`. Circular dots for empty squares.
  static HighlightTheme basic = HighlightTheme(empty: dot, piece: roundedOutline);

  /// A variant `HighlightTheme` with square dots for empty squares.
  static HighlightTheme square = HighlightTheme(empty: squareDot, piece: squareOutline);

  /// Builds a circular dot in the centre of the square, with a diameter equal
  /// to 1/3 of the width of the square.
  static HighlightBuilder dot = (context, size, colour) => Container(
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
  static HighlightBuilder squareDot = (context, size, colour) => Container(
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
  static HighlightBuilder roundedOutline = (context, size, colour) => Container(
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
  static HighlightBuilder squareOutline = (context, size, colour) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(
            color: colour,
            width: size / 16,
          ),
        ),
      );
}
