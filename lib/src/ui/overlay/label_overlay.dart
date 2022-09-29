import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class LabelOverlay extends StatelessWidget {
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
    int square = size.square(rank, file, orientation);
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

    if (labels) {
      label = Stack(
        children: [
          if (labelFile)
            Align(
              alignment: alignments.first,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: SizedBox(
                  // width: labelSize,
                  height: labelSize,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Container(
                      // color: Colors.deepOrange.withOpacity(0.5),
                      child: Text(
                        config.fileLabeller(flipped ? size.h - file - 1 : file),
                        // textHeightBehavior: TextHeightBehavior(
                        //   // applyHeightToFirstAscent: false,
                        //   applyHeightToLastDescent: false,
                        // ),
                        style: TextStyle(
                          color: textColour,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                          // height: alignments.first.y == 1.0 ? 0.7 : 1.1,
                        ),
                      ),
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
                  // width: labelSize,
                  height: labelSize,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      config.rankLabeller(flipped ? rank : size.v - rank - 1),
                      // textHeightBehavior: TextHeightBehavior(
                      //   // applyHeightToFirstAscent: false,
                      //   applyHeightToLastDescent: false,
                      // ),
                      style: TextStyle(
                        color: textColour,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                        // height: 0.7,
                      ),
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
