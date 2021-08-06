import 'package:example/game_controller.dart';
import 'package:flutter/material.dart';

import 'package:bishop/bishop.dart' as bishop;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  }

  void randomMove() {
    gc.randomMove();
  }

  @override
  Widget build(BuildContext context) {
    PieceSet pieceSet = PieceSet.merida();
    return Scaffold(
      appBar: AppBar(
        title: Text('Squares'),
        actions: [
          BlocBuilder<GameController, GameState>(
            bloc: gc,
            builder: (context, state) {
              return Container(
                width: 32,
                height: 32,
                child: state.thinking ? SpinKitFadingCircle(size: 28, color: Colors.white) : Icon(Icons.check),
              );
            },
          ),
        ],
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
                    theme: BROWN_THEME,
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
                  icon: Icon(MdiIcons.chessKing),
                  label: Text('Standard'),
                ),
                ElevatedButton.icon(
                  onPressed: () => startGame(bishop.Variant.mini()),
                  icon: Icon(MdiIcons.sizeXs),
                  label: Text('Mini'),
                ),
                ElevatedButton.icon(
                  onPressed: () => startGame(bishop.Variant.micro()),
                  icon: Icon(MdiIcons.sizeXxs),
                  label: Text('Micro'),
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
