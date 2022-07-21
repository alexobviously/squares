part of 'board.dart';

// TODO: don't allow opponent pieces to be dragged

class BoardPieces extends StatefulWidget {
  /// The set of widgets to use for pieces on the board.
  final PieceSet pieceSet;

  /// The state of the board - which pieces are on which squares, etc.
  final BoardState state;

  /// Dimensions of the board.
  final BoardSize size;

  /// Are the pieces draggable?
  final bool draggable;

  /// If true and there is a last move, it will be animated.
  final bool animatePieces;

  /// How long move animations take to play.
  final Duration animationDuration;

  /// Animation curve for piece movements.
  /// Defaults to [Curves.easeInQuad].
  final Curve animationCurve;

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
    this.animatePieces = true,
    this.animationDuration = Squares.defaultAnimationDuration,
    this.animationCurve = Squares.defaultAnimationCurve,
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
  bool animate = true;
  bool afterDrag = false; // track drags so they're not animated

  @override
  void didUpdateWidget(covariant BoardPieces oldWidget) {
    // This prevents the animation from repeating in cases where it shouldn't,
    // e.g. if the board is rotated. It would also be possible to do this with
    // collection's ListEquality or something but this seems efficient.
    animate = oldWidget.state.board.join() != widget.state.board.join() && !afterDrag;
    afterDrag = false;
    super.didUpdateWidget(oldWidget);
  }

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
    final p = Piece(
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
      onDragEnd: (details) => _onDragEnd(id, details),
    );
    if (widget.state.lastTo == id &&
        widget.state.lastFrom != Squares.hand &&
        symbol.isNotEmpty &&
        widget.animatePieces &&
        animate) {
      int orientation = widget.state.orientation == Squares.white ? 1 : -1;
      return MoveAnimation(
        child: p,
        x: -widget.size.fileDiff(widget.state.lastFrom!, widget.state.lastTo!).toDouble() *
            orientation,
        y: widget.size.rankDiff(widget.state.lastFrom!, widget.state.lastTo!).toDouble() *
            orientation,
        duration: widget.animationDuration,
        curve: widget.animationCurve,
      );
    }
    return p;
  }

  void _onDragStarted(int id) {
    setState(() => currentDrag = id);
    widget.onDragStarted?.call(id);
  }

  void _onDragCancelled(int id) {
    setState(() => currentDrag = null);
    widget.onDragCancelled?.call(id);
  }

  void _onDragEnd(int id, DraggableDetails details) {
    setState(() {
      currentDrag = null;
      if (details.wasAccepted) afterDrag = true;
    });
    widget.onDragEnd?.call(id);
  }
}
