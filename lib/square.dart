import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final int id;
  final Color colour;
  const Square({required this.id, required this.colour});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        color: colour,
      ),
    );
  }
}
