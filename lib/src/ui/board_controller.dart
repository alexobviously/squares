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

  /// How to behave on promotion moves.
  final PromotionBehaviour promotionBehaviour;

  /// The relative hierarchy of pieces, specified by their symbols, in order
  /// from best to worst. Used in ordering the pieces in piece selectors, and
  /// in deciding which piece to auto promote to.
  /// Note that this won't change which pieces are available in selectors - that
  /// depends on the moves available - it only orders them.
  /// All symbols should be lower case.
  final List<String> pieceHierarchy;

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

  /// Opacity of overlay pieces shown on the board resulting from promotion
  /// or dropping premoves.
  final double premovePieceOpacity;

  late final Map<int, List<Move>> moveMap;
  late final List<Move> drops;

  String get bestPiece => pieceHierarchy.isNotEmpty ? pieceHierarchy.first : 'q';

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
    this.promotionBehaviour = PromotionBehaviour.alwaysSelect,
    this.pieceHierarchy = Squares.defaultPieceHierarchy,
    this.moves = const [],
    this.draggable = true,
    this.dragFeedbackSize = 2.0,
    this.dragFeedbackOffset = const Offset(0.0, -1.0),
    this.animatePieces = true,
    this.animationDuration = Squares.defaultAnimationDuration,
    this.animationCurve = Squares.defaultAnimationCurve,
    this.premovePieceOpacity = Squares.defaultPremovePieceOpacity,
  }) {
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

  int get player => widget.state.playerForState(widget.playState);

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
      animatePieces: widget.animatePieces,
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
      overlays: [
        if (premove?.promotion ?? false)
          PieceOverlay.single(
            size: widget.size,
            orientation: widget.state.orientation,
            pieceSet: widget.pieceSet,
            square: premove!.to,
            piece: pieceForPlayer(premove!.promo!, widget.state.waitingPlayer),
            opacity: widget.premovePieceOpacity,
          ),
        if (premove?.drop ?? false)
          PieceOverlay.single(
            size: widget.size,
            orientation: widget.state.orientation,
            pieceSet: widget.pieceSet,
            square: premove!.dropSquare!,
            piece: pieceForPlayer(premove!.piece!, widget.state.waitingPlayer),
            opacity: widget.premovePieceOpacity,
          ),
      ],
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
      return _handleMoveTap(square, _setPremove, true);
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
            gatingSquare: data.disambiguateGating ? data.gatingSquare : null,
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
      return widget.drops.to(to).withPiece(partial.piece).isNotEmpty;
    }
    if (widget.moveMap[partial.from] == null) return false;
    Move? move = widget.moveMap[partial.from]!.firstWhereOrNull((m) => m.to == to);
    return move != null;
  }

  void _acceptDrag(PartialMove partial, int to) {
    if (partial.drop) {
      _onDrop(partial, to);
    } else {
      _setSelection(partial.from);
      // afterDrag = true;
      _onTap(to);
    }
  }

  void _handleMoveTap(
    int square,
    void Function(Move)? onMove, [
    bool isPremove = false,
  ]) {
    if (selection == null) {
      return _setSelection(square);
    }
    if (selection == square) {
      return _clearSelection();
    }
    final moves = dests.to(square);
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
        _openPieceSelector(
          square,
          gate: true,
          gatingSquare: x,
          disambiguateGating: gatingSquares.length > 1,
        );
      }
    } else if (promoting) {
      bool showSelector = widget.promotionBehaviour == PromotionBehaviour.alwaysSelect ||
          (!isPremove && widget.promotionBehaviour == PromotionBehaviour.autoPremove);
      if (!showSelector) {
        final m = promoMoves.bestPromo(widget.pieceHierarchy);
        if (m != null) {
          return onMove?.call(m);
        }
      }
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
      premove = null;
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
    _closePieceSelectors();
    widget.onSetPremove?.call(move);
  }

  void _openPieceSelector(
    int square, {
    bool gate = false,
    int? gatingSquare,
    bool disambiguateGating = false,
  }) {
    List<Move> moves = widget.moves
        .to(square)
        .where(
          (e) => (gate ? e.gate : e.promotion) && e.gatingSquare == gatingSquare,
        )
        .toList();
    List<String?> pieces = moves.map<String?>((e) => (gate ? e.piece : e.promo) ?? '').toList();
    pieces.sort(_promoComp);
    if (player == Squares.white) {
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
          disambiguateGating: disambiguateGating,
        ),
      );
    });
  }

  void _closePieceSelectors() {
    setState(() => pieceSelectors = []);
  }

  int _promoComp(String? a, String? b) {
    if (a == null) return -1;
    if (b == null) return 1;
    return widget.pieceHierarchy.indexOf(a).compareTo(widget.pieceHierarchy.indexOf(b));
  }

  void _onDrop(PartialMove partial, int to) {
    List<Move> targetMoves = widget.drops.to(to).withPiece(partial.piece);
    if (targetMoves.isEmpty) {
      _clearSelection();
    } else {
      if (widget.playState == PlayState.ourTurn) {
        _onMove(targetMoves.first);
      } else if (widget.playState == PlayState.theirTurn) {
        _setPremove(targetMoves.first);
      }
    }
  }
}
