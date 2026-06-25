import 'package:flutter/material.dart';

import '../../models/cube/cube.dart';
import '../../models/cube/cube_move.dart';

class CubeController extends ChangeNotifier {
  Cube _cube = Cube.solved();

  Cube get cube => _cube;

  void reset() {
    _cube = Cube.solved();
    notifyListeners();
  }

  void applyMove(CubeMove move) {
    // Rotation logic will be implemented next.
    debugPrint("Applying move: $move");

    notifyListeners();
  }

  void applyMoves(List<CubeMove> moves) {
    for (final move in moves) {
      applyMove(move);
    }
  }
}