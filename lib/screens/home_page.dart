import 'package:flutter/material.dart';
import '../widgets/drawing_canvas.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<DrawingCanvasState> _canvasKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: DrawingCanvas(
                key: _canvasKey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
