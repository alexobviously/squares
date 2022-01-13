import 'package:flutter/material.dart';

/// A function that returns an `int`.
typedef IntCallback = int Function();

/// A function that builds a widget, given a [context], [size] and [colour].
typedef HighlightBuilder = Widget Function(BuildContext context, double size, Color colour);
