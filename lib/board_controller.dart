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
  final Map<int, List<int>> moves;
  final bool canMove;

  BoardController({
    required this.pieceSet,
    required this.state,
    this.size = const BoardSize(8, 8),
    this.onMove,
    this.moves = const {},
    required this.canMove,
  });

  @override
  _BoardControllerState createState() => _BoardControllerState();
}

class _BoardControllerState extends State<BoardController> {
  int? selection;
  List<int> dests = [];

  void onTap(int square) {
    if (square == selection) {
      deselectSquare();
    } else {
      if (widget.moves.containsKey(square)) {
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
      dests = widget.moves[square] ?? [];
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
