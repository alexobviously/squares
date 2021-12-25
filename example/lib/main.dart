import 'package:example/game_controller.dart';
import 'package:example/game_manager.dart';
import 'package:example/home_view.dart';
import 'package:flutter/material.dart';

import 'package:bishop/bishop.dart' as bishop;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squares/squares.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GameManager>(
          create: (ctx) => GameManager(),
        ),
      ],
      child: MaterialApp(
        title: 'Squares Demo',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.cyan,
        ),
        home: HomeView(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bishop.Variant variant = bishop.Variant.standard();
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
  int themeIndex = 0;
  BoardTheme theme = BoardTheme.BROWN;
  List<BoardTheme> themes = [
    BoardTheme.BROWN,
    BoardTheme.BLUEGREY,
    BoardTheme.PINK,
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

  void onChangeTheme(int? index) {
    if (index == null) return;
    setState(() {
      themeIndex = index;
      theme = themes[index];
    });
  }

  void nextTheme() => onChangeTheme((themeIndex + 1) % themes.length);

  @override
  Widget build(BuildContext context) {
    return HomeView();
  }

  void startGame(bishop.Variant variant, {String? fen}) {
    gc.startGame(variant, fen: fen);
    setState(() {
      this.variant = variant;
    });
  }

  Widget _hand(GameController gc, int player) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        color: theme.lightSquare,
        child: BlocBuilder<GameController, GameState>(
          bloc: gc,
          builder: (_context, state) {
            return Hand(
              theme: theme,
              pieceSet: pieceSet,
              pieces: state.hands[player],
              fixedPieces: ['Q', 'R', 'B', 'N', 'P'].map((x) => player == WHITE ? x : x.toLowerCase()).toList(),
              squareSize: 50,
              badgeColour: Colors.blue,
            );
          },
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
