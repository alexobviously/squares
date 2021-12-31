import 'package:flutter/material.dart';
import 'package:squares/squares.dart';
import 'package:squares/src/highlight_theme.dart';

/// A wrapper that handles interactions and certain elements of board state
/// (such as premoves) for a [Board].
class BoardController extends StatefulWidget {
  final PieceSet pieceSet;
  final BoardState state;
  final BoardTheme theme;
  final BoardSize size;
  final HighlightTheme? highlightTheme;

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

  late final Map<int, List<Move>> moveMap;
  late final List<Move> drops;

  /// If true and there is a last move, it will be animated.
  final bool allowAnimation;

  /// How long move animations take to play.
  final Duration? animationDuration;

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
    this.allowAnimation = true,
    this.animationDuration,
  }) {
    moveMap = {};
    drops = [];
    for (Move m in moves) {
      if (m.handDrop) {
        drops.add(m);
        continue;
      }
      if (!moveMap.containsKey(m.from))
        moveMap[m.from] = [m];
      else
        moveMap[m.from]!.add(m);
    }
  }

  @override
  _BoardControllerState createState() => _BoardControllerState();
}

class _BoardControllerState extends State<BoardController> {
  int? selection;
  int? target;
  List<Move> dests = [];
  PromoState? promoState;
  GlobalKey boardKey = GlobalKey();
  bool get hasPromo => promoState != null;
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
              openPromoSelector(square, squareKey, gateSquare: 0);
            }
          }
        }
      }
    }
  }

  void onDrop(PartialMove partial, int to, GlobalKey squareKey) {
    List<Move> targetMoves = widget.drops.where((m) => m.piece == partial.piece && m.to == to).toList();
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

  void onPromo(int piece) {
    if (promoState == null || selection == null || widget.onMove == null) {
      closePromoSelector();
      return;
    }
    Move move = Move(
      from: selection!,
      to: promoState!.square,
      promo: promoState!.pieces[piece].toLowerCase(),
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

  void openPromoSelector(int square, GlobalKey key, {int? gateSquare}) {
    bool gate = gateSquare != null;
    List<String> pieces = ['Q', 'R', 'B', 'N'];
    List<Move> _moves = widget.moves.where((e) => e.from == square && (gate ? e.gate : e.promotion)).toList();
    pieces = _moves.map((e) => (gate ? e.piece : e.promo) ?? '').toList();
    RenderBox squareBox = key.currentContext!.findRenderObject() as RenderBox;
    RenderBox boardBox = boardKey.currentContext!.findRenderObject() as RenderBox;
    Offset promoOffset = boardBox.globalToLocal(squareBox.localToGlobal(Offset.zero));
    double squareSize = squareBox.size.width;
    int rank = widget.size.squareRank(square);
    int file = widget.size.squareFile(square);
    bool flip = ((widget.state.orientation == WHITE && rank == 0) ||
        (widget.state.orientation == BLACK && rank == widget.size.maxRank + 1));
    if (flip) {
      promoOffset = promoOffset.translate(0, -squareSize * (pieces.length - 1));
      rank = rank - pieces.length - 1;
      pieces = pieces.reversed.toList();
    }

    bool startLight = (rank + file) % 2 == 1;
    setState(() {
      promoState = PromoState(
        square: square,
        offset: promoOffset,
        squareSize: squareSize,
        startLight: startLight,
        pieces: pieces,
        gate: gate,
      );
    });
  }

  void closePromoSelector() {
    setState(() {
      promoState = null;
    });
  }

  void onNewBoardState() {
    if (premove != null && widget.onPremove != null) widget.onPremove!(premove!);
    if (target != null) {
      target = null;
      selection = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.orientation != lastState?.orientation) {
      // detect if the board has flipped
      closePromoSelector();
    }

    bool _animate = true;
    if (!widget.allowAnimation || widget.state == lastState?.copyWith(orientation: widget.state.orientation)) {
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

    List<Widget> promos = [];
    if (hasPromo) {
      for (String symbol in promoState!.pieces) {
        Widget? piece = symbol.isNotEmpty ? widget.pieceSet.piece(context, symbol) : null;
        if (piece != null) promos.add(piece);
      }
    }
    return Stack(
      children: [
        Board(
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
          onTap: onTap,
          onDragCancel: onDragCancel,
          validateDrag: validateDrag,
          acceptDrag: acceptDrag,
          highlights: dests.map((e) => e.to).toList(),
          allowAnimation: _animate,
          animationDuration: widget.animationDuration,
        ),
        if (hasPromo)
          Positioned(
            left: promoState!.offset.dx,
            top: promoState!.offset.dy,
            child: PieceSelector(
              theme: widget.theme,
              pieceSet: widget.pieceSet,
              squareSize: promoState!.squareSize,
              pieces: promoState?.pieces ?? [],
              startOnLight: promoState!.startLight,
              onTap: onPromo,
            ),
          ),
      ],
    );
  }
}

/// Also used for gating.
class PromoState {
  final int square;
  final Offset offset;
  final double squareSize;
  final bool startLight;
  final List<String> pieces;
  final bool gate;

  PromoState({
    required this.square,
    required this.offset,
    required this.squareSize,
    required this.startLight,
    required this.pieces,
    this.gate = false,
  });
}
