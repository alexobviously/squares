import 'package:bishop/bishop.dart' as bishop;
import 'package:squares/squares.dart';

class GameConfig {
  final bishop.Variant variant;
  final int humanPlayer;
  final OpponentType opponentType;
  final String? fen;

  const GameConfig({
    required this.variant,
    this.humanPlayer = Squares.white,
    this.opponentType = OpponentType.ai,
    this.fen,
  });
}

enum OpponentType {
  randomMover('Random Mover'),
  ai('AI'),
  human('Human');

  final String title;
  const OpponentType(this.title);
}
