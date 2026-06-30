import 'package:flutter/material.dart';
import 'cube_painter.dart';

class CubeView extends StatefulWidget {
  const CubeView({super.key});

  @override
  State<CubeView> createState() => _CubeViewState();
}

class _CubeViewState extends State<CubeView> {
  double _xRotation = -0.5;
  double _yRotation = 0.6;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _yRotation += details.delta.dx * 0.01;
          _xRotation -= details.delta.dy * 0.01;
        });
      },
      child: Center(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_xRotation)
            ..rotateY(_yRotation),
          child: CustomPaint(
  size: const Size(220, 220),
  painter: CubePainter(),
),
        ),
      ),
    );
  }
}