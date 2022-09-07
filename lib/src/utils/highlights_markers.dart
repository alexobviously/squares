import 'package:squares/squares.dart';

Map<int, Marker> generateMarkers({
  HighlightType colour = HighlightType.selected,
  required BoardState state,
  required List<int> squares,
}) {
  return Map<int, Marker>.fromEntries(
    squares.map(
      (e) => MapEntry<int, Marker>(
        e,
        Marker(
          colour: colour,
          hasPiece: state.board[e].isNotEmpty,
        ),
      ),
    ),
  );
}

Map<int, HighlightType> generateHighlights({
  int? selection,
  int? target,
  required BoardState state,
  PlayState playState = PlayState.observing,
}) {
  HighlightType selectionColour = playState != PlayState.theirTurn
      ? HighlightType.selected
      : HighlightType.premove;
  Map<int, HighlightType> highlights = {
    if (selection != null) selection: selectionColour,
    if (target != null) target: selectionColour,
    if (state.checkSquare != null &&
        state.checkSquare != selection &&
        state.checkSquare != target)
      state.checkSquare!: playState == PlayState.finished
          ? HighlightType.checkmate
          : HighlightType.check,
    if (state.lastFrom != null &&
        state.lastFrom != selection &&
        state.lastFrom != target)
      state.lastFrom!: HighlightType.previous,
    if (state.lastTo != null &&
        state.lastTo != selection &&
        state.lastTo != target)
      state.lastTo!: HighlightType.previous,
  };
  return highlights;
}
