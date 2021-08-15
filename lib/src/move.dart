import 'package:squares/squares.dart';

class Move {
  final int from;
  final int to;
  final String? promo;

  bool get promotion => promo != null;

  Move({required this.from, required this.to, this.promo});

  @override
  String toString() => '$from-$to';
}

// Used for dragging pieces
class PartialMove {
  final int from;
  final String piece;

  bool get fromHand => from == HAND;

  PartialMove({required this.from, required this.piece});
}
