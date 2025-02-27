// lib/widgets/drawing_canvas.dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'drawing_controller.dart';
import 'drawing_painter.dart';

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({
    super.key,
  });

  @override
  State<DrawingCanvas> createState() => DrawingCanvasState();
}

class DrawingCanvasState extends State<DrawingCanvas>
    with SingleTickerProviderStateMixin {
  late final DrawingController _controller;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _controller = DrawingController();
    _ticker = createTicker(_onTick());
    _ticker.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    _ticker.dispose();
    super.dispose();
  }

  void Function(Duration elapsed) _onTick() {
    var prev = Duration.zero;
    return (elapsed) {
      final delta = (elapsed - prev).inMicroseconds / 1000000.0;
      _controller.update(delta);
      prev = elapsed;
    };
  }

  void clearCanvas() {
    _controller.clearStrokes();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 1.3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: GestureDetector(
            onPanStart: (details) {
              _controller.startStroke(details.localPosition);
            },
            onPanUpdate: (details) {
              _controller.updateStroke(details.localPosition);
            },
            onPanEnd: (details) {
              _controller.endStroke();
            },
            child: RepaintBoundary(
              child: CustomPaint(
                painter: DrawingPainter(
                  controller: _controller,
                ),
                size: Size.infinite,
              ),
            ),
          ),
        ),
      );
}
