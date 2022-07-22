part of 'board.dart';

/// A function to build a widget from [rank], [file] and [squareSize].
typedef SquareBuilder = Widget Function(int rank, int file, double squareSize);

///  Builds a grid of widgets of [size], according to [builder].
class BoardBuilder extends StatelessWidget {
  /// A function to build a widget from [rank], [file] and [squareSize].
  final SquareBuilder builder;

  /// The size of the board.
  final BoardSize size;

  const BoardBuilder({
    super.key,
    required this.builder,
    this.size = BoardSize.standard,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: size.aspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double squareSize = constraints.maxWidth / size.h;
          return Column(
            children: List.generate(
              size.v,
              (rank) => Expanded(
                child: Row(
                  children: List.generate(
                    size.h,
                    (file) => builder(rank, file, squareSize),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
