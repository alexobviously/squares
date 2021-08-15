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
  bishop.Variant variant = bishop.Variant.standard();
  BoardTheme theme = BOARD_THEME_BROWN;
  static PieceSet emojiPieceSet = PieceSet.text(
    strings: {
      //
      'P': '😂', 'p': '😢', 'N': '💯', 'n': '🐴',
      'B': '🍆', 'b': '🙏', 'R': '🏰', 'r': '🏯',
      'Q': '🍑', 'q': '👸', 'K': '👑', 'k': '🤴',
      'C': '☁️', 'c': '🐓', 'A': '🌪', 'a': '🐈',
    },
  );

  bishop.Game game = bishop.Game(variant: bishop.Variant.mini());
  GameController gc = GameController();
  int boardOrientation = WHITE;
  PieceSet pieceSet = PieceSet.merida();
  int pieceSetIndex = 0;
  List<PieceSet> pieceSets = [
    PieceSet.merida(),
    PieceSet.letters(),
    emojiPieceSet,
  ];
  Move? premove;

  void onMove(Move move) {
    gc.makeMove(move);
    premove = null;
  }

  void onPremove(Move move) {
    premove = move;
  }

  void randomMove() {
    gc.randomMove();
  }

  void flipBoard() {
    setState(() {
      boardOrientation = 1 - boardOrientation;
    });
  }

  void onChangePieceSet(int? index) {
    if (index == null) return;
    setState(() {
      pieceSetIndex = index;
      pieceSet = pieceSets[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Squares'),
        actions: [
          DropdownButton<int>(
            value: pieceSetIndex,
            items: [
              DropdownMenuItem(
                child: Text('Merida'),
                value: 0,
              ),
              DropdownMenuItem(
                child: Text('Letters'),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text('Emojis'),
                value: 2,
              ),
            ],
            onChanged: onChangePieceSet,
          ),
          BlocBuilder<GameController, GameState>(
            bloc: gc,
            builder: (context, state) {
              if (state.canMove && premove != null) onMove(premove!);
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
            if (variant.hands) _hand(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: BlocBuilder<GameController, GameState>(
                bloc: gc,
                builder: (context, state) {
                  return BoardController(
                    state: state.board.copyWith(orientation: boardOrientation),
                    pieceSet: pieceSet,
                    theme: theme,
                    size: state.size,
                    onMove: onMove,
                    onPremove: onPremove,
                    moves: state.moves,
                    canMove: state.canMove,
                  );
                },
              ),
            ),
            if (variant.hands) _hand(),
            Container(height: 100),
            Wrap(
              children: [
                ElevatedButton.icon(
                  onPressed: () => startGame(bishop.Variant.standard()),
                  icon: Icon(MdiIcons.chessKing),
                  label: Text('Standard'),
                ),
                ElevatedButton.icon(
                  onPressed: () => startGame(bishop.Variant.mini(), fen: 'k4/4P/5/5/K4 w - - 0 1'),
                  icon: Icon(MdiIcons.sizeXs),
                  label: Text('Mini'),
                ),
                ElevatedButton.icon(
                  onPressed: () => startGame(bishop.Variant.micro()),
                  icon: Icon(MdiIcons.sizeXxs),
                  label: Text('Micro'),
                ),
                ElevatedButton.icon(
                  onPressed: () => startGame(bishop.Variant.grand()),
                  icon: Icon(MdiIcons.sizeXl),
                  label: Text('Grand'),
                ),
                ElevatedButton.icon(
                  onPressed: () => startGame(bishop.Variant.crazyhouse()),
                  icon: Icon(MdiIcons.sizeXl),
                  label: Text('Crazyhouse'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(MdiIcons.rotate3DVariant),
                  onPressed: flipBoard,
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
    setState(() {
      this.variant = variant;
    });
  }

  Widget _hand() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        color: theme.lightSquare,
        child: Hand(
          theme: theme,
          pieceSet: pieceSet,
          pieces: ['Q', 'Q', 'N'],
          fixedPieces: ['Q', 'R', 'B', 'N', 'P'],
          squareSize: 50,
        ),
      ),
    );
  }
}

Move moveFromAlgebraic(String alg, BoardSize size) {
  int from = size.squareNumber(alg.substring(0, 2));
  int to = size.squareNumber(alg.substring(2, 4));
  return Move(from: from, to: to);
}
