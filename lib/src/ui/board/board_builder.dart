part of 'board.dart';

typedef BoardBuilderFunction = Widget Function(int rank, int file, double squareSize);

class BoardBuilder extends StatelessWidget {
  final BoardBuilderFunction builder;
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
