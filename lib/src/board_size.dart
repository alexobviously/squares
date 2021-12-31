import 'dart:math';

import 'package:squares/squares.dart';

class BoardSize {
  final int h;
  final int v;
  int get numSquares => h * v;
  int get minDim => min(h, v);
  int get maxDim => max(h, v);
  int get maxRank => v - 1;
  int get maxFile => h - 1;
  const BoardSize(this.h, this.v);
  factory BoardSize.standard() => BoardSize(8, 8);

  String squareName(int square) {
    int rank = v - (square ~/ h);
    int file = square % h;
    String fileName = String.fromCharCode(ASCII_a + file);
    return '$fileName$rank';
  }

  int squareNumber(String name) {
    name = name.toLowerCase();
    if (name == 'hand') return HAND;
    RegExp rx = RegExp(r'([A-Za-z])([0-9]+)');
    RegExpMatch? match = rx.firstMatch(name);
    assert(match != null, 'Invalid square name: $name');
    assert(match!.groupCount == 2, 'Invalid square name: $name');
    String file = match!.group(1)!;
    String rank = match.group(2)!;
    int _file = file.codeUnits[0] - ASCII_a;
    int _rank = v - int.parse(rank);
    int square = _rank * h + _file;
    return square;
  }

  int squareRank(int square) => v - (square ~/ h);
  int squareFile(int square) => square % h;
  int rankDiff(int from, int to) => squareRank(to) - squareRank(from);
  int fileDiff(int from, int to) => squareFile(to) - squareFile(from);

  Move moveFromAlgebraic(String alg) {
    if (alg[1] == '@') {
      // it's a drop
      int from = HAND;
      int to = squareNumber(alg.substring(2, 4));
      return Move(from: from, to: to, piece: alg[0].toUpperCase());
    }
    int from = squareNumber(alg.substring(0, 2));
    int to = squareNumber(alg.substring(2, 4));

    String? piece;
    int? gatingSquare;
    List<String> _sections = alg.split('/');
    if (_sections.length > 1) {
      String _gate = _sections.last;
      piece = _gate[0];
      gatingSquare = _gate.length > 2 ? squareNumber(_gate.substring(1, 3)) : from;
    }
    String? promo = (alg.length > 4) ? alg[4] : null;
    return Move(
      from: from,
      to: to,
      promo: promo,
      piece: piece,
      gatingSquare: gatingSquare,
    );
  }

  String moveToAlgebraic(Move move) {
    if (move.drop) {
      return '${move.piece!.toLowerCase()}@${squareName(move.to)}';
    } else {
      String from = squareName(move.from);
      String to = squareName(move.to);
      String alg = '$from$to';
      if (move.promotion) alg = '$alg${move.promo}';
      return alg;
    }
  }
}
