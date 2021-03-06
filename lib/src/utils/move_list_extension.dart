import 'package:squares/squares.dart';

extension MoveListExtension on List<Move> {
  List<Move> get promoMoves => where((e) => e.promotion).toList();
  List<Move> get gatingMoves => where((e) => e.gate).toList();
  List<Move> movesFrom(int square) => where((e) => e.from == square).toList();
  List<Move> movesTo(int square) => where((e) => e.to == square).toList();
}
