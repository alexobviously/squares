import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bishop/bishop.dart' as bp;
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';
import 'package:squares_complex/app_bar.dart';
import 'package:squares_complex/game_manager.dart';

class BoardEditorView extends StatefulWidget {
  final bp.Variant variant;
  final String? initialFen;

  const BoardEditorView({
    super.key,
    required this.variant,
    this.initialFen,
  });

  @override
  State<BoardEditorView> createState() => _BoardEditorViewState();
}

class _BoardEditorViewState extends State<BoardEditorView> {
  BoardSize get size => widget.variant.boardSize.toSquares();
  List<String> get pieceTypes => widget.variant.pieceTypes.keys.toList();
  late BoardState state;
  bool handDrag = false;

  @override
  void initState() {
    final sq = buildSquaresState(variant: widget.variant, fen: widget.initialFen)!;
    state = sq.board;
    super.initState();
  }

  void _acceptDrag(PartialMove move, int to) {
    Map<int, String> updates = {
      if (size.isOnBoard(move.from)) move.from: '',
      if (size.isOnBoard(to)) to: move.piece,
    };
    final newState = state.updateSquares(updates);
    setState(() => state = newState);
  }

  void _enableHandDrag() => setState(() => handDrag = true);
  void _disableHandDrag() => setState(() => handDrag = false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SafeArea(
        child: BlocBuilder<GameManager, GameManagerState>(
          builder: (context, gm) {
            return Column(
              children: [
                Board(
                  state: state,
                  size: size,
                  pieceSet: gm.pieceSet,
                  theme: gm.theme,
                  markerTheme: gm.markerTheme,
                  validateDrag: (_, __) => true,
                  acceptDrag: _acceptDrag,
                  externalDrag: handDrag,
                ),
                Text(state.fen()),
                Text(pieceTypes.join(', ')),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DragTarget<PartialMove>(
                    builder: (context, _, __) => Container(
                      color: gm.theme.previous,
                      height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete),
                            Text(
                              'drag pieces here to remove them',
                              style: const TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onAccept: (move) => _acceptDrag(move, Squares.invalid),
                  ),
                ),
                _hand(Squares.white, gm),
                _hand(Squares.black, gm),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop<String?>(state.fen());
                  },
                  child: Text('Use'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _hand(int player, GameManagerState gm) {
    final pieces = widget.variant.pieceSymbols.reversed
        .map((x) => player == Squares.white ? x : x.toLowerCase())
        .toList();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        color: gm.theme.lightSquare,
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            double squareSize = width / size.h;
            return Hand(
              theme: gm.theme,
              pieceSet: gm.pieceSet,
              pieces: pieces,
              fixedPieces: pieces,
              squareSize: squareSize,
              showCounts: false,
              mainAxisAlignment: MainAxisAlignment.center,
              onDragStarted: (_) => _enableHandDrag(),
              onDragCancelled: (_) => _disableHandDrag(),
              onDragEnd: (_, __) => _disableHandDrag(),
            );
          },
        ),
      ),
    );
  }
}
