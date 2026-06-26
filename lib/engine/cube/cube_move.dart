import 'cube_face.dart';

enum MoveType {
  clockwise,
  counterClockwise,
  doubleTurn,
}

class CubeMove {
  final CubeFace face;
  final MoveType type;

  const CubeMove({
    required this.face,
    this.type = MoveType.clockwise,
  });

  @override
  String toString() {
    final faceName = switch (face) {
      CubeFace.up => "U",
      CubeFace.down => "D",
      CubeFace.left => "L",
      CubeFace.right => "R",
      CubeFace.front => "F",
      CubeFace.back => "B",
    };

    switch (type) {
      case MoveType.clockwise:
        return faceName;
      case MoveType.counterClockwise:
        return "$faceName'";
      case MoveType.doubleTurn:
        return "${faceName}2";
    }
  }
}