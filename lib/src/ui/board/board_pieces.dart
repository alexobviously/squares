part of 'board.dart';

class BoardPieces extends StatefulWidget {
  /// The set of widgets to use for pieces on the board.
  final PieceSet pieceSet;

  /// The state of the board - which pieces are on which squares, etc.
  final BoardState state;

  /// Dimensions of the board.
  final BoardSize size;

  /// Are the pieces draggable?
  final bool draggable;

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
    this.draggable = true,
    this.onTap,
    this.onDragStarted,
    this.onDragCancelled,
    this.onDragEnd,
  });

  @override
  State<BoardPieces> createState() => _BoardPiecesState();
}

class _BoardPiecesState extends State<BoardPieces> {
  int? currentDrag;

  @override
  Widget build(BuildContext context) {
    return BoardBuilder(
      size: widget.size,
      builder: (rank, file, squareSize) => _piece(context, rank, file, squareSize),
    );
  }

  Widget _piece(BuildContext context, int rank, int file, double squareSize) {
    int id = widget.size.square(rank, file, widget.state.orientation);
    String symbol = widget.state.board.length > id ? widget.state.board[id] : '';
    Widget piece = symbol.isNotEmpty
        ? widget.pieceSet.piece(context, symbol)
        : SizedBox(
            width: squareSize,
            height: squareSize,
          );
    return Piece(
      child: piece,
      draggable: currentDrag != null ? currentDrag == id : widget.draggable,
      interactible: currentDrag == null || currentDrag == id,
      move: PartialMove(
        from: id,
        piece: symbol,
      ),
      onTap: () => widget.onTap?.call(id),
      onDragStarted: () => _onDragStarted(id),
      onDragCancelled: () => _onDragCancelled(id),
      onDragEnd: () => _onDragEnd(id),
    );
  }

  void _onDragStarted(int id) {
    setState(() => currentDrag = id);
    widget.onDragStarted?.call(id);
  }

  void _onDragCancelled(int id) {
    setState(() => currentDrag = null);
    widget.onDragCancelled?.call(id);
  }

  void _onDragEnd(int id) {
    setState(() => currentDrag = null);
    widget.onDragEnd?.call(id);
  }
}
