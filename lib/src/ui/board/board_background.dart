part of 'board.dart';

/// The background layer of a board. Contains coloured boxes, potentially with markers.
class BoardBackground extends StatelessWidget {
  /// Configuration for the background. Determines which squares to draw, and
  /// allows an opacity for squares to be defined.
  final BackgroundConfig config;

  /// Dimensions of the board.
  final BoardSize size;

  /// Determines which way around the board is facing.
  /// 0 (white) will place the white pieces at the bottom,
  /// and 1 will place the black pieces there.
  final int orientation;

  /// Colour scheme for the board.
  final BoardTheme theme;

  /// Squares that should be highlighted (i.e. have their background colour set).
  /// The key is the square index.
  final Map<int, HighlightType> highlights;

  /// Squares that should be marked. The key is the square index.
  final Map<int, Marker> markers;

  /// Widget builders for the various types of square highlights used.
  late final MarkerTheme markerTheme;

  BoardBackground({
    super.key,
    this.config = BackgroundConfig.standard,
    this.size = BoardSize.standard,
    this.orientation = Squares.white,
    this.theme = BoardTheme.brown,
    this.highlights = const {},
    this.markers = const {},
    MarkerTheme? markerTheme,
  }) : markerTheme = markerTheme ?? MarkerTheme.basic;

  @override
  Widget build(BuildContext context) {
    return BoardBuilder(
      size: size,
      builder: (rank, file, squareSize) =>
          _square(context, rank, file, squareSize),
    );
  }

  Widget _square(BuildContext context, int rank, int file, double squareSize) {
    int id = size.square(rank, file, orientation);

    Color squareColour = config.drawNormalSquares
        ? (((rank + file) % 2 == 0) ? theme.lightSquare : theme.darkSquare)
        : Colors.transparent;
    if (config.drawHighlightedSquares && highlights.containsKey(id)) {
      squareColour = Color.alphaBlend(
        theme.highlight(highlights[id]!),
        squareColour,
      );
    }
    if (config.opacity != null &&
        (squareColour.opacity >= 1.0 || config.modifyTranslucentOpacity)) {
      squareColour =
          squareColour.withOpacity(squareColour.opacity * config.opacity!);
    }

    Widget? marker;
    if (config.drawMarkers && markers.containsKey(id)) {
      final m = markers[id]!;
      marker = m.hasPiece
          ? markerTheme.piece(context, squareSize, theme.highlight(m.colour))
          : markerTheme.empty(context, squareSize, theme.highlight(m.colour));
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      decoration: config.squareDecoration.copyWith(color: squareColour),
      width: squareSize,
      height: squareSize,
      child: marker,
    );
  }
}
