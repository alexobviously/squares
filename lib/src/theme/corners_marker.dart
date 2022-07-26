part of 'marker_theme.dart';

class CornersPainter extends CustomPainter {
  final Color colour;
  final double scale;

  CornersPainter({required this.colour, this.scale = 0.2});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = colour
      ..style = PaintingStyle.fill;

    double sizeX = size.width * scale;
    double sizeY = size.height * scale;

    Path topLeft = Path()
      ..moveTo(0, 0)
      ..lineTo(sizeX, 0)
      ..lineTo(0, sizeY)
      ..lineTo(0, 0);

    Path topRight = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height * scale)
      ..lineTo(size.width - sizeX, 0)
      ..lineTo(size.width, 0);

    Path bottomLeft = Path()
      ..moveTo(0, size.height)
      ..lineTo(sizeX, size.height)
      ..lineTo(0, size.height - sizeY)
      ..moveTo(0, size.height);

    Path bottomRight = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width, size.height - sizeY)
      ..lineTo(size.width - sizeX, size.height)
      ..lineTo(size.width, size.height);

    canvas.drawPath(topLeft, paint);
    canvas.drawPath(topRight, paint);
    canvas.drawPath(bottomLeft, paint);
    canvas.drawPath(bottomRight, paint);
  }

  @override
  bool shouldRepaint(covariant CornersPainter oldDelegate) =>
      colour != oldDelegate.colour || scale != oldDelegate.scale;
}
