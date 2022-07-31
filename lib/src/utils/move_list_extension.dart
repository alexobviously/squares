import 'package:squares/squares.dart';

extension MoveListExtension on Iterable<Move> {
  List<Move> get promoMoves => where((e) => e.promotion).toList();
  List<Move> get gatingMoves => where((e) => e.gate).toList();
  List<Move> get handDropMoves => where((e) => e.handDrop).toList();
  List<Move> from(int square) => where((e) => e.from == square).toList();
  List<Move> to(int square) => where((e) => e.to == square).toList();
  List<Move> withPiece(String? piece) =>
      where((e) => e.piece?.toLowerCase() == piece?.toLowerCase()).toList();
  List<Move> withPromo(String? promo) =>
      where((e) => e.promo?.toLowerCase() == promo?.toLowerCase()).toList();
  Move? bestPromo(List<String> pieceHierarchy) {
    for (String p in pieceHierarchy) {
      final m = firstWhereOrNull((e) => e.promo?.toLowerCase() == p.toLowerCase());
      if (m != null) return m;
    }
    return null;
  }
}
