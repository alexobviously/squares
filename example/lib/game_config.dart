import 'package:bishop/bishop.dart' as bishop;
import 'package:squares/squares.dart';

class GameConfig {
  final bishop.Variant variant;
  final int humanPlayer;
  final String? fen;

  GameConfig({required this.variant, this.humanPlayer = WHITE, this.fen});
}
