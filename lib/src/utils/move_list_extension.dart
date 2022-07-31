import 'package:squares/squares.dart';

extension MoveListExtension on Iterable<Move> {
  /// All moves that involve a promotion.
  List<Move> get promoMoves => where((e) => e.promotion).toList();

  /// All moves that involve gating.
  List<Move> get gatingMoves => where((e) => e.gate).toList();

  /// All moves that involve a hand drop.
  List<Move> get handDropMoves => where((e) => e.handDrop).toList();

  /// All moves from [square].
  List<Move> from(int square) => where((e) => e.from == square).toList();

  /// All moves to [square].
  List<Move> to(int square) => where((e) => e.to == square).toList();

  /// All moves with the drop piece [piece].
  List<Move> withPiece(String? piece) =>
      where((e) => e.piece?.toLowerCase() == piece?.toLowerCase()).toList();

  /// All moves with the promo piece [piece].
  List<Move> withPromo(String? piece) =>
      where((e) => e.promo?.toLowerCase() == piece?.toLowerCase()).toList();

  /// Gets the best promotion move according to [pieceHierarchy].
  /// Returns null if no appropriate move is found.
  /// If [strict] is true, pieces outside of [pieceHierarchy] won't be considered.
  Move? bestPromo(List<String> pieceHierarchy, [bool strict = false]) {
    final promos = promoMoves;
    for (String p in pieceHierarchy) {
      final m = promos.firstWhereOrNull((e) => e.promo?.toLowerCase() == p.toLowerCase());
      if (m != null) return m;
    }
    return (promos.isNotEmpty && !strict) ? promos.first : null;
  }
}
