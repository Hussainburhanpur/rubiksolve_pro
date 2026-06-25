import 'package:flutter/material.dart';

import 'cube_face.dart';
import 'cubie.dart';

class Cube {
  final List<Cubie> cubies;

  Cube({
    required this.cubies,
  });

  factory Cube.solved() {
    final List<Cubie> cubies = [];

    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        for (int z = -1; z <= 1; z++) {
          if (x == 0 && y == 0 && z == 0) {
            continue;
          }

          final stickers = <CubeFace, Color>{};

          if (y == 1) {
            stickers[CubeFace.up] = Colors.white;
          }

          if (y == -1) {
            stickers[CubeFace.down] = Colors.yellow;
          }

          if (x == -1) {
            stickers[CubeFace.left] = Colors.orange;
          }

          if (x == 1) {
            stickers[CubeFace.right] = Colors.red;
          }

          if (z == 1) {
            stickers[CubeFace.front] = Colors.green;
          }

          if (z == -1) {
            stickers[CubeFace.back] = Colors.blue;
          }

          cubies.add(
            Cubie(
              x: x,
              y: y,
              z: z,
              stickers: stickers,
            ),
          );
        }
      }
    }

    return Cube(cubies: cubies);
  }

  Cubie? cubieAt(int x, int y, int z) {
    try {
      return cubies.firstWhere(
        (c) => c.x == x && c.y == y && c.z == z,
      );
    } catch (_) {
      return null;
    }
  }

  Cube copy() {
    return Cube(
      cubies: cubies
          .map(
            (c) => c.copyWith(),
          )
          .toList(),
    );
  }
}