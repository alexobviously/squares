import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class BoardController extends StatefulWidget {
  final PieceSet pieceSet;
  final BoardState state;
  final BoardTheme theme;
  final BoardSize size;
  final Function(Move)? onMove;
  final Function(Move?)? onSetPremove;
  final Function(Move)? onPremove;
  final List<Move> moves;
  final bool canMove;
  late final Map<int, List<Move>> moveMap;

  BoardController({
    required this.pieceSet,
    required this.state,
    required this.theme,
    this.size = const BoardSize(8, 8),
    this.onMove,
    this.onSetPremove,
    this.onPremove,
    this.moves = const [],
    required this.canMove,
  }) {
    moveMap = {};
    for (Move m in moves) {
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
            if (promoMoves.isEmpty) {
              if (widget.canMove) {
                if (widget.onMove != null) widget.onMove!(targetMoves.first);
                deselectSquare();
              } else {
                setTarget(square);
                premove = targetMoves.first;
                if (widget.onSetPremove != null) widget.onSetPremove!(premove);
              }
            } else {
              openPromoSelector(square, squareKey);
            }
          }
        }
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
    if (widget.moveMap[partial.from] == null) return false;
    Move? move = widget.moveMap[partial.from]!.firstWhereOrNull((m) => m.to == to);
    return move != null;
  }

  void acceptDrag(PartialMove partial, int to, GlobalKey squareKey) {
    selection = partial.from;
    onTap(to, squareKey);
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

  void openPromoSelector(int square, GlobalKey key) {
    List<String> pieces = ['Q', 'R', 'B', 'N'];
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
      );
    });
  }

  void closePromoSelector() {
    setState(() {
      promoState = null;
    });
  }

  void onNewBoardState() {
    print('new board state');
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

    if (widget.state != lastState) {
      onNewBoardState();
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
          selection: selection,
          target: target,
          canMove: widget.canMove,
          onTap: onTap,
          onDragCancel: onDragCancel,
          validateDrag: validateDrag,
          acceptDrag: acceptDrag,
          highlights: dests.map((e) => e.to).toList(),
        ),
        if (hasPromo)
          Positioned(
            left: promoState!.offset.dx,
            top: promoState!.offset.dy,
            child: PromoSelector(
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

class PromoState {
  final int square;
  final Offset offset;
  final double squareSize;
  final bool startLight;
  final List<String> pieces;

  PromoState({
    required this.square,
    required this.offset,
    required this.squareSize,
    required this.startLight,
    required this.pieces,
  });
}
