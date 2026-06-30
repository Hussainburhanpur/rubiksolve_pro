import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

import 'cubie.dart';

class Cube3D {
  final List<Cubie> cubies = [];

  Cube3D() {
    _buildSolvedCube();
  }

  void _buildSolvedCube() {
    cubies.clear();

    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        for (int z = -1; z <= 1; z++) {
          final stickers = <String, Color>{};

          if (y == 1) stickers["U"] = Colors.white;
          if (y == -1) stickers["D"] = Colors.yellow;

          if (x == -1) stickers["L"] = Colors.orange;
          if (x == 1) stickers["R"] = Colors.red;

          if (z == 1) stickers["F"] = Colors.green;
          if (z == -1) stickers["B"] = Colors.blue;

          cubies.add(
            Cubie(
              position: Vector3(
                x.toDouble(),
                y.toDouble(),
                z.toDouble(),
              ),
              stickers: stickers,
            ),
          );
        }
      }
    }
  }
}