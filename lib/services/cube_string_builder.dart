import '../models/cube/cube_color.dart';
import '../models/cube/cube_face.dart';
import '../models/cube/cube_state.dart';

class CubeStringBuilder {
  static String build(CubeState state) {
    if (!state.isComplete) {
      throw Exception('Cube is not fully scanned.');
    }

    final order = [
      CubeFace.up,
      CubeFace.right,
      CubeFace.front,
      CubeFace.down,
      CubeFace.left,
      CubeFace.back,
    ];

    final buffer = StringBuffer();

    for (final face in order) {
      final scanned = state.faces[face]!;

      for (final color in scanned.stickers) {
        buffer.write(_toLetter(color));
      }
    }

    return buffer.toString();
  }

  static String _toLetter(CubeColor color) {
    switch (color) {
      case CubeColor.white:
        return 'U';
      case CubeColor.red:
        return 'R';
      case CubeColor.green:
        return 'F';
      case CubeColor.yellow:
        return 'D';
      case CubeColor.orange:
        return 'L';
      case CubeColor.blue:
        return 'B';
      case CubeColor.unknown:
        throw Exception('Unknown cube color detected.');
    }
  }
}