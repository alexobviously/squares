class Move {
  final int from;
  final int to;

  Move({required this.from, required this.to});

  @override
  String toString() => '$from-$to';
}
