import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import 'camera.dart';
import 'cube3d.dart';
import 'mesh.dart';
import 'projection.dart';

class _ProjectedFace {
  final List<Offset> points;
  final double depth;
  final Color color;

  _ProjectedFace({
    required this.points,
    required this.depth,
    required this.color,
  });
}

class CubeRenderer extends CustomPainter {
  final Cube3D cube;
  final Camera camera;

  CubeRenderer(this.cube, this.camera);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final faces = <_ProjectedFace>[];
    final cameraMatrix = camera.matrix;
    final scale = camera.zoom / 4.0;

    for (final cubie in cube.cubies) {
      final mesh = Mesh.cube(
        size: 0.90,
        stickers: cubie.stickers,
      );

      final bool animate =
          cube.isAnimating &&
          cube.animationMove != null &&
          _belongsToLayer(
            cubie.position,
            cube.animationMove!,
          );

      final vm.Vector3 axis = animate
          ? _axisForMove(cube.animationMove!)
          : vm.Vector3.zero();

      final double angle = animate
          ? _animationAngle(
              cube.animationMove!,
              cube.animationProgress,
            )
          : 0.0;

      for (final face in mesh.faces) {
        final transformedVertices = <vm.Vector3>[];

        for (final vertex in face.vertices) {
          // Convert the vertex from cubie-local space
          // into cube/world space.
          final worldPoint = vertex.clone()
            ..add(cubie.position);

          // Unity's Pivot is at the cube center.
          // Therefore rotate the COMPLETE world point
          // around the origin.
          if (animate) {
            _rotateAroundOrigin(
              worldPoint,
              axis,
              angle,
            );
          }

          transformedVertices.add(worldPoint);
        }

        // Rotate the face normal as well so back/front
        // face visibility follows the animated layer.
        final rotatedNormal = face.normal.clone();

        if (animate) {
          _rotateAroundOrigin(
            rotatedNormal,
            axis,
            angle,
          );
        }

        final normal = cameraMatrix.transform3(
          rotatedNormal,
        );

        // Back-face culling.
        if (normal.z <= 0.001) continue;

        final cameraVertices = transformedVertices
            .map(
              (point) => cameraMatrix.transform3(point),
            )
            .toList();

        final projectedPoints = cameraVertices.map(
          (point) {
            final projected = Projection.project(
              point,
              size.width,
              size.height,
              scale,
            );

            return Offset(
              projected.x,
              projected.y,
            );
          },
        ).toList();

        final averageDepth =
            cameraVertices
                    .map((point) => point.z)
                    .reduce((a, b) => a + b) /
                cameraVertices.length;

        faces.add(
          _ProjectedFace(
            points: projectedPoints,
            depth: averageDepth,
            color: face.color,
          ),
        );
      }
    }

    // Draw farthest faces first.
    faces.sort(
      (a, b) => a.depth.compareTo(b.depth),
    );

    for (final face in faces) {
      final path = Path()
        ..moveTo(
          face.points.first.dx,
          face.points.first.dy,
        );

      for (final point in face.points.skip(1)) {
        path.lineTo(
          point.dx,
          point.dy,
        );
      }

      path.close();

      canvas.drawPath(
        path,
        Paint()
          ..color = face.color
          ..style = PaintingStyle.fill,
      );

      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF151515)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  bool _belongsToLayer(
    vm.Vector3 position,
    String move,
  ) {
    switch (move[0]) {
      case 'R':
        return position.x.round() == 1;

      case 'L':
        return position.x.round() == -1;

      case 'U':
        return position.y.round() == 1;

      case 'D':
        return position.y.round() == -1;

      case 'F':
        return position.z.round() == 1;

      case 'B':
        return position.z.round() == -1;

      default:
        return false;
    }
  }

  vm.Vector3 _axisForMove(String move) {
    switch (move[0]) {
      case 'R':
      case 'L':
        return vm.Vector3(1, 0, 0);

      case 'U':
      case 'D':
        return vm.Vector3(0, 1, 0);

      case 'F':
      case 'B':
        return vm.Vector3(0, 0, 1);

      default:
        return vm.Vector3(0, 1, 0);
    }
  }

  double _animationAngle(
    String move,
    double progress,
  ) {
    double direction;

    switch (move[0]) {
      case 'R':
        direction = -1;
        break;

      case 'L':
        direction = 1;
        break;

      case 'U':
        direction = -1;
        break;

      case 'D':
        direction = 1;
        break;

      case 'F':
        direction = -1;
        break;

      case 'B':
        direction = 1;
        break;

      default:
        direction = 1;
    }

    if (move.endsWith("'")) {
      direction *= -1;
    }

    final turns = move.endsWith('2') ? 2.0 : 1.0;

    return direction *
        turns *
        (math.pi / 2.0) *
        progress;
  }

  void _rotateAroundOrigin(
    vm.Vector3 point,
    vm.Vector3 axis,
    double angle,
  ) {
    final c = math.cos(angle);
    final s = math.sin(angle);

    final x = axis.x;
    final y = axis.y;
    final z = axis.z;

    final px = point.x;
    final py = point.y;
    final pz = point.z;

    point.x =
        (c + x * x * (1 - c)) * px +
        (x * y * (1 - c) - z * s) * py +
        (x * z * (1 - c) + y * s) * pz;

    point.y =
        (y * x * (1 - c) + z * s) * px +
        (c + y * y * (1 - c)) * py +
        (y * z * (1 - c) - x * s) * pz;

    point.z =
        (z * x * (1 - c) - y * s) * px +
        (z * y * (1 - c) + x * s) * py +
        (c + z * z * (1 - c)) * pz;
  }

  @override
  bool shouldRepaint(
    covariant CubeRenderer oldDelegate,
  ) {
    return true;
  }
}