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
                child: BoardWrapper(
                  state: BoardState(board: game.boardSymbols()),
                  pieceSet: PieceSet.merida(),
                  files: game.size.h,
                  ranks: game.size.v,
                  onMove: (m) => print(m),
                  moves: {
                    57: [40, 42]
                  },
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
