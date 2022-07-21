import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class BoardController extends StatefulWidget {
  /// The state of the board - which pieces are on which squares, etc.
  final BoardState state;

  /// The state of the game, from the perspective of the current player.
  final PlayState playState;

  /// The set of widgets to use for pieces on the board.
  final PieceSet pieceSet;

  /// Colour scheme for the board.
  final BoardTheme theme;

  /// Dimensions of the board.
  final BoardSize size;

  /// Widget builders for the various types of square highlights used.
  final MarkerTheme? markerTheme;

  /// Called when a move is successfully made.
  final void Function(Move)? onMove;

  /// Called when the premove is changed.
  final void Function(Move?)? onSetPremove;

  /// Called when a premove is triggered.
  final void Function(Move)? onPremove;

  /// A list of moves that can be played/premoved.
  final List<Move> moves;

  // Whether pieces should be draggable or not.
  final bool draggable;

  /// The size of pieces being dragged will be multiplied by this.
  /// /// 1.5 is a good value for mobile, but 1.0 is preferable for web.
  final double dragFeedbackSize;

  /// A vector to offset the position of dragged pieces by, relative to the size of the piece.
  /// No offset is recommended for web, and Offset(0,-1) for mobile, in which case
  /// the bottom of the piece will be anchored to the finger.
  final Offset dragFeedbackOffset;

  /// If true and there is a last move, it will be animated.
  final bool animatePieces;

  /// How long move animations take to play.
  final Duration animationDuration;

  /// Animation curve for piece movements.
  /// Defaults to [Curves.easeInQuad].
  final Curve animationCurve;

  late final Map<int, List<Move>> moveMap;
  late final List<Move> drops;

  BoardController({
    super.key,
    required this.state,
    required this.playState,
    required this.pieceSet,
    required this.theme,
    this.size = const BoardSize(8, 8),
    this.markerTheme,
    this.onMove,
    this.onSetPremove,
    this.onPremove,
    this.moves = const [],
    this.draggable = true,
    this.dragFeedbackSize = 2.0,
    this.dragFeedbackOffset = const Offset(0.0, -1.0),
    this.animatePieces = true,
    this.animationDuration = Squares.defaultAnimationDuration,
    this.animationCurve = Squares.defaultAnimationCurve,
  }) {
    // TODO: abstract this
    moveMap = {};
    drops = [];
    for (Move m in moves) {
      if (m.handDrop) {
        drops.add(m);
        continue;
      }
      if (!moveMap.containsKey(m.from)) {
        moveMap[m.from] = [m];
      } else {
        moveMap[m.from]!.add(m);
      }
      // Make pieces with no moves selectable
      bool whitePlayer = state.player == Squares.white;
      for (int i = 0; i < state.board.length; i++) {
        String p = state.board[i];
        bool whitePiece = p == p.toUpperCase();
        if (p.isNotEmpty && whitePlayer == whitePiece) {
          if (!moveMap.containsKey(i)) moveMap[i] = [];
        }
      }
    }
  }

  @override
  State<BoardController> createState() => _BoardControllerState();
}

class _BoardControllerState extends State<BoardController> {
  int? selection;
  int? target;
  Move? premove;
  List<Move> dests = [];
  List<PieceSelectorData> pieceSelectors = [];

  @override
  void didUpdateWidget(covariant BoardController oldWidget) {
    if (oldWidget.state != widget.state) {
      _onNewBoardState(oldWidget.state);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Board(
      state: widget.state,
      playState: widget.playState,
      pieceSet: widget.pieceSet,
      theme: widget.theme,
      size: widget.size,
      markerTheme: widget.markerTheme,
      draggable: widget.draggable,
      dragFeedbackSize: widget.dragFeedbackSize,
      dragFeedbackOffset: widget.dragFeedbackOffset,
      animateLastMove: widget.animatePieces,
      animationDuration: widget.animationDuration,
      animationCurve: widget.animationCurve,
      selection: selection,
      target: target,
      pieceSelectors: pieceSelectors,
      markers: dests.map((e) => e.to).toList(),
      onTap: _onTap,
      acceptDrag: _acceptDrag,
      validateDrag: _validateDrag,
      onPieceSelected: _onPieceSelected,
    );
  }

  void _onNewBoardState(BoardState lastState) {
    if (widget.state.orientation != lastState.orientation) {
      // detect if the board has flipped
      _closePieceSelectors();
    }

    if (premove != null && widget.onPremove != null) {
      final premove = this.premove!;
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onPremove!(premove));
    }

    if (target != null) {
      setState(() {
        premove = null;
        target = null;
        selection = null;
      });
    }
  }

  void _onTap(int square) {
    if (widget.playState == PlayState.ourTurn) {
      return _handleMoveTap(square, _onMove);
    }
    if (widget.playState == PlayState.theirTurn) {
      return _handleMoveTap(square, _setPremove);
    }
    setState(() => selection = square);
  }

  void _onPieceSelected(PieceSelectorData data, int index) {
    if (pieceSelectors.isEmpty || selection == null || widget.onMove == null) {
      return _closePieceSelectors();
    }
    String? piece = data.pieces[index];
    if (piece != null) piece = piece.toLowerCase();
    Move move = !data.gate
        ? Move(
            from: selection!,
            to: data.square,
            promo: piece,
          )
        : Move(
            from: selection!,
            to: data.square,
            piece: piece,
            gatingSquare: data.gatingSquare,
          );
    if (widget.playState != PlayState.theirTurn) {
      if (widget.onMove != null) _onMove(move);
    } else {
      _setPremove(move);
    }
  }

  bool _validateDrag(PartialMove partial, int to) {
    if (partial.drop) {
      if (widget.drops.isEmpty) return false;
      return widget.drops.where((m) => m.piece == partial.piece && m.to == to).isNotEmpty;
    }
    if (widget.moveMap[partial.from] == null) return false;
    Move? move = widget.moveMap[partial.from]!.firstWhereOrNull((m) => m.to == to);
    return move != null;
  }

  void _acceptDrag(PartialMove partial, int to) {
    if (partial.drop) {
      // onDrop(partial, to, squareKey);
    } else {
      _setSelection(partial.from);
      // afterDrag = true;
      _onTap(to);
    }
  }

  void _handleMoveTap(int square, void Function(Move)? onMove) {
    if (selection == null) {
      return _setSelection(square);
    }
    if (selection == square) {
      return _clearSelection();
    }
    final moves = dests.movesTo(square);
    if (moves.isEmpty) {
      return _setSelection(square);
    }
    List<Move> promoMoves = moves.promoMoves;
    List<Move> gatingMoves = moves.gatingMoves;
    bool promoting = promoMoves.isNotEmpty;
    bool gating = gatingMoves.isNotEmpty;
    if (gating) {
      Set<int?> gatingSquares = {};
      for (Move m in gatingMoves) {
        gatingSquares.add(m.gatingSquare);
      }
      for (int? x in gatingSquares) {
        _openPieceSelector(square, gate: true, gatingSquare: x);
      }
    } else if (promoting) {
      _openPieceSelector(square);
    } else {
      onMove?.call(moves.first);
    }
  }

  void _setSelection(int square) {
    setState(() {
      selection = square;
      target = null;
      dests = widget.moveMap[square] ?? [];
      pieceSelectors = [];
    });
  }

  void _clearSelection() {
    setState(() {
      selection = null;
      target = null;
      dests = [];
      pieceSelectors = [];
    });
  }

  void _setTarget(int square) {
    setState(() {
      target = square;
      dests = [];
    });
  }

  void _onMove(Move move) {
    widget.onMove?.call(move);
    _clearSelection();
  }

  void _setPremove(Move move) {
    premove = move;
    _setTarget(move.to);
    widget.onSetPremove?.call(move);
  }

  void _openPieceSelector(int square, {bool gate = false, int? gatingSquare}) {
    List<Move> moves = widget.moves
        .where(
          (e) => e.to == square && (gate ? e.gate : e.promotion) && e.gatingSquare == gatingSquare,
        )
        .toList();
    List<String?> pieces = moves.map<String?>((e) => (gate ? e.piece : e.promo) ?? '').toList();
    pieces.sort(_promoComp);
    if (widget.state.player == Squares.white) {
      pieces = pieces.map<String?>((e) => e!.toUpperCase()).toList();
    }
    if (gate) {
      pieces.insert(0, null);
    }

    setState(() {
      pieceSelectors.add(
        PieceSelectorData(
          square: square,
          startLight: widget.size.isLightSquare(square),
          pieces: pieces,
          gate: gate,
          gatingSquare: gatingSquare,
        ),
      );
    });
  }

  void _closePieceSelectors() {
    setState(() => pieceSelectors = []);
  }

  // TODO: find a more permanent solution - maybe this should be done in bishop?
  static const _promoOrder = ['d', 'q', 'a', 'c', 'r', 'b', 'n', 'p'];
  int _promoComp(String? a, String? b) {
    if (a == null) return -1;
    if (b == null) return 1;
    return _promoOrder.indexOf(a).compareTo(_promoOrder.indexOf(b));
  }
}
