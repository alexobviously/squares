import 'package:bishop/bishop.dart' as bishop;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:squares/squares.dart';
import 'package:squares_complex/game_config.dart';

class GameController extends Cubit<GameState> {
  GameController() : super(GameState.initial());
  bishop.Game? game;
  bishop.Engine? engine;
  int humanPlayer = Squares.white;
  OpponentType opponentType = OpponentType.ai;
  bishop.Variant? get variant => game?.variant.data;
  bool get isXiangqi => game?.variant.data.name == 'Xiangqi';

  void emitState([bool thinking = false]) {
    if (game == null) emit(GameState.initial());
    BoardSize size = BoardSize(game!.size.h, game!.size.v);

    Move convertBishopMove(bishop.Move move) {
      String algebraic = game!.toAlgebraic(move);
      return size.moveFromAlgebraic(algebraic);
    }

    bool canMove =
        game!.turn == humanPlayer || opponentType == OpponentType.human;
    List<bishop.Move> _moves =
        canMove ? game!.generateLegalMoves() : game!.generatePremoves();
    List<Move> moves = [];
    for (bishop.Move move in _moves) {
      moves.add(convertBishopMove(move));
    }
    bishop.GameInfo gameInfo = game!.info;
    BoardState board = BoardState(
      board: game!.boardSymbols(),
      lastFrom: gameInfo.lastFrom != null
          ? size.squareNumber(gameInfo.lastFrom!)
          : null,
      lastTo:
          gameInfo.lastTo != null ? size.squareNumber(gameInfo.lastTo!) : null,
      checkSquare: gameInfo.checkSq != null
          ? size.squareNumber(gameInfo.checkSq!)
          : null,
      orientation: state.board.orientation,
      turn: game!.turn,
    );
    PlayState _state = game!.gameOver
        ? PlayState.finished
        : (canMove ? PlayState.ourTurn : PlayState.theirTurn);
    emit(
      GameState(
        state: _state,
        thinking: thinking,
        size: size,
        board: board,
        moves: moves,
        hands: game!.handSymbols,
        history: game!.history
            .where((x) => x.move != null)
            .map((m) => convertBishopMove(m.move!))
            .toList(),
      ),
    );
  }

  void startGame(
    bishop.Variant variant, {
    String? fen,
    int? humanPlayer,
    OpponentType? opponentType,
  }) {
    game = bishop.Game(variant: variant, fen: fen);
    engine = bishop.Engine(game: game!);
    if (humanPlayer != null) this.humanPlayer = humanPlayer;
    if (opponentType != null) this.opponentType = opponentType;
    emitState();
    if (humanPlayer == Squares.black) {
      flipBoard();
    }
    if (game!.turn != humanPlayer) {
      opponentMove();
    }
  }

  void makeMove(Move move) {
    if (game == null) return;
    String alg = state.size.moveToAlgebraic(move);
    bishop.Move? m = game!.getMove(alg);
    // print('makeMove $alg, ')
    if (m == null) {
      print('move $alg not found');
      print(
        game!.generateLegalMoves().map((e) => game!.toAlgebraic(e)).toList(),
      );
    } else {
      game!.makeMove(m);
      emitState();
      //Future.delayed(Duration(milliseconds: 200)).then((_) => engineMove());
      opponentMove();
    }
  }

  void randomMove() {
    if (game == null || game!.gameOver) return;
    game!.makeRandomMove();
    emitState();
  }

  void opponentMove() {
    if (opponentType == OpponentType.ai) {
      return engineMove();
    }
    if (opponentType == OpponentType.randomMover) {
      return randomMove();
    }
  }

  void engineMove() async {
    emitState(true);
    await Future.delayed(const Duration(milliseconds: 250));
    //bishop.EngineResult result = await engine!.search();
    bishop.EngineResult result = await compute(engineSearch, game!);
    if (result.hasMove) {
      // print('Best Move: ${formatResult(result)}');
      game!.makeMove(result.move!);
      emitState();
    }
  }

  void resign() {
    if (game == null) return;
    emit(state.copyWith(state: PlayState.finished));
  }

  String formatResult(bishop.EngineResult res) {
    if (game == null) return 'No Game';
    if (!res.hasMove) return 'No Move';
    String san = game!.toSan(res.move!);
    return '$san (${res.eval}) [depth ${res.depth}]';
  }

  void flipBoard() => emit(state.flipped());
}

Future<bishop.EngineResult> engineSearch(bishop.Game game) async {
  return await bishop.Engine(game: game)
      .search(timeLimit: 1000, timeBuffer: 500);
}

class GameState extends Equatable {
  final PlayState state;
  final BoardSize size;
  final BoardState board;
  final List<Move> moves;
  final List<List<String>> hands;
  final bool thinking;
  final List<Move> history;

  bool get canMove => state == PlayState.ourTurn;

  const GameState({
    required this.state,
    required this.size,
    required this.board,
    required this.moves,
    this.hands = const [[], []],
    this.thinking = false,
    this.history = const [],
  });
  factory GameState.initial() => GameState(
        state: PlayState.observing,
        size: BoardSize.standard,
        board: BoardState.empty(),
        moves: const [],
      );

  GameState copyWith({
    PlayState? state,
    BoardSize? size,
    BoardState? board,
    List<Move>? moves,
    List<List<String>>? hands,
    bool? thinking,
    int? orientation,
    List<Move>? history,
  }) {
    return GameState(
      state: state ?? this.state,
      size: size ?? this.size,
      board: board ?? this.board,
      moves: moves ?? this.moves,
      hands: hands ?? this.hands,
      thinking: thinking ?? this.thinking,
      history: history ?? this.history,
    );
  }

  GameState flipped() => copyWith(board: board.flipped());

  @override
  List<Object> get props => [state, size, board, moves, hands, thinking];
  @override
  bool get stringify => true;
}
