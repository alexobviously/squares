import 'package:flutter/material.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:squares/squares.dart';

void main() {
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
  late BoardState boardState;

  void _resetGame() {
    game = bishop.Game(variant: bishop.Variant.standard());
    //
  }

  void _onMove(Move move) {}

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
            BoardController(
              pieceSet: PieceSet.merida(),
              state: boardState,
              theme: BoardTheme.BROWN,
              canMove: false,
              onMove: _onMove,
            ),
          ],
        ),
      ),
    );
  }
}
