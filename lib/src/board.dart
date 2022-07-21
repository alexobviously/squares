import 'package:flutter/material.dart';
import 'package:squares/squares.dart';
import 'package:squares/src/move_animation.dart';

/// The visual representation of the board. Can be used by itself to simply display
/// a board, or in conjunction with [OldBoardController] or some other wrapper to
/// manage its state and handle interactions.
class OldBoard extends StatelessWidget {
  /// A key for the board.
  final GlobalKey boardKey;

  /// The set of widgets to use for pieces on the board.
  final PieceSet pieceSet;

  /// The state of the board - which pieces are on which squares, etc.
  final BoardState state;

  /// Colour scheme for the board.
  final BoardTheme theme;

  /// Dimensions of the board.
  final BoardSize size;

  /// Widget builders for the various types of square highlights used.
  late final MarkerTheme highlightTheme;

  /// The currently selected square index.
  final int? selection;

  /// The currently selected target square index (for premoves).
  final int? target;

  /// Is the game over?
  final bool gameOver;

  /// If false, premoves will be allowed.
  final bool canMove;

  /// Whether pieces should be draggable or not.
  final bool draggable;

  /// The size of pieces being dragged will be multiplied by this.
  /// 1.5 is a good value for mobile, but 1.0 is preferable for web.
  final double dragFeedbackSize;

  /// A vector to offset the position of dragged pieces by, relative to the size of the piece.
  /// No offset is recommended for web, and Offset(0,-1) for mobile, in which case
  /// the bottom of the piece will be anchored to the finger.
  final Offset dragFeedbackOffset;

  /// Called when a square is tapped.
  final Function(int, GlobalKey)? onTap;

  /// Called when a piece drag is cancelled.
  final Function(int)? onDragCancel;

  /// Called when a piece moves over a new square. This includes external pieces,
  /// such as those that came from hands.
  final bool Function(PartialMove, int)? validateDrag;

  /// Called when a square accepts a piece dragged onto it.
  final Function(PartialMove, int, GlobalKey)? acceptDrag;

  /// A list of highlighted square indices. Usually this will correspond to squares
  /// that the selected piece can move to.
  final List<int> highlights;

  /// If true and there is a last move, it will be animated.
  final bool allowAnimation;

  /// How long move animations take to play.
  final Duration? animationDuration;

  /// Animation curve for piece movements.
  /// Defaults to [Curves.easeInQuad].
  final Curve? animationCurve;

  OldBoard({
    required this.boardKey,
    required this.pieceSet,
    required this.state,
    required this.theme,
    this.size = const BoardSize(8, 8),
    MarkerTheme? highlightTheme,
    this.selection,
    this.target,
    this.gameOver = false,
    this.canMove = false,
    this.draggable = true,
    this.dragFeedbackSize = 2.0,
    this.dragFeedbackOffset = const Offset(0.0, -1.0),
    this.onTap,
    this.onDragCancel,
    this.validateDrag,
    this.acceptDrag,
    this.highlights = const [],
    this.allowAnimation = true,
    this.animationDuration,
    this.animationCurve,
  }) : highlightTheme = highlightTheme ?? MarkerTheme.basic;

  void _onDragCancel(int square) {
    if (onDragCancel != null) onDragCancel!(square);
  }

  bool _validateDrag(PartialMove? move, int to) {
    if (move == null || validateDrag == null) return false;
    return validateDrag!(move, to);
  }

  void _acceptDrag(PartialMove? move, int to, GlobalKey squareKey) {
    if (move == null || acceptDrag == null) return;
    acceptDrag!(move, to, squareKey);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      key: boardKey,
      aspectRatio: size.h / size.v,
      child: LayoutBuilder(builder: (context, constraints) {
        double squareSize = constraints.maxWidth / size.h;
        return Stack(
          children: [
            Container(
              child: Column(
                children: List.generate(
                  size.v,
                  (rank) => Expanded(
                    child: Row(
                      children: List.generate(
                        size.h,
                        (file) => _square(context, rank, file, squareSize),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (state.lastFrom != null &&
                state.lastFrom != Squares.hand &&
                state.lastTo != null &&
                allowAnimation)
              Builder(
                builder: (context) {
                  int r = size.v - size.squareRank(state.lastTo!);
                  int f = size.squareFile(state.lastTo!);
                  return Positioned(
                    child: Container(
                      width: squareSize,
                      height: squareSize,
                      child: _square(
                        context,
                        r,
                        f,
                        squareSize,
                        animation: allowAnimation,
                        orient: false,
                      ),
                    ),
                    top: state.orientation == Squares.white ? squareSize * r : null,
                    left: state.orientation == Squares.white ? squareSize * f : null,
                    bottom: state.orientation == Squares.black ? squareSize * r : null,
                    right: state.orientation == Squares.black ? squareSize * f : null,
                  );
                },
              ),
          ],
        );
      }),
    );
  }

  Widget _square(BuildContext context, int rank, int file, double squareSize,
      {bool animation = false, bool orient = true}) {
    int id = (!orient || state.orientation == Squares.white ? rank : size.v - rank - 1) * size.h +
        (!orient || state.orientation == Squares.white ? file : size.h - file - 1);
    GlobalKey squareKey = GlobalKey();
    String symbol = state.board.length > id ? state.board[id] : '';
    Widget? piece = symbol.isNotEmpty ? pieceSet.piece(context, symbol) : null;
    num _orientation = state.orientation == Squares.white ? 1 : -1;
    if (piece != null &&
        state.lastFrom != null &&
        state.lastFrom != Squares.hand &&
        state.lastTo != null &&
        state.lastTo == id &&
        allowAnimation) {
      if (animation) {
        piece = MoveAnimation(
          child: piece,
          x: -size.fileDiff(state.lastFrom!, state.lastTo!).toDouble() * _orientation,
          y: size.rankDiff(state.lastFrom!, state.lastTo!).toDouble() * _orientation,
          duration: animationDuration,
          curve: animationCurve,
        );
      } else {
        return Container(
          width: squareSize,
          height: squareSize,
          color: Colors.transparent,
        );
      }
    }
    Color squareColour = ((rank + file) % 2 == 0) ? theme.lightSquare : theme.darkSquare;
    if (state.lastFrom == id || state.lastTo == id) {
      squareColour = Color.alphaBlend(theme.previous, squareColour);
    }
    if (selection == id) {
      squareColour = Color.alphaBlend(canMove ? theme.selected : theme.premove, squareColour);
    }
    if (state.checkSquare == id) {
      squareColour = Color.alphaBlend(gameOver ? theme.checkmate : theme.check, squareColour);
    }
    if (target == id) squareColour = Color.alphaBlend(theme.premove, squareColour);
    bool hasHighlight = highlights.contains(id);
    return DragTarget<PartialMove>(
      builder: (context, accepted, rejected) {
        return Square(
          id: id,
          squareKey: squareKey,
          colour: squareColour,
          piece: piece,
          symbol: symbol,
          draggable: draggable,
          dragFeedbackSize: dragFeedbackSize,
          dragFeedbackOffset: dragFeedbackOffset,
          onTap: onTap != null ? (key) => onTap!(id, key) : null,
          onDragCancel: () => _onDragCancel(id),
          highlight: hasHighlight ? (canMove ? theme.selected : theme.premove) : null,
          highlightTheme: highlightTheme,
        );
      },
      onWillAccept: (from) => _validateDrag(from, id),
      onAccept: (from) => _acceptDrag(from, id, squareKey),
    );
  }
}
