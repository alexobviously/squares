import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final sq =
        buildSquaresState(variant: widget.variant, fen: widget.initialFen)!;
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

  void _clearBoard() => setState(() => state = state.clearBoard(size));

  void _copyFen() async {
    await Clipboard.setData(ClipboardData(text: state.fen(size)));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('FEN copied')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: SafeArea(
        child: BlocBuilder<GameManager, GameManagerState>(
          builder: (context, gm) {
            return Column(
              children: [
                Expanded(
                  child: Board(
                    state: state,
                    size: size,
                    pieceSet: gm.pieceSet,
                    theme: gm.theme,
                    markerTheme: gm.markerTheme,
                    validateDrag: (_, __) => true,
                    acceptDrag: _acceptDrag,
                    externalDrag: handDrag,
                  ),
                ),
                GestureDetector(
                  onTap: _copyFen,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                    color: gm.theme.lightSquare,
                    child: Center(
                      child: Text(
                        state.fen(size),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DragTarget<PartialMove>(
                    builder: (context, _, __) => GestureDetector(
                      onLongPress: _clearBoard,
                      child: Container(
                        color: gm.theme.previous,
                        height: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: const FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete),
                              Text(
                                'drag pieces here to remove them',
                                style: TextStyle(
                                  fontSize: 20,
                                  // fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
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
                    Navigator.of(context).pop<String?>(state.fen(size));
                  },
                  child: const Text('Use'),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        color: gm.theme.lightSquare,
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            double squareSize = width / pieces.length;
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
