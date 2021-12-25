import 'package:example/game_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:squares/squares.dart';

class GamePage extends StatefulWidget {
  final GameController game;
  final PieceSet pieceSet;
  final BoardTheme theme;
  GamePage({
    Key? key,
    required this.game,
    required this.pieceSet,
    required this.theme,
  }) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Move? premove;

  void _flipBoard() => widget.game.flipBoard();
  void _resign() => widget.game.resign();

  void _onMove(Move move) {
    widget.game.makeMove(move);
  }

  void randomMove() {
    widget.game.randomMove();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // if (variant.hands) _hand(gc, BLACK),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: BlocBuilder<GameController, GameState>(
              bloc: widget.game,
              builder: (context, state) {
                return BoardController(
                  state: state.board,
                  pieceSet: widget.pieceSet,
                  theme: widget.theme,
                  size: state.size,
                  onMove: _onMove,
                  onPremove: _onMove,
                  moves: state.moves,
                  canMove: state.canMove,
                  draggable: true,
                );
              },
            ),
          ),
          // if (variant.hands) _hand(gc, WHITE),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                label: Text('Flip Board'),
                icon: Icon(MdiIcons.rotate3DVariant),
                onPressed: _flipBoard,
              ),
              TextButton.icon(
                label: Text('Resign'),
                icon: Icon(MdiIcons.flag),
                onPressed: _resign,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
