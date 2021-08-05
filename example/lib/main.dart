import 'package:flutter/material.dart';

import 'package:bishop/bishop.dart' as bishop;
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
  bishop.Game game = bishop.Game(variant: bishop.Variant.standard());
  @override
  Widget build(BuildContext context) {
    BoardSize size = BoardSize(game.size.h, game.size.v);
    List<bishop.Move> legalMoves = game.generateLegalMoves();
    print(legalMoves.map((e) => game.toAlgebraic(e)).toList());
    Map<int, List<int>> moves = {};
    for (bishop.Move move in legalMoves) {
      String algebraic = game.toAlgebraic(move);
      Move _move = moveFromAlgebraic(algebraic, size);
      if (moves.containsKey(_move.from))
        moves[_move.from]!.add(_move.to);
      else
        moves[_move.from] = [_move.to];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Squares'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: BoardController(
                  state: BoardState(board: game.boardSymbols()),
                  pieceSet: PieceSet.merida(),
                  size: size,
                  onMove: (m) => print(m),
                  moves: moves,
                  // selectedFrom: 16,
                  // checkSquare: 4,
                  // gameOver: true,
                ),
              ),
            ]),
      ),
    );
  }
}

Move moveFromAlgebraic(String alg, BoardSize size) {
  int from = size.squareNumber(alg.substring(0, 2));
  int to = size.squareNumber(alg.substring(2, 4));
  return Move(from: from, to: to);
}
