import 'package:equatable/equatable.dart';
import 'package:squares/squares.dart';

/// A representation of a move. [from] and [to] are square indices.
/// [promo] and [piece] (both optional) are uppercase single character piece symbols.
/// [from] can also be [HAND] (-2), for drops originating off the board.
class Move {
  /// The board location this move starts from.
  final int from;

  /// The board location this move ends at.
  final int to;

  /// The piece type that is being promoted to.
  final String? promo;

  /// The piece type that is being dropped/gated.
  final String? piece;

  /// In most cases, gated pieces will be placed on the [from] square, but there
  /// are some situations where there are other possibilities, e.g. in Seirawan
  /// chess during castling, a piece can gate on either the rook or the king square.
  final int? gatingSquare;

  /// Whether this is a promotion move.
  bool get promotion => promo != null;

  /// Whether this is a drop move (any type, including gating).
  bool get drop => piece != null;

  /// Whether this is a drop move where the piece came from the hand to an empty
  /// square, e.g. the drops in Crazyhouse.
  bool get handDrop => drop && from == HAND;

  /// Whether this is a gated drop, e.g. the drops in Seirawan chess.
  bool get gate => drop && from >= 0;

  Move({
    required this.from,
    required this.to,
    this.promo,
    this.piece,
    this.gatingSquare,
  }) {
    if (from == HAND) assert(piece != null, 'Drop moves require a piece');
  }

  @override
  String toString() => '$from-$to${promo != null ? '[$promo]' : ''}';
}

/// Used for dragging pieces.
class PartialMove extends Equatable {
  final int from;
  final String piece;

  bool get drop => from == HAND;

  PartialMove({required this.from, required this.piece});

  List<Object> get props => [from, piece];
  bool get stringify => true;
}
