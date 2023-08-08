import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

/// Defines a builder function for a widget that will be displayed when a piece
/// is dragged over a square.
abstract class DragTargetFeedback {
  const DragTargetFeedback();

  Widget? build({
    required BuildContext context,
    required int id,
    required double squareSize,
    required List<PartialMove?> accepted,
    required List<dynamic> rejected,
  });
}

/// Build your own feedback!
class CustomDragTargetFeedback implements DragTargetFeedback {
  final Widget Function({
    required BuildContext context,
    required int id,
    required double squareSize,
    required List<PartialMove?> accepted,
    required List<dynamic> rejected,
  }) builder;

  const CustomDragTargetFeedback({
    required this.builder,
  });

  @override
  Widget? build({
    required BuildContext context,
    required int id,
    required double squareSize,
    required List<PartialMove?> accepted,
    required List<dynamic> rejected,
  }) {
    return builder(
      context: context,
      id: id,
      squareSize: squareSize,
      accepted: accepted,
      rejected: rejected,
    );
  }
}

/// Displays single widgets depending on whether a drag is valid or not.
class SimpleDragTargetFeedback implements DragTargetFeedback {
  final Widget? none;
  final Widget? valid;
  final Widget? invalid;

  const SimpleDragTargetFeedback({
    this.none,
    this.valid,
    this.invalid,
  });

  @override
  Widget? build({
    required BuildContext context,
    required int id,
    required double squareSize,
    required List<PartialMove?> accepted,
    required List<dynamic> rejected,
  }) {
    return switch ((accepted.isNotEmpty, rejected.isNotEmpty)) {
      (true, false) => valid,
      (false, true) => invalid,
      _ => none,
    };
  }
}

/// Displays simple containers with colours depending on whether a drag is
/// valid or not.
class ColourDragTargetFeedback extends SimpleDragTargetFeedback {
  ColourDragTargetFeedback({
    Color? none,
    Color? valid,
    Color? invalid,
    BoxShape shape = BoxShape.rectangle,
    EdgeInsetsGeometry? margin,
  }) : super(
          none: none == null
              ? null
              : Container(
                  margin: margin,
                  decoration: BoxDecoration(color: none, shape: shape),
                ),
          valid: valid == null
              ? null
              : Container(
                  margin: margin,
                  decoration: BoxDecoration(color: valid, shape: shape),
                ),
          invalid: invalid == null
              ? null
              : Container(
                  margin: margin,
                  decoration: BoxDecoration(color: invalid, shape: shape),
                ),
        );

  /// Uses colours from [theme].
  factory ColourDragTargetFeedback.fromTheme({
    BoardTheme theme = BoardTheme.blueGrey,
    BoxShape shape = BoxShape.rectangle,
    EdgeInsetsGeometry? margin,
  }) =>
      ColourDragTargetFeedback(
        valid: theme.selected.withOpacity(0.2),
        invalid: theme.check.withOpacity(0.1),
        shape: shape,
        margin: margin,
      );
}
