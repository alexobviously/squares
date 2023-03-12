import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:squares/squares.dart';

PieceSet svgPieceSet({
  required String folder,
  String? package,
  required List<String> symbols,
}) {
  Map<String, WidgetBuilder> pieces = {};
  for (String symbol in symbols) {
    pieces[symbol.toUpperCase()] = (BuildContext context) =>
        SvgPicture.asset('${folder}w$symbol.svg', package: package);
    pieces[symbol.toLowerCase()] = (BuildContext context) =>
        SvgPicture.asset('${folder}b$symbol.svg', package: package);
  }
  return PieceSet(pieces: pieces);
}
