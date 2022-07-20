import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

part 'board_background.dart';
part 'board_builder.dart';
part 'board_pieces.dart';
part 'board_targets.dart';

class Board extends StatelessWidget {
  /// The set of widgets to use for pieces on the board.
  final PieceSet pieceSet;

  /// The state of the board - which pieces are on which squares, etc.
  final BoardState state;

  /// Colour scheme for the board.
  final BoardTheme theme;

  /// Dimensions of the board.
  final BoardSize size;

  /// Widget builders for the various types of square highlights used.
  late final MarkerTheme markerTheme;

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
  final void Function(int)? onTap;

  /// Called when a piece drag is cancelled.
  final void Function(int)? onDragCancel;

  /// Called when a piece moves over a new square. This includes external pieces,
  /// such as those that came from hands.
  final bool Function(PartialMove, int)? validateDrag;

  /// Called when a square accepts a piece dragged onto it.
  final void Function(PartialMove, int)? acceptDrag;

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

  Board({
    super.key,
    required this.pieceSet,
    required this.state,
    required this.theme,
    this.size = BoardSize.standard,
    MarkerTheme? markerTheme,
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
  }) : markerTheme = markerTheme ?? MarkerTheme.basic;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: size.aspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double squareSize = constraints.maxWidth / size.h;
          return Stack(
            children: [
              BoardBackground(
                size: size,
                orientation: state.orientation,
                theme: theme,
                highlights: {},
                markers: {},
                markerTheme: markerTheme,
              ),
              BoardTargets(
                size: size,
                orientation: state.orientation,
                onTap: onTap,
                validateDrag: validateDrag,
                acceptDrag: acceptDrag,
              ),
              BoardPieces(
                pieceSet: pieceSet,
                state: state,
                size: size,
                onTap: onTap,
                onDragStarted: onTap,
                onDragEnd: onTap,
              ),
            ],
          );
        },
      ),
    );
  }
}
