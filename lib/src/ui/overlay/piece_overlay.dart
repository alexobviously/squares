part of 'board_overlay.dart';

class PieceOverlay extends StatelessWidget {
  final BoardSize size;
  final int orientation;
  final Map<int, String> pieces;
  final PieceSet pieceSet;
  final double opacity;

  const PieceOverlay({
    super.key,
    this.size = BoardSize.standard,
    this.orientation = Squares.white,
    required this.pieces,
    required this.pieceSet,
    this.opacity = Squares.defaultPremovePieceOpacity,
  });

  factory PieceOverlay.single({
    BoardSize size = BoardSize.standard,
    int orientation = Squares.white,
    required PieceSet pieceSet,
    double opacity = Squares.defaultPremovePieceOpacity,
    required int square,
    required String piece,
  }) =>
      PieceOverlay(
        size: size,
        orientation: orientation,
        pieces: {square: piece},
        pieceSet: pieceSet,
        opacity: opacity,
      );

  @override
  Widget build(BuildContext context) {
    return BoardOverlay(
      size: size,
      orientation: orientation,
      children: pieces.map((sq, symbol) => MapEntry(sq, _piece(context, symbol))),
    );
  }

  Widget _piece(BuildContext context, String symbol) {
    return Opacity(
      opacity: opacity,
      child: pieceSet.piece(context, symbol),
    );
  }
}
