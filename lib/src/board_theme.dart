import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class BoardTheme {
  final Color lightSquare;
  final Color darkSquare;
  final Color check;
  final Color checkmate;
  final Color previous;
  final Color selected;
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
}

const BoardTheme BROWN_THEME = BoardTheme(
  lightSquare: Color(0xfff0d9b6),
  darkSquare: Color(0xffb58863),
  check: Color(0xffcb3927),
  checkmate: Colors.orange,
  previous: Color(0x809cc700),
  selected: Color(0x8014551e),
  premove: Color(0x80141e55),
);
