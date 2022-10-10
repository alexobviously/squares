import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

/// An overlay that builds rank and file labels.
class LabelOverlay extends StatelessWidget {
  /// Defines how and where labels are built.
  final LabelConfig config;

  /// Dimensions of the board.
  final BoardSize size;

  /// Determines which way around the board is facing.
  /// 0 (white) will place the white pieces at the bottom,
  /// and 1 will place the black pieces there.
  final int orientation;

  /// Colour scheme for the board.
  final BoardTheme theme;

  const LabelOverlay({
    super.key,
    this.config = LabelConfig.standard,
    this.size = BoardSize.standard,
    this.orientation = Squares.white,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return BoardBuilder(size: size, builder: _square);
  }

  Widget _square(int rank, int file, double squareSize) {
    Color textColour =
        ((rank + file) % 2 == 1) ? theme.lightSquare : theme.darkSquare;
    Widget? label;
    int targetRank =
        config.fileLabelPosition == FileLabelPosition.top ? 0 : size.maxRank;
    int targetFile =
        config.rankLabelPosition == RankLabelPosition.left ? 0 : size.maxFile;
    bool labelFile = rank == targetRank;
    bool labelRank = file == targetFile;
    bool labels = labelFile || labelRank;
    List<Alignment> alignments =
        _alignments(config.fileLabelPosition, config.rankLabelPosition);
    bool flipped = orientation == Squares.black;
    double labelSize = squareSize * config.labelScale;
    TextStyle ts = config.textStyle.copyWith(color: textColour);

    if (labels) {
      label = Stack(
        children: [
          if (labelFile)
            Align(
              alignment: alignments.first,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: SizedBox(
                  height: labelSize,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      config.fileLabeller(flipped ? size.h - file - 1 : file),
                      style: ts,
                    ),
                  ),
                ),
              ),
            ),
          if (labelRank)
            Align(
              alignment: alignments.last,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: SizedBox(
                  height: labelSize,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      config.rankLabeller(flipped ? rank : size.v - rank - 1),
                      style: ts,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    }
    return SizedBox(
      width: squareSize,
      height: squareSize,
      child: label,
    );
  }

  List<Alignment> _alignments(FileLabelPosition f, RankLabelPosition r) {
    if (f == FileLabelPosition.bottom) {
      if (r == RankLabelPosition.right) {
        return [Alignment.bottomLeft, Alignment.topRight];
      }
      return [Alignment.bottomRight, Alignment.topLeft];
    }
    if (r == RankLabelPosition.right) {
      return [Alignment.topLeft, Alignment.bottomRight];
    }
    return [Alignment.topRight, Alignment.bottomLeft];
  }
}
