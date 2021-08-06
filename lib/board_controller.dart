import 'package:flutter/material.dart';
import 'package:squares/board.dart';
import 'package:squares/board_state.dart';
import 'package:squares/move.dart';
import 'package:squares/piece_set.dart';
import 'package:squares/squares.dart';

class BoardController extends StatefulWidget {
  final PieceSet pieceSet;
  final BoardState state;
  final BoardSize size;
  final Function(Move)? onMove;
  final List<Move> moves;
  final bool canMove;
  late final Map<int, List<Move>> moveMap;

  BoardController({
    required this.pieceSet,
    required this.state,
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
  List<int> dests = []; // TODO: replace this with List<Move>, search it, do promotions

  void onTap(int square) {
    if (square == selection) {
      deselectSquare();
    } else {
      if (widget.moveMap.containsKey(square)) {
        selectSquare(square);
      } else {
        if (dests.contains(square) && widget.onMove != null) widget.onMove!(Move(from: selection!, to: square));
        deselectSquare();
      }
    }
  }

  void selectSquare(int square) {
    setState(() {
      selection = square;
      dests = widget.moveMap[square]?.map((e) => e.to).toList() ?? [];
    });
  }

  void deselectSquare() {
    setState(() {
      selection = null;
      dests = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Board(
      pieceSet: widget.pieceSet,
      state: widget.state,
      size: widget.size,
      selectedTo: selection,
      onTap: onTap,
      highlights: dests,
    );
  }
}
