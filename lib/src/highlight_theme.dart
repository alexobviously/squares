import 'package:flutter/material.dart';
import 'package:squares/src/types.dart';

class HighlightTheme {
  final HighlightBuilder empty;
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

  static HighlightTheme basic = HighlightTheme(empty: dot, piece: roundedOutline);
  static HighlightTheme square = HighlightTheme(empty: squareDot, piece: squareOutline);

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
