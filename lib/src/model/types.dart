import 'package:flutter/material.dart';

/// A function that returns an `int`.
typedef IntCallback = int Function();

/// A function that builds a widget, given a [context], [size] and [colour].
typedef MarkerBuilder = Widget Function(BuildContext context, double size, Color colour);

class Marker {
  final HighlightType colour;
  final bool hasPiece;
  const Marker({required this.colour, required this.hasPiece});
  factory Marker.empty(HighlightType colour) => Marker(colour: colour, hasPiece: false);
  factory Marker.piece(HighlightType colour) => Marker(colour: colour, hasPiece: true);
}

enum HighlightType {
  check,
  checkmate,
  previous,
  selected,
  premove,
}
