import 'package:flutter/material.dart';
import 'package:squares/squares.dart';
import 'board.dart';

/// A wrapper that handles interactions and certain elements of board state
/// (such as premoves) for a [Board].
class BoardController extends StatefulWidget {
  /// The set of widgets to use for pieces on the board.
  final PieceSet pieceSet;

  /// The state of the board - which pieces are on which squares, etc.
  final BoardState state;

  /// Colour scheme for the board.
  final BoardTheme theme;

  /// Dimensions of the board.
  final BoardSize size;

  /// Widget builders for the various types of square highlights used.
  final MarkerTheme? highlightTheme;

  /// Called when a move is successfully made.
  final Function(Move)? onMove;

  /// Called when the premove is changed.
  final Function(Move?)? onSetPremove;

  /// Called when a premove is triggered.
  final Function(Move)? onPremove;

  /// A list of moves that can be played/premoved.
  final List<Move> moves;

  /// If false, premoves will be allowed.
  final bool canMove;

  // Whether pieces should be draggable or not.
  final bool draggable;

  /// The size of pieces being dragged will be multiplied by this.
  /// /// 1.5 is a good value for mobile, but 1.0 is preferable for web.
  final double dragFeedbackSize;

  /// A vector to offset the position of dragged pieces by, relative to the size of the piece.
  /// No offset is recommended for web, and Offset(0,-1) for mobile, in which case
  /// the bottom of the piece will be anchored to the finger.
  final Offset dragFeedbackOffset;

  late final Map<int, List<Move>> moveMap;
  late final List<Move> drops;

  /// If true and there is a last move, it will be animated.
  final bool allowAnimation;

  /// How long move animations take to play.
  final Duration? animationDuration;

  /// Animation curve for piece movements.
  /// Defaults to [Curves.easeInQuad].
  final Curve? animationCurve;

  BoardController({
    required this.pieceSet,
    required this.state,
    required this.theme,
    this.size = const BoardSize(8, 8),
    this.highlightTheme,
    this.onMove,
    this.onSetPremove,
    this.onPremove,
    this.moves = const [],
    required this.canMove,
    this.draggable = true,
    this.dragFeedbackSize = 2.0,
    this.dragFeedbackOffset = const Offset(0.0, -1.0),
    this.allowAnimation = true,
    this.animationDuration,
    this.animationCurve,
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
  _BoardControllerState createState() => _BoardControllerState();
}

class _BoardControllerState extends State<BoardController> {
  int? selection;
  int? target;
  List<Move> dests = [];
  List<PieceSelectorData> promoState = [];
  GlobalKey boardKey = GlobalKey();
  bool get hasPromo => promoState.isNotEmpty;
  BoardState? lastState;
  Move? premove;
  bool afterDrag = false; // track drags so they're not animated

  void onTap(int square, GlobalKey squareKey) {
    if (square == selection) {
      deselectSquare();
    } else {
      closePromoSelector();
      if (widget.moveMap.containsKey(square)) {
        if (!widget.canMove && selection != null) {
          setTarget(square);
          premove = null;
        } else {
          selectSquare(square);
        }
      } else {
        if (selection != null) {
          List<Move> targetMoves = dests.where((m) => m.to == square).toList();
          if (targetMoves.isEmpty) {
            deselectSquare();
          } else {
            List<Move> promoMoves = targetMoves.where((m) => m.promotion).toList();
            List<Move> gateMoves = targetMoves.where((m) => m.gate).toList();
            bool gating = gateMoves.isNotEmpty;
            if (promoMoves.isEmpty && gateMoves.isEmpty) {
              if (widget.canMove) {
                if (widget.onMove != null) widget.onMove!(targetMoves.first);
                deselectSquare();
              } else {
                setTarget(square);
                premove = targetMoves.first;
                if (widget.onSetPremove != null) widget.onSetPremove!(premove);
              }
            } else {
              if (gating) {
                List<Move> _moves = widget.moves
                    .where((e) => e.from == selection && e.to == square && e.gate)
                    .toList();
                Set<int?> gatingSquares = {};
                for (Move m in _moves) gatingSquares.add(m.gatingSquare);
                for (int? x in gatingSquares) {
                  openPieceSelector(square, squareKey, gate: true, gatingSquare: x);
                }
              } else {
                // promotion
                openPieceSelector(square, squareKey);
              }
            }
          }
        }
      }
    }
  }

  void onDrop(PartialMove partial, int to, GlobalKey squareKey) {
    List<Move> targetMoves =
        widget.drops.where((m) => m.piece == partial.piece && m.to == to).toList();
    if (targetMoves.isEmpty) {
      deselectSquare();
    } else {
      if (widget.canMove) {
        if (widget.onMove != null) widget.onMove!(targetMoves.first);
        deselectSquare();
      } else {
        setTarget(to);
        premove = targetMoves.first;
        if (widget.onSetPremove != null) widget.onSetPremove!(premove);
      }
    }
  }

  void onPromo(int piece, PieceSelectorData data) {
    if (!hasPromo || selection == null || widget.onMove == null) {
      closePromoSelector();
      return;
    }
    String? _piece = data.pieces[piece];
    if (_piece != null) _piece = _piece.toLowerCase();
    Move move = !data.gate
        ? Move(
            from: selection!,
            to: data.square,
            promo: _piece,
          )
        : Move(
            from: selection!,
            to: data.square,
            piece: _piece,
            gatingSquare: data.gatingSquare,
          );
    if (widget.canMove) {
      if (widget.onMove != null) widget.onMove!(move);
    } else {
      premove = move;
      if (widget.onSetPremove != null) widget.onSetPremove!(premove);
    }

    deselectSquare();
  }

  void onDragCancel(int square) {
    if (selection == square) deselectSquare();
  }

  bool validateDrag(PartialMove partial, int to) {
    if (partial.drop) {
      if (widget.drops.isEmpty) return false;
      return widget.drops.where((m) => m.piece == partial.piece && m.to == to).isNotEmpty;
    }
    if (widget.moveMap[partial.from] == null) return false;
    Move? move = widget.moveMap[partial.from]!.firstWhereOrNull((m) => m.to == to);
    return move != null;
  }

  void acceptDrag(PartialMove partial, int to, GlobalKey squareKey) {
    if (partial.drop) {
      onDrop(partial, to, squareKey);
    } else {
      selection = partial.from;
      afterDrag = true;
      onTap(to, squareKey);
    }
  }

  void selectSquare(int square) {
    setState(() {
      selection = square;
      dests = widget.moveMap[square] ?? [];
      target = null;
    });
  }

  void deselectSquare() {
    closePromoSelector();
    setState(() {
      selection = null;
      dests = [];
      target = null;
    });
  }

  void setTarget(int square) {
    setState(() {
      target = square;
      dests = [];
    });
  }

  // TODO: find a more permanent solution - maybe this should be done in bishop?
  static const _promoOrder = ['d', 'q', 'a', 'c', 'r', 'b', 'n', 'p'];
  int _promoComp(String? a, String? b) {
    if (a == null) return -1;
    if (b == null) return 1;
    return _promoOrder.indexOf(a).compareTo(_promoOrder.indexOf(b));
  }

  void openPieceSelector(int square, GlobalKey key, {bool gate = false, int? gatingSquare}) {
    List<Move> _moves = widget.moves
        .where((e) =>
            e.to == square && (gate ? e.gate : e.promotion) && e.gatingSquare == gatingSquare)
        .toList();
    List<String?> pieces = _moves.map<String?>((e) => (gate ? e.piece : e.promo) ?? '').toList();
    pieces.sort(_promoComp);
    print('pieces: $pieces');
    if (widget.state.player == Squares.white) {
      pieces = pieces.map<String?>((e) => e!.toUpperCase()).toList();
    }
    if (gate) {
      pieces.insert(0, null);
    }
    RenderBox squareBox = key.currentContext!.findRenderObject() as RenderBox;
    RenderBox boardBox = boardKey.currentContext!.findRenderObject() as RenderBox;
    Offset promoOffset = boardBox.globalToLocal(squareBox.localToGlobal(Offset.zero));
    double squareSize = squareBox.size.width;
    int rank = widget.size.squareRank(square);
    int file = widget.size.squareFile(square);
    bool flip = (gate && widget.state.orientation == widget.state.player) ||
        ((widget.state.orientation == Squares.white && rank == 0) ||
            (widget.state.orientation == Squares.black && rank == widget.size.maxRank + 1));
    if (flip) {
      promoOffset = promoOffset.translate(0, -squareSize * (pieces.length - 1));
      rank = rank - pieces.length - 1;
      pieces = pieces.reversed.toList();
    }

    bool startLight = (rank + file) % 2 == 0;

    Offset? gateOffset;
    if (gate) {
      int origin = gatingSquare ?? selection ?? square; // shouldn't ever be `square`
      int m = widget.state.orientation == Squares.black ? -1 : 1;
      int fileDiff = widget.size.fileDiff(square, origin) * m;
      int rankDiff = widget.size.rankDiff(origin, square) * m;
      gateOffset = Offset(
        fileDiff * squareSize,
        rankDiff * squareSize,
      );
      if ((fileDiff.abs() + rankDiff.abs()) % 2 == 1) {
        startLight = !startLight;
      }
    }

    setState(() {
      promoState.add(PieceSelectorData(
        square: square,
        offset: gateOffset != null ? promoOffset + gateOffset : promoOffset,
        squareSize: squareSize,
        startLight: startLight,
        pieces: pieces,
        gate: gate,
      ));
    });
  }

  void closePromoSelector() {
    setState(() {
      promoState = [];
    });
  }

  void onNewBoardState() {
    if (premove != null && widget.onPremove != null) {
      final _premove = premove!;
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onPremove!(_premove));
    }
    if (target != null) {
      setState(() {
        premove = null;
        target = null;
        selection = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.orientation != lastState?.orientation) {
      // detect if the board has flipped
      closePromoSelector();
    }

    bool _animate = true;
    if (!widget.allowAnimation ||
        widget.state == lastState?.copyWith(orientation: widget.state.orientation)) {
      _animate = false; // don't animate the previous move twice
    }
    if (widget.state != lastState) {
      onNewBoardState();
    }
    if (afterDrag) {
      _animate = false;
      afterDrag = false;
    }
    lastState = widget.state;

    return Stack(
      children: [
        OldBoard(
          boardKey: boardKey,
          pieceSet: widget.pieceSet,
          state: widget.state,
          theme: widget.theme,
          size: widget.size,
          highlightTheme: widget.highlightTheme,
          selection: selection,
          target: target,
          canMove: widget.canMove,
          draggable: widget.draggable,
          dragFeedbackSize: widget.dragFeedbackSize,
          dragFeedbackOffset: widget.dragFeedbackOffset,
          onTap: onTap,
          onDragCancel: onDragCancel,
          validateDrag: validateDrag,
          acceptDrag: acceptDrag,
          highlights: dests.map((e) => e.to).toList(),
          allowAnimation: _animate,
          animationDuration: widget.animationDuration,
          animationCurve: widget.animationCurve,
        ),
        for (PieceSelectorData data in promoState)
          Positioned(
            left: data.offset.dx,
            top: data.offset.dy,
            child: PieceSelector(
              theme: widget.theme,
              pieceSet: widget.pieceSet,
              squareSize: data.squareSize,
              pieces: data.pieces,
              startOnLight: data.startLight,
              onTap: (i) => onPromo(i, data),
            ),
          ),
      ],
    );
  }
}

/// Also used for gating.
class PieceSelectorData {
  final int square;
  final Offset offset;
  final double squareSize;
  final bool startLight;
  final List<String?> pieces;
  final bool gate;
  final int? gatingSquare;

  PieceSelectorData({
    required this.square,
    required this.offset,
    required this.squareSize,
    required this.startLight,
    required this.pieces,
    this.gate = false,
    this.gatingSquare,
  });

  @override
  String toString() => 'PieceSelectorData($square, $offset, $pieces)';
}
