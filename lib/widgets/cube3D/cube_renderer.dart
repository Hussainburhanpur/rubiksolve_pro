import 'package:flutter/material.dart';
import 'camera.dart';
import 'cube3d.dart';

class CubeRenderer extends CustomPainter {
  final Cube3D cube;
  final Camera camera;

  CubeRenderer(
    this.cube,
    this.camera,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.fill;

    for (final cubie in cube.cubies) {
      final dx = size.width / 2 + cubie.position.x * 35;
      final dy = size.height / 2 - cubie.position.y * 35;

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(dx, dy),
          width: 24,
          height: 24,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}