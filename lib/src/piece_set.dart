import 'package:flutter/material.dart';

class PieceSet {
  static const List<String> DEFAULT_SYMBOLS = ['P', 'N', 'B', 'R', 'Q', 'K'];
  static const List<String> EXTENDED_SYMBOLS = ['P', 'N', 'B', 'R', 'Q', 'K', 'A', 'C', 'H', 'E', 'S'];
  final Map<String, WidgetBuilder> pieces;
  const PieceSet({required this.pieces});

  Widget piece(BuildContext context, String symbol) => pieces[symbol]!(context);

  factory PieceSet.fromImageAssets({
    required String folder,
    String? package,
    required List<String> symbols,
    String format = 'png',
  }) {
    Map<String, WidgetBuilder> pieces = {};
    for (String symbol in symbols) {
      pieces[symbol.toUpperCase()] =
          (BuildContext context) => Image.asset('${folder}w$symbol.$format', package: package);
      pieces[symbol.toLowerCase()] =
          (BuildContext context) => Image.asset('${folder}b$symbol.$format', package: package);
    }
    return PieceSet(pieces: pieces);
  }

  // Not used any more as part of the package, because flutter_svg doesn't
  // support web. However, I'm keeping it here in case it's useful to someone.
  // factory PieceSet.fromSvgAssets({required String folder, String? package, required List<String> symbols}) {
  //   Map<String, WidgetBuilder> pieces = {};
  //   for (String symbol in symbols) {
  //     pieces[symbol.toUpperCase()] =
  //         (BuildContext context) => SvgPicture.asset('${folder}w$symbol.svg', package: package);
  //     pieces[symbol.toLowerCase()] =
  //         (BuildContext context) => SvgPicture.asset('${folder}b$symbol.svg', package: package);
  //   }
  //   return PieceSet(pieces: pieces);
  // }

  factory PieceSet.text({required Map<String, String> strings}) {
    Map<String, WidgetBuilder> pieces = {};
    strings.forEach((k, v) {
      pieces[k] = (BuildContext context) => Text(v);
    });
    return PieceSet(pieces: pieces);
  }

  factory PieceSet.merida() => PieceSet.fromImageAssets(
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
}
