import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

/// Describes a colour scheme to be used by a `Board`.
class BoardTheme {
  /// Base colour of the light squares.
  final Color lightSquare;

  /// Base colour of the dark squares.
  final Color darkSquare;

  /// Colour for squares in check.
  final Color check;

  /// Colour for squares in checkmate.
  final Color checkmate;

  /// Colour for previous move highlights.
  final Color previous;

  /// Colour for selected pieces, and possible move decorations.
  final Color selected;

  /// Colour for committed premoves.
  final Color premove;

  const BoardTheme({
    required this.lightSquare,
    required this.darkSquare,
    required this.check,
    required this.checkmate,
    required this.previous,
    required this.selected,
    required this.premove,
  });

  BoardTheme copyWith({
    Color? lightSquare,
    Color? darkSquare,
    Color? check,
    Color? checkmate,
    Color? previous,
    Color? selected,
    Color? premove,
  }) =>
      BoardTheme(
        lightSquare: lightSquare ?? this.lightSquare,
        darkSquare: darkSquare ?? this.darkSquare,
        check: check ?? this.check,
        checkmate: checkmate ?? this.checkmate,
        previous: previous ?? this.previous,
        selected: selected ?? this.selected,
        premove: premove ?? this.premove,
      );

  Color highlight(HighlightType type) => {
        HighlightType.check: check,
        HighlightType.checkmate: checkmate,
        HighlightType.previous: previous,
        HighlightType.selected: selected,
        HighlightType.premove: premove,
      }[type]!;

  /// Brown. Classic. Looks like chess.
  static const brown = BoardTheme(
    lightSquare: Color(0xfff0d9b6),
    darkSquare: Color(0xffb58863),
    check: Color(0xffeb5160),
    checkmate: Colors.orange,
    previous: Color(0x809cc700),
    selected: Color(0x8014551e),
    premove: Color(0x80141e55),
  );

  /// A more modern blueish greyish theme.
  static const blueGrey = BoardTheme(
    lightSquare: Color(0xffdee3e6),
    darkSquare: Color(0xff788a94),
    check: Color(0xffeb5160),
    checkmate: Colors.orange,
    previous: Color(0x809bc700),
    selected: Color(0x8014551e),
    premove: Color(0x807b56b3),
  );

  /// Eye pain theme.
  static const pink = BoardTheme(
    lightSquare: Color(0xffeef0c7),
    darkSquare: Color(0xffe27c78),
    check: Color(0xffcb3927),
    checkmate: Colors.blue,
    previous: Color(0xff6ad1eb),
    selected: Color(0x8014551e),
    premove: Color(0x807b56b3),
  );

  /// A tribute.
  static const dart = BoardTheme(
    lightSquare: Color(0xff41c4ff),
    darkSquare: Color(0xff0f659f),
    check: Color(0xffeb5160),
    checkmate: Color(0xff56351e),
    previous: Color(0xffa9fbd7),
    selected: Color(0xfff6f1d1),
    premove: Color(0xffe3d8f1),
  );
}
