import 'package:equatable/equatable.dart';
import 'package:squares/squares.dart';

/// A representation of a move. [from] and [to] are square indices.
/// [promo] and [piece] (both optional) are uppercase single character piece symbols.
/// [from] can also be [HAND] (-2), for drops originating off the board.
class Move {
  final int from;
  final int to;
  final String? promo;
  final String? piece;

  bool get promotion => promo != null;
  bool get drop => from == HAND;

  Move({required this.from, required this.to, this.promo, this.piece}) {
    if (drop) assert(piece != null, 'Drop moves required a piece');
  }

  @override
  String toString() => '$from-$to';
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
