import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

/// An overlay that displays the square numbers. Primarily for debugging.
class SquareNumberOverlay extends StatelessWidget {
  /// The orientation that the board is being viewed from.
  /// Required because this is a debugging tool and I want to help you :)
  final int orientation;

  /// Style of the number text.
  final TextStyle? textStyle;

  /// Whether to show the background circle.
  final bool showCircle;

  /// Colour of the background circle.
  final Color? circleColour;

  const SquareNumberOverlay({
    super.key,
    required this.orientation,
    this.textStyle,
    this.showCircle = true,
    this.circleColour,
  });

  @override
  Widget build(BuildContext context) {
    return BoardBuilder.index(
      builder: (i, size) => Padding(
        padding: EdgeInsets.all(size / 4),
        child: Container(
          decoration: showCircle
              ? BoxDecoration(
                  color:
                      circleColour ?? Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(size / 2),
                )
              : null,
          child: FittedBox(child: Center(child: Text('$i', style: textStyle))),
        ),
      ),
      orientation: orientation,
    );
  }
}
