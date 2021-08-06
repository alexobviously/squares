import 'package:squares/squares.dart';

class BoardState {
  final List<String> board;
  final int? lastFrom;
  final int? lastTo;
  final int? checkSquare;

  BoardState({
    required this.board,
    this.lastFrom,
    this.lastTo,
    this.checkSquare,
  });
  factory BoardState.empty() => BoardState(board: []);
}
