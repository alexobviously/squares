import 'package:flutter/material.dart';
import 'package:squares/board.dart';
import 'package:squares/board_state.dart';
import 'package:squares/move.dart';
import 'package:squares/piece_set.dart';

class BoardWrapper extends StatefulWidget {
  final PieceSet pieceSet;
  final BoardState state;
  final int ranks;
  final int files;
  final Function(Move)? onMove;
  final Map<int, List<int>> moves;

  BoardWrapper({
    required this.pieceSet,
    required this.state,
    required this.ranks,
    required this.files,
    this.onMove,
    this.moves = const {},
  });

  @override
  _BoardWrapperState createState() => _BoardWrapperState();
}

class _BoardWrapperState extends State<BoardWrapper> {
  int? selection;
  List<int> dests = [];

  void onTap(int square) {
    int? newSelection;
    if (square == selection) {
      deselectSquare();
    } else {
      if (widget.moves.containsKey(square)) {
        selectSquare(square);
      } else if (dests.contains(square)) {
        if (widget.onMove != null) widget.onMove!(Move(from: selection!, to: square));
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
      ranks: widget.ranks,
      files: widget.files,
      selectedTo: selection,
      onTap: onTap,
      highlights: dests,
    );
  }
}
