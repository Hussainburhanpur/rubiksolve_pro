import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import 'cubie.dart';

class Cube3D {
  final List<Cubie> cubies = [];

  // Animation state.
  bool isAnimating = false;
  String? animationMove;
  double animationProgress = 0.0;

  Cube3D({String? cubeString}) {
    if (cubeString == null) {
      _buildSolvedCube();
    } else {
      _buildCubeFromString(cubeString);
    }
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
              position: vm.Vector3(
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

  // Starts the visual animation state.
  void startAnimation(String move) {
    if (isAnimating) return;

    final normalized = move.trim().toUpperCase();

    if (normalized.isEmpty) return;

    isAnimating = true;
    animationMove = normalized;
    animationProgress = 0.0;
  }

  // Updates animation progress from 0.0 to 1.0.
  void updateAnimation(double progress) {
    if (!isAnimating) return;

    animationProgress = progress.clamp(0.0, 1.0);
  }

  // Finishes the animation and commits the logical move.
  void finishAnimation() {
    if (!isAnimating || animationMove == null) return;

    final move = animationMove!;

    isAnimating = false;
    animationMove = null;
    animationProgress = 0.0;

    applyMove(move);
  }

  void cancelAnimation() {
    isAnimating = false;
    animationMove = null;
    animationProgress = 0.0;
  }

  // Applies a standard Rubik's Cube move.
  // Supported moves:
  // R, R', R2, L, L', L2,
  // U, U', U2, D, D', D2,
  // F, F', F2, B, B', B2.

  void applyMove(String move) {
    final normalized = move.trim().toUpperCase();

    if (normalized.isEmpty) return;

    final face = normalized[0];

    final validFaces = ['R', 'L', 'U', 'D', 'F', 'B'];

    if (!validFaces.contains(face)) {
      throw ArgumentError('Invalid cube move: $move');
    }

    final suffix = normalized.substring(1);

    if (suffix != '' && suffix != "'" && suffix != '2') {
      throw ArgumentError('Invalid cube move: $move');
    }

    int axis;
    int layer;
    int quarterTurns;

    switch (face) {
      case 'R':
        axis = 0;
        layer = 1;
        quarterTurns = -1;
        break;

      case 'L':
        axis = 0;
        layer = -1;
        quarterTurns = 1;
        break;

      case 'U':
        axis = 1;
        layer = 1;
        quarterTurns = -1;
        break;

      case 'D':
        axis = 1;
        layer = -1;
        quarterTurns = 1;
        break;

      case 'F':
        axis = 2;
        layer = 1;
        quarterTurns = -1;
        break;

      case 'B':
        axis = 2;
        layer = -1;
        quarterTurns = 1;
        break;

      default:
        return;
    }

    if (suffix == "'") {
      quarterTurns *= -1;
    } else if (suffix == '2') {
      quarterTurns *= 2;
    }

    final turns = quarterTurns.abs();
    final direction = quarterTurns.sign;

    for (int i = 0; i < turns; i++) {
      for (final cubie in cubies) {
        final coordinate = axis == 0
            ? cubie.position.x
            : axis == 1
                ? cubie.position.y
                : cubie.position.z;

        if (coordinate.round() != layer) continue;

        _rotateCubie(cubie, axis, direction);
      }
    }
  }

  bool isSolved() {
    for (final cubie in cubies) {
      for (final entry in cubie.stickers.entries) {
        final expected = _faceColor(entry.key);

        if (entry.value != expected) {
          return false;
        }
      }
    }

    return true;
  }

  bool testMoveEngine() {
    _buildSolvedCube();

    applyMove('R');
    applyMove("R'");

    return isSolved();
  }

  Color _faceColor(String face) {
    switch (face) {
      case 'U':
        return Colors.white;
      case 'R':
        return Colors.red;
      case 'F':
        return Colors.green;
      case 'D':
        return Colors.yellow;
      case 'L':
        return Colors.orange;
      case 'B':
        return Colors.blue;
      default:
        throw ArgumentError('Unknown face: $face');
    }
  }

  void _rotateCubie(
    Cubie cubie,
    int axis,
    int direction,
  ) {
    var position = cubie.position.clone();

    if (direction < 0) {
      for (int i = 0; i < 3; i++) {
        position = _rotateVector(position, axis);
      }
    } else {
      position = _rotateVector(position, axis);
    }

    cubie.position = position;

    final rotatedStickers = <String, Color>{};

    for (final entry in cubie.stickers.entries) {
      final normal = _faceNormal(entry.key);

      final rotatedNormal = direction < 0
          ? _rotateVectorTimes(normal, axis, 3)
          : _rotateVector(normal, axis);

      rotatedStickers[_faceFromNormal(rotatedNormal)] = entry.value;
    }

    cubie.stickers
      ..clear()
      ..addAll(rotatedStickers);
  }

  vm.Vector3 _rotateVectorTimes(
    vm.Vector3 vector,
    int axis,
    int turns,
  ) {
    var result = vector.clone();

    for (int i = 0; i < turns; i++) {
      result = _rotateVector(result, axis);
    }

    return result;
  }

  vm.Vector3 _rotateVector(
    vm.Vector3 v,
    int axis,
  ) {
    switch (axis) {
      case 0:
        return vm.Vector3(v.x, -v.z, v.y);

      case 1:
        return vm.Vector3(v.z, v.y, -v.x);

      case 2:
        return vm.Vector3(-v.y, v.x, v.z);

      default:
        return v.clone();
    }
  }

  vm.Vector3 _faceNormal(String face) {
    switch (face) {
      case 'U':
        return vm.Vector3(0, 1, 0);
      case 'D':
        return vm.Vector3(0, -1, 0);
      case 'L':
        return vm.Vector3(-1, 0, 0);
      case 'R':
        return vm.Vector3(1, 0, 0);
      case 'F':
        return vm.Vector3(0, 0, 1);
      case 'B':
        return vm.Vector3(0, 0, -1);
      default:
        throw ArgumentError('Unknown face: $face');
    }
  }

  String _faceFromNormal(vm.Vector3 normal) {
    if (normal.x > 0.5) return 'R';
    if (normal.x < -0.5) return 'L';
    if (normal.y > 0.5) return 'U';
    if (normal.y < -0.5) return 'D';
    if (normal.z > 0.5) return 'F';
    if (normal.z < -0.5) return 'B';

    throw StateError('Invalid sticker orientation');
  }

  void _buildCubeFromString(String cubeString) {
    if (cubeString.length != 54) {
      throw ArgumentError(
        'Cube string must contain exactly 54 characters.',
      );
    }

    cubies.clear();

    final Map<String, Cubie> cubieMap = {};

    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        for (int z = -1; z <= 1; z++) {
          final key = '$x,$y,$z';

          final cubie = Cubie(
            position: vm.Vector3(
              x.toDouble(),
              y.toDouble(),
              z.toDouble(),
            ),
            stickers: {},
          );

          cubies.add(cubie);
          cubieMap[key] = cubie;
        }
      }
    }

    final Map<String, Color> colors = {
      'U': Colors.white,
      'R': Colors.red,
      'F': Colors.green,
      'D': Colors.yellow,
      'L': Colors.orange,
      'B': Colors.blue,
    };

    final List<String> faces = [
      'U',
      'R',
      'F',
      'D',
      'L',
      'B',
    ];

    for (int faceIndex = 0; faceIndex < 6; faceIndex++) {
      final face = faces[faceIndex];

      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          final index =
              faceIndex * 9 + row * 3 + col;

          final colorLetter = cubeString[index];

          if (!colors.containsKey(colorLetter)) {
            throw ArgumentError(
              'Invalid cube color: $colorLetter',
            );
          }

          late int x, y, z;

          switch (face) {
            case 'U':
              x = col - 1;
              y = 1;
              z = row - 1;
              break;

            case 'R':
              x = 1;
              y = 1 - row;
              z = 1 - col;
              break;

            case 'F':
              x = col - 1;
              y = 1 - row;
              z = 1;
              break;

            case 'D':
              x = col - 1;
              y = -1;
              z = 1 - row;
              break;

            case 'L':
              x = -1;
              y = 1 - row;
              z = col - 1;
              break;

            case 'B':
              x = 1 - col;
              y = 1 - row;
              z = -1;
              break;
          }

          final key = '$x,$y,$z';

          cubieMap[key]!.stickers[face] =
              colors[colorLetter]!;
        }
      }
    }
  }

  String debugFaceCenters() {
    final result = <String, String>{};

    for (final cubie in cubies) {
      for (final entry in cubie.stickers.entries) {
        final face = entry.key;

        final isCenter =
            (face == 'U' &&
                    cubie.position.x == 0 &&
                    cubie.position.z == 0) ||
                (face == 'D' &&
                    cubie.position.x == 0 &&
                    cubie.position.z == 0) ||
                (face == 'F' &&
                    cubie.position.x == 0 &&
                    cubie.position.y == 0) ||
                (face == 'B' &&
                    cubie.position.x == 0 &&
                    cubie.position.y == 0) ||
                (face == 'R' &&
                    cubie.position.y == 0 &&
                    cubie.position.z == 0) ||
                (face == 'L' &&
                    cubie.position.y == 0 &&
                    cubie.position.z == 0);

        if (isCenter) {
          result[face] = entry.value.toString();
        }
      }
    }

    return result.toString();
  }
}