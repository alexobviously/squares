import 'package:bloc/bloc.dart';
import 'package:squares_complex/game_config.dart';
import 'package:squares_complex/game_controller.dart';
import 'package:squares_complex/svg_piece_set.dart';
import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class GameManager extends Cubit<GameManagerState> {
  GameManager() : super(GameManagerState.initial());

  static PieceSet emojiPieceSet = PieceSet.text(
    strings: {
      //
      'P': '😂', 'p': '😢', 'N': '💯', 'n': '🐴',
      'B': '🍆', 'b': '🙏', 'R': '🏰', 'r': '🏯',
      'Q': '🍑', 'q': '👸', 'K': '👑', 'k': '🤴',
      'C': '☁️', 'c': '🐓', 'A': '🌪', 'a': '🐈',
    },
  );

  int pieceSetIndex = 0;
  List<PieceSet> pieceSets = [
    PieceSet.merida(),
    PieceSet.letters(style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
    emojiPieceSet,
    svgPieceSet(folder: 'assets/kaneo/', symbols: PieceSet.extendedSymbols),
  ];
  int themeIndex = 0;
  List<BoardTheme> themes = [
    BoardTheme.brown,
    BoardTheme.blueGrey,
    BoardTheme.pink,
    BoardTheme.dart,
  ];
  int highlightThemeIndex = 0;
  List<MarkerTheme> highlightThemes = [
    MarkerTheme.basic,
    MarkerTheme.square,
  ];

  void createGame(GameConfig config) {
    GameController gc = GameController();
    gc.startGame(config.variant, humanPlayer: config.humanPlayer, fen: config.fen);
    List<GameController> _games = List.from(state.games);
    _games.add(gc);
    emit(state.copyWith(games: _games));
  }

  void removeGame(int index) {
    print('removegame $index ${state.games.length}');
    if (index >= 0 && index < state.games.length) {
      List<GameController> _games = List.from(state.games);
      _games.removeAt(index);
      emit(state.copyWith(games: _games));
    }
  }

  void changePieceSet(int? index) {
    if (index == null) return;
    pieceSetIndex = index;
    emit(state.copyWith(pieceSet: pieceSets[index], pieceSetIndex: pieceSetIndex));
  }

  void changeTheme(int? index) {
    if (index == null) return;
    themeIndex = index;
    emit(state.copyWith(theme: themes[index]));
  }

  void nextTheme() => changeTheme((themeIndex + 1) % themes.length);

  void changeHighlightTheme(int? index) {
    if (index == null) return;
    highlightThemeIndex = index;
    emit(state.copyWith(highlightTheme: highlightThemes[index]));
  }

  void nextHighlightTheme() =>
      changeHighlightTheme((highlightThemeIndex + 1) % highlightThemes.length);
}

class GameManagerState {
  final List<GameController> games;
  final int pieceSetIndex;
  final PieceSet pieceSet;
  final BoardTheme theme;
  final MarkerTheme highlightTheme;
  GameManagerState({
    required this.games,
    required this.pieceSetIndex,
    required this.pieceSet,
    required this.theme,
    required this.highlightTheme,
  });
  factory GameManagerState.initial() => GameManagerState(
        games: [],
        pieceSetIndex: 0,
        pieceSet: PieceSet.merida(),
        theme: BoardTheme.brown,
        highlightTheme: MarkerTheme.basic,
      );

  GameManagerState copyWith({
    List<GameController>? games,
    int? pieceSetIndex,
    PieceSet? pieceSet,
    BoardTheme? theme,
    MarkerTheme? highlightTheme,
  }) =>
      GameManagerState(
        games: games ?? this.games,
        pieceSetIndex: pieceSetIndex ?? this.pieceSetIndex,
        pieceSet: pieceSet ?? this.pieceSet,
        theme: theme ?? this.theme,
        highlightTheme: highlightTheme ?? this.highlightTheme,
      );
}
