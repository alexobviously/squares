part of 'board.dart';

class BoardPieces extends StatelessWidget {
  /// The set of widgets to use for pieces on the board.
  final PieceSet pieceSet;

  /// The state of the board - which pieces are on which squares, etc.
  final BoardState state;

  /// Dimensions of the board.
  final BoardSize size;

  /// Called when a piece is tapped.
  final void Function(int)? onTap;
  final void Function(int)? onDragStarted;
  final void Function(int)? onDragCancelled;
  final void Function(int)? onDragEnd;

  const BoardPieces({
    super.key,
    required this.pieceSet,
    required this.state,
    this.size = BoardSize.standard,
    this.onTap,
    this.onDragStarted,
    this.onDragCancelled,
    this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return BoardBuilder(
      size: size,
      builder: (rank, file, squareSize) => _piece(context, rank, file, squareSize),
    );
  }

  Widget _piece(BuildContext context, int rank, int file, double squareSize) {
    int id = size.square(rank, file, state.orientation);
    String symbol = state.board.length > id ? state.board[id] : '';
    Widget piece = symbol.isNotEmpty
        ? pieceSet.piece(context, symbol)
        : SizedBox(
            width: squareSize,
            height: squareSize,
          );
    return Piece(
      child: piece,
      move: PartialMove(
        from: id,
        piece: symbol,
      ),
      onTap: () => onTap?.call(id),
      onDragStarted: () => onDragStarted?.call(id),
      onDragCancelled: () => onDragCancelled?.call(id),
      onDragEnd: () => onDragEnd?.call(id),
    );
  }
}
