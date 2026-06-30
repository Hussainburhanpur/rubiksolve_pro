import '../models/cube/cube_face.dart';
import '../models/cube/cube_state.dart';
import '../models/cube/scanned_face.dart';

class FaceStorage {
  static final FaceStorage instance = FaceStorage._();

  FaceStorage._();

  final CubeState cubeState = CubeState();

  bool addFace(ScannedFace face) {
  cubeState.addFace(face);
  return true;
}

  bool hasFace(CubeFace face) {
    return cubeState.faces.containsKey(face);
  }

  ScannedFace? getFace(CubeFace face) {
    return cubeState.faces[face];
  }

  int get scannedFaces => cubeState.faces.length;

  int get remainingFaces => 6 - scannedFaces;

  double get progress => scannedFaces / 6.0;

  bool get isComplete => cubeState.isComplete;

  void reset() {
    cubeState.clear();
  }
}