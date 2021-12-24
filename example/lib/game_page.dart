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

  void flipBoard() => widget.game.flipBoard();

  void _onMove(Move move) {
    widget.game.makeMove(move);
    premove = null;
  }

  void _onPremove(Move move) {
    premove = move;
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
                  onPremove: _onPremove,
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
              IconButton(
                icon: Icon(MdiIcons.rotate3DVariant),
                onPressed: flipBoard,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
