import 'package:flutter/material.dart';

import 'camera.dart';
import 'cube3d.dart';
import 'cube_renderer.dart';

class Cube3DView extends StatefulWidget {
  const Cube3DView({super.key});

  @override
  State<Cube3DView> createState() => _Cube3DViewState();
}

class _Cube3DViewState extends State<Cube3DView> {
  final Cube3D cube = Cube3D();
  final Camera camera = Camera();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          camera.rotate(
            details.delta.dx * 0.01,
            -details.delta.dy * 0.01,
          );
        });
      },
      child: CustomPaint(
        painter: CubeRenderer(
  cube,
  camera,
),
        size: Size.infinite,
      ),
    );
  }
}