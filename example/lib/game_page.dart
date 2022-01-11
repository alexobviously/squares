import 'package:example/game_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:squares/squares.dart';

class GamePage extends StatefulWidget {
  final GameController game;
  final PieceSet pieceSet;
  final BoardTheme theme;
  final HighlightTheme? highlightTheme;
  GamePage({
    Key? key,
    required this.game,
    required this.pieceSet,
    required this.theme,
    this.highlightTheme,
  }) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
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
    final _variant = widget.game.variant;
    bool _hands = _variant?.hands ?? false;
    return BlocBuilder<GameController, GameState>(
      bloc: widget.game,
      builder: (context, state) {
        int _orientation = state.board.orientation;
        return Container(
          // width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_hands) _hand(1 - _orientation),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: BoardController(
                  state: state.board,
                  pieceSet: widget.pieceSet,
                  theme: widget.theme,
                  size: state.size,
                  highlightTheme: widget.highlightTheme,
                  onMove: _onMove,
                  onPremove: _onMove,
                  moves: state.moves,
                  canMove: state.canMove,
                  draggable: true,
                  dragFeedbackSize: kIsWeb ? 1.5 : 2.0,
                  dragFeedbackOffset: kIsWeb ? Offset(0.0, 0.0) : Offset(0.0, -1.0),
                ),
              ),
              if (_hands) _hand(_orientation),
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
      },
    );
  }

  Widget _hand(int player) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        color: widget.theme.lightSquare,
        child: BlocBuilder<GameController, GameState>(
          bloc: widget.game,
          builder: (_context, state) {
            return Hand(
              theme: widget.theme,
              pieceSet: widget.pieceSet,
              pieces: state.hands[player],
              fixedPieces: STANDARD_PIECES.map((x) => player == WHITE ? x : x.toLowerCase()).toList(),
              squareSize: 37,
              badgeColour: Colors.blue,
            );
          },
        ),
      ),
    );
  }
}
