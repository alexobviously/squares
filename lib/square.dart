import 'package:flutter/material.dart';
import 'package:squares/piece_set.dart';

class Square extends StatelessWidget {
  final int id;
  final Color colour;
  final Widget? piece;
  const Square({required this.id, required this.colour, this.piece});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        color: colour,
        child: Stack(
          children: [
            if (piece != null)
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: piece,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
