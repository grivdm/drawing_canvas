import 'package:flutter/material.dart';

class DrawingController with ChangeNotifier {
  DrawingController({
    this.fadeDuration = const Duration(seconds: 5),
  }) : _strokes = [];

  final Duration fadeDuration;
  final List<StrokeData> _strokes;
  List<StrokeData> get strokes => List.unmodifiable(_strokes);

  StrokeData? _currentStroke;
  StrokeData? get currentStroke => _currentStroke;

  static const int _maxStrokes = 100;

  double _totalTime = 0.0;

  bool update(double deltaTime) {
    _totalTime += deltaTime;

    _strokes.removeWhere(
        (stroke) => stroke.getVisiblePointCount(_totalTime, fadeDuration) == 0);

    notifyListeners();
    return true;
  }

  void startStroke(
    Offset position,
  ) {
    _currentStroke = StrokeData(
      points: [position],
      startTime: _totalTime,
    );

    _strokes.add(_currentStroke!);

    if (_strokes.length > _maxStrokes) {
      _strokes.removeAt(0);
    }

    notifyListeners();
  }

  void updateStroke(Offset position) {
    if (_currentStroke != null) {
      _currentStroke!.addPoint(position, _totalTime);
      notifyListeners();
    }
  }

  void endStroke() {
    _currentStroke = null;
  }

  void clearStrokes() {
    _strokes.clear();
    _currentStroke = null;
    notifyListeners();
  }
}

class StrokeData {
  final List<Offset> points;

  final double startTime;
  double opacity = 1.0;

  late final List<double> pointTimes;

  StrokeData({
    required this.points,
    required this.startTime,
  }) {
    pointTimes = [startTime];
  }

  void addPoint(Offset point, double time) {
    points.add(point);
    pointTimes.add(time);
  }

  int getVisiblePointCount(double currentTime, Duration fadeDuration) {
    final fadeTimeInSeconds = fadeDuration.inMilliseconds / 1000;
    int visibleCount = 0;

    for (int i = 0; i < pointTimes.length; i++) {
      double pointAge = currentTime - pointTimes[i];
      if (pointAge < fadeTimeInSeconds) {
        visibleCount = i + 1;
      }
    }

    return visibleCount;
  }
}
