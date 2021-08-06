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
    PieceSet pieceSet = PieceSet.merida();
    List<Widget> promos = [];
    for (String symbol in ['Q', 'R', 'B', 'N']) {
      Widget? piece = symbol.isNotEmpty ? pieceSet.piece(context, symbol) : null;
      if (piece != null) promos.add(piece);
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
            // Row(
            //   children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: BlocBuilder<GameController, GameState>(
                bloc: gc,
                builder: (context, state) {
                  print(state);
                  return BoardController(
                    state: state.board,
                    pieceSet: pieceSet,
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
            // Container(
            //   height: 400,
            //   width: 100,
            //   child: PromoSelector(pieces: promos),
            // ),
            //   ],
            // ),
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
                ElevatedButton.icon(
                  onPressed: () => startGame(bishop.Variant.mini(), fen: '4k/P4/5/5/4K w Qq - 0 1'),
                  icon: Icon(Icons.upgrade),
                  label: Text('Promo test'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void startGame(bishop.Variant variant, {String? fen}) {
    gc.startGame(variant, fen: fen);
  }
}

Move moveFromAlgebraic(String alg, BoardSize size) {
  int from = size.squareNumber(alg.substring(0, 2));
  int to = size.squareNumber(alg.substring(2, 4));
  return Move(from: from, to: to);
}
