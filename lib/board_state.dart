import 'package:squares/board.dart';

class BoardState {
  final List<String> board;

  BoardState({required this.board});
  factory BoardState.empty() => BoardState(board: []);
}
