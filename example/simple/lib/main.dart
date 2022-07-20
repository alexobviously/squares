import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:squares/squares.dart';
import 'package:square_bishop/square_bishop.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Squares Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bishop.Game game;
  late SquaresState state;
  int player = WHITE;
  bool aiThinking = false;

  @override
  void initState() {
    _resetGame(false);
    super.initState();
  }

  void _resetGame([bool ss = true]) {
    game = bishop.Game(variant: bishop.Variant.standard());
    state = game.squaresState(player);
    if (ss) setState(() {});
  }

  void _onMove(Move move) async {
    print('_onMove $move');
    bool result = game.makeSquaresMove(move);
    if (result) {
      setState(() => state = game.squaresState(player));
    }
    if (state.state == PlayState.playing && !aiThinking) {
      setState(() => aiThinking = true);
      await Future.delayed(Duration(milliseconds: Random().nextInt(4750) + 250));
      game.makeRandomMove();
      setState(() {
        aiThinking = false;
        state = game.squaresState(player);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Squares Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              // child: BoardController(
              //   pieceSet: PieceSet.merida(),
              //   state: state.board,
              //   theme: BoardTheme.BLUEGREY,
              //   canMove: state.canMove(player),
              //   moves: state.moves,
              //   onMove: _onMove,
              //   onPremove: _onMove,
              // ),
              child: Board(
                pieceSet: PieceSet.merida(),
                state: state.board,
                size: state.size,
                theme: BoardTheme.BLUEGREY,
                canMove: state.canMove(player),
                onTap: print,
              ),
              // child: BoardBackground(
              //   size: state.size,
              //   theme: BoardTheme.BLUEGREY,
              //   orientation: BLACK,
              //   highlights: {4: HighlightType.check, 16: HighlightType.previous},
              //   markers: {
              //     22: Marker.empty(HighlightType.premove),
              //     41: Marker.piece(HighlightType.premove),
              //     42: Marker.piece(HighlightType.selected),
              //   },
              // ),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: _resetGame,
              child: const Text('New Game'),
            ),
          ],
        ),
      ),
    );
  }
}
