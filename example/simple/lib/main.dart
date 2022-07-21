import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:squares/squares.dart';
import 'package:square_bishop/square_bishop.dart' hide PlayState;
import 'package:square_bishop/square_bishop.dart' as sb show PlayState;

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
  int player = Squares.white;
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
    bool result = game.makeSquaresMove(move);
    if (result) {
      setState(() => state = game.squaresState(player));
    }
    if (state.state == sb.PlayState.playing && !aiThinking && !state.canMove(player)) {
      setState(() => aiThinking = true);
      await Future.delayed(Duration(milliseconds: Random().nextInt(4750) + 250));
      game.makeRandomMove();
      setState(() {
        aiThinking = false;
        state = game.squaresState(player);
      });
    }
  }

  // TODO: remove this on square_bishop upgrade
  PlayState getPlayState(sb.PlayState sbp, bool canMove) {
    if (sbp == sb.PlayState.idle) return PlayState.observing;
    if (sbp == sb.PlayState.finished) return PlayState.finished;
    if (canMove) return PlayState.ourTurn;
    return PlayState.theirTurn;
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
              // child: OldBoardController(
              //   pieceSet: PieceSet.merida(),
              //   state: state.board,
              //   theme: BoardTheme.blueGrey,
              //   canMove: state.canMove(player),
              //   moves: state.moves,
              //   onMove: _onMove,
              //   onPremove: _onMove,
              // ),
              child: BoardController(
                state: state.board,
                playState: getPlayState(state.state, state.canMove(player)),
                pieceSet: PieceSet.merida(),
                theme: BoardTheme.brown,
                moves: state.moves,
                onMove: _onMove,
                onPremove: _onMove,
              ),
              // child: Board(
              //   pieceSet: PieceSet.merida(),
              //   state: state.board,
              //   size: state.size,
              //   theme: BoardTheme.blueGrey,
              //   playState: getPlayState(state.state, state.canMove(player)),
              //   onTap: print,
              // ),
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
