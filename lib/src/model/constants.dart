// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const int asciiA = 97;
@Deprecated('Use Squares.white')
const int WHITE = 0;
@Deprecated('Use Squares.black')
const int BLACK = 1;
@Deprecated('Use Squares.hand')
const int HAND = -2;
const List<String> standardPieces = ['Q', 'R', 'B', 'N', 'P'];

class Squares {
  static const int white = 0;
  static const int black = 1;
  static const int hand = -2;

  static const defaultAnimationDuration = Duration(milliseconds: 250);
  static const defaultAnimationCurve = Curves.easeInQuad;
}
