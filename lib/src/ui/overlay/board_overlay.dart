import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

part 'piece_overlay.dart';

/// Builds a map of arbitrary [children] in a board arrangement, according to
/// [size] and [orientation]. The keys of [children] should be square indices.
class BoardOverlay extends StatelessWidget {
  /// Dimensions of the board.
  final BoardSize size;

  /// Determines which way around the board is facing.
  /// 0 (white) will place the white pieces at the bottom,
  /// and 1 will place the black pieces there.
  /// You likely want to take this from `BoardState.orientation`.
  final int orientation;

  /// Child widgets to draw on the board, at the indices specified by their keys.
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
