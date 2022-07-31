import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

part 'piece_overlay.dart';

class BoardOverlay extends StatelessWidget {
  final BoardSize size;
  final int orientation;
  final Map<int, Widget> children;

  const BoardOverlay({
    super.key,
    this.size = BoardSize.standard,
    this.orientation = Squares.white,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return BoardBuilder(
      builder: ((rank, file, squareSize) => _child(rank, file, squareSize)),
    );
  }

  Widget _child(int rank, int file, double squareSize) {
    int square = size.square(rank, file, orientation);
    Widget child = children[square] ??
        SizedBox(
          width: squareSize,
          height: squareSize,
        );
    return child;
  }
}
