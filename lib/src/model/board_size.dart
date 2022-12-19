import 'dart:math';

import 'package:squares/squares.dart';

/// Specifies the dimensions of a board.
class BoardSize {
  /// The horizontal size, i.e. number of files on the board.
  final int h;

  /// The vertical size, i.e. number of ranks on the board.
  final int v;

  /// Horizontal size divided by vertical size.
  double get aspectRatio => h / v;

  /// The total number of squares on a board of this size.
  int get numSquares => h * v;

  /// Returns the shortest dimension.
  int get minDim => min(h, v);

  /// Returns the longest dimension.
  int get maxDim => max(h, v);

  /// Index of the last rank.
  int get maxRank => v - 1;

  /// Index of the last file.
  int get maxFile => h - 1;

  const BoardSize(this.h, this.v);

  /// A standard 8x8 board.
  static const standard = BoardSize(8, 8);

  /// Gets a square id for [rank], [file] and [orientation].
  /// Orientation can be 0 (white) or 1 (black);
  int square(int rank, int file, int orientation) =>
      (orientation == Squares.white ? rank : v - rank - 1) * h +
      (orientation == Squares.white ? file : h - file - 1);

  /// Returns a human-readable name for a square on a board of this size.
  /// e.g. c1, h6.
  String squareName(int square) {
    int rank = v - (square ~/ h);
    int file = square % h;
    String fileName = String.fromCharCode(asciiALower + file);
    return '$fileName$rank';
  }

  /// Converts a human-readable square name into an integer, corresponding to
  /// the correct square on a board of this size.
  int squareNumber(String name) {
    name = name.toLowerCase();
    if (name == 'hand') return Squares.hand;
    RegExp rx = RegExp(r'([A-Za-z])([0-9]+)');
    RegExpMatch? match = rx.firstMatch(name);
    assert(match != null, 'Invalid square name: $name');
    assert(match!.groupCount == 2, 'Invalid square name: $name');
    String fileStr = match!.group(1)!;
    String rankStr = match.group(2)!;
    int file = fileStr.codeUnits[0] - asciiALower;
    int rank = v - int.parse(rankStr);
    int square = rank * h + file;
    return square;
  }

  /// Returns the rank that [square] is on.
  int squareRank(int square) => v - (square ~/ h);

  /// Returns the file that [square] is on.
  int squareFile(int square) => square % h;

  /// Calculates the difference in ranks between two squares.
  int rankDiff(int from, int to) => squareRank(to) - squareRank(from);

  /// Calculates the difference in files between two squares.
  int fileDiff(int from, int to) => squareFile(to) - squareFile(from);

  /// Returns true if [square] is a light square.
  bool isLightSquare(int square) =>
      (squareRank(square) + squareFile(square)) % 2 == 0;

  /// Returns true if [square] is a dark square.
  bool isDarkSquare(int square) => !isLightSquare(square);

  /// Returns true if [square] is on the board.
  bool isOnBoard(int square) => square >= 0 && square < numSquares;

  static final RegExp _moveRegex =
      RegExp(r'([a-z][0-9]+)([a-z][0-9]+)([a-z])?');

  /// Create a `Move` from an algebraic string (e.g. a2a3, g6f3) for a board
  /// of this size.
  Move moveFromAlgebraic(String alg) {
    // A normal move - b1c3
    // A normal move with promo - e7e8q
    // A drop - e@g7
    // A gating move - g7f6/e
    // A disambiguated gating move - e1g1/eh1 (castling)
    if (alg[1] == '@') {
      // it's a drop
      int from = Squares.hand;
      int to = squareNumber(alg.substring(2));
      return Move(from: from, to: to, piece: alg[0]);
    }
    List<String> sections = alg.split('/');
    String move = sections.first;
    final m = _moveRegex.firstMatch(move);
    if (m == null) {
      throw Exception('Invalid move string: $alg');
    }
    int from = squareNumber(m.group(1)!);
    int to = squareNumber(m.group(2)!);
    String? promo = m.group(3);
    String? piece;
    int? gatingSquare;
    if (sections.length > 1) {
      String gate = sections.last;
      piece = gate[0];
      gatingSquare = gate.length > 2 ? squareNumber(gate.substring(1)) : from;
    }

    return Move(
      from: from,
      to: to,
      promo: promo,
      piece: piece,
      gatingSquare: gatingSquare,
    );
  }

  /// Returns an algebraic string (e.g. a2a3, g6f3), for a given [move].
  String moveToAlgebraic(Move move) {
    // String alg = move.algebraic(this);
    // if (move.promotion) alg = '$alg${move.promo}';
    // if (move.from == HAND) alg = '${move.piece}$alg';
    if (move.handDrop) {
      return '${move.piece!.toLowerCase()}@${squareName(move.to)}';
    } else {
      String from = squareName(move.from);
      String to = squareName(move.to);
      String alg = '$from$to';
      if (move.promotion) alg = '$alg${move.promo!.toLowerCase()}';
      if (move.gate) {
        alg = '$alg/${move.piece!.toLowerCase()}';
        if (move.gatingSquare != null) {
          alg = '$alg${squareName(move.gatingSquare!)}';
        }
      }
      return alg;
    }
  }

  @override
  String toString() => 'BoardSize($h, $v)';
}
