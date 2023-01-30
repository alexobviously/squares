part of 'board_overlay.dart';

/// Builds a map of [pieces] in a board arrangement, according to [size] and
/// [orientation], using [pieceSet] to determine the piece widgets.
class PieceOverlay extends StatelessWidget {
  /// Dimensions of the board.
  final BoardSize size;

  /// Determines which way around the board is facing.
  /// 0 (white) will place the white pieces at the bottom,
  /// and 1 will place the black pieces there.
  /// You likely want to take this from `BoardState.orientation`.
  final int orientation;

  /// Pieces to draw on the board, at the indices specified by their keys.
  final Map<int, String> pieces;

  /// The set of widgets to use for pieces.
  final PieceSet pieceSet;

  /// Opacity of the pieces.
  final double opacity;

  const PieceOverlay({
    super.key,
    this.size = BoardSize.standard,
    this.orientation = Squares.white,
    required this.pieces,
    required this.pieceSet,
    this.opacity = Squares.defaultPremovePieceOpacity,
  });

  /// Creates a `PieceOverlay` with a single [piece], drawn at [square].
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
      children:
          pieces.map((sq, symbol) => MapEntry(sq, _piece(context, symbol))),
    );
  }

  Widget _piece(BuildContext context, String symbol) {
    return Opacity(
      opacity: opacity,
      child: pieceSet.piece(context, symbol),
    );
  }
}
