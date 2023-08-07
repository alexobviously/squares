import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

/// Builds `GestureDetector`s for each square on the board, handling some
/// common gestures such as right clicks, long presses etc. Doesn't include
/// everything that `GestureDetector` supports because it has literally 60+
/// parameters. It's easy enough to add more if you need them, and if you think
/// one is a common enough use case, feel free to make a PR.
///
/// Note that this can't support `onTap` because it will interfere with the
/// standard piece drag behaviour. Also note that gestures like long press
/// will make tap responses on the pieces and squares take longer to respond
/// as the gestures have to go through this first.
class InputOverlay extends StatelessWidget {
  /// The orientation that the board is being viewed from.
  final int orientation;
  final BoardSize size;
  final void Function(int i)? onSecondaryTap;
  final void Function(int i, TapDownDetails details)? onSecondaryTapDown;
  final void Function(int i, TapUpDetails details)? onSecondaryTapUp;
  final void Function(int i)? onSecondaryTapCancel;
  final void Function(int i)? onLongPress;
  final void Function(int i, LongPressStartDetails details)? onLongPressStart;
  final void Function(int i, LongPressMoveUpdateDetails details)?
      onLongPressMoveUpdate;
  final void Function(int i, LongPressEndDetails details)? onLongPressEnd;
  final void Function(int i)? onLongPressUp;
  final void Function(int i)? onDoubleTap;

  const InputOverlay({
    super.key,
    required this.orientation,
    this.size = BoardSize.standard,
    this.onSecondaryTap,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.onLongPressUp,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return BoardBuilder.index(
      size: size,
      orientation: orientation,
      builder: (i, _) => GestureDetector(
        onSecondaryTap:
            onSecondaryTap == null ? null : () => onSecondaryTap!(i),
        onSecondaryTapDown: onSecondaryTapDown == null
            ? null
            : (det) => onSecondaryTapDown!(i, det),
        onSecondaryTapUp: onSecondaryTapUp == null
            ? null
            : (det) => onSecondaryTapUp!(i, det),
        onSecondaryTapCancel: onSecondaryTapCancel == null
            ? null
            : () => onSecondaryTapCancel!(i),
        onLongPress: onLongPress == null ? null : () => onLongPress!(i),
        onLongPressStart: onLongPressStart == null
            ? null
            : (det) => onLongPressStart!(i, det),
        onLongPressMoveUpdate: onLongPressMoveUpdate == null
            ? null
            : (det) => onLongPressMoveUpdate!(i, det),
        onLongPressEnd:
            onLongPressEnd == null ? null : (det) => onLongPressEnd!(i, det),
        onLongPressUp: onLongPressUp == null ? null : () => onLongPressUp!(i),
        onDoubleTap: onDoubleTap == null ? null : () => onDoubleTap!(i),
      ),
    );
  }
}
