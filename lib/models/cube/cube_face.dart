enum CubeFace {
  up,
  down,
  left,
  right,
  front,
  back,
}

extension CubeFaceExtension on CubeFace {
  String get name {
    switch (this) {
      case CubeFace.up:
        return 'U';
      case CubeFace.down:
        return 'D';
      case CubeFace.left:
        return 'L';
      case CubeFace.right:
        return 'R';
      case CubeFace.front:
        return 'F';
      case CubeFace.back:
        return 'B';
    }
  }
}