import 'package:flutter/material.dart';

class ArrowIcon extends StatelessWidget {
  const ArrowIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(24, 24), painter: ArrowIconPainter());
  }
}

class ArrowIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Circle paint
    final circlePaint =
        Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    // Circle path
    final circlePath =
        Path()..addOval(
          Rect.fromCircle(center: Offset(width / 2, height / 2), radius: 9),
        );

    // Arrow paint
    final arrowPaint =
        Paint()
          ..color = const Color(0xFF4400FF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    // Arrow path
    final arrowPath = Path();

    // Horizontal line
    arrowPath.moveTo(9, 12);
    arrowPath.lineTo(15, 12);

    // Arrow up
    arrowPath.moveTo(12, 9);
    arrowPath.lineTo(15, 12);

    // Arrow down
    arrowPath.moveTo(12, 15);
    arrowPath.lineTo(15, 12);

    // Draw the circle with dark gray color
    canvas.drawPath(
      circlePath,
      Paint()
        ..color = const Color(0xFF292929)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Draw the arrow with purple color
    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
