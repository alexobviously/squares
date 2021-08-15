import 'package:bishop/bishop.dart' as bishop;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:squares/squares.dart';

class GameController extends Cubit<GameState> {
  GameController() : super(GameState.initial());
  bishop.Game? game;
  bishop.Engine? engine;

  void emitState([bool thinking = false]) {
    if (game == null) emit(GameState.initial());
    BoardSize size = BoardSize(game!.size.h, game!.size.v);
    bool canMove = game!.turn == WHITE;
    List<bishop.Move> _moves = canMove ? game!.generateLegalMoves() : game!.generatePremoves();
    List<Move> moves = [];
    for (bishop.Move move in _moves) {
      String algebraic = game!.toAlgebraic(move);
      Move _move = moveFromAlgebraic(algebraic, size);
      moves.add(_move);
    }
    bishop.GameInfo gameInfo = game!.info;
    BoardState board = BoardState(
      board: game!.boardSymbols(),
      lastFrom: gameInfo.lastFrom != null ? size.squareNumber(gameInfo.lastFrom!) : null,
      lastTo: gameInfo.lastTo != null ? size.squareNumber(gameInfo.lastTo!) : null,
      checkSquare: gameInfo.checkSq != null ? size.squareNumber(gameInfo.checkSq!) : null,
    );
    PlayState state = game!.gameOver ? PlayState.finished : (canMove ? PlayState.ourTurn : PlayState.theirTurn);
    emit(
      GameState(
        state: state,
        thinking: thinking,
        size: size,
        board: board,
        moves: moves,
        hands: game!.handSymbols(),
      ),
    );
  }

  void startGame(bishop.Variant variant, {String? fen}) {
    game = bishop.Game(variant: variant, fen: fen);
    engine = bishop.Engine(game: game!);
    emitState();
  }

  void makeMove(Move move) {
    if (game == null) return;
    String alg = moveToAlgebraic(move, state.size);
    bishop.Move? m = game!.getMove(alg);
    if (m == null)
      print('move $alg not found');
    else {
      game!.makeMove(m);
      emitState();
      //Future.delayed(Duration(milliseconds: 200)).then((_) => engineMove());
      engineMove();
    }
  }

  void randomMove() {
    if (game == null || game!.gameOver) return;
    game!.makeRandomMove();
    emitState();
  }

  void engineMove() async {
    emitState(true);
    await Future.delayed(Duration(milliseconds: 250));
    //bishop.EngineResult result = await engine!.search();
    bishop.EngineResult result = await compute(engineSearch, game!);
    if (result.hasMove) {
      print('Best Move: ${formatResult(result)}');
      game!.makeMove(result.move!);
      emitState();
    }
  }

  String formatResult(bishop.EngineResult res) {
    if (game == null) return 'No Game';
    if (!res.hasMove) return 'No Move';
    String san = game!.toSan(res.move!);
    return '$san (${res.eval}) [depth ${res.depth}]';
  }
}

Future<bishop.EngineResult> engineSearch(bishop.Game game) async {
  return await bishop.Engine(game: game).search(timeLimit: 1000, timeBuffer: 500);
}

class GameState extends Equatable {
  final PlayState state;
  final BoardSize size;
  final BoardState board;
  final List<Move> moves;
  final List<List<String>> hands;
  final bool thinking;

  bool get canMove => state == PlayState.ourTurn;

  GameState({
    required this.state,
    required this.size,
    required this.board,
    required this.moves,
    this.hands = const [[], []],
    this.thinking = false,
  });
  factory GameState.initial() =>
      GameState(state: PlayState.idle, size: BoardSize.standard(), board: BoardState.empty(), moves: []);

  GameState copyWith({
    PlayState? state,
    BoardSize? size,
    BoardState? board,
    List<Move>? moves,
    List<List<String>>? hands,
    bool? thinking,
  }) {
    return GameState(
      state: state ?? this.state,
      size: size ?? this.size,
      board: board ?? this.board,
      moves: moves ?? this.moves,
      hands: hands ?? this.hands,
      thinking: thinking ?? this.thinking,
    );
  }

  List<Object> get props => [state, size, board, moves, hands, thinking];
  bool get stringify => true;
}

enum PlayState {
  idle,
  ourTurn,
  theirTurn,
  finished,
}
Move moveFromAlgebraic(String alg, BoardSize size) {
  if (alg[1] == '@') {
    // it's a drop
    int from = HAND;
    int to = size.squareNumber(alg.substring(2, 4));
    return Move(from: from, to: to, piece: alg[0].toUpperCase());
  }
  int from = size.squareNumber(alg.substring(0, 2));
  int to = size.squareNumber(alg.substring(2, 4));
  String? promo = (alg.length > 4) ? alg[4] : null;
  return Move(from: from, to: to, promo: promo);
}

String moveToAlgebraic(Move move, BoardSize size) {
  if (move.drop) {
    return '${move.piece!.toLowerCase()}@${size.squareName(move.to)}';
  } else {
    String from = size.squareName(move.from);
    String to = size.squareName(move.to);
    String alg = '$from$to';
    if (move.promotion) alg = '$alg${move.promo}';
    return alg;
  }
}
