import 'package:bishop/bishop.dart' as bishop;
import 'package:squares/squares.dart';

class GameConfig {
  final bishop.Variant variant;
  final int humanPlayer;
  final String? fen;

  const GameConfig({
    required this.variant,
    this.humanPlayer = Squares.white,
    this.fen,
  });
}
