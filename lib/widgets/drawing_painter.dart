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
    final currentTime = _controller.totalTime;

    for (var stroke in _controller.strokes) {
      final visibleCount = stroke.getVisiblePointCount(currentTime);

      if (visibleCount <= 1) continue;

      final paint = Paint()
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final allPoints = stroke.points;

      final startIndex = allPoints.length - visibleCount;

      final path = Path();

      if (startIndex < allPoints.length) {
        path.moveTo(allPoints[startIndex].dx, allPoints[startIndex].dy);

        for (int i = startIndex + 1; i < allPoints.length; i++) {
          path.lineTo(allPoints[i].dx, allPoints[i].dy);
        }

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
