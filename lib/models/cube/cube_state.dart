import 'scanned_face.dart';
import 'cube_face.dart';

class CubeState {
  final Map<CubeFace, ScannedFace> faces = {};

  void addFace(ScannedFace face) {
    faces[face.face] = face;
  }

  bool get isComplete => faces.length == 6;

  void clear() {
    faces.clear();
  }
}