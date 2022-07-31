import 'package:squares/squares.dart';

String pieceForPlayer(String piece, int player) =>
    player == Squares.white ? piece.toUpperCase() : piece.toLowerCase();

int playerForPiece(String piece, [int fallback = Squares.white]) => piece.isEmpty
    ? fallback
    : piece == piece.toUpperCase()
        ? Squares.white
        : Squares.black;
