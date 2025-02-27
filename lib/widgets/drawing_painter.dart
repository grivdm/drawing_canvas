import 'package:flutter/material.dart';
import 'drawing_controller.dart';

class DrawingPainter extends CustomPainter {
  const DrawingPainter({
    required DrawingController controller,
  })  : _controller = controller,
        super(repaint: controller);

  final DrawingController _controller;

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in _controller.strokes) {
      final visibleCount =
          stroke.getVisiblePointCount(5, _controller.fadeDuration);

      if (visibleCount <= 1) continue;

      final paint = Paint()
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(stroke.points[0].dx, stroke.points[0].dy);

      for (int i = 1; i < visibleCount; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) =>
      !identical(oldDelegate._controller, _controller);

  @override
  bool shouldRebuildSemantics(covariant DrawingPainter oldDelegate) => false;
}
