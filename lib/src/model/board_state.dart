import 'package:equatable/equatable.dart';
import 'package:squares/squares.dart';

/// A representation of a state of a board.
/// Stores the contents of each square in [board], the [turn] to move,
/// [orientation] of the board, and highlights in [lastFrom], [lastTo] and [checkSquare].
class BoardState extends Equatable {
  /// A list of the pieces on each square of the board.
  /// An empty string indicates no piece is on the square. Otherwise, it should be
  /// a single character string matching an entry in the `PieceSet` being used.
  /// Upper case is white, lower case is black.
  final List<String> board;

  /// Whose turn is it to play?
  /// 0 for white, 1 for black.
  final int turn;

  @Deprecated('Please use [turn] instead')
  int get player => turn;

  /// Determines which way around the board is facing.
  /// 0 (white) will place the white pieces at the bottom,
  /// and 1 will place the black pieces there.
  final int orientation;

  /// The square that the last move started on.
  final int? lastFrom;

  /// The square that the last move finished on.
  final int? lastTo;

  /// If a king is in check, which square is it on?
  final int? checkSquare;

  /// The player whose turn it isn't.
  int get waitingPlayer => 1 - turn;

  const BoardState({
    required this.board,
    this.turn = Squares.white,
    int? orientation,
    this.lastFrom,
    this.lastTo,
    this.checkSquare,
  }) : orientation = orientation ?? turn;

  factory BoardState.empty() => BoardState(board: []);

  BoardState copyWith({
    List<String>? board,
    int? turn,
    int? orientation,
    int? lastFrom,
    int? lastTo,
    int? checkSquare,
  }) {
    return BoardState(
      board: board ?? this.board,
      turn: turn ?? this.turn,
      orientation: orientation ?? this.orientation,
      lastFrom: lastFrom ?? this.lastFrom,
      lastTo: lastTo ?? this.lastTo,
      checkSquare: checkSquare ?? this.checkSquare,
    );
  }

  BoardState updateSquares(Map<int, String> updates) {
    List<String> newBoard = [...board];
    for (final u in updates.entries) {
      newBoard[u.key] = u.value;
    }
    return copyWith(board: newBoard);
  }

  BoardState clearBoard(BoardSize size) =>
      copyWith(board: List.filled(size.numSquares, ''));

  /// Returns a `BoardState` identical to this one, but with [orientation] flipped.
  BoardState flipped() => copyWith(orientation: 1 - orientation);

  int playerForState(PlayState playState) =>
      playState == PlayState.theirTurn ? waitingPlayer : turn;

  /// Returns the fen string - the board part only.
  String fen([BoardSize size = BoardSize.standard]) {
    return board
        .partition(size.h)
        .map((e) => e.countAndReplace('', (c) => '$c').join(''))
        .join('/');
  }

  @override
  List<Object?> get props =>
      [board, turn, lastFrom, lastTo, checkSquare, orientation];
}
