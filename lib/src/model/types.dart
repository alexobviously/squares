import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

/// A function that returns an `int`.
typedef IntCallback = int Function();

/// A function that builds a widget, given a [context], [size] and [colour].
typedef MarkerBuilder = Widget Function(
  BuildContext context,
  double size,
  Color colour,
);

/// Data representation of a marker on the board, to simplify building them.
class Marker {
  /// The colour of the marker.
  final HighlightType colour;

  /// Whether the marker is for a square that has a piece on it or not.
  final bool hasPiece;

  const Marker({
    required this.colour,
    required this.hasPiece,
  });
  factory Marker.empty(HighlightType colour) =>
      Marker(colour: colour, hasPiece: false);
  factory Marker.piece(HighlightType colour) =>
      Marker(colour: colour, hasPiece: true);
}

/// Various types of highlights that might be present on the board.
enum HighlightType {
  check,
  checkmate,
  previous,
  selected,
  premove,
}

/// The core state of play, from a player's perpective.
enum PlayState {
  observing,
  ourTurn,
  theirTurn,
  finished;

  bool get playing => this == ourTurn || this == theirTurn;
}

/// A configuration for a piece selector, i.e. for promotion or gating.
class PieceSelectorData extends Equatable {
  /// The square that the move that spawned this selector is *to*.
  /// For promotion and some types of gating, this will also serve as the square
  /// that the selector is anchored to.
  final int square;

  /// A piece selector has alternating colour background squares like a board.
  /// [startLight] indicates whether the first square should be light.
  final bool startLight;

  /// The pieces in the selector. Null indicates an empty square and can be used
  /// a move could have a selected piece or not, such as with Crazyhouse drops.
  final List<String?> pieces;

  /// Whether this is a gating selector, or a promotion selector.
  final bool gate;

  /// The square to anchor the selector to if gating. If this is null, then
  /// [square] will be used instead.
  final int? gatingSquare;

  /// Used during algebraic move string generation as a result of moves made
  /// by a piece selector. There are cases where multiple piece selectors can
  /// be shown at once for gating, such as when a castling move is made.
  /// If there is only one then we don't want to disambiguate. Remember that
  /// the piece selector (or indeed a `BoardController`) has no knowledge
  /// of castling.
  final bool disambiguateGating;

  PieceSelectorData({
    required this.square,
    required this.startLight,
    required this.pieces,
    this.gate = false,
    this.gatingSquare,
    this.disambiguateGating = false,
  });

  @override
  String toString() => 'PieceSelectorData($square, $square, $pieces)';

  @override
  List<Object?> get props => [square, pieces, gate];
}

/// Behaviour to use on promotion, regarding showing the piece selector.
/// * alwaysSelect: always show the piece selector.
/// * autoPremove: don't show the piece selector for premoves, pick the best piece.
/// * alwaysAuto: never show the piece selector, pick the best piece.
enum PromotionBehaviour {
  /// Always show the piece selector.
  alwaysSelect,

  /// Don't show the piece selector for premoves, pick the best piece.
  autoPremove,

  /// Never show the piece selector, pick the best piece.
  alwaysAuto,
}

enum FileLabelPosition {
  top,
  bottom,
}

enum RankLabelPosition {
  left,
  right,
}

typedef Labeller = String Function(int);

/// Configuration for `LabelOverlay`.
class LabelConfig {
  /// Whether labels should be shown at all.
  final bool showLabels;

  /// The scale of labels relative to the size of the square, where 1.0 is the
  /// full width/height of the square.
  final double labelScale;

  /// The position of the file labels (top or bottom).
  final FileLabelPosition fileLabelPosition;

  /// The position of the rank labels (left or right).
  final RankLabelPosition rankLabelPosition;

  /// Defines how file label strings are built from indices.
  final Labeller fileLabeller;

  /// Defines how rank label strings are built from indices.
  final Labeller rankLabeller;

  /// Text style of the labels.
  /// Will have a colour applied to it depending on the square.
  final TextStyle textStyle;

  const LabelConfig({
    this.showLabels = true,
    this.labelScale = 0.25,
    this.fileLabelPosition = FileLabelPosition.bottom,
    this.rankLabelPosition = RankLabelPosition.right,
    this.fileLabeller = alphaLowerLabel,
    this.rankLabeller = numericLabel,
    this.textStyle = const TextStyle(height: 1.0, fontWeight: FontWeight.bold),
  });

  /// The standard labelling configuration.
  static const standard = LabelConfig(showLabels: true);

  /// Disabled labels.
  static const disabled = LabelConfig(showLabels: false);
}
