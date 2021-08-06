class Move {
  final int from;
  final int to;
  final String? promo;

  bool get promotion => promo != null;

  Move({required this.from, required this.to, this.promo});

  @override
  String toString() => '$from-$to';
}
