part of 'marker_theme.dart';

class CrossPainter extends CustomPainter {
  final Color colour;
  final double scale;
  final double strokeWidth;
  final StrokeCap strokeCap;

  CrossPainter({
    required this.colour,
    this.scale = 0.75,
    this.strokeWidth = 2.0,
    this.strokeCap = StrokeCap.round,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = colour
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap
      ..style = PaintingStyle.stroke;

    double padX = size.width * (1 - scale);
    double padY = size.width * (1 - scale);

    Path one = Path()
      ..moveTo(padX, padY)
      ..lineTo(size.width - padX, size.height - padY);
    Path two = Path()
      ..moveTo(padX, size.height - padY)
      ..lineTo(size.width - padX, padY);

    canvas.drawPath(one, paint);
    canvas.drawPath(two, paint);
  }

  @override
  bool shouldRepaint(covariant CrossPainter oldDelegate) =>
      colour != oldDelegate.colour || scale != oldDelegate.scale;
}
