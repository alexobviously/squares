import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class PieceSet {
  static const List<String> DEFAULT_SYMBOLS = ['P', 'N', 'B', 'R', 'Q', 'K'];
  static const List<String> EXTENDED_SYMBOLS = ['P', 'N', 'B', 'R', 'Q', 'K', 'A', 'C', 'H', 'E', 'S'];
  final Map<String, WidgetBuilder> pieces;
  const PieceSet({required this.pieces});

  Widget piece(BuildContext context, String symbol) => pieces[symbol]!(context);

  factory PieceSet.fromSvgAssets({required String folder, String? package, required List<String> symbols}) {
    Map<String, WidgetBuilder> pieces = {};
    for (String symbol in symbols) {
      pieces[symbol.toUpperCase()] =
          (BuildContext context) => SvgPicture.asset('${folder}w$symbol.svg', package: package);
      pieces[symbol.toLowerCase()] =
          (BuildContext context) => SvgPicture.asset('${folder}b$symbol.svg', package: package);
    }
    return PieceSet(pieces: pieces);
  }

  factory PieceSet.text({required Map<String, String> strings}) {
    Map<String, WidgetBuilder> pieces = {};
    strings.forEach((k, v) {
      pieces[k] = (BuildContext context) => Text(v);
    });
    return PieceSet(pieces: pieces);
  }

  factory PieceSet.merida() => PieceSet.fromSvgAssets(
        folder: 'lib/piece_sets/merida/',
        package: 'squares',
        symbols: EXTENDED_SYMBOLS,
      );

  factory PieceSet.letters() => PieceSet.text(
        strings: {
          //
          'P': 'P', 'p': 'p', 'N': 'N', 'n': 'n',
          'B': 'B', 'b': 'b', 'R': 'R', 'r': 'r',
          'Q': 'Q', 'q': 'q', 'K': 'K', 'k': 'k',
          'C': 'C', 'c': 'c', 'A': 'A', 'a': 'a',
        },
      );

  // factory PieceSet.merida() => PieceSet(
  //       pieces: {
  //         'P': (_) => SvgPicture.asset('lib/piece_sets/merida/wP.svg', package: 'squares'),
  //         'p': (_) => SvgPicture.asset('lib/piece_sets/merida/bP.svg', package: 'squares')
  //       },
  //     );
}
