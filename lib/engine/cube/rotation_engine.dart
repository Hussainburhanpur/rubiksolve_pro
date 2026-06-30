import 'cube_move.dart';
import 'cube_face.dart';
import 'cube_state.dart';

class RotationEngine {
  CubeState applyMove(
    CubeState state,
    CubeMove move,
  ) {
    switch (move.face) {
      case CubeFace.right:
        return _applyR(state, move.type);

      case CubeFace.left:
        return _applyL(state, move.type);

      case CubeFace.up:
        return _applyU(state, move.type);

      case CubeFace.down:
        return _applyD(state, move.type);

      case CubeFace.front:
        return _applyF(state, move.type);

      case CubeFace.back:
        return _applyB(state, move.type);
    }
  }

  CubeState applyAlgorithm(
  CubeState state,
  List<CubeMove> moves,
) {
  CubeState cube = state;

  for (final move in moves) {
    cube = applyMove(cube, move);
  }

  return cube;
}

CubeState scramble(
  CubeState state,
  List<CubeMove> moves,
) {
  return applyAlgorithm(state, moves);
}

  CubeState _applyR(
      CubeState state,
      MoveType type,
      ) {
    switch (type) {
      case MoveType.clockwise:
        return rotateR(state);

      case MoveType.counterClockwise:
        return rotateRPrime(state);

      case MoveType.doubleTurn:
        return rotateR2(state);
    }
  }

  CubeState _applyL(
  CubeState state,
  MoveType type,
) {
  switch (type) {
    case MoveType.clockwise:
      return rotateL(state);

    case MoveType.counterClockwise:
      return rotateLPrime(state);

    case MoveType.doubleTurn:
      return rotateL2(state);
  }
}

  CubeState _applyU(
  CubeState state,
  MoveType type,
) {
  switch (type) {
    case MoveType.clockwise:
      return rotateU(state);

    case MoveType.counterClockwise:
      return rotateUPrime(state);

    case MoveType.doubleTurn:
      return rotateU2(state);
  }
}

  CubeState _applyD(
  CubeState state,
  MoveType type,
) {
  switch (type) {
    case MoveType.clockwise:
      return rotateD(state);

    case MoveType.counterClockwise:
      return rotateDPrime(state);

    case MoveType.doubleTurn:
      return rotateD2(state);
  }
}

  CubeState _applyF(
  CubeState state,
  MoveType type,
) {
  switch (type) {
    case MoveType.clockwise:
      return rotateF(state);

    case MoveType.counterClockwise:
      return rotateFPrime(state);

    case MoveType.doubleTurn:
      return rotateF2(state);
  }
}

  CubeState _applyB(
  CubeState state,
  MoveType type,
) {
  switch (type) {
    case MoveType.clockwise:
      return rotateB(state);

    case MoveType.counterClockwise:
      return rotateBPrime(state);

    case MoveType.doubleTurn:
      return rotateB2(state);
  }
}

  CubeState rotateR(CubeState state) {
    final cube = state.copy();

    final c = cube.corners;

    final tempCorner = c[0];
    c[0] = c[3];
    c[3] = c[7];
    c[7] = c[4];
    c[4] = tempCorner;

    final e = cube.edges;

    final tempEdge = e[1];
    e[1] = e[7];
    e[7] = e[9];
    e[9] = e[4];
    e[4] = tempEdge;

    return cube;
  }

  CubeState rotateRPrime(CubeState state) {
    CubeState cube = state;

    for (int i = 0; i < 3; i++) {
      cube = rotateR(cube);
    }

    return cube;
  }

  CubeState rotateR2(CubeState state) {
    return rotateR(rotateR(state));
  }

  CubeState rotateL(CubeState state) {
  final cube = state.copy();

  final c = cube.corners;

  final tempCorner = c[1];
  c[1] = c[5];
  c[5] = c[6];
  c[6] = c[2];
  c[2] = tempCorner;

  final e = cube.edges;

  final tempEdge = e[3];
  e[3] = e[6];
  e[6] = e[11];
  e[11] = e[5];
  e[5] = tempEdge;

  return cube;
}

CubeState rotateLPrime(CubeState state) {
  CubeState cube = state;

  for (int i = 0; i < 3; i++) {
    cube = rotateL(cube);
  }

  return cube;
}

CubeState rotateL2(CubeState state) {
  return rotateL(rotateL(state));
}

CubeState rotateU(CubeState state) {
  final cube = state.copy();

  final c = cube.corners;

  final tempCorner = c[0];
  c[0] = c[1];
  c[1] = c[2];
  c[2] = c[3];
  c[3] = tempCorner;

  final e = cube.edges;

  final tempEdge = e[0];
  e[0] = e[3];
  e[3] = e[2];
  e[2] = e[1];
  e[1] = tempEdge;

  return cube;
}

CubeState rotateUPrime(CubeState state) {
  CubeState cube = state;

  for (int i = 0; i < 3; i++) {
    cube = rotateU(cube);
  }

  return cube;
}

CubeState rotateU2(CubeState state) {
  return rotateU(rotateU(state));
}

CubeState rotateD(CubeState state) {
  final cube = state.copy();

  final c = cube.corners;

  final tempCorner = c[4];
  c[4] = c[7];
  c[7] = c[6];
  c[6] = c[5];
  c[5] = tempCorner;

  final e = cube.edges;

  final tempEdge = e[8];
  e[8] = e[9];
  e[9] = e[10];
  e[10] = e[11];
  e[11] = tempEdge;

  return cube;
}

CubeState rotateDPrime(CubeState state) {
  CubeState cube = state;

  for (int i = 0; i < 3; i++) {
    cube = rotateD(cube);
  }

  return cube;
}

CubeState rotateD2(CubeState state) {
  return rotateD(rotateD(state));
}

CubeState rotateF(CubeState state) {
  final cube = state.copy();

  final c = cube.corners;

  final tempCorner = c[3];
  c[3] = c[2];
  c[2] = c[6];
  c[6] = c[7];
  c[7] = tempCorner;

  final e = cube.edges;

  final tempEdge = e[2];
  e[2] = e[6];
  e[6] = e[10];
  e[10] = e[7];
  e[7] = tempEdge;

  return cube;
}

CubeState rotateFPrime(CubeState state) {
  CubeState cube = state;

  for (int i = 0; i < 3; i++) {
    cube = rotateF(cube);
  }

  return cube;
}

CubeState rotateF2(CubeState state) {
  return rotateF(rotateF(state));
}

CubeState rotateB(CubeState state) {
  final cube = state.copy();

  final c = cube.corners;

  final tempCorner = c[0];
  c[0] = c[4];
  c[4] = c[5];
  c[5] = c[1];
  c[1] = tempCorner;

  final e = cube.edges;

  final tempEdge = e[0];
  e[0] = e[4];
  e[4] = e[8];
  e[8] = e[5];
  e[5] = tempEdge;

  return cube;
}

CubeState rotateBPrime(CubeState state) {
  CubeState cube = state;

  for (int i = 0; i < 3; i++) {
    cube = rotateB(cube);
  }

  return cube;
}

CubeState rotateB2(CubeState state) {
  return rotateB(rotateB(state));
}
}