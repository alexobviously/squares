import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class BoardController extends StatefulWidget {
  final PieceSet pieceSet;
  final BoardState state;
  final BoardTheme theme;
  final BoardSize size;
  final Function(Move)? onMove;
  final List<Move> moves;
  final bool canMove;
  late final Map<int, List<Move>> moveMap;

  BoardController({
    required this.pieceSet,
    required this.state,
    required this.theme,
    this.size = const BoardSize(8, 8),
    this.onMove,
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
  List<Move> dests = [];
  PromoState? promoState;
  GlobalKey boardKey = GlobalKey();
  bool get hasPromo => promoState != null;

  void onTap(int square, GlobalKey squareKey) {
    if (square == selection) {
      deselectSquare();
    } else {
      closePromoSelector();
      if (widget.moveMap.containsKey(square)) {
        selectSquare(square);
      } else {
        if (selection != null) {
          List<Move> targetMoves = dests.where((m) => m.to == square).toList();
          if (targetMoves.isEmpty) {
            deselectSquare();
          } else {
            List<Move> promoMoves = targetMoves.where((m) => m.promotion).toList();
            if (promoMoves.isEmpty) {
              if (widget.onMove != null) widget.onMove!(targetMoves.first);
              deselectSquare();
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
    widget.onMove!(move);
    deselectSquare();
  }

  void onDragCancel(int square) {
    if (selection == square) deselectSquare();
  }

  bool validateDrag(int from, int to) {
    if (widget.moveMap[from] == null) return false;
    Move? move = widget.moveMap[from]!.firstWhereOrNull((m) => m.to == to);
    return move != null;
  }

  void acceptDrag(int from, int to, GlobalKey squareKey) {
    selection = from;
    onTap(to, squareKey);
  }

  void selectSquare(int square) {
    setState(() {
      selection = square;
      dests = widget.moveMap[square] ?? [];
    });
  }

  void deselectSquare() {
    closePromoSelector();
    setState(() {
      selection = null;
      dests = [];
    });
  }

  void openPromoSelector(int square, GlobalKey key) {
    RenderBox squareBox = key.currentContext!.findRenderObject() as RenderBox;
    RenderBox boardBox = boardKey.currentContext!.findRenderObject() as RenderBox;
    Offset promoOffset = boardBox.globalToLocal(squareBox.localToGlobal(Offset.zero));
    double squareSize = squareBox.size.width;
    int rank = widget.size.squareRank(square);
    int file = widget.size.squareFile(square);
    bool startLight = (rank + file) % 2 == 1;
    List<String> pieces = ['Q', 'R', 'B', 'N'];
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

  @override
  Widget build(BuildContext context) {
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
              squareSize: promoState!.squareSize,
              pieces: promos,
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
