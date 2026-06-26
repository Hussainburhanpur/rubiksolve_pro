import 'cube_state.dart';

class RotationEngine {
  CubeState rotateR(CubeState state) {
    final cube = state.copy();

    // Corner cycle
    final c = cube.corners;

    final tempCorner = c[0];
    c[0] = c[3];
    c[3] = c[7];
    c[7] = c[4];
    c[4] = tempCorner;

    // Edge cycle
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
}