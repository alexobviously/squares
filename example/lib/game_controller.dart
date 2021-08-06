import 'package:bishop/bishop.dart' as bishop;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squares/squares.dart';

class GameController extends Cubit<GameState> {
  GameController() : super(GameState.initial());
  bishop.Game? game;

  void emitState() {
    print('emit');
    if (game == null) emit(GameState.initial());
    BoardSize size = BoardSize(game!.size.h, game!.size.v);
    BoardState board = BoardState(board: game!.boardSymbols());
    bool canMove = game!.turn == 0;
    List<bishop.Move> legalMoves = game!.generateLegalMoves();
    List<Move> moves = [];
    if (canMove) {
      for (bishop.Move move in legalMoves) {
        String algebraic = game!.toAlgebraic(move);
        Move _move = moveFromAlgebraic(algebraic, size);
        moves.add(_move);
      }
    }
    PlayState state = game!.gameOver ? PlayState.finished : (canMove ? PlayState.ourTurn : PlayState.theirTurn);
    emit(
      GameState(
        state: state,
        size: size,
        board: board,
        moves: moves,
      ),
    );
  }

  void startGame(bishop.Variant variant, {String? fen}) {
    game = bishop.Game(variant: variant, fen: fen);
    emitState();
  }

  void makeMove(Move move) {
    if (game == null) return;
    BoardSize size = state.size;
    String from = size.squareName(move.from);
    String to = size.squareName(move.to);
    String alg = '$from$to';
    if (move.promotion) alg = '$alg${move.promo}';
    bishop.Move? m = game!.getMove(alg);
    if (m == null)
      print('move $alg not found');
    else {
      game!.makeMove(m);
      emitState();
      Future.delayed(Duration(seconds: 3)).then((_) => randomMove());
    }
  }

  void randomMove() {
    if (game == null || game!.gameOver) return;
    game!.makeRandomMove();
    emitState();
  }
}

class GameState extends Equatable {
  final PlayState state;
  final BoardSize size;
  final BoardState board;
  final List<Move> moves;

  bool get canMove => state == PlayState.ourTurn;

  GameState({required this.state, required this.size, required this.board, required this.moves});
  factory GameState.initial() =>
      GameState(state: PlayState.idle, size: BoardSize.standard(), board: BoardState.empty(), moves: []);

  List<Object> get props => [state, size, board, moves];
  bool get stringify => true;
}

enum PlayState {
  idle,
  ourTurn,
  theirTurn,
  finished,
}
Move moveFromAlgebraic(String alg, BoardSize size) {
  int from = size.squareNumber(alg.substring(0, 2));
  int to = size.squareNumber(alg.substring(2, 4));
  String? promo = (alg.length > 4) ? alg[4] : null;
  return Move(from: from, to: to, promo: promo);
}
