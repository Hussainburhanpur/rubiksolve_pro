import '../models/cube/cube_color.dart';
import '../models/cube/cube_face.dart';

class FaceIdentifier {
  static CubeFace identify(CubeColor center) {
    switch (center) {
      case CubeColor.white:
        return CubeFace.up;

      case CubeColor.red:
        return CubeFace.right;

      case CubeColor.green:
        return CubeFace.front;

      case CubeColor.yellow:
        return CubeFace.down;

      case CubeColor.orange:
        return CubeFace.left;

      case CubeColor.blue:
        return CubeFace.back;

      case CubeColor.unknown:
        throw Exception(
          "Center color could not be identified.",
        );
    }
  }
}