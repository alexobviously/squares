part of 'board.dart';

/// The target layer of a board.
/// Contains the invisible widgets that handle gestures.
class BoardTargets extends StatelessWidget {
  /// Dimensions of the board.
  final BoardSize size;

  /// Determines which way around the board is facing.
  /// 0 (white) will place the white pieces at the bottom,
  /// and 1 will place the black pieces there.
  final int orientation;

  /// Called when a square is tapped.
  /// Note that if a piece is above this square, it will absorb the tap, so both
  /// [onTap] functions need to be handled.
  final Function(int)? onTap;

  /// Called when a piece moves over a new square. This includes external pieces,
  /// such as those that came from hands.
  final bool Function(PartialMove, int)? validateDrag;

  /// Called when a square accepts a piece dragged onto it.
  final void Function(PartialMove, int)? acceptDrag;

  /// Called when a draggable leaves a square.
  final void Function(PartialMove, int)? onDragLeave;

  const BoardTargets({
    super.key,
    this.size = BoardSize.standard,
    this.orientation = Squares.white,
    this.onTap,
    this.validateDrag,
    this.acceptDrag,
    this.onDragLeave,
  });

  bool _validateDrag(PartialMove? move, int to) {
    if (move == null || validateDrag == null) return false;
    return validateDrag!(move, to);
  }

  void _acceptDrag(PartialMove? move, int to) {
    if (move == null || acceptDrag == null) return;
    acceptDrag!(move, to);
  }

  void _onDragLeave(PartialMove? move, int to) {
    if (move == null || onDragLeave == null) return;
    onDragLeave!(move, to);
  }

  @override
  Widget build(BuildContext context) {
    return BoardBuilder(
      size: size,
      builder: (rank, file, squareSize) => _target(
        size.square(
          rank,
          file,
          orientation,
        ),
        squareSize,
      ),
    );
  }

  Widget _target(int id, double squareSize) {
    return DragTarget<PartialMove>(
      builder: (context, accepted, rejected) {
        return GestureDetector(
          onTap: () => onTap?.call(id),
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: squareSize,
            height: squareSize,
          ),
        );
      },
      onWillAccept: (from) => _validateDrag(from, id),
      onAccept: (from) => _acceptDrag(from, id),
      onLeave: (from) => _onDragLeave(from, id),
    );
  }
}
