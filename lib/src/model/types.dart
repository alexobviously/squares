import 'package:equatable/equatable.dart';
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

enum PlayState {
  observing,
  ourTurn,
  theirTurn,
  finished;

  bool get playing => this == ourTurn || this == theirTurn;
}

class PieceSelectorData extends Equatable {
  final int square;
  final bool startLight;
  final List<String?> pieces;
  final bool gate;
  final int? gatingSquare;

  PieceSelectorData({
    required this.square,
    required this.startLight,
    required this.pieces,
    this.gate = false,
    this.gatingSquare,
  });

  @override
  String toString() => 'PieceSelectorData($square, $square, $pieces)';

  @override
  List<Object?> get props => [square, pieces, gate];
}
