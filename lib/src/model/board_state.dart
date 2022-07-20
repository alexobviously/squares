import 'package:equatable/equatable.dart';
import 'package:squares/squares.dart';

/// A representation of a state of a board.
/// Stores the contents of each square in [board], the [player] to move,
/// [orientation] of the board, and highlights in [lastFrom], [lastTo] and [checkSquare].
class BoardState extends Equatable {
  /// A list of the pieces on each square of the board.
  /// An empty string indicates no piece is on the square. Otherwise, it should be
  /// a single character string matching an entry in the `PieceSet` being used.
  /// Upper case is white, lower case is black.
  final List<String> board;

  /// Whose turn is it to play?
  /// 0 for white, 1 for black.
  final int player;

  /// Determines which way around the board is facing.
  /// 0 (white) will place the white pieces at the bottom,
  /// and 1 will place the black pieces there.
  late final int orientation;

  /// The square that the last move started on.
  final int? lastFrom;

  /// The square that the last move finished on.
  final int? lastTo;

  /// If a king is in check, which square is it on?
  final int? checkSquare;

  BoardState({
    required this.board,
    this.player = Squares.white,
    int? orientation,
    this.lastFrom,
    this.lastTo,
    this.checkSquare,
  }) {
    this.orientation = orientation ?? player;
  }
  factory BoardState.empty() => BoardState(board: []);

  BoardState copyWith({
    List<String>? board,
    int? player,
    int? orientation,
    int? lastFrom,
    int? lastTo,
    int? checkSquare,
  }) {
    return BoardState(
      board: board ?? this.board,
      player: player ?? this.player,
      orientation: orientation ?? this.orientation,
      lastFrom: lastFrom ?? this.lastFrom,
      lastTo: lastTo ?? this.lastTo,
      checkSquare: checkSquare ?? this.checkSquare,
    );
  }

  /// Returns a `BoardState` identical to this one, but with [orientation] flipped.
  BoardState flipped() => copyWith(orientation: 1 - orientation);

  @override
  List<Object?> get props => [board, player, lastFrom, lastTo, checkSquare, orientation];
}
