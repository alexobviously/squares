import 'package:flutter/material.dart';
import 'package:squares/square.dart';

class PromoSelector extends StatelessWidget {
  final double squareSize;
  final List<Widget> pieces;
  final bool startOnLight;
  final Color? light;
  final Color? dark;
  final Function(int)? onTap;
  PromoSelector({
    required this.squareSize,
    required this.pieces,
    this.startOnLight = false,
    this.light,
    this.dark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color _light = light ?? theme.primaryColorLight;
    Color _dark = dark ?? theme.primaryColorDark;
    List<Widget> squares = [];
    for (int i = 0; i < pieces.length; i++) {
      Square square = Square(
        id: i,
        colour: i % 2 == (startOnLight ? 0 : 1) ? _light : _dark,
        piece: pieces[i],
        onTap: onTap != null ? (key) => onTap!(i) : null,
        highlight: Colors.amber.withAlpha(120),
      );
      squares.add(square);
    }
    return Container(
      width: squareSize,
      height: squareSize * squares.length,
      child: Column(children: squares),
    );
  }
}
