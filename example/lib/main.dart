import 'package:example/game_controller.dart';
import 'package:flutter/material.dart';

import 'package:bishop/bishop.dart' as bishop;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squares/board_state.dart';
import 'package:squares/squares.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Squares Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.cyan,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bishop.Game game = bishop.Game(variant: bishop.Variant.mini());
  GameController gc = GameController();

  void onMove(Move move) {
    gc.makeMove(move);
    // BoardSize size = BoardSize(game.size.h, game.size.v);
    // String from = size.squareName(move.from);
    // String to = size.squareName(move.to);
    // String alg = '$from$to';
    // print('onMove $alg');
    // bishop.Move? m = game.getMove(alg);
    // if (m == null)
    //   print('move $alg not found');
    // else {
    //   game.makeMove(m);
    //   setState(() {});
    //   Future.delayed(Duration(seconds: 3)).then((_) => randomMove());
    // }
  }

  void randomMove() {
    gc.randomMove();
    // if (game.gameOver) return;
    // game.makeRandomMove();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool canMove = game.turn == 0;
    BoardSize size = BoardSize(game.size.h, game.size.v);
    List<bishop.Move> legalMoves = game.generateLegalMoves();
    print(legalMoves.map((e) => game.toAlgebraic(e)).toList());
    Map<int, List<int>> moves = {};
    if (canMove) {
      for (bishop.Move move in legalMoves) {
        String algebraic = game.toAlgebraic(move);
        Move _move = moveFromAlgebraic(algebraic, size);
        if (moves.containsKey(_move.from))
          moves[_move.from]!.add(_move.to);
        else
          moves[_move.from] = [_move.to];
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Squares'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: BlocBuilder<GameController, GameState>(
                bloc: gc,
                builder: (context, state) {
                  print(state);
                  return BoardController(
                    state: state.board,
                    pieceSet: PieceSet.merida(),
                    size: state.size,
                    onMove: onMove,
                    moves: state.moves,
                    canMove: state.canMove,
                    // selectedFrom: 16,
                    // checkSquare: 4,
                    // gameOver: true,
                  );
                },
              ),
            ),
            Container(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => startGame(bishop.Variant.standard()),
                  icon: Icon(Icons.star_rate),
                  label: Text('Standard'),
                ),
                ElevatedButton.icon(
                  onPressed: () => startGame(bishop.Variant.mini()),
                  icon: Icon(Icons.minimize),
                  label: Text('Mini'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void startGame(bishop.Variant variant) {
    gc.startGame(variant);
  }
}

Move moveFromAlgebraic(String alg, BoardSize size) {
  int from = size.squareNumber(alg.substring(0, 2));
  int to = size.squareNumber(alg.substring(2, 4));
  return Move(from: from, to: to);
}
