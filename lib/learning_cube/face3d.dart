import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class Face3D {
  final List<Vector3> vertices;

  final Color color;

  Face3D({
    required this.vertices,
    required this.color,
  });

  Vector3 get center {
    var c = Vector3.zero();

    for (final v in vertices) {
      c += v;
    }

    return c / vertices.length.toDouble();
  }

  Vector3 get normal {
    final a = vertices[1] - vertices[0];
    final b = vertices[2] - vertices[0];

    return a.cross(b).normalized();
  }
}