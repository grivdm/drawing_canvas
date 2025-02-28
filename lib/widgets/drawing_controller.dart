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
  double get totalTime => _totalTime;

  bool update(double deltaTime) {
    _totalTime += deltaTime;

    for (var i = _strokes.length - 1; i >= 0; i--) {
      if (_strokes[i].isFullyFaded(_totalTime)) {
        _strokes.removeAt(i);
      }
    }

    notifyListeners();
    return true;
  }

  void startStroke(Offset position) {
    _currentStroke = StrokeData(
      creationTime: _totalTime,
      fadeDuration: fadeDuration,
    );
    _currentStroke!.addPoint(position);

    _strokes.add(_currentStroke!);

    if (_strokes.length > _maxStrokes) {
      _strokes.removeAt(0);
    }

    notifyListeners();
  }

  void updateStroke(Offset position) {
    if (_currentStroke != null) {
      _currentStroke!.addPoint(position);
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
  final List<Offset> _points = [];
  List<Offset> get points => List.unmodifiable(_points);

  final double creationTime;
  final Duration fadeDuration;

  StrokeData({
    required this.creationTime,
    required this.fadeDuration,
  });

  void addPoint(Offset point) {
    _points.add(point);
  }

  bool isFullyFaded(double currentTime) {
    double elapsedTime = currentTime - creationTime;
    return elapsedTime > fadeDuration.inMilliseconds / 1000;
  }

  int getVisiblePointCount(double currentTime) {
    if (_points.isEmpty) return 0;
    double elapsedTime = currentTime - creationTime;
    double fadeDurationSec = fadeDuration.inMilliseconds / 1000;
    if (elapsedTime >= fadeDurationSec) return 0;
    double fadeProgress = elapsedTime / fadeDurationSec;
    int hiddenPoints = (fadeProgress * _points.length).floor();
    return _points.length - hiddenPoints;
  }
}
