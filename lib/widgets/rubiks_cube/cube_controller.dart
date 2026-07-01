import 'package:flutter/material.dart';

import 'cubie_data.dart';

class CubeController extends ChangeNotifier {
  double rotationX = -0.55;
  double rotationY = 0.75;

  final List<CubieData> cubies = [];

  CubeController() {
    _buildSolvedCube();
  }

  void _buildSolvedCube() {
    cubies.clear();

    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        for (int z = -1; z <= 1; z++) {
          cubies.add(
            CubieData(
              x: x,
              y: y,
              z: z,
              front: z == 1 ? Colors.green : null,
              back: z == -1 ? Colors.blue : null,
              left: x == -1 ? Colors.orange : null,
              right: x == 1 ? Colors.red : null,
              top: y == 1 ? Colors.white : null,
              bottom: y == -1 ? Colors.yellow : null,
            ),
          );
        }
      }
    }
  }

  void rotate(double dx, double dy) {
    rotationY += dx;
    rotationX -= dy;

    rotationX = rotationX.clamp(-1.3, 1.3);

    notifyListeners();
  }

  void reset() {
    rotationX = -0.55;
    rotationY = 0.75;
    notifyListeners();
  }
}