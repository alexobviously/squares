import 'package:squares/squares.dart';

String pieceForPlayer(String piece, int player) =>
    player == Squares.white ? piece.toUpperCase() : piece.toLowerCase();

int playerForPiece(String piece, [int fallback = Squares.white]) =>
    piece.isEmpty
        ? fallback
        : piece == piece.toUpperCase()
            ? Squares.white
            : Squares.black;

String alphaLowerLabel(int index) => String.fromCharCode(asciiALower + index);
String alphaUpperLabel(int index) => String.fromCharCode(asciiAUpper + index);
String numericLabel(int index) => '${index + 1}';
