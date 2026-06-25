import 'package:vector_math/vector_math_64.dart';

import 'cube_face.dart';

class Cubie {
  Vector3 position;

  Matrix4 orientation;

  final Map<CubeFace, CubeColor> stickers;

  Cubie({
    required this.position,
    required this.orientation,
    required this.stickers,
  });

  Cubie copy() {
    return Cubie(
      position: position.clone(),
      orientation: orientation.clone(),
      stickers: Map<CubeFace, CubeColor>.from(stickers),
    );
  }

  bool hasFace(CubeFace face) {
    return stickers.containsKey(face);
  }

  CubeColor? colorOf(CubeFace face) {
    return stickers[face];
  }
}